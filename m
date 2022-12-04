Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C22641D28
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 14:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiLDNHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 08:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDNHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 08:07:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2172217899
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 05:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8AE1B8075D
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 13:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5E5C433C1;
        Sun,  4 Dec 2022 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670159222;
        bh=chlRnalb7pVdKBbL3xGD8d14nSvltNKVeqlHVirWbRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UQx82WapAzgvTFf5/1aEQLF7JcEQ7XSfQDR/4FGloJIsltQBF3dW7GctJe711/AG/
         GmEcukTONqrDRD3Y82mUrqc6FibQSBOrK0mVMtR4LHpldUNO6rUnhyT514RTqnGiFa
         iy6yJXrk2rz4i+PqXfAGCBF13Yjt0ui1zDOjfxraKniawbmtqvWDD+2OSXvYmAeYlA
         uOFAHlbOVGRklSFyyc3v+G8f42P7G5PO4vAP5FNABmOjMwMEb0u2BVtte1oUdIQJFc
         OVLaX2Xn9NGOGTTDig/8JJFN4wZqKlJdRGiFKGuY+6nveEVzJJSpJsRIZWRwfLbUrC
         iILT8FIZXkzkQ==
Date:   Sun, 4 Dec 2022 15:06:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix possible deadlock
 if mtk_wed_wo_init fails
Message-ID: <Y4ybbkn+nXkGsqWe@unreal>
References: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 06:36:33PM +0100, Lorenzo Bianconi wrote:
> Introduce __mtk_wed_detach() in order to avoid a possible deadlock in
> mtk_wed_attach routine if mtk_wed_wo_init fails.
> 
> Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_wed.c     | 24 ++++++++++++++-------
>  drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 10 ++++++---
>  drivers/net/ethernet/mediatek/mtk_wed_wo.c  |  3 +++
>  3 files changed, 26 insertions(+), 11 deletions(-)

<...>

> diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> index f9539e6233c9..b084009a32f9 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> @@ -176,6 +176,9 @@ int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
>  	u16 seq;
>  	int ret;
>  
> +	if (!wo)
> +		return -ENODEV;

<...>

>  static void
>  mtk_wed_wo_hw_deinit(struct mtk_wed_wo *wo)
>  {
> +	if (!wo)
> +		return;

How are these changes related to the written in deadlock?
How is it possible to get internal mtk functions without valid wo?

Thanks

> +
>  	/* disable interrupts */
>  	mtk_wed_wo_set_isr(wo, 0);
>  
> -- 
> 2.38.1
> 
