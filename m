Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC613269A1
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBZVgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhBZVgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 16:36:14 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15342C061756
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:35:34 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id 7so9943628wrz.0
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CTK2CZW6dThnJoLa96XyzUuczzpCg6mfYSe2z1EpnaA=;
        b=RNworZCVBIJIg7DrO8emBzugLV072do89NPseJKP6lQfoqKGxsNl8wXAWOsdk68LXr
         2Og0VT0nJc4vIcVx0yuEqGH4dYDyvrPaDsl/G1pte9rFZZ9IhYHRVs6UBsZ/I723Fl+t
         vpoxMQlfTzXzLpQGGHHgkTp93Kt4FerIMbSmcGMsR8CP5rvGCEGsgjhV2wpk0M0IJ9vc
         vcEyhXLCpbnuHrP7tkcxfQd4pCwylzvZ+E+BwFN6kutgOu1SMMbT46p6dbEEWrkaW/bG
         3atjo1dxyPaEbJe+knWPUkQNolJ9IQBFJiZyejiZBWzboyMbDcTMJZSmsdgZG5WTUizc
         pnXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CTK2CZW6dThnJoLa96XyzUuczzpCg6mfYSe2z1EpnaA=;
        b=WvYvxpaR7C8VRWqW8a+mxakPAlG+Z5OmYkpA1cfntz4rnilHlTnViu5B5u2dwK7Rn3
         lnyn2iboVpi0hzAT6GQrSye3a+WMrAyAahxwJau93W5nGqTGECGCD3s2ZwMPl7X8kztF
         Ii7s2894VBwAnLTfIK2R1EXKvuNFELhez9Wvy9utJ+e6sHRLan5Y36X1/KxrqdnuAI4c
         +o51WYFLvJrJbFwcXI4RWEqI3xyiLgTs5r3uIj/z8f5ANLFZMJZZ9nYGtSlPEnxYYONh
         pC0NZwRZqSmDhB9enLUDO/eX2f79b6vA1ZvfjK3vmyLRIvsON/zEz2LL5k924cWSVKuZ
         IjqA==
X-Gm-Message-State: AOAM533lp4a+2vlA7eMeBhfLmIAhN14l1wrkSkyTMSbQ6Jot2Y9jyLbk
        QFUd9cHppXZkIAwQH4pDBgw=
X-Google-Smtp-Source: ABdhPJz2lLkTOKGPoUwdVQF1+LjfwyHqVhyvDE/IiS//qK+jUCCtQAWlL2FQ3ootFDEdm6ip8KrAnA==
X-Received: by 2002:adf:b1c9:: with SMTP id r9mr5375017wra.51.1614375332778;
        Fri, 26 Feb 2021 13:35:32 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id z11sm17587241wrm.72.2021.02.26.13.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 13:35:32 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, bram-yvahk@mail.wizbit.be,
        sd@queasysnail.net, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec 2/2] vti6: fix ipv4 pmtu check to honor ip header df
Date:   Fri, 26 Feb 2021 23:35:06 +0200
Message-Id: <20210226213506.506799-3-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226213506.506799-1-eyal.birger@gmail.com>
References: <20210226213506.506799-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frag needed should only be sent if the header enables DF.

This fix allows IPv4 packets larger than MTU to pass the vti6 interface
and be fragmented after encapsulation, aligning behavior with
non-vti6 xfrm.

Fixes: ccd740cbc6e0 ("vti6: Add pmtu handling to vti6_xmit.")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/ipv6/ip6_vti.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 0225fd694192..2f0be5ac021c 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -494,7 +494,7 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	}
 
 	if (dst->flags & DST_XFRM_QUEUE)
-		goto queued;
+		goto xmit;
 
 	x = dst->xfrm;
 	if (!vti6_state_check(x, &t->parms.raddr, &t->parms.laddr))
@@ -523,6 +523,8 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		} else {
+			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
+				goto xmit;
 			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				  htonl(mtu));
 		}
@@ -531,7 +533,7 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 		goto tx_err_dst_release;
 	}
 
-queued:
+xmit:
 	skb_scrub_packet(skb, !net_eq(t->net, dev_net(dev)));
 	skb_dst_set(skb, dst);
 	skb->dev = skb_dst(skb)->dev;
-- 
2.25.1

