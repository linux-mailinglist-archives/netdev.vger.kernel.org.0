Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF372A802F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 14:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgKEN6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 08:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730465AbgKEN6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 08:58:10 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB5FC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 05:58:10 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id cw8so2758200ejb.8
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 05:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gexqGXgKCfuZ4JYL7hIwGCmGixuC5SFgZeJSOTRoMh4=;
        b=YZCU2lsGwVjFILz7mMEnShyhmbG5G788ATSKBvs84WH1porAT0v/alNK6zb2kTq+Fp
         oN83lAu3TAkYggZ4RQ3LDnpzMe16BJdanHK6Pzg645f3lXTqzIBCBEPoiS3Jzx/FOXEO
         qI9H56bV2f+xuiTiI2xIdmqFV8okfqhygDPZx2zYFf/Qqh9rAf1bikmN/lQzo0/Cfa81
         DOE7W893FcIGDfbJWUW8CH1ZsbQMnoT33myHKBEMpx2sxEyXTyc6Lji6ChtoYMbhUkuq
         y3JDNII7s1VT9rL9SykTtfzAq8f4rhuaAlSl0rTZdyFbqqMTjrlfcZsS5wGuzVdpywpx
         aTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gexqGXgKCfuZ4JYL7hIwGCmGixuC5SFgZeJSOTRoMh4=;
        b=IR/PfcIqNyBkc3DrcYgAkTo0AoiskpoVXDGsJUHn2UA2reyDgsjQqxgmnYIFMAyLQ5
         5kdUY/SfXxEDLFO4eGNFfDqQdNfyk3BKoHxokqtGyEk8x6ZlU5KSupLT+0geV20caSPS
         LSzxuc16TSyKGdjNl8l0cHFkaUhNo+mFYE4NYssguGDuzLBOk+ggfT3dTQVl+dbRnQah
         qpj/j4OAMl+6me8N/nmJc61wDjySCZadmwfDTrVxbA3d6X5Vo3x4uFCi1iCwzCOiO6H3
         JijQg106DWJA/4Q5tupmy5NcnwxgEqwmkvmE0N6d+vKIlN1wnf+mKtvQfsYb0Dg+rokH
         J36A==
X-Gm-Message-State: AOAM533DKS6et4+rvc1NdjNWCOOnJYnlRJAHWnag0A1VdsoRwMWD6tPD
        KmLDN7Q2N+UMeHKkB/qiCSn7qHBoBJnNWA==
X-Google-Smtp-Source: ABdhPJz5QACjoEacY5xc3AV+gNwxk9dMviob2s4uWrtR2cYqkE55TAyX47rylVSWMimzTGXcFtEwqw==
X-Received: by 2002:a17:906:36cd:: with SMTP id b13mr2511942ejc.235.1604584688850;
        Thu, 05 Nov 2020 05:58:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:59d0:7417:1e79:f522? (p200300ea8f23280059d074171e79f522.dip0.t-ipconnect.de. [2003:ea:8f23:2800:59d0:7417:1e79:f522])
        by smtp.googlemail.com with ESMTPSA id c11sm934095eds.62.2020.11.05.05.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 05:58:08 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: disable hw csum for short packets and chip
 versions with hw padding bug
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <e82f7f4d-8d45-1e7c-a2ef-5a8bfc3992c6@gmail.com>
Date:   Thu, 5 Nov 2020 14:58:01 +0100
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
versions. Change the code in a way that in case of further affected
chip versions we have to add them in one place only.

Fixes: 0439297be951 ("r8169: add support for RTL8125B")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c5d5c1cfc..56f84b597 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4315,11 +4315,13 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 			features &= ~NETIF_F_ALL_TSO;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		if (skb->len < ETH_ZLEN) {
+			if (rtl_test_hw_pad_bug(tp))
+				features &= ~NETIF_F_CSUM_MASK;
+
 			switch (tp->mac_version) {
 			case RTL_GIGA_MAC_VER_11:
 			case RTL_GIGA_MAC_VER_12:
 			case RTL_GIGA_MAC_VER_17:
-			case RTL_GIGA_MAC_VER_34:
 				features &= ~NETIF_F_CSUM_MASK;
 				break;
 			default:
-- 
2.29.2

