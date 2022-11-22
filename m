Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E608A633BB0
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiKVLpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiKVLou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:44:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037BA2F5;
        Tue, 22 Nov 2022 03:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669117433; x=1700653433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fV6MbCTXgRneefHxLzFbEthfpU8gb9LywWsgmtPBDV8=;
  b=YSm/uOLV9fkjLy/gWQj0LZWObx3ofBZfkBetr96MpcVRqNJ6YizYbxBy
   tCz/ykUVv1QWQcBojRpm3JW1TmDZ/AFjJ6GfCfRQmSS6pkKFJ7yGsxIcR
   +SbXUAHMafKQxdfC06xHVgdDzOwtHioJhQRReGjs3RGJHMN3zmaCVm2zp
   Br85J4hCrZzu4eK8Dve8uFXvzD9CngQaH0LhLFxJOnLUQB20cl9+LoSyK
   g7s7gDJ2MKVsogcBRepY0b6vzjz5YaP9pHR9PLXaitDZECDAmJmy1Sfr3
   3+oIu/qPmfYt2He0gl21PAdvNlB7QmcsGoa/4V5GAbkp4eCZaMRUcOvLo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="400084491"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="400084491"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 03:43:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="643693740"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="643693740"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 22 Nov 2022 03:43:49 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AMBhlEG003863;
        Tue, 22 Nov 2022 11:43:48 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 5/7] net: lan966x: Update dma_dir of page_pool_params
Date:   Tue, 22 Nov 2022 12:43:39 +0100
Message-Id: <20221122114339.419188-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121212850.3212649-6-horatiu.vultur@microchip.com>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com> <20221121212850.3212649-6-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 21 Nov 2022 22:28:48 +0100

> To add support for XDP_TX it is required to be able to write to the DMA
> area therefore it is required that the pages will be mapped using
> DMA_BIDIRECTIONAL flag.
> Therefore check if there are any xdp programs on the interfaces and in
> that case set DMA_BIDRECTIONAL otherwise use DMA_FROM_DEVICE.
> Therefore when a new XDP program is added it is required to redo the
> page_pool.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 29 ++++++++++++++----
>  .../ethernet/microchip/lan966x/lan966x_main.h |  2 ++
>  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 30 +++++++++++++++++++
>  3 files changed, 55 insertions(+), 6 deletions(-)

[...]

> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> index 8ebde1eb6a09c..05c5a28206558 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> @@ -11,6 +11,8 @@ static int lan966x_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
>  	struct lan966x_port *port = netdev_priv(dev);
>  	struct lan966x *lan966x = port->lan966x;
>  	struct bpf_prog *old_prog;
> +	bool old_xdp, new_xdp;
> +	int err;
>  
>  	if (!lan966x->fdma) {
>  		NL_SET_ERR_MSG_MOD(xdp->extack,
> @@ -18,7 +20,20 @@ static int lan966x_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
>  		return -EOPNOTSUPP;
>  	}
>  
> +	old_xdp = lan966x_xdp_present(lan966x);
>  	old_prog = xchg(&port->xdp_prog, xdp->prog);
> +	new_xdp = lan966x_xdp_present(lan966x);
> +
> +	if (old_xdp != new_xdp)
> +		goto out;

Shouldn't it be the other way around? E.g. when there's no prog and
you're installing it or there is a prog and we're removing it from
the interface, DMA dir must be changed, so we reload the Pools, but
if `old_xdp == new_xdp` we should just hotswap them and goto out?

> +
> +	err = lan966x_fdma_reload_page_pool(lan966x);
> +	if (err) {
> +		xchg(&port->xdp_prog, old_prog);
> +		return err;
> +	}
> +
> +out:
>  	if (old_prog)
>  		bpf_prog_put(old_prog);
>  

[...]

> -- 
> 2.38.0

Thanks,
Olek
