Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EB05EEB3E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiI2Bv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbiI2BvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:51:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F5F760E5;
        Wed, 28 Sep 2022 18:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oGBNk7ehsr6naNZyndXMCMbMLWq4E6sNqHzKAcVK0R0=; b=N2j6it1iwchaJQ6Jw5RQXNCHoj
        J19EWqrL0hSDlTAcP+QEHawdH5d9OYTsG2zhQz+nKNZQvrIqxGbdX96gmADamfWO72dBAMcTHAG+X
        1ymlj6tsvfo8H0xh2dr/nR2RfxrLSJ9HzQuMG8dofHR2oGtgu/KTM2NAlpu6YLyE2T8Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odihJ-000ZSE-Nb; Thu, 29 Sep 2022 03:50:45 +0200
Date:   Thu, 29 Sep 2022 03:50:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <YzT59R+zx4dA5G5Q@lunn.ch>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928152509.141490-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct fec_enet_xdp_stats {
> +	u64	xdp_pass;
> +	u64	xdp_drop;
> +	u64	xdp_xmit;
> +	u64	xdp_redirect;
> +	u64	xdp_xmit_err;
> +	u64	xdp_tx;
> +	u64	xdp_tx_err;
> +};
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		rxq->stats.xdp_pass++;

Since the stats are u64, and most machines using the FEC are 32 bit,
you cannot just do an increment. Took a look at u64_stats_sync.h.

> -#define FEC_STATS_SIZE		(ARRAY_SIZE(fec_stats) * sizeof(u64))
> +static struct fec_xdp_stat {
> +	char name[ETH_GSTRING_LEN];
> +	u32 count;
> +} fec_xdp_stats[] = {
> +	{ "rx_xdp_redirect", 0 },
> +	{ "rx_xdp_pass", 0 },
> +	{ "rx_xdp_drop", 0 },
> +	{ "rx_xdp_tx", 0 },
> +	{ "rx_xdp_tx_errors", 0 },
> +	{ "tx_xdp_xmit", 0 },
> +	{ "tx_xdp_xmit_errors", 0 },
> +};
> +
> +#define FEC_STATS_SIZE	((ARRAY_SIZE(fec_stats) + \
> +			ARRAY_SIZE(fec_xdp_stats)) * sizeof(u64))

The page pool also has some stats. See page_pool_get_stats(),
page_pool_ethtool_stats_get_strings() etc.

      Andrew
