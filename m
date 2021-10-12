Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA9642A438
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbhJLMUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbhJLMUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 08:20:21 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2DFC061570;
        Tue, 12 Oct 2021 05:18:19 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id g25so19870061wrb.2;
        Tue, 12 Oct 2021 05:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A+41Sh3sYcbNdBr2oBbX/atHaO9CurH+V8mFKTB9hbY=;
        b=hBDIpUuMFK31ujZepMKWDL4RyF9qwC8tv/9EOzoHlLQdXNtxa6ec2zc+vcYhdC4lL6
         p6uLWRngQV6daz6Tm85gfuBefypv/NnNKEv4O/s+qSW1EAMXvo/QNfcwkQHsso5lenrh
         PwWzpVde4t1LpU8aXYwejmRnt1CAJ7YrZK5qXqgEI8xWq3bJ2XP2nMY4BBwGgzu0gPm6
         vDA1FQ4NB1xIqr3qNY3VRQljWXXYvl2sZdJA1NA6vl8kbNdOyKZg5nsm0GoNnxRwt9A2
         3o0HvXIna7lBs+gECH15XkKymY2oBz/N2KzvnxrLGYev0GKC6kj6zbYHbobRQ2xfjYuH
         rQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A+41Sh3sYcbNdBr2oBbX/atHaO9CurH+V8mFKTB9hbY=;
        b=qLZS7stuQwRnRYy3iCkGRXIH5nfu5u/gy7i++RrTQI6Ko7XB5Pk3kf7wl2ZhA1sYwk
         Qi4VFe2r6McFR5dI9VR6s6MXh5kuiRMmiJDlTqeKZpSMmkC1jfejX2rimPJeQg7e/vcG
         S06Y7Se1KERd/Q9tLQX6AIFVl89zTkT/BvOl4sFKhMnF5wtPGeAHKAF/gAVzMVAlEwtp
         1JZObtdak7XhtUoDRwuqKOglX7ifE5YT79S8ilfKf+AXzYBaCgPTxKjypAXKcQQMS1fK
         RLZdJSUQZ5zc3ch9wwhKC6h96bPbr9tf+KpUODgzxhD1azZ6f8rDRy9BQDfrSJHL8I9G
         Ofkg==
X-Gm-Message-State: AOAM530blPTarTsWa/y95Ovgrtro/O3YwCY4qrG9Vi0Tr37dMuHHscKu
        bP6o70PfC/arRtWMPwqizJYU4hqqkv9rPg==
X-Google-Smtp-Source: ABdhPJyCigdsPo1zoksWAqmnLwvihuBrSnoZ29lQdLVTtkFu/Groszljjr0On9FEh9GHwJRH1tUY6g==
X-Received: by 2002:a1c:a5cd:: with SMTP id o196mr5281701wme.96.1634041096751;
        Tue, 12 Oct 2021 05:18:16 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id h8sm10923800wrm.27.2021.10.12.05.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 05:18:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCHv2 nf] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
Date:   Tue, 12 Oct 2021 08:18:13 -0400
Message-Id: <6ee8ec63c78925fadf0304c8a55cac73824234af.1634041093.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rt_mt6(), when it's a nonlinear skb, the 1st skb_header_pointer()
only copies sizeof(struct ipv6_rt_hdr) to _route that rh points to.
The access by ((const struct rt0_hdr *)rh)->reserved will overflow
the buffer. So this access should be moved below the 2nd call to
skb_header_pointer().

Besides, after the 2nd skb_header_pointer(), its return value should
also be checked, othersize, *rp may cause null-pointer-ref.

v1->v2:
  - clean up some old debugging log.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/netfilter/ip6t_rt.c | 48 +++++-------------------------------
 1 file changed, 6 insertions(+), 42 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 733c83d38b30..4ad8b2032f1f 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -25,12 +25,7 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 static inline bool
 segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
-	bool r;
-	pr_debug("segsleft_match:%c 0x%x <= 0x%x <= 0x%x\n",
-		 invert ? '!' : ' ', min, id, max);
-	r = (id >= min && id <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
-	return r;
+	return (id >= min && id <= max) ^ invert;
 }
 
 static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
@@ -65,30 +60,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		return false;
 	}
 
-	pr_debug("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
-	pr_debug("TYPE %04X ", rh->type);
-	pr_debug("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
-
-	pr_debug("IPv6 RT segsleft %02X ",
-		 segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-				rh->segments_left,
-				!!(rtinfo->invflags & IP6T_RT_INV_SGS)));
-	pr_debug("type %02X %02X %02X ",
-		 rtinfo->rt_type, rh->type,
-		 (!(rtinfo->flags & IP6T_RT_TYP) ||
-		  ((rtinfo->rt_type == rh->type) ^
-		   !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
-	pr_debug("len %02X %04X %02X ",
-		 rtinfo->hdrlen, hdrlen,
-		 !(rtinfo->flags & IP6T_RT_LEN) ||
-		  ((rtinfo->hdrlen == hdrlen) ^
-		   !!(rtinfo->invflags & IP6T_RT_INV_LEN)));
-	pr_debug("res %02X %02X %02X ",
-		 rtinfo->flags & IP6T_RT_RES,
-		 ((const struct rt0_hdr *)rh)->reserved,
-		 !((rtinfo->flags & IP6T_RT_RES) &&
-		   (((const struct rt0_hdr *)rh)->reserved)));
-
 	ret = (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
 			      rh->segments_left,
 			      !!(rtinfo->invflags & IP6T_RT_INV_SGS))) &&
@@ -107,22 +78,22 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 						       reserved),
 					sizeof(_reserved),
 					&_reserved);
+		if (!rp) {
+			par->hotdrop = true;
+			return false;
+		}
 
 		ret = (*rp == 0);
 	}
 
-	pr_debug("#%d ", rtinfo->addrnr);
 	if (!(rtinfo->flags & IP6T_RT_FST)) {
 		return ret;
 	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
-		pr_debug("Not strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
 			unsigned int i = 0;
 
-			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0;
 			     temp < (unsigned int)((hdrlen - 8) / 16);
 			     temp++) {
@@ -138,26 +109,20 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 					return false;
 				}
 
-				if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
-					pr_debug("i=%d temp=%d;\n", i, temp);
+				if (ipv6_addr_equal(ap, &rtinfo->addrs[i]))
 					i++;
-				}
 				if (i == rtinfo->addrnr)
 					break;
 			}
-			pr_debug("i=%d #%d\n", i, rtinfo->addrnr);
 			if (i == rtinfo->addrnr)
 				return ret;
 			else
 				return false;
 		}
 	} else {
-		pr_debug("Strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
-			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0; temp < rtinfo->addrnr; temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
@@ -173,7 +138,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				if (!ipv6_addr_equal(ap, &rtinfo->addrs[temp]))
 					break;
 			}
-			pr_debug("temp=%d #%d\n", temp, rtinfo->addrnr);
 			if (temp == rtinfo->addrnr &&
 			    temp == (unsigned int)((hdrlen - 8) / 16))
 				return ret;
-- 
2.27.0

