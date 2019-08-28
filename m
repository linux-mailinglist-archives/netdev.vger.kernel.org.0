Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310C3A0B85
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfH1U33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:29:29 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35710 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfH1U32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:29:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so1452005wmg.0
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8Rv4AAo8R3kQnDh7ur1n9pm4iYI4Aizo/u0DQ/4aK4I=;
        b=mIXs+hVjNbofK7/NLU2XzEBf+P+Y9unYciCA8yWX2/qrbDPyDKaryrGij79qWQrtkn
         OLT8gL4SSuvrzPHDAd7om4xw1nwAM18M/qbW/8YB9IYQaS0wEbwSvYwIbqYRXrSeEdMT
         xpvFHz3baERUq/HpFmG+uqpeXLWgl1I5RBSiv2Z4y8lfoOKSGz3Mozr/HXawDBFU+fT7
         9ioc7fbtljp7JeOf0aLR59NHHngsRXDLCS80luJD7az/ITPC8KPg3g1FVWcYmwIZ0t6M
         Qyf/BaOPvaKHb9VaucAUiBolmHp9xl6IiXs4kLFvQ3peSuFYLDnhbB3LU8GgBV9oRrT5
         dbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Rv4AAo8R3kQnDh7ur1n9pm4iYI4Aizo/u0DQ/4aK4I=;
        b=GkVFtlgFTnWD//TxxEWUtKt5cruyZKpcUHeYEnUQ7+/bsLgUxo+BC5w9WtvxRMQXk9
         yX1uUw6chcOYtGxI0CZ/5GtgCiafof+5EkeboZEMhpQY/dA+ogI9LdJLrg6hVx+K0Les
         //3BjmatSeZXc6Kw7/Zo/kDEOYLfpgcIGu4e8U5BogF/Yh8Y7KCP94WSEl8CTxD4/daC
         eYuVQziI5ZiCW6p6i/xjFGXBFFA2dv2w6r99+qtPA8yqnpEov75fmX4cZW/Qx2NkDUwQ
         X+tAf4uxAgIqKPw8UsZJPQQhZXhJKbqlGpSrK+MtbqkNgQ+EE+3qW/IATmbA09iDw49Q
         f0SQ==
X-Gm-Message-State: APjAAAXq++agn/Ad+M8lK1/GMy8J5qRJ99etkhgs658skAvV5Bck+n4d
        OJ59hJyqLslD5O97Ofk0ENckawit
X-Google-Smtp-Source: APXvYqyzQ0lea2I6D53lt2x4cNZ7GIp4zJvsf1jW8pKFpF9gcCEuxfXQg/YiXekyWR84klKP3uT0MQ==
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr6980496wmh.63.1567024166187;
        Wed, 28 Aug 2019 13:29:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id w13sm428824wre.44.2019.08.28.13.29.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:29:25 -0700 (PDT)
Subject: [PATCH net-next v2 3/9] r8169: factor out reading MAC address from
 registers
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Message-ID: <48558933-b4f0-7d4a-b61d-103b76f013b6@gmail.com>
Date:   Wed, 28 Aug 2019 22:25:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For RTL8125 we will have to read the MAC address also from another
register range, therefore create a small helper.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e9d900c11..7d89826cb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -741,6 +741,14 @@ static bool rtl_supports_eee(struct rtl8169_private *tp)
 	       tp->mac_version != RTL_GIGA_MAC_VER_39;
 }
 
+static void rtl_read_mac_from_reg(struct rtl8169_private *tp, u8 *mac, int reg)
+{
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		mac[i] = RTL_R8(tp, reg + i);
+}
+
 struct rtl_cond {
 	bool (*check)(struct rtl8169_private *);
 	const char *msg;
@@ -6630,7 +6638,7 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 {
 	struct net_device *dev = tp->dev;
 	u8 *mac_addr = dev->dev_addr;
-	int rc, i;
+	int rc;
 
 	rc = eth_platform_get_mac_address(tp_to_dev(tp), mac_addr);
 	if (!rc)
@@ -6640,8 +6648,7 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 	if (is_valid_ether_addr(mac_addr))
 		goto done;
 
-	for (i = 0; i < ETH_ALEN; i++)
-		mac_addr[i] = RTL_R8(tp, MAC0 + i);
+	rtl_read_mac_from_reg(tp, mac_addr, MAC0);
 	if (is_valid_ether_addr(mac_addr))
 		goto done;
 
-- 
2.23.0


