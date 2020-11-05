Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136222A8488
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 18:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbgKERO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 12:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgKERO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 12:14:57 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F02C0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 09:14:56 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id d142so2339085wmd.4
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 09:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=eB/exOtN1wMm6HlL4BUzoLrvtR6RF+J6VdvQMAdKsIQ=;
        b=rqzO3mG9YkDQdCPDtQMHeeFaRu3Dwu6yUo/IK7F/cxke1hRVR2kP4Nt1XRZF0dQGZH
         B670KQiaNZAQwCM+AzPsif8lOUqMjGjDkwaOhaej/GeblbVrmFLqLHbIUaezIGgnfXQF
         GBDktNwlIsrLdIBFrl2ZPUgpB4oyLNW+Izc6j6SkN/D3Hc8m0lxjMCgJWbTMnXEr9en1
         FxaIb/uC92XM/LH+SusCHtBwsEcOqf+p1tjkHXq3LwY716RKB5c0XYvowDK10L2WYEPh
         T5Lwb288cLC/tYuZVYZAnSGQ+vc39iZ+9R1Wrl1L7zLCmYlkAnjEUnRUpr1RQkTKCAyQ
         UwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=eB/exOtN1wMm6HlL4BUzoLrvtR6RF+J6VdvQMAdKsIQ=;
        b=ZPntvkc4jISYIzewZuNYfKtRImViBmCgytPxn7mKJnhu6JG3ut96EK5BLuX20/zz1N
         KN96YBmtjNmOovjy36Yayhuu8lTXWj4O/wKvkVs58Xc055HfQ00FLhUXyMr487sVpDu9
         D+zy3AS8sTGvDccHL4CRwhHGcMcRp2xfJ7pSPmZNqPYju4lJCXKyP8C2lI6EnCXN+k5e
         +0H8Dz8dkobkaEIBzultfVTfX6+lN2tOSurw9tyy7CEd4Yom5VJ40HZmuRVtR4GPiav9
         TpX0epzkXwXOPjnRFCuJNMPs77D6+OXeSuWDU8+5WNiFbhJvPmQg/BExsFso6LmW1AZr
         RSbQ==
X-Gm-Message-State: AOAM530IEc+NMxOFoq9cIggpMeQ9noYCrgo5/gJTEZm6TNdxGWnWOTf6
        Bbix1XA8BZLdcOvoeJOCanr3hqQIta10ew==
X-Google-Smtp-Source: ABdhPJzCV2HHWy+jmJ1H5qNpO3XMYDE4UvQDH+vG7GgF3rUS/wVKLJMhAPQuMGlr1GBq4OfzCYpP8Q==
X-Received: by 2002:a1c:2ed3:: with SMTP id u202mr3873515wmu.85.1604596495355;
        Thu, 05 Nov 2020 09:14:55 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:59d0:7417:1e79:f522? (p200300ea8f23280059d074171e79f522.dip0.t-ipconnect.de. [2003:ea:8f23:2800:59d0:7417:1e79:f522])
        by smtp.googlemail.com with ESMTPSA id l11sm3585037wro.89.2020.11.05.09.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 09:14:54 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net] r8169: disable hw csum for short packets on all chip
 versions
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <7fbb35f0-e244-ef65-aa55-3872d7d38698@gmail.com>
Date:   Thu, 5 Nov 2020 18:14:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8125B has same or similar short packet hw padding bug as RTL8168evl.
The main workaround has been extended accordingly, however we have to
disable also hw checksumming for short packets on affected new chip
versions. Instead of checking for an affected chip version let's
simply disable hw checksumming for short packets in general.

v2:
- remove the version checks and disable short packet hw csum in general
- reflect this in commit title and message

Fixes: 0439297be951 ("r8169: add support for RTL8125B")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c5d5c1cfc..aa6f8b16d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4314,18 +4314,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_ALL_TSO;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		if (skb->len < ETH_ZLEN) {
-			switch (tp->mac_version) {
-			case RTL_GIGA_MAC_VER_11:
-			case RTL_GIGA_MAC_VER_12:
-			case RTL_GIGA_MAC_VER_17:
-			case RTL_GIGA_MAC_VER_34:
-				features &= ~NETIF_F_CSUM_MASK;
-				break;
-			default:
-				break;
-			}
-		}
+		/* work around hw bug on some chip versions */
+		if (skb->len < ETH_ZLEN)
+			features &= ~NETIF_F_CSUM_MASK;
 
 		if (transport_offset > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-- 
2.29.2

