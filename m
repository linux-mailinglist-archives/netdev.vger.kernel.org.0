Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949726C0BC4
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 09:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjCTIJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 04:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjCTIJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 04:09:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737BD188
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 01:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679299751; x=1710835751;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K9iTaJAeqKf3spu4edy686+6ZVRu3c/BYHtP0Lr6VOE=;
  b=nRsjTKbkx/NTstP/3WBMWC90m2i3eyHvIt7FMwfz5GBmH9pZQvg0eRmN
   ogSE/Q84QyBE4CtiYODiCdYRuv4oSmcpDjkoBkCCAlokrYbuukU2mEetg
   XK+NreXv1MZkl9eKya96cjoNlQc2ZvP8DweIZjMEu4oPBLBSariZF4M+K
   8Yb02/vFoP6pchlvmD/3TNJZvWn7KRGel+oMcJLin5JpDFqEoUU/CL1Ew
   1bWSqDx1KiDXCxcMUsS8i4MHLqMeTjqQP14q4PIHMqdC/NNEGe8vFNcIL
   sem/TO7Su/MdSSha7h1HmZptBqvHc/7RZFtgh8LD1ynM7CvbAjVgQadc3
   w==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="scan'208";a="206239606"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Mar 2023 01:09:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 01:09:06 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 20 Mar 2023 01:09:06 -0700
Date:   Mon, 20 Mar 2023 09:09:06 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nathan Chancellor <nathan@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ndesaulniers@google.com>, <trix@redhat.com>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>,
        <patches@lists.linux.dev>
Subject: Re: [PATCH net-next] net: pasemi: Fix return type of
 pasemi_mac_start_tx()
Message-ID: <20230320080906.yowjcay7qvcxv63f@soft-dev3-1>
References: <20230319-pasemi-incompatible-pointer-types-strict-v1-1-1b9459d8aef0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230319-pasemi-incompatible-pointer-types-strict-v1-1-1b9459d8aef0@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/19/2023 16:41, Nathan Chancellor wrote:
> 
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> warning in clang aims to catch these at compile time, which reveals:
> 
>   drivers/net/ethernet/pasemi/pasemi_mac.c:1665:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit         = pasemi_mac_start_tx,
>                                     ^~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of
> pasemi_mac_start_tx() to match the prototype's to resolve the warning.
> While PowerPC does not currently implement support for kCFI, it could in
> the future, which means this warning becomes a fatal CFI failure at run
> time.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/net/ethernet/pasemi/pasemi_mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
> index aaab590ef548..ed7dd0a04235 100644
> --- a/drivers/net/ethernet/pasemi/pasemi_mac.c
> +++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
> @@ -1423,7 +1423,7 @@ static void pasemi_mac_queue_csdesc(const struct sk_buff *skb,
>         write_dma_reg(PAS_DMA_TXCHAN_INCR(txring->chan.chno), 2);
>  }
> 
> -static int pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
> +static netdev_tx_t pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
>  {
>         struct pasemi_mac * const mac = netdev_priv(dev);
>         struct pasemi_mac_txring * const txring = tx_ring(mac);
> 
> ---
> base-commit: e8d018dd0257f744ca50a729e3d042cf2ec9da65
> change-id: 20230319-pasemi-incompatible-pointer-types-strict-8569226f4e10
> 
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
> 

-- 
/Horatiu
