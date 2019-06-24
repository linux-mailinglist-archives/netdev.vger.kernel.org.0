Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0B85064B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 11:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfFXJ5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 05:57:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41629 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfFXJ5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 05:57:21 -0400
Received: by mail-pl1-f196.google.com with SMTP id m7so6569267pls.8
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 02:57:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=9ZA8Iexrs/y5c8FvffbT362N37zmnH9csKA2fCgK9OY=;
        b=sQe6giogzLBa/dH0iomMIKj24Xxae1o5CXcwlNLEr4aCXz5rtRlZs9aupKzaMIdkvY
         7sMAZwHC38n46ukrNZ/XO3/D0dkLBiJW38d8X8U3igxeAG8URsKx1CisrZW56mNwu7LO
         zf7NJddQOoCZl3whdsxAXSlr0TuvUAc4ORL5gAxdiBgkl4U8P5jlG7SC+XN0UCeoWq9h
         +Dsd5emWeEgNgdvkj3mNMXnwkCDNSsZhgyuj1PWU3//y23rIFsU9sO4llC/5wq5VnyIC
         xpUxRNlbu2ly45niU7hA7YcxMIVxHVQXrlPlFdpFEmLw4xwugIx9jahnkV4MlHZ66MAT
         hq0w==
X-Gm-Message-State: APjAAAVD7ZuLXb1Kzs62jJG3DEs87X3EPKGfeBUYwfPnnW5ftjSNbzAa
        G4mEFSl3IGM8kQQT+ehwwzLnRA==
X-Google-Smtp-Source: APXvYqyhlEtx+PTabYdQPoUQm4v4dfwVYWiWo57Km7Qjwr2ZeSFUr7wTRl5jDUCxv/va9KjpKl64iQ==
X-Received: by 2002:a17:902:8509:: with SMTP id bj9mr32285512plb.79.1561370240329;
        Mon, 24 Jun 2019 02:57:20 -0700 (PDT)
Received: from localhost (220-132-236-182.HINET-IP.hinet.net. [220.132.236.182])
        by smtp.gmail.com with ESMTPSA id x7sm10010802pfm.82.2019.06.24.02.57.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 02:57:19 -0700 (PDT)
Date:   Mon, 24 Jun 2019 02:57:19 -0700 (PDT)
X-Google-Original-Date: Mon, 24 Jun 2019 02:50:25 PDT (-0700)
Subject:     Re: [PATCH 1/2] net: macb: Fix compilation on systems without COMMON_CLK
In-Reply-To: <c440e194-dc93-5a3e-7608-710afade9774@microchip.com>
CC:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@sifive.com>
To:     Nicolas.Ferre@microchip.com
Message-ID: <mhng-ac6d3a1f-07a8-40b5-a4ad-93e529ecc206@palmer-si-x1e>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 02:40:21 PDT (-0700), Nicolas.Ferre@microchip.com wrote:
> On 24/06/2019 at 08:16, Palmer Dabbelt wrote:
>> External E-Mail
>> 
>> 
>> The patch to add support for the FU540-C000 added a dependency on
>> COMMON_CLK, but didn't express that via Kconfig.  This fixes the build
>> failure by adding CONFIG_MACB_FU540, which depends on COMMON_CLK and
>> conditionally enables the FU540-C000 support.
> 
> Let's try to limit the use of  #ifdef's throughout the code. We are 
> using them in this driver but only for the hot paths and things that 
> have an impact on performance. I don't think it's the case here: so 
> please find another option => NACK.

OK.  Would you accept adding a Kconfig dependency of the generic MACB driver on
COMMON_CLK, as suggested in the cover letter?

