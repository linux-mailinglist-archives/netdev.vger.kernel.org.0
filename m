Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB343B96B
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfFJQ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:28:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42446 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389998AbfFJQZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:25:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so9803739wrl.9
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5b/VUR2lp6LAQoLNMgzCuTW5Z06uzjxtKNxXOR8Fq8g=;
        b=F5O/d/DZ6HenOhHbsRY2orRKi8vstASX2mxy2UxMfT+knhttO3o8xyTKT1xQs/3RPh
         Nn/ePl4bIxcAmcD6bJ3KGSH133K8heKzRwXtuPQ7zyjrcwAQjaG2IEElrbRT5wqTvm1b
         M/NGqhVPL7w4ROPsMg/xpgzw9JyV5+BT8EShfJA0W9owE/7DcwXCbvuDMKrbNGAvDloJ
         u66XMtZQCWp0reh/DdPDSl1J0TXodi0626bqBPEauhRkXtJmiJoC0jkfC1zjKif080BE
         ZF6LP8NJ8jD7NERiKsKRxrckUMrv5e2sEei1bTcJ7cT9jmqeL9uSKtqfhOLa+3vIdr3R
         Yq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5b/VUR2lp6LAQoLNMgzCuTW5Z06uzjxtKNxXOR8Fq8g=;
        b=Zfdco513xg3t6PkxstyY+qlwCvcKIzlhbxIJ3GkuKT4JAMB5ndCGogCz/IOsKb4Fb/
         ci2b1T4OpgWUw554iN4PBsKB1S74+QHppPzhM4230RY3QUd5N/1QHSIE2CnIyv0Lrq+D
         wFSvt3s+EJzXN99RMjlFNxr5pGO2eaSxuyL5/dTjs3rN3WKKv1AJ0BvmIqsDpyL61bfF
         bDQhvdvUEb2qq8Jh3/5lAvxfuV9EyYHel9RTqVfuQEr2+t/tVeVu7b1CBZM9V1TRWMwh
         3JRjR4OgZ1bPAw4MZhUeyjU9oxtdQ40Br7lRLgxE+IwGKPTkm4kEQZWpLHNhgRrwDdfX
         5/3A==
X-Gm-Message-State: APjAAAWDQM24wm7SqxgJwqDQNt7Q43wDrdKRzscc3pcc4GF7lM/V6n9E
        sh5cE+BmOAGhHzebZgbHnzuhkKOB
X-Google-Smtp-Source: APXvYqyor29m84iHTA0TpN6/dKbvvnzPvqojFjtq1puGuA6pNHLgYsdetz+Gu8iTw3a7csfCThGNSQ==
X-Received: by 2002:a5d:6acc:: with SMTP id u12mr37731942wrw.349.1560183943293;
        Mon, 10 Jun 2019 09:25:43 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8cc:c330:790b:34f7? (p200300EA8BF3BD0008CCC330790B34F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8cc:c330:790b:34f7])
        by smtp.googlemail.com with ESMTPSA id a67sm5696772wmh.40.2019.06.10.09.25.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 09:25:42 -0700 (PDT)
Subject: [PATCH next 1/5] r8169: improve setting interrupt mask
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Message-ID: <2285d93f-5d9f-1b28-7577-70322b3c363b@gmail.com>
Date:   Mon, 10 Jun 2019 18:21:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far several places in the code deal with setting the interrupt mask
for the respective chip versions. Improve this by having one function
for this only. In addition don't set RxFIFOOver for all 8101 chip
versions like in the vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 28 +++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8b7d45ff1..c62e6845f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5136,20 +5136,11 @@ static void rtl_hw_start_8168(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
 
-	/* Workaround for RxFIFO overflow. */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_11) {
-		tp->irq_mask |= RxFIFOOver;
-		tp->irq_mask &= ~RxOverflow;
-	}
-
 	rtl_hw_config(tp);
 }
 
 static void rtl_hw_start_8101(struct rtl8169_private *tp)
 {
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_30)
-		tp->irq_mask &= ~RxFIFOOver;
-
 	if (tp->mac_version == RTL_GIGA_MAC_VER_13 ||
 	    tp->mac_version == RTL_GIGA_MAC_VER_16)
 		pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
@@ -6491,29 +6482,38 @@ static const struct net_device_ops rtl_netdev_ops = {
 
 static const struct rtl_cfg_info {
 	void (*hw_start)(struct rtl8169_private *tp);
-	u16 irq_mask;
 	unsigned int has_gmii:1;
 	const struct rtl_coalesce_info *coalesce_info;
 } rtl_cfg_infos [] = {
 	[RTL_CFG_0] = {
 		.hw_start	= rtl_hw_start_8169,
-		.irq_mask	= SYSErr | LinkChg | RxOverflow | RxFIFOOver,
 		.has_gmii	= 1,
 		.coalesce_info	= rtl_coalesce_info_8169,
 	},
 	[RTL_CFG_1] = {
 		.hw_start	= rtl_hw_start_8168,
-		.irq_mask	= LinkChg | RxOverflow,
 		.has_gmii	= 1,
 		.coalesce_info	= rtl_coalesce_info_8168_8136,
 	},
 	[RTL_CFG_2] = {
 		.hw_start	= rtl_hw_start_8101,
-		.irq_mask	= LinkChg | RxOverflow | RxFIFOOver,
 		.coalesce_info	= rtl_coalesce_info_8168_8136,
 	}
 };
 
+static void rtl_set_irq_mask(struct rtl8169_private *tp)
+{
+	tp->irq_mask = RTL_EVENT_NAPI | LinkChg;
+
+	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
+		tp->irq_mask |= SYSErr | RxOverflow | RxFIFOOver;
+	else if (tp->mac_version == RTL_GIGA_MAC_VER_11)
+		/* special workaround needed */
+		tp->irq_mask |= RxFIFOOver;
+	else
+		tp->irq_mask |= RxOverflow;
+}
+
 static int rtl_alloc_irq(struct rtl8169_private *tp)
 {
 	unsigned int flags;
@@ -6874,8 +6874,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	jumbo_max = rtl_jumbo_max(tp);
 	dev->max_mtu = jumbo_max;
 
+	rtl_set_irq_mask(tp);
 	tp->hw_start = cfg->hw_start;
-	tp->irq_mask = RTL_EVENT_NAPI | cfg->irq_mask;
 	tp->coalesce_info = cfg->coalesce_info;
 
 	tp->fw_name = rtl_chip_infos[chipset].fw_name;
-- 
2.21.0


