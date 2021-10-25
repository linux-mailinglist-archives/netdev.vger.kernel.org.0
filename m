Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC34C439575
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 13:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhJYMBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhJYMBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:01:43 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AB7C061745;
        Mon, 25 Oct 2021 04:59:21 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so8232516pjb.3;
        Mon, 25 Oct 2021 04:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7EfxP+NNNDqzXZbApTvLoWyoKYpAMnYA8qlrdpBRI48=;
        b=bq2XHOiAgE0+68ggQGvbgW1f1CCDuX617uhA+20w+r2E0eyNvNPw2swqehGCk1jBSC
         tefyDUWchsfEWkG63Z9PUujW/0WnPSjBhFr72XXmB9CTkufKPMuVPpIYfZIn467bnEeV
         lMlcSejWxGs7Uw2mw9y/WaQGCKyJOcu3+G7mWYbB8fabHScCu/Ubjj0Vo402K9rIaM2v
         wIlEEky2LrMyAPqxumyoxJ3bfZBjbgicYtB+6IiMeE1o5FhV3wdFsV4lZ7aAeZP9Hroz
         AzoMjgqF8c7V3VyZkG/Ju3g19rSA3NlMRCMqqPAdbxKZo3kN+PnMtofZh6WbpKwLVWPW
         EpLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7EfxP+NNNDqzXZbApTvLoWyoKYpAMnYA8qlrdpBRI48=;
        b=YfLaqjsnK5r4T+CyIQm7PJD+kEaqWbe2D/W8WZ2n9zR0+paNvUEREibCG/2BfxQuK9
         Oof8gzOOtPf150e0YAHrTT2kHGAKqGCj3m03pjM1YrP60a5n3+W2/rFmKoVOa3Eg+s98
         IvXsCl/ON6wWy2n6opNylQfvsRkiCsxFNj/wDQ59+Cufv2hFi5rFS5+isCodWrdKa9uD
         l2muEH0luI49qvHh95141ykUqsLu4IxnNlE0B/Zv2Uz1EktaQPSQqQz/j+RHw40XYStT
         3IRHo2ElQ0X8tRpmUjb+RFMSr7qCI+Xt1toDIl2Ymu87XU5nYbcMi01h097KCgH1QLfT
         EvPw==
X-Gm-Message-State: AOAM530K+iwLJvWMdAAt8Gk4pb8AbgUB9gndlNg0l8MVv2OtQobQrRFI
        WPh9N2V3h2BotmmDumE2AHU=
X-Google-Smtp-Source: ABdhPJxMuslf8J3sqJtUWlL/rKPGmGcdRJ/N091CQE0aJ7TVEq1RNpzWbjvkZxIGz3vc7qlrsVZXgg==
X-Received: by 2002:a17:90a:bd0f:: with SMTP id y15mr12070038pjr.186.1635163161172;
        Mon, 25 Oct 2021 04:59:21 -0700 (PDT)
Received: from ubuntu-hirsute.. ([154.86.159.246])
        by smtp.gmail.com with ESMTPSA id u4sm19362300pfh.147.2021.10.25.04.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 04:59:20 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     horms@verge.net.au
Cc:     ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net, xingwu.yang@gmail.com
Subject: [PATCH] ipvs: Fix reuse connection if RS weight is 0
Date:   Mon, 25 Oct 2021 19:59:10 +0800
Message-Id: <20211025115910.2595-1-xingwu.yang@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit dc7b3eb900aa ("ipvs: Fix reuse connection if real server is
dead"), new connections to dead servers are redistributed immediately to
new servers.

Then commit d752c3645717 ("ipvs: allow rescheduling of new connections when
port reuse is detected") disable expire_nodest_conn if conn_reuse_mode is
0. And new connection may be distributed to a real server with weight 0.

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
---
 Documentation/networking/ipvs-sysctl.rst | 3 +--
 net/netfilter/ipvs/ip_vs_core.c          | 5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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
index 128690c512df..9279aed69e23 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2042,14 +2042,15 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 			     ipvs, af, skb, &iph);
 
 	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
-	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
+	if (!iph.fragoffs && is_new_conn(skb, &iph) && cp) {
 		bool old_ct = false, resched = false;
 
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

