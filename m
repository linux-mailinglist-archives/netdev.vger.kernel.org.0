Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81E81FD687
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgFQU4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbgFQU4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:56:53 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30D0C061755
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:51 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r7so3862942wro.1
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e2uEbfhiW8TczOATnDb4CRx8CnIR8PSnuYhqZA/V3hA=;
        b=jFtWTOent+BW8GEwNFKoJ+J1/hJos2l8WrYD4ikGwt/0sqHIwkjnvERUDs9U4ph3eC
         0EZmvlj4sKS6sksPA/7DZs/p7IL6S2+pSlh2WrU6r/+6u1mhxXBMpWSZ/Dff5l6LKp9T
         vo1ZI6HEiNc99lWX+8+FkDSG2MD37wsAssc/Ang3deivzUtSn1Kz/eNgxm2+uoAoyA26
         ic0+XorXdR33VjsjRHZgUxkbLvIRFLEtbRe6NgRZ+zBzkKBjFzwrnY5pRxNSZSwxiKHm
         CNivOwvDf5w+c5oJF2Ylcl7ZLc6Ebuqy6zB0vdOdDyc/rRp1s663KaPf+MY73v1d2X+K
         jjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e2uEbfhiW8TczOATnDb4CRx8CnIR8PSnuYhqZA/V3hA=;
        b=AAP0Xurvn5mZXyYiu6uVssQIKtvnPm+LxXbTzZbkgsTW8Vd9SZ4CVDw/m4cBDjF0OS
         L1wv0BlyahYCwJ2hfdZhOXkXKGcnXX7ZGAkbAHSpmF20lfPCvfVsdFMf50jphSxe8UvK
         RMUngA0pEpCYw2n7aXyt/155v321yFruRH5OS6VYqohoAA3swuMxGeb44jzp6W549eN4
         R4kYrDtZTGOirCaTw2tH9BvkT76ysVcqxisES7a1hO6KIoiE8HyFC6ciQbv7rWEz+R9J
         lvL5/JHLj/CjwjyZ2vM7JwM/uqTSn9zgaekzbgP50sGgsvTFkCbHEAHN1RVlWTls0waK
         KFlw==
X-Gm-Message-State: AOAM5329AeYxACVFBygSlbSIO8Ul4msY7Xw+x1U/x4lBbYsQ9vwtTsBr
        KzBi8kPGl+rVdRsPUHiwtCM09YHe
X-Google-Smtp-Source: ABdhPJwFoBCF8lclBsSqptikOdFDHIcm4KRmmy3lvi+Dt9Zo1TVhs8GbKdv3fMmRy6H7sYoEkKIOMA==
X-Received: by 2002:a5d:40d2:: with SMTP id b18mr1045860wrq.131.1592427410237;
        Wed, 17 Jun 2020 13:56:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c06e:b26:fa7c:aab? (p200300ea8f235700c06e0b26fa7c0aab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c06e:b26:fa7c:aab])
        by smtp.googlemail.com with ESMTPSA id v66sm1065833wme.13.2020.06.17.13.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:56:49 -0700 (PDT)
Subject: [PATCH net-next 8/8] r8169: allow setting irq coalescing if link is
 down
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Message-ID: <aae18a90-b9f9-5801-730b-8ee5ea81f370@gmail.com>
Date:   Wed, 17 Jun 2020 22:56:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far we can not configure irq coalescing when link is down. Allow the
user to do this, and assume that he wants to configure irq coalescing
for highest speed. Otherwise the irq rate is low enough anyway.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d55bf2cd2..a3c4187d9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1731,16 +1731,16 @@ struct rtl_coalesce_info {
 #define COALESCE_DELAY(d) { (d), 8 * (d), 16 * (d), 32 * (d) }
 
 static const struct rtl_coalesce_info rtl_coalesce_info_8169[] = {
-	{ SPEED_10,	COALESCE_DELAY(40960) },
-	{ SPEED_100,	COALESCE_DELAY(2560) },
 	{ SPEED_1000,	COALESCE_DELAY(320) },
+	{ SPEED_100,	COALESCE_DELAY(2560) },
+	{ SPEED_10,	COALESCE_DELAY(40960) },
 	{ 0 },
 };
 
 static const struct rtl_coalesce_info rtl_coalesce_info_8168_8136[] = {
-	{ SPEED_10,	COALESCE_DELAY(40960) },
-	{ SPEED_100,	COALESCE_DELAY(2560) },
 	{ SPEED_1000,	COALESCE_DELAY(5000) },
+	{ SPEED_100,	COALESCE_DELAY(2560) },
+	{ SPEED_10,	COALESCE_DELAY(40960) },
 	{ 0 },
 };
 #undef COALESCE_DELAY
@@ -1756,6 +1756,10 @@ rtl_coalesce_info(struct rtl8169_private *tp)
 	else
 		ci = rtl_coalesce_info_8168_8136;
 
+	/* if speed is unknown assume highest one */
+	if (tp->phydev->speed == SPEED_UNKNOWN)
+		return ci;
+
 	for (; ci->speed; ci++) {
 		if (tp->phydev->speed == ci->speed)
 			return ci;
-- 
2.27.0


