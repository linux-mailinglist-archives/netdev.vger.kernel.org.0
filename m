Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B954960D6CC
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiJYWKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiJYWJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:09:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965C213E84;
        Tue, 25 Oct 2022 15:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kg+oKuPzQbTyP1EocNquVGFw+o9EuqAdUm+zEML38gE=; b=rl891+VA1wNWpKwJKkDAu9W60J
        LLvLHuoukgccNS6YMAE5xHIrK+wuAflDjT3Ulvv+xBUqBY8Ti0vN6vlBpIY7QkV57uu40DLG9UbrJ
        jAF5eWHxpVyHtjfG5YARs7VdoQnrU72oulWU7SjxEolRQ3mD5qP1DxEFzJY8XfWbjDNk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1onS62-000aE9-85; Wed, 26 Oct 2022 00:08:30 +0200
Date:   Wed, 26 Oct 2022 00:08:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: fec: add initial XDP support
Message-ID: <Y1heXnxgA6e5T8sr@lunn.ch>
References: <20221025201156.776576-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025201156.776576-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define FEC_ENET_XDP_PASS          0
> +#define FEC_ENET_XDP_CONSUMED      BIT(0)
> +#define FEC_ENET_XDP_TX            BIT(1)
> +#define FEC_ENET_XDP_REDIR         BIT(2)

I don't know XDP, so maybe a silly question. Are these action mutually
exclusive? Are these really bits, or should it be an enum?
fec_enet_run_xdp() does not combine them as bits.

> +static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
> +{
> +	struct fec_enet_private *fep = netdev_priv(dev);
> +	bool is_run = netif_running(dev);

You have the space, so maybe call it is_running.

> +	struct bpf_prog *old_prog;
> +	unsigned int dsize;
> +	int i;
> +
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		if (is_run)
> +			fec_enet_close(dev);

fec_net_close() followed by fec_enet_open() is pretty expensive.  The
PHY is stopped and disconnected, and then connected and started. That
will probably trigger an auto-neg, which takes around 1.5 seconds
before the link is up again.

Maybe you should optimise this. I guess the real issue here is you
need to resize the RX ring. You need to be careful with that
anyway. If the machine is under memory pressure, you might not be able
to allocate the ring, resulting in a broken interface. What is
recommended for ethtool --set-ring is that you first allocate the new
ring, and if that is successful, free the old ring. If the allocation
fails, you still have the old ring, and you can safely return -ENOMEM
and still have a working interface.

So i think you can split this patch up into a few parts:

XDP using the default ring size. Your benchmarks show it works, its
just not optimal. But the resulting smaller patch will be easier to
review.

Add support for ethtool set-ring, which will allow you to pick apart
the bits of fec_net_close() and fec_enet_open() which are needed for
changing the rings. This might actually need a refactoring patch?

And then add support for optimal ring size for XDP.

    Andrew
