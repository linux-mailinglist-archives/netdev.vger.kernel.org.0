Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BB3646ADF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiLHIov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiLHIoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:44:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B762D634B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:44:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5AAC61D0C
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE68DC433C1;
        Thu,  8 Dec 2022 08:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670489075;
        bh=4Od5jI8PP500Ivc1x21S6isQvmmiJ54/ylxZPILU1lY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cmB/sB3DU7qzYDJnJoXLMtdOhnXa8m0HkNwDuQTxzbp97f9LMuKI64O1BFjt/4Y1L
         /7+azhbxTWvouwuGFMcEBkv371HModImESN8OTSvPxMi4+woRM9eyvHEAZltBMoN7n
         eAaJoHY28gociiIkmWEbOQjpGat6A/eulpaKNYYzQQLEIkvYLXFgwxWIa97p8LBQgj
         /XiTZQ4C/pu7db1KCPLxiBRS2oKVMyf/QLbea0kEXKbpJFcxFzO5ik+k/fGummT1Pg
         XmYxtSIE52SL6tV7Skfr8elLXJVjp87PUhw+YtFlosiCMsB2WY9cbr4lCpTOpZp2o/
         AUc4k+3Mwqlvw==
Date:   Thu, 8 Dec 2022 10:44:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com
Subject: Re: [PATCH v3 net-next 2/2] net: ethernet: mtk_wed: fix possible
 deadlock if mtk_wed_wo_init fails
Message-ID: <Y5Gj7y0412M9zNpD@unreal>
References: <cover.1670421354.git.lorenzo@kernel.org>
 <b28b55a639002a56b77c0651a4122ebede041936.1670421354.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b28b55a639002a56b77c0651a4122ebede041936.1670421354.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 03:04:55PM +0100, Lorenzo Bianconi wrote:
> Introduce __mtk_wed_detach() in order to avoid a deadlock in
> mtk_wed_attach routine if mtk_wed_wo_init fails since both
> mtk_wed_attach and mtk_wed_detach run holding hw_lock mutex.
> 
> Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_wed.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
> index 4ef23eadd69e..a6271449617f 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> @@ -577,12 +577,10 @@ mtk_wed_deinit(struct mtk_wed_device *dev)
>  }
>  

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