> 
>> I've built this with a powerpc allyesconfig (which pointed out the bug)
>> and on RISC-V, manually checking to ensure the code was built.  I
>> haven't even booted the resulting kernels.
>> 
>> Fixes: c218ad559020 ("macb: Add support for SiFive FU540-C000")
>> Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
>> ---
>>   drivers/net/ethernet/cadence/Kconfig     | 11 +++++++++++
>>   drivers/net/ethernet/cadence/macb_main.c | 12 ++++++++++++
>>   2 files changed, 23 insertions(+)
>> 
>> diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
>> index 1766697c9c5a..74ee2bfd2369 100644
>> --- a/drivers/net/ethernet/cadence/Kconfig
>> +++ b/drivers/net/ethernet/cadence/Kconfig
>> @@ -40,6 +40,17 @@ config MACB_USE_HWSTAMP
>>   	---help---
>>   	  Enable IEEE 1588 Precision Time Protocol (PTP) support for MACB.
>>   
>> +config MACB_FU540
>> +	bool "Enable support for the SiFive FU540 clock controller"
>> +	depends on MACB && COMMON_CLK
>> +	default y
>> +	---help---
>> +	  Enable support for the MACB/GEM clock controller on the SiFive
>> +	  FU540-C000.  This device is necessary for switching between 10/100
>> +	  and gigabit modes on the FU540-C000 SoC, without which it is only
>> +	  possible to bring up the Ethernet link in whatever mode the
>> +	  bootloader probed.
>> +
>>   config MACB_PCI
>>   	tristate "Cadence PCI MACB/GEM support"
>>   	depends on MACB && PCI && COMMON_CLK
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index c545c5b435d8..a903dfdd4183 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -41,6 +41,7 @@
>>   #include <linux/pm_runtime.h>
>>   #include "macb.h"
>>   
>> +#ifdef CONFIG_MACB_FU540
>>   /* This structure is only used for MACB on SiFive FU540 devices */
>>   struct sifive_fu540_macb_mgmt {
>>   	void __iomem *reg;
>> @@ -49,6 +50,7 @@ struct sifive_fu540_macb_mgmt {
>>   };
>>   
>>   static struct sifive_fu540_macb_mgmt *mgmt;
>> +#endif
>>   
>>   #define MACB_RX_BUFFER_SIZE	128
>>   #define RX_BUFFER_MULTIPLE	64  /* bytes */
>> @@ -3956,6 +3958,7 @@ static int at91ether_init(struct platform_device *pdev)
>>   	return 0;
>>   }
>>   
>> +#ifdef CONFIG_MACB_FU540
>>   static unsigned long fu540_macb_tx_recalc_rate(struct clk_hw *hw,
>>   					       unsigned long parent_rate)
>>   {
>> @@ -4056,7 +4059,9 @@ static int fu540_c000_init(struct platform_device *pdev)
>>   
>>   	return macb_init(pdev);
>>   }
>> +#endif
>>   
>> +#ifdef CONFIG_MACB_FU540
>>   static const struct macb_config fu540_c000_config = {
>>   	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_JUMBO |
>>   		MACB_CAPS_GEM_HAS_PTP,
>> @@ -4065,6 +4070,7 @@ static const struct macb_config fu540_c000_config = {
>>   	.init = fu540_c000_init,
>>   	.jumbo_max_len = 10240,
>>   };
>> +#endif
>>   
>>   static const struct macb_config at91sam9260_config = {
>>   	.caps = MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII,
>> @@ -4155,7 +4161,9 @@ static const struct of_device_id macb_dt_ids[] = {
>>   	{ .compatible = "cdns,emac", .data = &emac_config },
>>   	{ .compatible = "cdns,zynqmp-gem", .data = &zynqmp_config},
>>   	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
>> +#ifdef CONFIG_MACB_FU540
>>   	{ .compatible = "sifive,fu540-macb", .data = &fu540_c000_config },
>> +#endif
>>   	{ /* sentinel */ }
>>   };
>>   MODULE_DEVICE_TABLE(of, macb_dt_ids);
>> @@ -4363,7 +4371,9 @@ static int macb_probe(struct platform_device *pdev)
>>   
>>   err_disable_clocks:
>>   	clk_disable_unprepare(tx_clk);
>> +#ifdef CONFIG_MACB_FU540
>>   	clk_unregister(tx_clk);
>> +#endif
>>   	clk_disable_unprepare(hclk);
>>   	clk_disable_unprepare(pclk);
>>   	clk_disable_unprepare(rx_clk);
>> @@ -4398,7 +4408,9 @@ static int macb_remove(struct platform_device *pdev)
>>   		pm_runtime_dont_use_autosuspend(&pdev->dev);
>>   		if (!pm_runtime_suspended(&pdev->dev)) {
>>   			clk_disable_unprepare(bp->tx_clk);
>> +#ifdef CONFIG_MACB_FU540
>>   			clk_unregister(bp->tx_clk);
>> +#endif
>>   			clk_disable_unprepare(bp->hclk);
>>   			clk_disable_unprepare(bp->pclk);
>>   			clk_disable_unprepare(bp->rx_clk);
>> 
> 
> 
> -- 
> Nicolas Ferre
