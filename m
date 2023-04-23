Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731626EC12E
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjDWQvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDWQvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0B110EB;
        Sun, 23 Apr 2023 09:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04D8860F7A;
        Sun, 23 Apr 2023 16:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3955C433EF;
        Sun, 23 Apr 2023 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682268697;
        bh=ddl3KZchd+IF5lI8r6xVNpN040Ycz34P60TD/AyX/VE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U3m22A7JMRNK3hFMM/m6oixvtjnK55rB4YOiGrP4bo3llGCubzez3OJ3el6P3B9hq
         Y70BGPXIe5dMJR0HCQBMknpb+08CCqSaVc0zj/GjLRTuh3+1yF1b7bGS9+mHut5Kay
         cb+nwsaDtk+9bkazN04bTmXi1u9RkFIWgUIygUQR98+pjCcgiHyVMyWtZj4OcAL8ZU
         ypMn32GXIaspzu+fyBn0LviV2iHEQR1g6QQ6/PXfTIH8w5ql0mTXhOwy/7P5kQHBPX
         FNuuKzPIJwFYReucdCxM6x8U9wt1RYjDyqp04iPeVZBTDPjXHY7grivO4T7wYNAvO6
         J3unjSh54aGPQ==
Date:   Sun, 23 Apr 2023 19:51:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [net PATCH 5/9] octeontx2-pf: mcs: Fix NULL pointer dereferences
Message-ID: <20230423165133.GH4782@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-6-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423095454.21049-6-gakula@marvell.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 03:24:50PM +0530, Geetha sowjanya wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> When system is rebooted after creating macsec interface
> below NULL pointer dereference crashes occurred. This
> patch fixes those crashes.
> 
> [ 3324.406942] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> [ 3324.415726] Mem abort info:
> [ 3324.418510]   ESR = 0x96000006
> [ 3324.421557]   EC = 0x25: DABT (current EL), IL = 32 bits
> [ 3324.426865]   SET = 0, FnV = 0
> [ 3324.429913]   EA = 0, S1PTW = 0
> [ 3324.433047] Data abort info:
> [ 3324.435921]   ISV = 0, ISS = 0x00000006
> [ 3324.439748]   CM = 0, WnR = 0
> ....
> [ 3324.575915] Call trace:
> [ 3324.578353]  cn10k_mdo_del_secy+0x24/0x180
> [ 3324.582440]  macsec_common_dellink+0xec/0x120
> [ 3324.586788]  macsec_notify+0x17c/0x1c0
> [ 3324.590529]  raw_notifier_call_chain+0x50/0x70
> [ 3324.594965]  call_netdevice_notifiers_info+0x34/0x7c
> [ 3324.599921]  rollback_registered_many+0x354/0x5bc
> [ 3324.604616]  unregister_netdevice_queue+0x88/0x10c
> [ 3324.609399]  unregister_netdev+0x20/0x30
> [ 3324.613313]  otx2_remove+0x8c/0x310
> [ 3324.616794]  pci_device_shutdown+0x30/0x70
> [ 3324.620882]  device_shutdown+0x11c/0x204
> 
> [  966.664930] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> [  966.673712] Mem abort info:
> [  966.676497]   ESR = 0x96000006
> [  966.679543]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  966.684848]   SET = 0, FnV = 0
> [  966.687895]   EA = 0, S1PTW = 0
> [  966.691028] Data abort info:
> [  966.693900]   ISV = 0, ISS = 0x00000006
> [  966.697729]   CM = 0, WnR = 0
> ....
> [  966.833467] Call trace:
> [  966.835904]  cn10k_mdo_stop+0x20/0xa0
> [  966.839557]  macsec_dev_stop+0xe8/0x11c
> [  966.843384]  __dev_close_many+0xbc/0x140
> [  966.847298]  dev_close_many+0x84/0x120
> [  966.851039]  rollback_registered_many+0x114/0x5bc
> [  966.855735]  unregister_netdevice_many.part.0+0x14/0xa0
> [  966.860952]  unregister_netdevice_many+0x18/0x24
> [  966.865560]  macsec_notify+0x1ac/0x1c0
> [  966.869303]  raw_notifier_call_chain+0x50/0x70
> [  966.873738]  call_netdevice_notifiers_info+0x34/0x7c
> [  966.878694]  rollback_registered_many+0x354/0x5bc
> [  966.883390]  unregister_netdevice_queue+0x88/0x10c
> [  966.888173]  unregister_netdev+0x20/0x30
> [  966.892090]  otx2_remove+0x8c/0x310
> [  966.895571]  pci_device_shutdown+0x30/0x70
> [  966.899660]  device_shutdown+0x11c/0x204
> [  966.903574]  __do_sys_reboot+0x208/0x290
> [  966.907487]  __arm64_sys_reboot+0x20/0x30
> [  966.911489]  el0_svc_handler+0x80/0x1c0
> [  966.915316]  el0_svc+0x8/0x180
> [  966.918362] Code: f9400000 f9400a64 91220014 f94b3403 (f9400060)
> [  966.924448] ---[ end trace 341778e799c3d8d7 ]---
> 
> Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> index 9ec5f38d38a8..5f4402f7b03e 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> @@ -1065,6 +1065,9 @@ static int cn10k_mdo_stop(struct macsec_context *ctx)
>  	struct cn10k_mcs_txsc *txsc;
>  	int err;
>  
> +	if (!cfg)
> +		return 0;
> +
>  	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
>  	if (!txsc)
>  		return -ENOENT;
> @@ -1146,6 +1149,9 @@ static int cn10k_mdo_del_secy(struct macsec_context *ctx)
>  	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
>  	struct cn10k_mcs_txsc *txsc;
>  
> +	if (!cfg)
> +		return 0;

How did you get call to .mdo_del_secy if you didn't add any secy?

Thanks

> +
>  	txsc = cn10k_mcs_get_txsc(cfg, ctx->secy);
>  	if (!txsc)
>  		return -ENOENT;
> -- 
> 2.25.1
> 
