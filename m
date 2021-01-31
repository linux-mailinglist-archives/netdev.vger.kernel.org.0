Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C266309CC4
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhAaOSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbhAaNg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 08:36:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2322EC061574
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 05:09:38 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e9so8437353plh.3
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 05:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dGOSBi40BFyr56cKbLxDd6vb58xUpDmEGktric9tQyU=;
        b=nIi5IYVlf22Ebw5g9/JL0inIPh8fU7tu8Gs291SImyg+lYm7msG6qxjdBQgYgFfn1l
         YFm6I0SS88pzvSTBRGcbNVhhTmKLCy4azPd4KA72DKTmjyOqYCrWKNlLDVipWv2kNVtv
         94FkrBX0QxXHVlx1MuZOy9uOAw48i/jqBXfgYR+l6tB+HUD7AqE3gf4/jm7P0iMRvsx5
         Yln1rZsJziTzudInkZ9J5Od3Bj1rdBwr0fOiWyO9se28p5/HEsFMoz54e+96BPYLmOS0
         OpFjb8VtpxtKnRi0adALHfgsDEcOIAzqf4YW5hOUlHg2iWWY6aXCSXXabvARBTOr95qJ
         MAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dGOSBi40BFyr56cKbLxDd6vb58xUpDmEGktric9tQyU=;
        b=hmFu+jdwUtx2q4iwDtTwX+I8lqNzgGegTNzqFeyFjVEJW29BK2sr4zhZh2q9X+Emrb
         /Kk4Vbo/msnWci71yAw3JVXhnd2ayBcEdclAsV5TBONxN/Q6tN2v7LuiS7gJfelCx63G
         jjONw9FRxHeSco5S2eW3MehW345+WPhSwkqJ0L5tgcPK8ISDThDAU3MBzxTMR6Pe8KQ6
         bUTNN44hjoYm3UJC4eTKjjTOAwWEeOPk2bGqtPWyUK55JguM0Pu0p6/5RHQRAjojYr0W
         L/bss3IMGekWaA10gFVOs1BZ94oUedWbhWWLPireJhKajCgsJD+qSga/oMMvShrr/5q3
         xzcA==
X-Gm-Message-State: AOAM533U/Kt8tPiNHEU3t9t7d9H5plLLv95z4q4DqzTCkb4PVA5p+VSl
        sd4bl/yIgW5CMaOA7144YLI=
X-Google-Smtp-Source: ABdhPJxn/ARnyiyhCkqMz5SLyfAOmG8pmgxZmWNouHiRCgKlu9ZHOgN84VVhl85/OSGaZNnMcmLrbQ==
X-Received: by 2002:a17:90a:d317:: with SMTP id p23mr3427170pju.14.1612098577405;
        Sun, 31 Jan 2021 05:09:37 -0800 (PST)
Received: from instance-00000467.ipinfusion.com ([14.141.145.174])
        by smtp.gmail.com with ESMTPSA id x186sm14198295pfd.57.2021.01.31.05.09.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 Jan 2021 05:09:36 -0800 (PST)
From:   Suprit Japagal <suprit.japagal@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, "Suprit.Japagal" <suprit.japagal@gmail.com>
Subject: [PATCH] NET: SRv6: seg6_local: Fixed SRH processing when segments left is 0
Date:   Sun, 31 Jan 2021 13:08:40 +0000
Message-Id: <20210131130840.32384-1-suprit.japagal@gmail.com>
X-Mailer: git-send-email 2.9.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Suprit.Japagal" <suprit.japagal@gmail.com>

According to the standard IETF RFC 8754, section 4.3.1.1
(https://tools.ietf.org/html/rfc8754#section-4.3.1.1)
When the segments left in SRH equals to 0, proceed to process the
next header in the packet, whose type is identified by the
Next header field of the routing header.

Signed-off-by: Suprit.Japagal <suprit.japagal@gmail.com>
---
 net/ipv6/seg6_local.c | 54 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index b07f7c1..b17f9dc 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -273,11 +273,25 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
 	struct ipv6_sr_hdr *srh;
 
-	srh = get_and_validate_srh(skb);
+	srh = get_srh(skb);
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+#ifdef CONFIG_IPV6_SEG6_HMAC
+	if (srh->segments_left > 0)
+		if (!seg6_hmac_validate_skb(skb))
+			goto drop;
+#endif
+
+	if (srh->segments_left == 0) {
+		if (!decap_and_validate(skb, srh->nexthdr))
+			goto drop;
+
+		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+			goto drop;
+	} else {
+		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	}
 
 	seg6_lookup_nexthop(skb, NULL, 0);
 
@@ -293,11 +307,25 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
 	struct ipv6_sr_hdr *srh;
 
-	srh = get_and_validate_srh(skb);
+	srh = get_srh(skb);
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+#ifdef CONFIG_IPV6_SEG6_HMAC
+	if (srh->segments_left > 0)
+		if (!seg6_hmac_validate_skb(skb))
+			goto drop;
+#endif
+
+	if (srh->segments_left == 0) {
+		if (!decap_and_validate(skb, srh->nexthdr))
+			goto drop;
+
+		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+			goto drop;
+	} else {
+		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	}
 
 	seg6_lookup_nexthop(skb, &slwt->nh6, 0);
 
@@ -312,11 +340,25 @@ static int input_action_end_t(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
 	struct ipv6_sr_hdr *srh;
 
-	srh = get_and_validate_srh(skb);
+	srh = get_srh(skb);
 	if (!srh)
 		goto drop;
 
-	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+#ifdef CONFIG_IPV6_SEG6_HMAC
+	if (srh->segments_left > 0)
+		if (!seg6_hmac_validate_skb(skb))
+			goto drop;
+#endif
+
+	if (srh->segments_left == 0) {
+		if (!decap_and_validate(skb, srh->nexthdr))
+			goto drop;
+
+		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+			goto drop;
+	} else {
+		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
+	}
 
 	seg6_lookup_nexthop(skb, NULL, slwt->table);
 
-- 
2.9.3

