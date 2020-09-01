Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC05258BB5
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIAJf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:35:27 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:26528 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgIAJf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:35:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598952925; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=qNTZoSjMOlARZfdwaGR/PtLZDXAa33m0efXNFazpRmA=;
 b=f9zZUnEXzWPwW+wTljFGObNMi20qjYERtLm7rpDnRyWnyx1kHvlrE7ey3uhcsLINqtjxf0C+
 X3cK+kKq9ogEIOcE92oS4uT127Hy1tG5NnG/ktaCZgsC8bXt3cmjBfhOsVNHVN0LjviwfxxC
 EyFg9Gut+G53Hb3SZ/dfQDX6y6M=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f4e15d9252c5224404585b7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 09:35:21
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0FB3EC43391; Tue,  1 Sep 2020 09:35:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F131EC433CA;
        Tue,  1 Sep 2020 09:35:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F131EC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: switch from 'pci_' to 'dma_' API
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200820144604.144521-1-christophe.jaillet@wanadoo.fr>
References: <20200820144604.144521-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        Larry.Finger@lwfinger.net, straube.linux@gmail.com,
        zhengbin13@huawei.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901093521.0FB3EC43391@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 09:35:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> The only file where some GFP_ flags are updated is 'pci.c'.
> 
> When memory is allocated in '_rtl_pci_init_tx_ring()' and
> '_rtl_pci_init_rx_ring()' GFP_KERNEL can be used because both functions are
> called from a probe function and no spinlock is taken.
> 
> The call chain is:
>   rtl_pci_probe
>     --> rtl_pci_init
>       --> _rtl_pci_init_trx_ring
>         --> _rtl_pci_init_rx_ring
>         --> _rtl_pci_init_tx_ring
> 
> 
> @@
> @@
> -    PCI_DMA_BIDIRECTIONAL
> +    DMA_BIDIRECTIONAL
> 
> @@
> @@
> -    PCI_DMA_TODEVICE
> +    DMA_TO_DEVICE
> 
> @@
> @@
> -    PCI_DMA_FROMDEVICE
> +    DMA_FROM_DEVICE
> 
> @@
> @@
> -    PCI_DMA_NONE
> +    DMA_NONE
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_alloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_zalloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_free_consistent(e1, e2, e3, e4)
> +    dma_free_coherent(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_single(e1, e2, e3, e4)
> +    dma_map_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_single(e1, e2, e3, e4)
> +    dma_unmap_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4, e5;
> @@
> -    pci_map_page(e1, e2, e3, e4, e5)
> +    dma_map_page(&e1->dev, e2, e3, e4, e5)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_page(e1, e2, e3, e4)
> +    dma_unmap_page(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_sg(e1, e2, e3, e4)
> +    dma_map_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_sg(e1, e2, e3, e4)
> +    dma_unmap_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
> +    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_device(e1, e2, e3, e4)
> +    dma_sync_single_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
> +    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
> +    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2;
> @@
> -    pci_dma_mapping_error(e1, e2)
> +    dma_mapping_error(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_dma_mask(e1, e2)
> +    dma_set_mask(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_consistent_dma_mask(e1, e2)
> +    dma_set_coherent_mask(&e1->dev, e2)
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net> for rtl8821ae.

Failed to apply, please rebase on top of wireless-drivers-next.

Recorded preimage for 'drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c'
Recorded preimage for 'drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c'
Recorded preimage for 'drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c'
error: Failed to merge in the changes.
Applying: rtlwifi: switch from 'pci_' to 'dma_' API
Using index info to reconstruct a base tree...
M	drivers/net/wireless/realtek/rtlwifi/pci.c
M	drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
M	drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
M	drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
M	drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
M	drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
M	drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
M	drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
M	drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
M	drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/pci.c
Patch failed at 0001 rtlwifi: switch from 'pci_' to 'dma_' API
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11726377/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

