Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B55F2E7BF1
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 19:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgL3SeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 13:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL3SeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 13:34:23 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6C8C061573
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 10:33:43 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id r4so5432385wmh.5
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 10:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+kbiBg7r++WyBcErBUhzBD7qVuel7OFNy0yGFYi/uqs=;
        b=tuEVtNqDkSvT4mE905RFqa0UmiB70L61V75/D+vMhfEb1hBKy5DpVxRcc4mc5lfpEe
         2RV277w++8G/nwaf78f5qdHNm5YbnaynjYbK6nKnhYUEYyHJEftQMRHEFTOieDQ43Jfm
         z39uS2EJJ1odUcNhPJcx6bFYExeXu90Zu2z+s5UaDDkpGHGYkIGRblO9aMgC3pzSju+7
         w25To+Du1EB/ML1p9cxzIuD7QA1Z7vHI0slNcscvnuVBk9pvy6hpk/WexQ6SVJSwUTaF
         6vO7tmdZGzq2Vkm8YfgiBJcpeDk2eM7g6hVVWlalAiYb5gRiy9W67TzSs/TyadEFRS0Y
         HdpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+kbiBg7r++WyBcErBUhzBD7qVuel7OFNy0yGFYi/uqs=;
        b=fOnlgRfKHuUyYryzFo9o2LccJUjnBezuSlcLpoBrh2eKYBP76Gk9UN9REKJgnTHaRX
         vAmaNaAZT6Ad3WpHpai50kaKPjeS0E4OMy93CZ1Os/k/GQfG8H/HjXrf04YHH7QctCN/
         9SDgIeOFSXdBV3KYWCd9yWk2KtSA9nBrZAQftXQNdbRFDWmFfyMHCpkATospSwr4PEDX
         csthe5K+9qMVSLHJZFsvjkO2Bh3jreQAztNyc/ecV9D1ACi7jXrX/VjzHuO8i+A6Cjgy
         7S03/MqMuihu+mCER39+bYkz2NPV15OmQcmb670KvNHk9RTU7Aawf8NEl6eC+phBk5fi
         tg5A==
X-Gm-Message-State: AOAM5322Yt/aufhANgau4bGHGw/NtBYT6DTMe8w0nlS4tBcYtPBQGXmW
        5vF4ayZvLRZ/4itL9TbzMAmmWEhlVgM=
X-Google-Smtp-Source: ABdhPJxmca5rOxHlZ0AgYz6+u+JbKdcaAfBaIjzvjnCxPxZk6UnkrGgVwxQjmnWmApUrRDYKQNHN2w==
X-Received: by 2002:a7b:c212:: with SMTP id x18mr8711966wmi.113.1609353221744;
        Wed, 30 Dec 2020 10:33:41 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:a1e5:2a55:c7d0:ad89? (p200300ea8f065500a1e52a55c7d0ad89.dip0.t-ipconnect.de. [2003:ea:8f06:5500:a1e5:2a55:c7d0:ad89])
        by smtp.googlemail.com with ESMTPSA id t1sm69295010wro.27.2020.12.30.10.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Dec 2020 10:33:41 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: work around power-saving bug on some chip versions
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <a1c39460-d533-7f9e-fa9d-2b8990b02426@gmail.com>
Date:   Wed, 30 Dec 2020 19:33:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user reported failing network with RTL8168dp (a quite rare chip
version). Realtek confirmed that few chip versions suffer from a PLL
power-down hw bug.

Fixes: 07df5bd874f0 ("r8169: power down chip in probe")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Note that since the original change source file r8169.c was renamed
to r8169_main.c. Also the name of the affected functions has changed
from r8168_pll_power_down/up to rtl_pll_power_down/up.
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 46d8510b2..a569abe7f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2207,7 +2207,8 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	}
 
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
+	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
 	case RTL_GIGA_MAC_VER_43:
@@ -2233,7 +2234,8 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
+	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
 	case RTL_GIGA_MAC_VER_43:
-- 
2.29.2

