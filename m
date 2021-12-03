Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC934467D88
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 19:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382722AbhLCS4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 13:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhLCS4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 13:56:07 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE653C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 10:52:42 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso3250085pjb.2
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 10:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBYB1zous+wYSIZpAQJAlVBFmIOAdoFBOd+JjPvbgKI=;
        b=MUwKuAUWP54KJICw7bYTn+qwaVTkWNcW5r+AnI6tXpKUvamEn6t9p4QllBZzDRrrBu
         xCi1G5p6VJhdK9uAwvo9uPyz9LdETGDdtj3u0OhobooeX4ilXn5TlanLaZnkeAVr8ZU4
         mJnzn+3cQZhu31dXeTYyCGrVFzXXq8w4u5vVj8mZT1lL0dCciNZUR9HQTgfCEJwa7BQv
         20xf9Do4EFfhi3UI0MiSsUYdWmbvi3q2WBIsoUI6ziZjXc+PU6Q2k3rXdhjUbt3JL4AO
         U5765mInlLNdsghDNo76swP89F1/RbwX3jJjeN9UO8kyIh7lgIBZXEsBZaoSoKuZR/a0
         ILPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBYB1zous+wYSIZpAQJAlVBFmIOAdoFBOd+JjPvbgKI=;
        b=O1nt+yCzpKJyeZC9lY121xgoyGJLh19IXGfCG/MqZ/uibE53/FR0neausla2kHpaC4
         BEeZJqqPdRI9E5hQYJNXTSjFtP/9QT9iXec+P8Bg438DxK3/xIsbhWtQxd2t8ziZYQKX
         a8DgnPWT7JwXu+10qsn5lwp/I1/YuP3q4NXiXrhmww+oMOg4ejFK+hxOGaRIhUeH9nli
         6iDATUufCueR2WGORv5m3ndRi5M1rxhl1JXdYp8ySY5LI0gxHQhEWk8y8ogSBULyDUl9
         aU4S1al602CnJB1VaS0FGsXvjuMsJCb9Er9SQWOmbdNC4EP0JKKE1FILtLjTh3AfnAoe
         2MtQ==
X-Gm-Message-State: AOAM532z+O11+8BfWspv/5O5ujL/7iptTqRlY3n92JHwMpeHy0eKk7yg
        VXTTgz/UWE8kvNgHklye+cY=
X-Google-Smtp-Source: ABdhPJwJfLz2/5sJtWzyDj9+N3yikZ+eHHCM0H7vf4ImivLU+6gblUHtDU8FfBzNjJ/EcIwjKRbFdA==
X-Received: by 2002:a17:90a:6906:: with SMTP id r6mr16098734pjj.118.1638557562434;
        Fri, 03 Dec 2021 10:52:42 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2440:7862:6d8b:2ea])
        by smtp.gmail.com with ESMTPSA id 26sm2992724pgn.82.2021.12.03.10.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 10:52:42 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Laight <David.Laight@ACULAB.COM>,
        David Lebrun <dlebrun@google.com>
Subject: [PATCH net-next] net: fix recent csum changes
Date:   Fri,  3 Dec 2021 10:52:38 -0800
Message-Id: <20211203185238.2011081-1-eric.dumazet@gmail.com>
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

Fixes: 29c3002644bd ("net: optimize skb_postpull_rcsum()")
Fixes: 0bd28476f636 ("gro: optimize skb_gro_postpull_rcsum()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Cc: David Lebrun <dlebrun@google.com>
---
 include/linux/skbuff.h | 2 +-
 include/net/gro.h      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index eae4bd3237a41cc1b60b44c91fbfe21dfdd8f117..2bbcdaf99ed3df739ddfd2de4be747262226d4b9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3486,7 +3486,7 @@ static inline void skb_postpull_rcsum(struct sk_buff *skb,
 				      const void *start, unsigned int len)
 {
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
-		skb->csum = ~csum_partial(start, len, ~skb->csum);
+		skb->csum = -csum_partial(start, len, -skb->csum);
 	else if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		 skb_checksum_start_offset(skb) < 0)
 		skb->ip_summed = CHECKSUM_NONE;
diff --git a/include/net/gro.h b/include/net/gro.h
index b1139fca7c435ca0c353c4ed17628dd7f3df4401..4529c4c6f3ca4ac23da569b0bc0e00e3c9dcd765 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -173,8 +173,8 @@ static inline void skb_gro_postpull_rcsum(struct sk_buff *skb,
 					const void *start, unsigned int len)
 {
 	if (NAPI_GRO_CB(skb)->csum_valid)
-		NAPI_GRO_CB(skb)->csum = ~csum_partial(start, len,
-						       ~NAPI_GRO_CB(skb)->csum);
+		NAPI_GRO_CB(skb)->csum = -csum_partial(start, len,
+						       -NAPI_GRO_CB(skb)->csum);
 }
 
 /* GRO checksum functions. These are logical equivalents of the normal
-- 
2.34.1.400.ga245620fadb-goog

