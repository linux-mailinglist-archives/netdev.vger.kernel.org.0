Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9B52D3189
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 18:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbgLHRzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 12:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730740AbgLHRzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 12:55:50 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E7BC0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 09:55:10 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id n95so14503941qte.16
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 09:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=nYHvevoIASAYOZmQoEPjRemVztiqceIp+R/vgvUkPCE=;
        b=iSQsH6LmvQo+a13JDo71PFsJ1udYMRBs0oPvETKjvDUSTvDiiDV15AOP5rpHMNQnEV
         m+U3f3UgIZmhVKp6OOQnC/9YLuOIABOQC1t16FmqVd0273xfIX2cPuuxpjbfcoBMHbXA
         cCQwuDl4zrnLZL6gys1xG8sEIejUeVyLn0h68u/RUQkuETGpr/aUm07GvPSptJOuw2tH
         CDSbFOYc60MXo6AQbb5KHkD6VwyaN+27IF/zZtuykOm21RG37YVCkJXr/0qKa6+6yvyX
         oLxZ/XNU1gp4K14++s9JGAQaQMRHQ1tjuKnQlAsJbHUT9xrSt0r+DOSdlQ/qPE/+yeaT
         rkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=nYHvevoIASAYOZmQoEPjRemVztiqceIp+R/vgvUkPCE=;
        b=fbf+KcTPKf4Zaj8QTWtuAeYT3zh4ndD6CwxHfNlUuoxH/XdYLCNI9tBzDfDD9o+4M5
         MSPBS91jKVLqpiAsY/qaBF2PMQLjB3UiQfEyz3AnXCuHtXLSgyU4bi5924fQDh3Hh7Fc
         Inrm6UJ4YpBY5+jAWznn2Habz2W8ct5GeGZypbQBlAMIJaw79sH+ATrspQOIEf+hlrwz
         pGyZh8u1EJpUA4yiFEN4gbn3pvFGVi64k4UIAEnux0TYsECEZh4JrqfO9h5urQQIpvlW
         Fvn3W8ltaQxxVc7VHYQHT7/b5LVUGGmmUN1Jhn2pBXd+XcgX8N2LSfGbzBwFKNS1oOEh
         xLyA==
X-Gm-Message-State: AOAM532nlAWQFtur/FQoLCg4f8XgYb2z6o+OZLPc6pA24hoKffTXwBCt
        ej+0A0f2n5RimTzhV7bjC5tBoroiJT8=
X-Google-Smtp-Source: ABdhPJzHHIT4c3NS6XhM2DzD1Tv6De8CoM0tu2vW3GRfasxNu5SksUhg//phtV/MPYK8kjv8TYXk98M8P7U=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:a802:: with SMTP id w2mr29049479qva.9.1607450109637;
 Tue, 08 Dec 2020 09:55:09 -0800 (PST)
Date:   Tue,  8 Dec 2020 09:55:08 -0800
Message-Id: <20201208175508.1793520-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net] tcp: Retain ECT bits for tos reflection
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For DCTCP, we have to retain the ECT bits set by the congestion control
algorithm on the socket when reflecting syn TOS in syn-ack, in order to
make ECN work properly.

Fixes: ac8f1710c12b ("tcp: reflect tos value received in SYN to the socket")
Reported-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_ipv4.c | 7 +++++--
 net/ipv6/tcp_ipv6.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8391aa29e7a4..595dcc3afac5 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -984,7 +984,8 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
 
 		tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
-				tcp_rsk(req)->syn_tos & ~INET_ECN_MASK :
+				(tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
+				(inet_sk(sk)->tos & INET_ECN_MASK) :
 				inet_sk(sk)->tos;
 
 		if (!INET_ECN_is_capable(tos) &&
@@ -1541,7 +1542,9 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		inet_csk(newsk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
 	newinet->inet_id = prandom_u32();
 
-	/* Set ToS of the new socket based upon the value of incoming SYN. */
+	/* Set ToS of the new socket based upon the value of incoming SYN.
+	 * ECT bits are set later in tcp_init_transfer().
+	 */
 	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
 		newinet->tos = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 992cbf3eb9e3..f676f176eb6b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -528,7 +528,8 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 			fl6->flowlabel = ip6_flowlabel(ipv6_hdr(ireq->pktopts));
 
 		tclass = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
-				tcp_rsk(req)->syn_tos & ~INET_ECN_MASK :
+				(tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
+				(np->tclass & INET_ECN_MASK) :
 				np->tclass;
 
 		if (!INET_ECN_is_capable(tclass) &&
@@ -1320,7 +1321,9 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	if (np->repflow)
 		newnp->flow_label = ip6_flowlabel(ipv6_hdr(skb));
 
-	/* Set ToS of the new socket based upon the value of incoming SYN. */
+	/* Set ToS of the new socket based upon the value of incoming SYN.
+	 * ECT bits are set later in tcp_init_transfer().
+	 */
 	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
 		newnp->tclass = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
 
-- 
2.29.2.576.ga3fc446d84-goog

