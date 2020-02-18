Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6711632C3
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgBRUQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35707 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgBRUQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:17 -0500
Received: by mail-wr1-f68.google.com with SMTP id w12so25535306wrt.2;
        Tue, 18 Feb 2020 12:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Rc8DWOPa+KHz6kWLduKvor/98RO2j9a30URsDICP5M=;
        b=FrOMnbpFqApO6TyQk8xsp26ipMrtIvZ5zEj6zO9O/GHWHPfOrCpDOpRYypk1e+yG8i
         pdxuDDBeMp/KMcID/uR7siiU147wfevvLmRIrkZMJCBqSOByaDl0QNfjNdH2gqgII8II
         qX/vZgNoyKB9NEyeuVxKOYygHNuOCogCIWSfg0G9mtkxOkjEzR0pLtWbLqk5fKJ67cfC
         gPeU2WV6Ar0b2Gxa79XU4qlCMcZctE4pb20SnD7RalGkzRc55M8hg9yjpNFBlyFxTjBi
         J4WTQ5H7I02TWuViMssEWgZShy/ANPpRJPpuOXZQP3m6CDAVppUafoB5+7Jon9fJNevX
         8sWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Rc8DWOPa+KHz6kWLduKvor/98RO2j9a30URsDICP5M=;
        b=mKKeEcM54RGA+9gJNFKOl5peT9X7/BeSgmUnWN5W95+VivazM2HeKBeI0XYNCqrNcy
         YSpW3d8E2LNkKSROVR+HD3XmWJO7X+1fuCIHRaPJP3Z60ZpBUc5q/pZjBdKC97RLN/jY
         RkBzFrSO1iD6Ge7oqvpJqOOOm1qxW3S4yPGFmQ0vHB90OaxMaD7V6sgXGM4oyCWTrUzl
         DpdpX4xWA1wC8as0VWQA+t60WKI4N0iqQyGm6OodxArzf0aHZrcrdYRWA2w0ojux9xWG
         C2+d88Wi58Dm7Moui0r6RcggD/E51WQGqb/CXpx0rteZgQQrBsb2NgQ9FRumfhhv9VV+
         2y8g==
X-Gm-Message-State: APjAAAVOISepbeG4EyuNYpR4ROoTOaADCGjQkTOmyRWoV/hrv4St5Wkh
        VCit4a12EhOsZ1XsDY9RKUJsrHew
X-Google-Smtp-Source: APXvYqxgOCIIRMTmEqbJu/JCIS3JlQVaNVFkdkjcKAyjtTkW/KrITw2gXflWe0C20eMenOmcVlUQuQ==
X-Received: by 2002:adf:ec0d:: with SMTP id x13mr30604236wrn.400.1582056975466;
        Tue, 18 Feb 2020 12:16:15 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id n1sm7999711wrw.52.2020.02.18.12.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:15 -0800 (PST)
Subject: [PATCH net-next v2 07/13] jme: use new helper tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <f9f6897b-8dc8-2036-97d4-60e154b57356@gmail.com>
Date:   Tue, 18 Feb 2020 21:06:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/jme.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 2e4975572..de3c7ce93 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2077,12 +2077,7 @@ jme_tx_tso(struct sk_buff *skb, __le16 *mss, u8 *flags)
 								IPPROTO_TCP,
 								0);
 		} else {
-			struct ipv6hdr *ip6h = ipv6_hdr(skb);
-
-			tcp_hdr(skb)->check = ~csum_ipv6_magic(&ip6h->saddr,
-								&ip6h->daddr, 0,
-								IPPROTO_TCP,
-								0);
+			tcp_v6_gso_csum_prep(skb);
 		}
 
 		return 0;
-- 
2.25.1


