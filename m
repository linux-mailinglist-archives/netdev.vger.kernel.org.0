Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BA25829CD
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiG0PkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiG0PkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:40:10 -0400
X-Greylist: delayed 423 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Jul 2022 08:40:05 PDT
Received: from mail.sai.msu.ru (mail.sai.msu.ru [93.180.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7283DBEB;
        Wed, 27 Jul 2022 08:40:05 -0700 (PDT)
Received: from oak.local (unknown [83.167.113.121])
        by mail.sai.msu.ru (Postfix) with ESMTPSA id 102DD1603C6;
        Wed, 27 Jul 2022 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=sai.msu.ru; s=mail;
        t=1658935979; bh=XqSc/cfsfhBrKEn3XCkL9QnEX/0FNbuSlrJn/D5KsNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywKNO55fBkQaWNL1GaF+KhqBCZNM8nnGyMUwdwFMoGUixmPTTuIomlSJfuBfkA4i8
         yOyQ46K9TO43+dV5rp9Lm7f6KxYUq5jGBVp/1M+kE7P/FfCAJn4rS2+x6w5NFAVSBB
         JSM6uNyEVbZnQeWHi1DSYB3QFNzJC9zuREomM4PlRazGui8UM0UjNwYtkOYx1pkGQo
         meqGrrx9LLNzL+611+Jr9DzyJ/zdg59vN+Dl1pOv8VXtEQ30RWkLgPUYSOJ710jhuI
         TmzO20KG33yoU7nW4GNtP93Bzz0xfmTaTJVonq57Bd5vJOyKnUztqMliNQr3Mu2cN4
         COqRSwHeY3BkQ==
From:   "Matwey V. Kornilov" <matwey@sai.msu.ru>
To:     hdegoede@redhat.com
Cc:     andriy.shevchenko@linux.intel.com, carlo@endlessm.com,
        davem@davemloft.net, hkallweit1@gmail.com, js@sig21.net,
        linux-clk@vger.kernel.org, linux-wireless@vger.kernel.org,
        matwey.kornilov@gmail.com, mturquette@baylibre.com,
        netdev@vger.kernel.org, pierre-louis.bossart@linux.intel.com,
        sboyd@kernel.org, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>, stable@vger.kernel.org
Subject: [PATCH] platform/x86: pmc_atom: Add DMI quirk for Lex 3I380A/CW boards
Date:   Wed, 27 Jul 2022 18:32:32 +0300
Message-Id: <20220727153232.13359-1-matwey@sai.msu.ru>
X-Mailer: git-send-email 2.35.3
In-Reply-To: 08c744e6-385b-8fcf-ecdf-1292b5869f94@redhat.com
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lex 3I380A/CW (Atom E3845) motherboards are equipped with dual Intel I211
based 1Gbps copper ethernet:

     http://www.lex.com.tw/products/pdf/3I380A&3I380CW.pdf

This patch is to fix the issue with broken "LAN2" port. Before the
patch, only one ethernet port is initialized:

     igb 0000:01:00.0: added PHC on eth0
     igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
     igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
     igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
     igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
     igb: probe of 0000:02:00.0 failed with error -2

With this patch, both ethernet ports are available:

     igb 0000:01:00.0: added PHC on eth0
     igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
     igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
     igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
     igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
     igb 0000:02:00.0: added PHC on eth1
     igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
     igb 0000:02:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e5
     igb 0000:02:00.0: eth1: PBA No: FFFFFF-0FF
     igb 0000:02:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)

The issue was observed at 3I380A board with BIOS version "A4 01/15/2016"
and 3I380CW board with BIOS version "A3 09/29/2014".

Reference: https://lore.kernel.org/netdev/08c744e6-385b-8fcf-ecdf-1292b5869f94@redhat.com/
Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/platform/x86/pmc_atom.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index b8b1ed1406de..5dc82667907b 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -388,6 +388,24 @@ static const struct dmi_system_id critclk_systems[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "CEC10 Family"),
 		},
 	},
+	{
+		/* pmc_plt_clk* - are used for ethernet controllers */
+		.ident = "Lex 3I380A",
+		.callback = dmi_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "3I380A"),
+		},
+	},
+	{
+		/* pmc_plt_clk* - are used for ethernet controllers */
+		.ident = "Lex 3I380CW",
+		.callback = dmi_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Lex BayTrail"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "3I380CW"),
+		},
+	},
 	{
 		/* pmc_plt_clk0 - 3 are used for the 4 ethernet controllers */
 		.ident = "Lex 3I380D",
-- 
2.35.3

