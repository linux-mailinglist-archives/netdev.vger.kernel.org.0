Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CD22BBA1D
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgKTXWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729165AbgKTXW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:22:29 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8111BC0613CF;
        Fri, 20 Nov 2020 15:22:28 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id x13so3857904wmj.1;
        Fri, 20 Nov 2020 15:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=kwxa6AJuFjND3m5jq1YdigG0kOFcdnFuNwDfJmwLDoU=;
        b=m2wfek4qA9MeuIpMJBOTTB4dz1p+WDfybIfsLJo7amOXyNDXFyCzEItNfRkcfBre8L
         6MJegiZ+KQD1OIN0d0rMljhpAtPvQDZ/x3XTZgq05+48wRvFmBKnhzIBOpGxuueAN9+z
         XNa9TT6ummZ6/XchO2/jYgTvKXloOlJkqgu1g/kj1BI3BRgtK52rq+Zc0ZS1poGaGHjH
         G42aM8ie0SVcUcGa9CAOLa+DDJWD7MNraNl/grAuCXbADxsijL0F+9O9McR7MeRVY7XR
         t0Mpb6074DzrBBetLapy2iRKp50LhHziy4GNypMsnAD3+6wUoNrm+TZyxjQm/YF6/yy1
         KgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=kwxa6AJuFjND3m5jq1YdigG0kOFcdnFuNwDfJmwLDoU=;
        b=EjMcEGgNSqiFAlG+VB0u/f8hCvSggMau6+8q5GmUmMMgOni1JNBEOOsH2audRInONQ
         EWnDCe77j3sLIyCPj0jweotUmTKYcngkgUGJxWlLMOPo+xJTV0Trm7dH7RmXeRWWZqjR
         GPtOs5Pf21Iu8SyZI1xVr4rpmb+wyGi5Ld+ENZlsR3mt8Gl5KxEoc2ZyLGHDVf0Xt6ot
         heBi36GJM1ofds+1EBhKdGxoz+f+ac95z66vrQK3zQU2pFbRkZr+ZZaqt6yP6Runza9E
         c+Z93rNX9j229BD+CWNxtJsZS4gLUAdQojm0csTRvV2FNs26o3Xo+oZR10wrt5jJID0p
         DbmQ==
X-Gm-Message-State: AOAM532Lze6TAN7KUVF8RBnpzDFkWlb98URbYPKA1UcNh8XdzgjWATvJ
        WshSzbQpryxNZcNtGB8lqPE+DayGXg9XZw==
X-Google-Smtp-Source: ABdhPJy/lvATDDOr64q6OmFUIdrwhy36vGq2PKy2zYaWdG7I2esZA5f+PyjkpKt5pSjBTXuwt1gWlw==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr12797097wma.100.1605914547156;
        Fri, 20 Nov 2020 15:22:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:85fe:30cb:3ff1:815c? (p200300ea8f23280085fe30cb3ff1815c.dip0.t-ipconnect.de. [2003:ea:8f23:2800:85fe:30cb:3ff1:815c])
        by smtp.googlemail.com with ESMTPSA id g186sm39300328wma.1.2020.11.20.15.22.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 15:22:26 -0800 (PST)
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: warn if gso_type isn't set for a GSO SKB
Message-ID: <97c78d21-7f0b-d843-df17-3589f224d2cf@gmail.com>
Date:   Sat, 21 Nov 2020 00:22:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bug report [0] a warning in r8169 driver was reported that was
caused by an invalid GSO SKB (gso_type was 0). See [1] for a discussion
about this issue. Still the origin of the invalid GSO SKB isn't clear.

It shouldn't be a network drivers task to check for invalid GSO SKB's.
Also, even if issue [0] can be fixed, we can't be sure that a
similar issue doesn't pop up again at another place.
Therefore let gso_features_check() check for such invalid GSO SKB's.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=209423
[1] https://www.spinics.net/lists/netdev/msg690794.html

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/core/dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4bfdcd6b2..3c3070d9d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3495,6 +3495,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	if (gso_segs > dev->gso_max_segs)
 		return features & ~NETIF_F_GSO_MASK;
 
+	if (!skb_shinfo(skb)->gso_type) {
+		skb_warn_bad_offload(skb);
+		return features & ~NETIF_F_GSO_MASK;
+	}
+
 	/* Support for GSO partial features requires software
 	 * intervention before we can actually process the packets
 	 * so we need to strip support for any partial features now
-- 
2.29.2

