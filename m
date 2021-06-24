Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAECB3B2C23
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 12:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhFXKKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 06:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbhFXKKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 06:10:38 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00766C061756
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:08:18 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d12so4300346pgd.9
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x9NKcgEa68r5VdGmcZtR9q9EE3hL1EdjeVJHJPoqJac=;
        b=kn+9SbsKlmW+K/3fcegv6Q8xm210aDfSmXbY1Tb6U6jsgpAkBpwOE6ANQdUFtQrfNb
         eF78sWs37x+STI6rASR+L4B1P9lDnOiIQc1Qe48axMU5uYbb9f1W99yNwB74l32QpFD4
         xVMOAaZaYvO9BXHV/5EOU+uBhVgGO4HYd1U+mU3Bn29UQkdVlrJZD8AfRY0KKNlFdml0
         NyUy7Y52cLZSUOEvFuSr0sl+rW4o+7tWZgfUm/tjP/IjhcFQuL4sHJTgt30Z4qJfcOPN
         ncMCrLMAn+DX8ByJLWR788bDBKu2A9tXJB9ExpgoLPl5xRl1rW6wRPCAbiJ7mT04Jukh
         Fd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x9NKcgEa68r5VdGmcZtR9q9EE3hL1EdjeVJHJPoqJac=;
        b=aOiApzC1hUQQiEgpZiqjoI1B9J56f8nArOjPEg3wUvOqHlOfD1GvgmmVD1yz3Mdf8o
         QnovQH4heEXJ9aTMyDvmSG30FvFGn3EIpx8152wYtmn5+8bSGRF0j4dicMqtJW0kYWOY
         3sJ2g/PD/UKsHbOs6LcXhCIXrwe2DdofmvhNuVKvpHOgrPbXF2WZaL5VBYqbHjAbwbuB
         MgGt0gFOudTm2YRIOiQCyA7lzmwLQUPuIcM7Em05skJUqsmi+xNZucF+b+bIFNESsWTj
         hYL9uAmUzkaZCGZVnLbBovggtt+B8oNQFzFJkf0CbuHwBWN2dUPA8LeJfxJArP3pHZjq
         7GhQ==
X-Gm-Message-State: AOAM532to4Qv1MErh2YuWl45r/heqyeZhz2F3UY36vqQl3rNe/Dkl/AT
        nRX0RifbrSZguRaBCabPHMMw9t+O630=
X-Google-Smtp-Source: ABdhPJztf0AunmIR22HhtNF8zDiFaSyAG6bAzbX/9II5emdmyfrnvXw7g1r40jzMD0iFkQ9m8t3+ew==
X-Received: by 2002:a63:5511:: with SMTP id j17mr4158419pgb.191.1624529298568;
        Thu, 24 Jun 2021 03:08:18 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:927c:36f0:f328:b8f3])
        by smtp.gmail.com with ESMTPSA id a6sm2365632pfo.212.2021.06.24.03.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 03:08:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>
Subject: [PATCH v2 net] ipv6: fix out-of-bound access in ip6_parse_tlv()
Date:   Thu, 24 Jun 2021 03:07:20 -0700
Message-Id: <20210624100720.2310271-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

First problem is that optlen is fetched without checking
there is more than one byte to parse.

Fix this by taking care of IPV6_TLV_PAD1 before
fetching optlen (under appropriate sanity checks against len)

Second problem is that IPV6_TLV_PADN checks of zero
padding are performed before the check of remaining length.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: c1412fce7ecc ("net/ipv6/exthdrs.c: Strict PadN option checking")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tom Herbert <tom@herbertland.com>
---
v2: Removed not needed optlen assignment for IPV6_TLV_PAD1 handling,
    added the Fixes: tag for first problem, feedback from Paolo, thanks !

 net/ipv6/exthdrs.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 6f7da8f3e2e5849f917853984c69bf02a0f1e27c..26882e165c9e37a105f988020031f03d6b1a5cf9 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -135,18 +135,23 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 	len -= 2;
 
 	while (len > 0) {
-		int optlen = nh[off + 1] + 2;
-		int i;
+		int optlen, i;
 
-		switch (nh[off]) {
-		case IPV6_TLV_PAD1:
-			optlen = 1;
+		if (nh[off] == IPV6_TLV_PAD1) {
 			padlen++;
 			if (padlen > 7)
 				goto bad;
-			break;
+			off++;
+			len--;
+			continue;
+		}
+		if (len < 2)
+			goto bad;
+		optlen = nh[off + 1] + 2;
+		if (optlen > len)
+			goto bad;
 
-		case IPV6_TLV_PADN:
+		if (nh[off] == IPV6_TLV_PADN) {
 			/* RFC 2460 states that the purpose of PadN is
 			 * to align the containing header to multiples
 			 * of 8. 7 is therefore the highest valid value.
@@ -163,12 +168,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 				if (nh[off + i] != 0)
 					goto bad;
 			}
-			break;
-
-		default: /* Other TLV code so scan list */
-			if (optlen > len)
-				goto bad;
-
+		} else {
 			tlv_count++;
 			if (tlv_count > max_count)
 				goto bad;
@@ -188,7 +188,6 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 				return false;
 
 			padlen = 0;
-			break;
 		}
 		off += optlen;
 		len -= optlen;
-- 
2.32.0.288.g62a8d224e6-goog

