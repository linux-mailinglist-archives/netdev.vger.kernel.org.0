Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EACF441207
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 03:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhKACHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 22:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhKACHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 22:07:09 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E23C061714;
        Sun, 31 Oct 2021 19:04:36 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id o14so475297plg.5;
        Sun, 31 Oct 2021 19:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f50QsgXF5clJv/Hog1ViBB6J+DOPMeugFSp10hvavv0=;
        b=Hoh5xAKungIThBxu6j2oiGq7W3N0Eq/1S7d7K5m3ZdR3Anspb5HbevIPJBuBQ8jrGv
         01IumQs8GDCNY4GSRAh8dYWwfLNRhxfkwauOq7ZAvR9qQjUnmeyWZZkN4kpqx8H6sVhs
         F6damnZOzNzCawHSjRMayB86BiRyRMtZw70taYZOJQjocfmbaVJ6L6H6t9iC44wg5HoT
         WCiqV5ExZWm19c5q7QWgjQO7Wbf1h43WbajTf55vZxWHVttq/8Qm0uAiN8GMoM0BZjwG
         P5ryOkSN85magx63Lgy9YNwiim6AkNkmY5DNvNM8OMnTkTOmrSuAcJcpXZ0pH+rLS1KF
         0fLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f50QsgXF5clJv/Hog1ViBB6J+DOPMeugFSp10hvavv0=;
        b=0mFwuaT0J3zsnapUSXs/LCKLP/OIdvp3LzH/aCjHk49ObKhYn6JAzNrYtpionavY5M
         F+1StCLph2TF4G1xZizFEGmHcnWrc4rB4t29N9yrgxnTtwNzdN5gldyzgx2kN227A8nQ
         PAVWJG+LTvWO05RApN3zT6l0AX4+w4XyHYTPtNZFtNAHDDOCb2POHJRJC/h1ofqEuTxa
         klnarOa2GyvWKhvqt5LdgJ2Ja6W9du+bV8SJK5mOHyjqBSLRUKQNQ7ROIpeJPBMrv6aS
         wBSOuX7rpGjbDeNMvebCOF5SEtpPj0utWwLkM3CyWwif/+6W3/rCRlegKcgwjHavSBDB
         jU0Q==
X-Gm-Message-State: AOAM533RzaiCSikyPPfpgGsU3HTprnIZfFcD4+spJawT4NUmmbF9A73t
        QjJMINzitIx65s6r4i0YcSZnQ1iSHSYOkg==
X-Google-Smtp-Source: ABdhPJxBa7TkwRx2JBjiSaoJDpcjqsrJPpRm8pQmXQfl6/uUAzNJNkw5HDl8hDPKFArBqqPDUi5S3A==
X-Received: by 2002:a17:90a:5b0d:: with SMTP id o13mr36196993pji.117.1635732276208;
        Sun, 31 Oct 2021 19:04:36 -0700 (PDT)
Received: from ubuntu-hirsute.. ([154.86.159.245])
        by smtp.gmail.com with ESMTPSA id n7sm12938315pfd.37.2021.10.31.19.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 19:04:35 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     horms@verge.net.au
Cc:     ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        yangxingwu <xingwu.yang@gmail.com>,
        Chuanqi Liu <legend050709@qq.com>
Subject: [PATCH nf-next v5] netfilter: ipvs: Fix reuse connection if RS weight is 0
Date:   Mon,  1 Nov 2021 10:04:16 +0800
Message-Id: <20211101020416.31402-1-xingwu.yang@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are changing expire_nodest_conn to work even for reused connections when
conn_reuse_mode=0, just as what was done with commit dc7b3eb900aa ("ipvs:
Fix reuse connection if real server is dead").

For controlled and persistent connections, the new connection will get the
needed real server depending on the rules in ip_vs_check_template().

Fixes: d752c3645717 ("ipvs: allow rescheduling of new connections when port reuse is detected")
Co-developed-by: Chuanqi Liu <legend050709@qq.com>
Signed-off-by: Chuanqi Liu <legend050709@qq.com>
Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
---
 Documentation/networking/ipvs-sysctl.rst | 3 +--
 net/netfilter/ipvs/ip_vs_core.c          | 8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
index 2afccc63856e..1cfbf1add2fc 100644
--- a/Documentation/networking/ipvs-sysctl.rst
+++ b/Documentation/networking/ipvs-sysctl.rst
@@ -37,8 +37,7 @@ conn_reuse_mode - INTEGER
 
 	0: disable any special handling on port reuse. The new
 	connection will be delivered to the same real server that was
-	servicing the previous connection. This will effectively
-	disable expire_nodest_conn.
+	servicing the previous connection.
 
 	bit 1: enable rescheduling of new connections when it is safe.
 	That is, whenever expire_nodest_conn and for TCP sockets, when
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 128690c512df..f9d65d2c8da8 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1964,7 +1964,6 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	struct ip_vs_proto_data *pd;
 	struct ip_vs_conn *cp;
 	int ret, pkts;
-	int conn_reuse_mode;
 	struct sock *sk;
 
 	/* Already marked as IPVS request or reply? */
@@ -2041,15 +2040,16 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	cp = INDIRECT_CALL_1(pp->conn_in_get, ip_vs_conn_in_get_proto,
 			     ipvs, af, skb, &iph);
 
-	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
-	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
+	if (!iph.fragoffs && is_new_conn(skb, &iph) && cp) {
 		bool old_ct = false, resched = false;
+		int conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
 
 		if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
 		    unlikely(!atomic_read(&cp->dest->weight))) {
 			resched = true;
 			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
-		} else if (is_new_conn_expected(cp, conn_reuse_mode)) {
+		} else if (conn_reuse_mode &&
+			   is_new_conn_expected(cp, conn_reuse_mode)) {
 			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 			if (!atomic_read(&cp->n_control)) {
 				resched = true;
-- 
2.30.2

