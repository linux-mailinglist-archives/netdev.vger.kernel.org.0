Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9646112C8
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJ1NbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiJ1Na4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:30:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2D397EDD
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h9-20020a25e209000000b006cbc4084f2eso4510610ybe.23
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CmPTSo++eaqXQRu2DaBooqOa1NSBcQeByMRnjkGhnxU=;
        b=l13/AdoDp6ssM2m142NqPMEEysq9+OIvW0gT3TJly6FMeKe9YYans53Vgo9g1KLYVc
         NL53RShl8Wbni++bOFBijnumPfYOWQwY5XpzS3A6vM94FwWRlYR+/R4QjhIH1ux3KlLn
         tjwIRCaNdEUC9uPFxpbXK9xplZBF1JXbQN7Gx6F0TmvtSFNDZzNy3MgPxHXIyUfjtupd
         GOTxpuWhkMrpYgCQ6ZQBCseqm31/kWT5kAvxs68ZsiPPygRAGNAosPPKRmnnyzidgiZ/
         gJxs5EozWlWiVqWV3gC7gVuJIa3fq0ANp/ORXd7XYEhQVFs7WqISFXi7+/nyWN26EKQq
         Yjlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CmPTSo++eaqXQRu2DaBooqOa1NSBcQeByMRnjkGhnxU=;
        b=tCGfg5m762XTDGwTnRtqYrVxmCNWV8T1DE++yBb0AKTrVFfqJNhIras8DbzJrl9Ipq
         X8/7yCZhH3/pfcWxeX/zk+F3o04XFZEd8xHb8JW4aSu05EUbu40sj18taASXEcwfCL0E
         j6zDZU/Pjp7fa4ANwzxbFdPPXrfzFWuV69mpKydfyYlDaRB+fGmj83bZHV/ves2x+VZz
         Sv8XUa+/c7RXTty+cv3qaAo+fCMm57oNrKAwxrmAZ2BJ447fLjX17pCXxWqzMibvJGpW
         ilr9SPkXVwNviBfnaL5P/pwvJHLo7ESWjcTwJw42MD2Q2uQdf+D1WotQ2Nt3jnb+QSY5
         tHFw==
X-Gm-Message-State: ACrzQf2fRPKjEIl3TDIAH76rdWnxHbVSyKCx3k2qNNJBkbKiwEF1lyAo
        hnJXpCXlEjvbm5Go1mNTe5sJaw+LQWTc8A==
X-Google-Smtp-Source: AMsMyM4wbXdXoEKcwZ3Qd3Ni+MBbYRF+/ks3E3lOtzJ0izKsHhmvCM6Lu23F3yg/gdeq3Yr+JW53AHj6tlrErw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:4e87:0:b0:368:3422:a62d with SMTP id
 c129-20020a814e87000000b003683422a62dmr41247871ywb.277.1666963853427; Fri, 28
 Oct 2022 06:30:53 -0700 (PDT)
Date:   Fri, 28 Oct 2022 13:30:41 +0000
In-Reply-To: <20221028133043.2312984-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221028133043.2312984-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221028133043.2312984-4-edumazet@google.com>
Subject: [PATCH net-next 3/5] net: dropreason: add SKB_DROP_REASON_DUP_FRAG
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

This is used to track when a duplicate segment received by various
reassembly units is dropped.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h                |  3 +++
 net/ipv4/ip_fragment.c                  | 13 +++++++++----
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/reassembly.c                   | 13 +++++++++----
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 0bd18c14dae0a570a150c31eeea99fe85bc734b0..602d555a5f8392715ec03f85418ecb98926d0481 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -68,6 +68,7 @@
 	FN(IP_INADDRERRORS)		\
 	FN(IP_INNOROUTES)		\
 	FN(PKT_TOO_BIG)			\
+	FN(DUP_FRAG)			\
 	FNe(MAX)
 
 /**
@@ -300,6 +301,8 @@ enum skb_drop_reason {
 	 * MTU)
 	 */
 	SKB_DROP_REASON_PKT_TOO_BIG,
+	/** @SKB_DROP_REASON_DUP_FRAG: duplicate fragment */
+	SKB_DROP_REASON_DUP_FRAG,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index fb153569889ecc8541640674880ff03e8c7bf24f..676bd8d259555448457dfd98ce4316c4b549a30a 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -278,10 +278,14 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	struct net_device *dev;
 	unsigned int fragsize;
 	int err = -ENOENT;
+	SKB_DR(reason);
 	u8 ecn;
 
-	if (qp->q.flags & INET_FRAG_COMPLETE)
+	/* If reassembly is already done, @skb must be a duplicate frag. */
+	if (qp->q.flags & INET_FRAG_COMPLETE) {
+		SKB_DR_SET(reason, DUP_FRAG);
 		goto err;
+	}
 
 	if (!(IPCB(skb)->flags & IPSKB_FRAG_COMPLETE) &&
 	    unlikely(ip_frag_too_far(qp)) &&
@@ -382,8 +386,9 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 
 insert_error:
 	if (err == IPFRAG_DUP) {
-		kfree_skb(skb);
-		return -EINVAL;
+		SKB_DR_SET(reason, DUP_FRAG);
+		err = -EINVAL;
+		goto err;
 	}
 	err = -EINVAL;
 	__IP_INC_STATS(net, IPSTATS_MIB_REASM_OVERLAPS);
@@ -391,7 +396,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	inet_frag_kill(&qp->q);
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 err:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return err;
 }
 
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 38db0064d6613a8472ec2835afdbf80071c1fcc2..d13240f13607bae8833d4e53471c575280ff49dc 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -253,7 +253,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 	if (err) {
 		if (err == IPFRAG_DUP) {
 			/* No error for duplicates, pretend they got queued. */
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_REASON_DUP_FRAG);
 			return -EINPROGRESS;
 		}
 		goto insert_error;
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index ff866f2a879e00769b273c22b970740eaebb6d99..5bc8a28e67f944c9e7bead79afa8b80a34b92db9 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -112,10 +112,14 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 	struct sk_buff *prev_tail;
 	struct net_device *dev;
 	int err = -ENOENT;
+	SKB_DR(reason);
 	u8 ecn;
 
-	if (fq->q.flags & INET_FRAG_COMPLETE)
+	/* If reassembly is already done, @skb must be a duplicate frag. */
+	if (fq->q.flags & INET_FRAG_COMPLETE) {
+		SKB_DR_SET(reason, DUP_FRAG);
 		goto err;
+	}
 
 	err = -EINVAL;
 	offset = ntohs(fhdr->frag_off) & ~0x7;
@@ -226,8 +230,9 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 
 insert_error:
 	if (err == IPFRAG_DUP) {
-		kfree_skb(skb);
-		return -EINVAL;
+		SKB_DR_SET(reason, DUP_FRAG);
+		err = -EINVAL;
+		goto err;
 	}
 	err = -EINVAL;
 	__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
@@ -237,7 +242,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 	__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
 			IPSTATS_MIB_REASMFAILS);
 err:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return err;
 }
 
-- 
2.38.1.273.g43a17bfeac-goog

