Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13CC15FEB7
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 14:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgBONyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 08:54:41 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43512 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgBONyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 08:54:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id r11so14289180wrq.10
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 05:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DC6Hwua0XIFj4DG4ZCjQ3w6UtylSA39EwFOJ9l+EITY=;
        b=YVOnxs2Hr6fMMMb9AxZWQjWvLuSV9D8uM+UWTdttCSgId3qR5a4dTWda39upX7F18I
         y0iYPUNS/DcsZPUEPt0acTSz3GQM+Y32//snUJsQbOh8G3wxZWiteI8xOpsl1pW5wF1x
         jzhMMtTjU7OUVwH6NNm+5PQ7BMhMMjb/Y86WwlBBdR4bmmluFGETaInG2FfGjNJDSQNa
         zTrHeYDj7ktJiWdVPsHBxZtlf9hccEA4lYT+mZWkNQNYx+myEkeWLYLIHkgM+DzR9WxN
         KkGuZV/+V47NRPShG6iaUyeqs4gIe/b8lNTQpMX4wA5iikR7NbKfSV7NqyJbUHH4bBbh
         7lCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DC6Hwua0XIFj4DG4ZCjQ3w6UtylSA39EwFOJ9l+EITY=;
        b=HL3k3kKMIdNDv1HWCuUY4KvUDWmdk7b1eyAg6CEcxWYePuR32xhLpmdgxpi+ZgJCgg
         1k3ivFM4ooRz4XjIQ79s21chp3uUPZBFNFlIw9p+TjmbLqLtH/KNWhIvKQ0ras2mQD5+
         Jp+g4rlK0jL1OEuP8bzJZquWBH6+Wo/MoZBewFZjwdWnqhz17CiY3ms1bTFo4OtC3vLk
         KXggoKs7xdICK084gYoN3n87L/dQfezZVs+NEhZN6Ee95ZPhkzkAy0WwheOjl8fQBTVO
         VNr29x7/Eoo8ILSu+9j6EIGAb5nebuAOzQEabs5oToUnWoT53/R1ZGzf0s5L8r/a72XU
         TdOQ==
X-Gm-Message-State: APjAAAXOEhy2esU0ajuwpDvWTgXdjVWGfWw1MF/aXaRpMg3v0jbN4mGM
        mQ1o5OIk6ubeln7bSOaOItJtivbf
X-Google-Smtp-Source: APXvYqz+3wGY83nYJOqYeH+ccb0P7jwSQKu0F1oNMxT7puKvmsayKdVEEqQpy1IvBvsZiDI/jcZH3w==
X-Received: by 2002:a5d:61cb:: with SMTP id q11mr10873425wrv.71.1581774877043;
        Sat, 15 Feb 2020 05:54:37 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1ddf:2e8f:533:981f? (p200300EA8F2960001DDF2E8F0533981F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1ddf:2e8f:533:981f])
        by smtp.googlemail.com with ESMTPSA id y7sm21230895wmd.1.2020.02.15.05.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 05:54:36 -0800 (PST)
Subject: [PATCH net-next 3/7] r8169: simplify setting netdev features
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Message-ID: <3f140e8b-c300-ca0d-8fb7-a7f92131a8e4@gmail.com>
Date:   Sat, 15 Feb 2020 14:49:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting dev->features a few lines later allows to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a9a55589e..bc92e8c55 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5544,9 +5544,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
 
-	dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
 	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_TX |
 		NETIF_F_HW_VLAN_CTAG_RX;
@@ -5568,7 +5565,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (rtl_chip_supports_csum_v2(tp)) {
 		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
-		dev->features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V2;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V2;
 	} else {
@@ -5583,9 +5579,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
 		dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
 		dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
-		dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
 	}
 
+	dev->features |= dev->hw_features;
+
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
 
-- 
2.25.0


