Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B7F626E6C
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 09:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiKMICo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 03:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiKMICm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 03:02:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C134813E97
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 00:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 431F760B1A
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 08:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA59AC433D6;
        Sun, 13 Nov 2022 08:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668326559;
        bh=ytFdfs058L5ijRmzc+7As48eGT1KENit1zTKFoAbfyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PowDYh+EjTm2Fng74z4Pa98MdDIlatbTMyY2p8y/v7SC+zhaRpQSFNXpGn319kGOa
         PNisEP9E5U30nYtV0ahdrnvgUMxltGFvLUIHnHU6vQUl2FLQapX0xGvDQZvs0IdRdU
         xGSaG4yShrjhHmxKm0Dg3rX4zfVhiz9JnDm/ijr8P4QEmnQTnxuJYCsaCEmMXgBOTa
         eBM2Cxf5toVnCQA1yQzHluRMqxrKMZTOVSNCCzH5FG9PlXTt9JumY2kjVlRHb1SjWK
         mYS8T2wILjH35rMPVg9OuBxTLEpfrWZnmErYeJ3KXM3Z2yOLCGWc6n+SoBirrJEIrS
         T8fVRrQZit8+g==
Date:   Sun, 13 Nov 2022 10:02:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gospo@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] bnxt_en: Remove debugfs when pci_register_driver
 failed
Message-ID: <Y3Ckmiael4/RsT21@unreal>
References: <20221111070433.3498215-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111070433.3498215-1-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 03:04:33PM +0800, Gaosheng Cui wrote:
> When pci_register_driver failed, we need to remove debugfs,
> which will caused a resource leak, fix it.
> 
> Resource leak logs as follows:
> [   52.184456] debugfs: Directory 'bnxt_en' with parent '/' already present!
> 
> Fixes: cabfb09d87bd ("bnxt_en: add debugfs support for DIM")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 743504a27b71..0fe164b42c5d 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -14059,8 +14059,16 @@ static struct pci_driver bnxt_pci_driver = {
>  
>  static int __init bnxt_init(void)
>  {
> +	int err;
> +
>  	bnxt_debug_init();
> -	return pci_register_driver(&bnxt_pci_driver);
> +	err = pci_register_driver(&bnxt_pci_driver);
> +	if (err) {
> +		bnxt_debug_exit();
> +		return err;
> +	}
> +
> +	return 0;
>  }
>  

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
