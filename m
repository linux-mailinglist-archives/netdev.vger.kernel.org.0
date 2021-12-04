Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4188468251
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 05:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384181AbhLDE5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 23:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384151AbhLDE5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 23:57:24 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866DBC061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 20:53:59 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id s137so5075815pgs.5
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 20:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uCCdshi0BxaR49gi389x4WvmDnUONm0CpB1W8MaGtnk=;
        b=YG7s7T/NFsbt0+IFNb8iKl5QI9lBXMh3vlJzYaIk8QRo4CaiCCnjG7Z/du7B+uV014
         VZidFkz6KsYIOUH4iOTCChMKAFoFGAWNCtiOdPWQfx7WzTwgq0Dn5BVCQjzvnctRgqm3
         9uaOw+tuvLCpxTGr44ygdedkyDevkbn5GOd4CbwCEIRm4Elg30a7q+0ERPPazaF2aSrS
         KgzHbrsnWldKQpqNhivqLbNOuvLnTVeIw9MBpympqDk7xSR7lPgv0Rr1T0XrkBBeb6gq
         ZLC3ZjIV1o/5Sbnjsnh0EWVkA+yLDaugeP8ubTdnrnr5rIm3XUzF2mQ6gqy5cmQHCqax
         TIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uCCdshi0BxaR49gi389x4WvmDnUONm0CpB1W8MaGtnk=;
        b=wnvfvMRtsYSq78p7bgf8t/UKcGPkexEe3vehZXvy7I504SlZ8JYkh0nwsoYn3P/cYX
         GTPn6V9zSUkf5xIdoG/bhhUYlkwZ1+AVPqq6R2jPEzmYEArAEcwWaljSJpmryZno/UUd
         Z9P/XDLcgq0krSWToRY829GalaPAIaE5ozo33ZYkDFL5efZJVEhs5TJySYSMWituFov1
         atPfDv2zVWrNvEImoEhRGFAPttjUsevZZCa6skAUF4coVRIsNwgyma8DzDGcv9s8DyrZ
         aVlhTOsXdVsDCYbZuDot409f5FxuySJ6lVGjmBlWOJh1l+J9X/59tNvWGsT5uIaHVBnD
         z9vA==
X-Gm-Message-State: AOAM5314IKVmtLWtiydVX3yDXcUn6DaeCyV6wYuqqq+9RhudNbtBTfhO
        rkL9iOkyvR6BbBOGrokkMc8=
X-Google-Smtp-Source: ABdhPJzAyVIp0VcKDMN3Izuey4XLLe30WNlE+PdGGT7BX/3N/tWCmRBVH8vB3MqByQT8/tbxQ5R56g==
X-Received: by 2002:a63:88c3:: with SMTP id l186mr7795876pgd.377.1638593639052;
        Fri, 03 Dec 2021 20:53:59 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2440:7862:6d8b:2ea])
        by smtp.gmail.com with ESMTPSA id mg17sm3662623pjb.17.2021.12.03.20.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 20:53:58 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Laight <David.Laight@ACULAB.COM>,
        David Lebrun <dlebrun@google.com>
Subject: [PATCH v2 net-next] net: fix recent csum changes
Date:   Fri,  3 Dec 2021 20:53:56 -0800
Message-Id: <20211204045356.3659278-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Vladimir reported csum issues after my recent change in skb_postpull_rcsum()

Issue here is the following:

initial skb->csum is the csum of

[part to be pulled][rest of packet]

Old code:
 skb->csum = csum_sub(skb->csum, csum_partial(pull, pull_length, 0));

New code:
 skb->csum = ~csum_partial(pull, pull_length, ~skb->csum);

This is broken if the csum of [pulled part]
happens to be equal to skb->csum, because end
result of skb->csum is 0 in new code, instead
of being 0xffffffff

David Laight suggested to use

skb->csum = -csum_partial(pull, pull_length, -skb->csum);

I based my patches on existing code present in include/net/seg6.h,
update_csum_diff4() and update_csum_diff16() which might need
a similar fix.

I guess that my tests, mostly pulling 40 bytes of IPv6 header
were not providing enough entropy to hit this bug.

v2: added wsum_negate() to make sparse happy.

Fixes: 29c3002644bd ("net: optimize skb_postpull_rcsum()")
Fixes: 0bd28476f636 ("gro: optimize skb_gro_postpull_rcsum()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Cc: David Lebrun <dlebrun@google.com>
---
 include/linux/skbuff.h | 3 ++-
 include/net/checksum.h | 4 ++++
 include/net/gro.h      | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index eae4bd3237a41cc1b60b44c91fbfe21dfdd8f117..dd262bd8ddbecc3638e40e198ebeecc115bbfffa 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3486,7 +3486,8 @@ static inline void skb_postpull_rcsum(struct sk_buff *skb,
 				      const void *start, unsigned int len)
 {
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
-		skb->csum = ~csum_partial(start, len, ~skb->csum);
+		skb->csum = wsum_negate(csum_partial(start, len,
+						     wsum_negate(skb->csum)));
 	else if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		 skb_checksum_start_offset(skb) < 0)
 		skb->ip_summed = CHECKSUM_NONE;
diff --git a/include/net/checksum.h b/include/net/checksum.h
index 5b96d5bd6e54532a7a82511ff5d7d4c6f18982d5..5218041e5c8f93cd369a2a3a46add3e6a5e41af7 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -180,4 +180,8 @@ static inline void remcsum_unadjust(__sum16 *psum, __wsum delta)
 	*psum = csum_fold(csum_sub(delta, (__force __wsum)*psum));
 }
 
+static inline __wsum wsum_negate(__wsum val)
+{
+	return (__force __wsum)-((__force u32)val);
+}
 #endif
diff --git a/include/net/gro.h b/include/net/gro.h
index b1139fca7c435ca0c353c4ed17628dd7f3df4401..8f75802d50fd734018d4b257c66fd0545095b593 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -173,8 +173,8 @@ static inline void skb_gro_postpull_rcsum(struct sk_buff *skb,
 					const void *start, unsigned int len)
 {
 	if (NAPI_GRO_CB(skb)->csum_valid)
-		NAPI_GRO_CB(skb)->csum = ~csum_partial(start, len,
-						       ~NAPI_GRO_CB(skb)->csum);
+		NAPI_GRO_CB(skb)->csum = wsum_negate(csum_partial(start, len,
+						wsum_negate(NAPI_GRO_CB(skb)->csum)));
 }
 
 /* GRO checksum functions. These are logical equivalents of the normal
-- 
2.34.1.400.ga245620fadb-goog

