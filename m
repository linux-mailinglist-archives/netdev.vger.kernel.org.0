Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86054407B8
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 08:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhJ3GfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 02:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhJ3GfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 02:35:03 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEBFC061570;
        Fri, 29 Oct 2021 23:32:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id r5so8269238pls.1;
        Fri, 29 Oct 2021 23:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UjE5rqV9YkEJ/jh/9FOC8oevBVSTtNSrYDvMxA/WymY=;
        b=LXdRKewdQg7gz7uAcQ2+iJKzay4f9pxTf4NGHvep0QLBcTCcv/NSepkifTzXlGs1Pr
         rsFfG6CVQTWjxOxhfYYyJ9jlHVlzeRfRzFG434YXDgZqFg16Xx+rnq/duL28dnKspzUz
         q2BQrAjKWJh15p4mQ6P19shWHkmcjLIu3S6jfnO+TWDPTp0mosWooaMGZoRFIWqqW7EP
         rwgUi+yq+iXCLD1HLugDZpd50KpM8jezCaXnFj5OoRm2On36yx9E4ewhIbcnO3YTyV8+
         Lqx4Ke7OBtcV/EKPFzEgGY/WZyNIBUMCjn2ei1WhqnApNUDqUV2TQ9pcQtQRoUy2tMyn
         y2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UjE5rqV9YkEJ/jh/9FOC8oevBVSTtNSrYDvMxA/WymY=;
        b=g3yATh+W03vbCELiU/apzua51IsrXg6OK18OtbqMSSwc09fN4UlmdrpG1hBM0O4JAS
         Q839GVh4Fjq3NA4e6lOGi0NPHrTOPLWzAte+YWqQ21310Ovi4WptdN+LauzT7eO6FPhZ
         Hj1Th5lmCSgmTL2tyJKeG5TEmoTLnftKzv2vKPjkQobEnJr/O1WXIEkqAgya5QaZl3Eh
         89eYP8dRoy7abeSe01rlzFFMfq1miCVRBGcAG6ASqgZv/t6uvfi/UkNH/B4+UlYvmpb9
         UvoSZw54b3piZZZo9TE6A5S3kMywhstc+KjokHxFQFS3uET9ldjbhpxz16zKHfQCzZhX
         knlw==
X-Gm-Message-State: AOAM531Nx+DPwP3FLI0mhzv1Od6/3zo4tJPOvIdSdxnCCYvZ5DKD16vS
        KpyYMdSNuE4THm9Q2TarzFk=
X-Google-Smtp-Source: ABdhPJyaeFzAwevmWOrOrCvzLw5eMTfuOamhEt17zCo+bAW6DQjGPuRh08uRXSsBVKsd8xkxO3XdRQ==
X-Received: by 2002:a17:902:a3c5:b0:141:9152:80d9 with SMTP id q5-20020a170902a3c500b00141915280d9mr12211669plb.83.1635575552354;
        Fri, 29 Oct 2021 23:32:32 -0700 (PDT)
Received: from ubuntu-hirsute.. ([162.219.34.243])
        by smtp.gmail.com with ESMTPSA id f20sm8476294pfj.108.2021.10.29.23.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 23:32:31 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     horms@verge.net.au
Cc:     ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net, xingwu.yang@gmail.com,
        legend050709@qq.com
Subject: [PATCH net-next v3] ipvs: Fix reuse connection if RS weight is 0
Date:   Sat, 30 Oct 2021 14:31:48 +0800
Message-Id: <20211030063148.9060-1-xingwu.yang@gmail.com>
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

