Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 123604AD23
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbfFRVPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:15:06 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39696 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730350AbfFRVPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:15:05 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so4697468wma.4;
        Tue, 18 Jun 2019 14:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rWwSJeLUsFHwAKGFtL8HKocirM8z2NvBy3ERORUMtdg=;
        b=XvaZP0OFZUyDtAFm8Jt0dCdogaeIMkmtHWzy/z+NaDk2EmVHjipKfok/GCvnfBCddz
         CCawxZfXYZOrsRu5u+tcj/ylBVY8kj/yw0E+TXT+embp8vIaj+imxJC2q/Bkil8yOV9y
         VxoJnO3aBSTu/jvHckfrIQGBHrPgamLYxwRqmnGI9OxsOcsOj9nYbjKDX1MPYBUEUiE4
         8/JdYqOgbJqufHOEVtpBgWmETPn6O3NqN74wa1Mx61KOwpCIL6XdHZ9HKucVmQFC9xrk
         0qPJOEqyogNNALobB90eiNT0Uj6LugfjfspjyUSzSs6b26yAmisBmrkdcg04Bf3m0Q35
         iB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rWwSJeLUsFHwAKGFtL8HKocirM8z2NvBy3ERORUMtdg=;
        b=XBltXh21laWk5llgZW4FNNzZ5H43o1X4EL2szV7h2iXw5LAxNmO89lSP0HOaYDxvKu
         T3onKzqcMlJVaIuZFGaPInz3pF6vYnPD4oLhqjUouYNuv8PxeCTaawRUqUxKU4i3eSGW
         KLMzd4QHIno694U9H2XiMahPEnHYxj6GTSZy+a4xgzYLcXBsa1c9aZ1uBZEYL45hS0Nq
         rQ5bHxXuedgilubreQQ899SYqBe717S/Zf2bhiesbKsK47yAKcrFBabPjwEDvU5EQpzx
         xQxSmEh5r9udmZKTKSiWHylkghVFXO+/9bir97oqsf7oIswo9qerQTS0ZKmreDnFMMJ5
         u3cg==
X-Gm-Message-State: APjAAAXPpj6R3Var2YUi5+385jDBkUOEx7dimehGbupWOVBYM/RXjqPw
        zxKtrqo9v55rBFUFVo9ICcGI+fDi
X-Google-Smtp-Source: APXvYqxsrGzOaEsC2qr3FAIs6zt3ylrJo+Csd3rypjCYCc5C9R7IAL4yO6RqnzyX5RHavRuv3/vfZA==
X-Received: by 2002:a1c:67c2:: with SMTP id b185mr4859786wmc.98.1560892503351;
        Tue, 18 Jun 2019 14:15:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:28c3:39c3:997e:395f? (p200300EA8BF3BD0028C339C3997E395F.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:28c3:39c3:997e:395f])
        by smtp.googlemail.com with ESMTPSA id q20sm35973938wra.36.2019.06.18.14.15.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 14:15:02 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: don't activate ASPM in chip if OS can't
 control ASPM
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5ea56278-05e2-794f-5f66-23343e72164c@gmail.com>
Message-ID: <680bce5c-44e7-b9ad-0f41-d7a4a70462b7@gmail.com>
Date:   Tue, 18 Jun 2019 23:14:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <5ea56278-05e2-794f-5f66-23343e72164c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain chip version / board combinations have massive problems if
ASPM is active. If BIOS enables ASPM and doesn't let OS control it,
then we may have a problem with the current code. Therefore check the
return code of pci_disable_link_state() and don't enable ASPM in the
network chip if OS can't control ASPM.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2e2a74aa0..48b8a90f7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -652,6 +652,7 @@ struct rtl8169_private {
 
 	unsigned irq_enabled:1;
 	unsigned supports_gmii:1;
+	unsigned aspm_manageable:1;
 	dma_addr_t counters_phys_addr;
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
@@ -4286,7 +4287,8 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
 
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
-	if (enable) {
+	/* Don't enable ASPM in the chip if OS can't control ASPM */
+	if (enable && tp->aspm_manageable) {
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
 	} else {
@@ -6678,7 +6680,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Disable ASPM completely as that cause random device stop working
 	 * problems as well as full system hangs for some PCIe devices users.
 	 */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
+					  PCIE_LINK_STATE_L1);
+	tp->aspm_manageable = !rc;
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
-- 
2.22.0


