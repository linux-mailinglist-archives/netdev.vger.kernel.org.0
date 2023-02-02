Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39212687916
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjBBJlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjBBJlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:41:06 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BDE37F25
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:41:05 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id ly4-20020a0562145c0400b0054d2629a759so652160qvb.16
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=THfvEAG2TAvlBAwu6uh0/CCSYlBGdlZVRDZYvQ/2zJg=;
        b=YSqipuFwu8/R1pxwuw0Q3jCoaJkzr9lwLQzhXtcNEfFQ56LuTprG2EoYMjHTiM+FBL
         NjP0mof+6wp5WzJ9ZbZ+ymlE/bttBle2hFjVBU19bzkfO2xh5Imk2YAW2yLBinXEE+lH
         V7NC1a06/OkS7p9ROue0SRvy4Mx2vkyN0l+fRnS9B6Ww5j8SmOA5ELyomGT2KB0AN78u
         Hb3tJOrZfUSM3iNVczgCEm6C66l2EQjFcTdju8HUZHuVmwDbgnopMql9Nb8nKvElirvG
         HEAStRo7xGh5ZE1I95NWm4Xol/Z3acsBZhwwbYU6sFi+o2vXAGl3y66rgy0e4Aij6fNz
         NdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=THfvEAG2TAvlBAwu6uh0/CCSYlBGdlZVRDZYvQ/2zJg=;
        b=vMCGeu82hcaBXS7nM9jlLFCcVfKLX/azPBJrBI4HjFgi58HMipl/KOFsNDlzFNC3Mc
         qL5BpiHEdVx/cUmcy1am4aqMwGUe8z0+M7aceSivfrxWxfQHAszksrfy4x9hdwkPsOEH
         U8nB2dRcj8nNN9XzvNTj5DNUCs1KJMTgdHZebYkLT/3V6sP0d2kq2YAzcPIB+XXh6EPw
         oBYFtPk2SIxrVOE0YRMwX738+BHEZ0kZOkz4u9EBdps0HZ9UBo6U/aoaLWTdG64t1B1p
         7vNs4/5D5FpObZQBiTeJLucnM7hXtzwyN/wtWeaX4Mnyjcg+PMSNCAzSfoYuJzadB+Fb
         ffJg==
X-Gm-Message-State: AO0yUKWmAydX+CpNnV9YdtwheUoyzawO0G5wjtYpblKQA5cBx7r42Tzm
        eSyymZbF5kTYQ9BHltqEkPJ7j0CTPgOHhw==
X-Google-Smtp-Source: AK7set8mzugN8yu7abqHSrIHggFlJchSeBo05PoZkm5kLFbXvtgls0NosTfd22x6l/XcABatzRChsji0FnMcsA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ad4:4102:0:b0:537:30a0:903c with SMTP id
 i2-20020ad44102000000b0053730a0903cmr378798qvp.8.1675330864592; Thu, 02 Feb
 2023 01:41:04 -0800 (PST)
Date:   Thu,  2 Feb 2023 09:40:58 +0000
In-Reply-To: <20230202094100.3083177-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230202094100.3083177-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230202094100.3083177-2-edumazet@google.com>
Subject: [PATCH net-next 1/3] ipv6: raw: add drop reasons
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use existing helpers and drop reason codes for RAW input path.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/raw.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index ada087b50541a6f67b9b47f6f98408a96f6a6250..2e1c8060b51aed020194d9461bff20de0768d1e1 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -355,17 +355,19 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 
 static inline int rawv6_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
+	enum skb_drop_reason reason;
+
 	if ((raw6_sk(sk)->checksum || rcu_access_pointer(sk->sk_filter)) &&
 	    skb_checksum_complete(skb)) {
 		atomic_inc(&sk->sk_drops);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_SKB_CSUM);
 		return NET_RX_DROP;
 	}
 
 	/* Charge it to the socket. */
 	skb_dst_drop(skb);
-	if (sock_queue_rcv_skb(sk, skb) < 0) {
-		kfree_skb(skb);
+	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
+		kfree_skb_reason(skb, reason);
 		return NET_RX_DROP;
 	}
 
@@ -386,7 +388,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb)) {
 		atomic_inc(&sk->sk_drops);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_XFRM_POLICY);
 		return NET_RX_DROP;
 	}
 
@@ -410,7 +412,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 	if (inet->hdrincl) {
 		if (skb_checksum_complete(skb)) {
 			atomic_inc(&sk->sk_drops);
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_REASON_SKB_CSUM);
 			return NET_RX_DROP;
 		}
 	}
-- 
2.39.1.456.gfc5497dd1b-goog

