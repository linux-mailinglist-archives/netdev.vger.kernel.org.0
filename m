Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E074C613BEF
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 18:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiJaRKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 13:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiJaRKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 13:10:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6CD12D28;
        Mon, 31 Oct 2022 10:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6vzHxEAPqVfIR65YIpx9t4I4izpmXEj2rkIyxRK348E=; b=3dHLv00PYewsTy8LuMrCq/Bk6/
        Erh0z8QowWmrxBI7wEcl+Hh5gljmTEw0el8eqthgQS3irtAAFOqwG+ehcaldnWBiRLhvMEU/jQM+d
        2sREW0EMdntpV7QWs1rfFPG70A3rBg2XIw4AbiPwDYcI/4F0g6d4R1g3sTdFYMEIP7FI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1opYIZ-0012Yw-Ce; Mon, 31 Oct 2022 18:10:07 +0100
Date:   Mon, 31 Oct 2022 18:10:07 +0100
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
        imx@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 1/1] net: fec: add initial XDP support
Message-ID: <Y2ABb+G+ykcUd413@lunn.ch>
References: <20221031162200.1997788-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031162200.1997788-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
> +{
> +	struct fec_enet_private *fep = netdev_priv(dev);
> +	bool is_run = netif_running(dev);
> +	struct bpf_prog *old_prog;
> +	unsigned int dsize;
> +	int i;
> +
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		if (is_run) {
> +			napi_disable(&fep->napi);
> +			netif_tx_disable(dev);
> +		}
> +
> +		old_prog = xchg(&fep->xdp_prog, bpf->prog);
> +
> +		/* Update RX ring size */
> +		dsize = fep->bufdesc_ex ? sizeof(struct bufdesc_ex) :
> +			sizeof(struct bufdesc);
> +		for (i = 0; i < fep->num_rx_queues; i++) {
> +			struct fec_enet_priv_rx_q *rxq = fep->rx_queue[i];
> +			struct bufdesc *cbd_base;
> +			unsigned int size;
> +
> +			cbd_base = rxq->bd.base;
> +			if (bpf->prog)
> +				rxq->bd.ring_size = XDP_RX_RING_SIZE;
> +			else
> +				rxq->bd.ring_size = RX_RING_SIZE;
> +			size = dsize * rxq->bd.ring_size;
> +			cbd_base = (struct bufdesc *)(((void *)cbd_base) + size);
> +			rxq->bd.last = (struct bufdesc *)(((void *)cbd_base) - dsize);

This does not look safe. netif_tx_disable(dev) will stop new
transmissions, but the hardware can be busy receiving, DMAing frames,
using the descriptors, etc. Modifying rxq->bd.last in particular seems
risky. I think you need to disable the receiver, wait for it to
indicate it really has stopped, and only then make these
modifications.

	Andrew
