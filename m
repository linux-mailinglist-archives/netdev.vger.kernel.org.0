Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE46B4407BD
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 08:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhJ3Gns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 02:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhJ3Gnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 02:43:47 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4169C061570;
        Fri, 29 Oct 2021 23:41:17 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p40so6454340pfh.8;
        Fri, 29 Oct 2021 23:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UjE5rqV9YkEJ/jh/9FOC8oevBVSTtNSrYDvMxA/WymY=;
        b=pBVae0l1mAb7sndDjkicYEsznprOmQKXS6Hyvgd6iZ2yGyVr6tGS8rIl/og97/laJF
         I95LHJeQR4UkLLOE6wiWX+FFRNzkS8SgDHfMXqaxAGyvnlSqDonSTf2w0rid0k2QZG13
         Ngb6hrFjZqgavSqA5Y/dkSeWL9FazihRDne/PtADOeV6yoUdHn1NHBKrDjnnSaSsWoDD
         wSLHG9DU9rmfWRyrPGUn8N3gFEGmUaTlpXWwyvYHSscvYYKNhMez5R72CK2rNZWusZ/7
         nbfuOcmoR7jYCVJj8/egg7T5/HxV5kV173OLVaHQtWKW0crlNL/Q5VnK3AoAJnMpCmWe
         eEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UjE5rqV9YkEJ/jh/9FOC8oevBVSTtNSrYDvMxA/WymY=;
        b=zy9Ro53TIKDsaHoyyc4DeT9DDg7jMMPQRP5xSsl7PdQL9K4QQ+FOk8ahj1vDpPkG01
         97qJWKmO9sdPD7q6+axx8ICKJdifI73h2W0J6/JmDA3YfdCOcYMwrVRt8HxPC4u2Q+N0
         wXdSP9ipBSUrSdMsFtox+ZsapkqtMgNmSsZ2NSif9mRh6LH5TZaBWzLtCwZrFNDiZt+y
         SUhpeK05yuLwD2pUDiO5JkJG0wWNXS3125KN3AaoWTsS4OH4lQ/AABofJL5kZ3iCDMxs
         gIsaSjsKlhrR/z2UoXMJTsDsaLGyEDCzqXHzTDg0/3OC+BHYGmZ+Llzv4trYErUUzQik
         bXqg==
X-Gm-Message-State: AOAM531rHwNQfX6gHV80lP/1GWrK0M9QqxlkuVQZCVtgph05VbM1+NIW
        RPcJ54riIzOYHJDyQ7cVMDZ/R/ehnzx6Xg==
X-Google-Smtp-Source: ABdhPJwqDKvgwZIA3uuA5VlUmELO62fbDB6QbdZMewrMV+TPxbxxg3hHIf+YKOlcrPH7lRZsduf3DQ==
X-Received: by 2002:a05:6a00:248a:b0:47c:f2e:1c3e with SMTP id c10-20020a056a00248a00b0047c0f2e1c3emr15615976pfv.84.1635576077042;
        Fri, 29 Oct 2021 23:41:17 -0700 (PDT)
Received: from ubuntu-hirsute.. ([162.219.34.243])
        by smtp.gmail.com with ESMTPSA id k13sm9769973pfc.197.2021.10.29.23.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 23:41:16 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     horms@verge.net.au
Cc:     ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        yangxingwu <xingwu.yang@gmail.com>,
        Chuanqi Liu <legend050709@qq.com>
Subject: [PATCH nf-next v4] netfilter: ipvs: Fix reuse connection if RS weight is 0
Date:   Sat, 30 Oct 2021 14:40:49 +0800
Message-Id: <20211030064049.9992-1-xingwu.yang@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are changing expire_nodest_conn to work even for reused connections when
conn_reuse_mode=0 but without affecting the controlled and persistent
connections during the graceful termination period while server is with
weight=0.

Fixes: d752c3645717 ("ipvs: allow rescheduling of new connections when port
reuse is detected")
Co-developed-by: Chuanqi Liu <legend050709@qq.com>
Signed-off-by: Chuanqi Liu <legend050709@qq.com>
Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
---
 Documentation/networking/ipvs-sysctl.rst |  3 +--
 net/netfilter/ipvs/ip_vs_core.c          | 12 ++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

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
index 128690c512df..ce6ceb55822b 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1100,10 +1100,6 @@ static inline bool is_new_conn(const struct sk_buff *skb,
 static inline bool is_new_conn_expected(const struct ip_vs_conn *cp,
 					int conn_reuse_mode)
 {
-	/* Controlled (FTP DATA or persistence)? */
-	if (cp->control)
-		return false;
-
 	switch (cp->protocol) {
 	case IPPROTO_TCP:
 		return (cp->state == IP_VS_TCP_S_TIME_WAIT) ||
@@ -1964,7 +1960,6 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	struct ip_vs_proto_data *pd;
 	struct ip_vs_conn *cp;
 	int ret, pkts;
-	int conn_reuse_mode;
 	struct sock *sk;
 
 	/* Already marked as IPVS request or reply? */
@@ -2041,15 +2036,16 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	cp = INDIRECT_CALL_1(pp->conn_in_get, ip_vs_conn_in_get_proto,
 			     ipvs, af, skb, &iph);
 
-	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
-	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
+	if (!iph.fragoffs && is_new_conn(skb, &iph) && cp && !cp->control) {
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

