Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7CA77268
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfGZTvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:51:54 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34686 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfGZTvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:51:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id w9so38675598wmd.1
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DMqh78qsPGfnakcNPgPt3fvjkckhBCyfkNvFybjBCtM=;
        b=ADI81Ip0snBBD8UoSzDhQMkzPrOmKPcjTfpBesgVd3kfThbIE194o1EvBcAvQVIxu5
         cMzid/WVa+2cS84UzyDrEnuKpYs9ywbX52fLsVbWgBkbCSuTY2pWTWvOYB0ZfBnvzkoW
         AT7TE0vuhAOgbsBs1JCUQyLc+3sPXp1xjzioxWot3ZtBN1LT/AIOwksyp3QYj+ey4wka
         MqQ51jDhrTtx8hAKlFayjPOPdJS99XdB4ZGhOdSbSnqJGjaBL7D7FMU3FFsyhGHHIL+D
         FnFw5qMS54tTebTxY6yns2wYJtn228GWn+VG3f4edFagUj/AjGyIOMrF9fJQ0j6oklN+
         GB6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DMqh78qsPGfnakcNPgPt3fvjkckhBCyfkNvFybjBCtM=;
        b=Q9coLHZQBvKU82M+gZ7XSnrwkraapsN7NYAaSSY/fEIn1xC7EWSJSQ2cBU7NsB/q5w
         4mntp6LBupTSlg05DIPn9/1bH+JpPnWdeRNqEtN8TK14rv04dvSxva2X9g1WrPh4IIu5
         QdnCWLQ01RZ/SZ/NKivG53YJpO19M9D3HJE0SoiGXedNAsiL4Z+9Dw1hlbWbv84fAEOx
         reW8yGx/ZT45G2YxT/JjJ/0L4gnlw7eqFsV3CYhn+BG32Es+ajPv99UsJhqpMOgckUIx
         J0eTtJr4NhZHPxu6W1ld1umHO5i7hWlaoo6CJQhEzkng2hVvDblj//zFm+g2DMF4P9qT
         baoQ==
X-Gm-Message-State: APjAAAU0ehlTkGYi4qdu4Fj1dMFdNA4zTpXYuWpflQb+WemXo1NsGjJn
        mnw6Oh08k6D45QUzAMFFeiuGdNFL
X-Google-Smtp-Source: APXvYqyQT/a2BNS5i+I75X5dEeCUpFfJDSCZ39ujZsSx4MgZzP5J7JV0HH1uDucQDSfLajbaBLFd+Q==
X-Received: by 2002:a7b:c4d0:: with SMTP id g16mr88382583wmk.88.1564170712486;
        Fri, 26 Jul 2019 12:51:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:55f1:e404:698f:358? (p200300EA8F43420055F1E404698F0358.dip0.t-ipconnect.de. [2003:ea:8f43:4200:55f1:e404:698f:358])
        by smtp.googlemail.com with ESMTPSA id l8sm98353947wrg.40.2019.07.26.12.51.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 12:51:52 -0700 (PDT)
Subject: [PATCH net-next 1/4] r8169: set GSO size and segment limits
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
Message-ID: <0091edd1-6e55-37c4-4551-ac3a9f48c0e9@gmail.com>
Date:   Fri, 26 Jul 2019 21:48:32 +0200
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

Set GSO max size and max segment number as in the vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5c337234b..52a9e2d2f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -569,6 +569,11 @@ enum rtl_rx_desc_bit {
 
 #define RsvdMask	0x3fffc000
 
+#define RTL_GSO_MAX_SIZE_V1	32000
+#define RTL_GSO_MAX_SEGS_V1	24
+#define RTL_GSO_MAX_SIZE_V2	64000
+#define RTL_GSO_MAX_SEGS_V2	64
+
 struct TxDesc {
 	__le32 opts1;
 	__le32 opts2;
@@ -6919,8 +6924,14 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* Disallow toggling */
 		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 
-	if (rtl_chip_supports_csum_v2(tp))
+	if (rtl_chip_supports_csum_v2(tp)) {
 		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+		dev->gso_max_size = RTL_GSO_MAX_SIZE_V2;
+		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V2;
+	} else {
+		dev->gso_max_size = RTL_GSO_MAX_SIZE_V1;
+		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V1;
+	}
 
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
-- 
2.22.0


