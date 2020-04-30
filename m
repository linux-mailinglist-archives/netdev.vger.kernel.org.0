Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC981C0734
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgD3UAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgD3UAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:00:13 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E262BC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:12 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h4so3413404wmb.4
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xN+odAodqOebFWoxnEURaCdwiNve62tDkHg9Crur6qg=;
        b=Np9diWhOhVbbW7NDerk66E9zs4YuI0hjsUG4k7vtqTtBTFAiPVgZZZDQ+gbmH8R3aP
         fv3g+x176lGEKHIwR6zxyQ8J/UcYptxmH/KkH8PPObwN8E579bsCPCJnpYM0hsz6bQ6x
         nzX3XG6c6GswvSev6N7sh/EeJGSXBm4JwM69fxWfdLpsgiezFCUDBDMEQFrYJ7JsyTF2
         tk/xj4Yp9akzGUYNHAuelz7TSrYb297LZpOP3Dl6nDjr8czVFIAwJUzPdfKorUjAUoWP
         EI17aOPWOFgp/fkUmViOFxclzxMb+jSqdFmsK0f5Nm7lSUYHL8jNPS6gNKwEooQ1I52y
         hw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xN+odAodqOebFWoxnEURaCdwiNve62tDkHg9Crur6qg=;
        b=iTIgr11K6W0kPRMI0E8Oiwk8AePdRBOxygkLKqA8CVmLTGbCAz8Fm1SKTfCysLY7aq
         Ez+cn4IABWCNmuSSylUiHA6GPdzBhEVZwboPJSN4d8nDM7OzQjQncOK8kyovrFXuyfEg
         4WoCjxJ2y/dd3Fbfuah+nIaBxaKB0wqR5aMgobJsqiCx1Cx/VZSizFXji/iK4SQRaK8h
         bMKUVWkGSkG/6qpN8983VgXUg6nGZPZs0XWDScsH975y3I8sOwEKEUk/KkRnzoAGt4m4
         losx31gpYSPTobKm1njftceqYulRfrHkP68shcNZDNEvJqIrMrH02MHKwD5352Kz6rOV
         ibKw==
X-Gm-Message-State: AGi0PuYRtzHCLiX9+fByy4tGoNErKSHIppHGkfjwT8QtxLyVoBEYTuZY
        wJa/4vbI0zLIxkx1LJAUOH8iWkrq
X-Google-Smtp-Source: APiQypLHMsCghVYM2ONe+LedzCKjyQPMJDVV92SA00X1J2OAMQt82lQpvJ9WFNf3C0alRpn+thTPCQ==
X-Received: by 2002:a7b:c104:: with SMTP id w4mr298441wmi.8.1588276811343;
        Thu, 30 Apr 2020 13:00:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f0e:e300:b04f:e17d:bb1a:140e? (p200300EA8F0EE300B04FE17DBB1A140E.dip0.t-ipconnect.de. [2003:ea:8f0e:e300:b04f:e17d:bb1a:140e])
        by smtp.googlemail.com with ESMTPSA id n6sm1176343wrs.81.2020.04.30.13.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:00:10 -0700 (PDT)
Subject: [PATCH net-next 4/7] r8169: improve rtl_coalesce_choose_scale
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Message-ID: <15ec315a-724b-e4ba-83ad-9df424307fa4@gmail.com>
Date:   Thu, 30 Apr 2020 21:57:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The time limit provided by userspace is multiplied with 1000,
what could result in an overflow. Therefore change the time limit
parameter unit from ns to us, and avoid the problematic operation.
If there's no matching scale because provided time limit is too big,
return ERANGE instead of EINVAL to provide a hint to the user what's
wrong.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d898e6f5f..a95615684 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1854,8 +1854,8 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	return 0;
 }
 
-/* choose appropriate scale factor and CPlusCmd[0:1] for (speed, nsec) */
-static int rtl_coalesce_choose_scale(struct rtl8169_private *tp, u32 nsec,
+/* choose appropriate scale factor and CPlusCmd[0:1] for (speed, usec) */
+static int rtl_coalesce_choose_scale(struct rtl8169_private *tp, u32 usec,
 				     u16 *cp01)
 {
 	const struct rtl_coalesce_info *ci;
@@ -1866,13 +1866,13 @@ static int rtl_coalesce_choose_scale(struct rtl8169_private *tp, u32 nsec,
 		return PTR_ERR(ci);
 
 	for (i = 0; i < 4; i++) {
-		if (nsec <= ci->scale_nsecs[i] * RTL_COALESCE_T_MAX) {
+		if (usec <= ci->scale_nsecs[i] * RTL_COALESCE_T_MAX / 1000U) {
 			*cp01 = i;
 			return ci->scale_nsecs[i];
 		}
 	}
 
-	return -EINVAL;
+	return -ERANGE;
 }
 
 static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
@@ -1886,13 +1886,14 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 		{ ec->tx_max_coalesced_frames, ec->tx_coalesce_usecs }
 	}, *p = coal_settings;
 	u16 w = 0, cp01 = 0;
+	u32 coal_usec_max;
 	int scale, i;
 
 	if (rtl_is_8125(tp))
 		return -EOPNOTSUPP;
 
-	scale = rtl_coalesce_choose_scale(tp,
-			max(p[0].usecs, p[1].usecs) * 1000, &cp01);
+	coal_usec_max = max(ec->rx_coalesce_usecs, ec->tx_coalesce_usecs);
+	scale = rtl_coalesce_choose_scale(tp, coal_usec_max, &cp01);
 	if (scale < 0)
 		return scale;
 
-- 
2.26.2


