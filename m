Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FED7726B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfGZTwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:52:01 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39842 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbfGZTv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:51:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id u25so38218174wmc.4
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mmm3tH+f5jenqu17NutsRzK0GsOvD5iTjxqZ6zoyFJQ=;
        b=O69ShzhiYnqxesiZEkNHp1HfZxeS6M4hYkJ+Jb7n2qNmt+2iE7DGQIJHrFC6FLmql6
         wTiNuab9T9zG1bwCQw9cKHTREolJfyjV+nQ5qdTGKT2hR9kgK9wYgyVd8XiujEofkedy
         hktymGZ5O8I9vGfpVkCDrtDaGg/B5DnMH7sQk59KoAantolYbtI7E3D8t+J8c2rD9Q9u
         Cee6Y4KSGDpyA/TeQlOPHgLRz/lfpAHFXgOVFM7c6+slf6YHNG/qeqsyMebIESOApvuW
         AIaLcRX4jOpt1Hsi/C3WYXBTB80ysoprAo9neU4Iea5koJWRaxWThStsee1mn1c9MWwN
         sfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mmm3tH+f5jenqu17NutsRzK0GsOvD5iTjxqZ6zoyFJQ=;
        b=UEmtzUkSssZgddn+whQFKISDPOdNc6zVyfNmpoziYXEGSLKO31d1mcoBAJmVDIfkRC
         y8IX5qJdytkeO27NXmkAaRnXsJNX52Ae0q9WUMy2Ru1RQ3aS2bFEtKW7R3JtRwuWt1i9
         JK3Lv0IrvJSZ5Uj97yVUuWEKC3MMnSzeZYNQNc4+UnDMVISWGgijzaZL8frlKU3siLww
         nd0SieLHSwT7yFtJOIgY7ugq9JT7wZa4PkAZjqWOnexobBRqYBG0e+H77Lh/ON/7waPt
         ash6TM5HWJe8pAW48JrgDawArJcQuY1k/nX9PwlJQ2uCHhs8KvyofSjuCtJP+Mwl4IA5
         wPZQ==
X-Gm-Message-State: APjAAAVt3h3MWFyvwu6eS20xGWTt6UL0JF/2WpD/SanYhaChkM90U+Es
        /VCRiIV9M81yXp2N4tAGCf31HCIX
X-Google-Smtp-Source: APXvYqzO03nojCRJ4kNbiD0Y9EXgixU16W/aWnMmO5Awu69Isne50qgQbSJQ751eOALgH4bxedq2eQ==
X-Received: by 2002:a1c:1f41:: with SMTP id f62mr88035621wmf.176.1564170716409;
        Fri, 26 Jul 2019 12:51:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:55f1:e404:698f:358? (p200300EA8F43420055F1E404698F0358.dip0.t-ipconnect.de. [2003:ea:8f43:4200:55f1:e404:698f:358])
        by smtp.googlemail.com with ESMTPSA id f2sm47605182wrq.48.2019.07.26.12.51.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 12:51:55 -0700 (PDT)
Subject: [PATCH net-next 4/4] r8169: enable HW csum and TSO
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
Message-ID: <2ac06cf3-3240-ef67-db89-735bd07bea21@gmail.com>
Date:   Fri, 26 Jul 2019 21:51:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable HW csum and TSO per default except on known buggy chip versions.
Realtek confirmed that RTL8168evl has a HW issue with TSO.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f77159540..61a23aee0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6879,11 +6879,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
 
-	/* don't enable SG, IP_CSUM and TSO by default - it might not work
-	 * properly for all devices */
-	dev->features |= NETIF_F_RXCSUM |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-
+	dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
+		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_TX |
+		NETIF_F_HW_VLAN_CTAG_RX;
 	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_TX |
 		NETIF_F_HW_VLAN_CTAG_RX;
@@ -6903,6 +6901,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (rtl_chip_supports_csum_v2(tp)) {
 		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+		dev->features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V2;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V2;
 	} else {
@@ -6910,6 +6909,13 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V1;
 	}
 
+	/* RTL8168e-vl has a HW issue with TSO */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
+		dev->vlan_features &= ~NETIF_F_ALL_TSO;
+		dev->hw_features &= ~NETIF_F_ALL_TSO;
+		dev->features &= ~NETIF_F_ALL_TSO;
+	}
+
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
 
-- 
2.22.0


