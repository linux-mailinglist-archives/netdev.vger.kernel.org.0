Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A25444D9F
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 04:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhKDDNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 23:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhKDDNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 23:13:17 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDABC061714;
        Wed,  3 Nov 2021 20:10:39 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n8so4957076plf.4;
        Wed, 03 Nov 2021 20:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pVMWYzSKDSb7lsl9klO/kz5BlvSpls9AhNm08IAgTtc=;
        b=BSqZJDoE6Kf26f4Qphg3UUATcCUHmjv8DO0pTiDETbkZLFb5/Ik7pqjo8DhoVoornv
         9qbGTrNDWWTOkAv+WDjFIP6LutM+zUSJj9snw/E96zMgVeMJ1H4XCPsEKPbCEgcNDln+
         IE8Na/2CzMsCM0tOWVJi5Dx0tNoqRHffzBI+O9vqn6fJozQqb+qxgZq+ndcw2qMe49l9
         9xTksSyDCIjXqr9OJ3d4XWG8r4WkZRC8tN+g2ChSZN8725MljLH3Mt+SnHr84SuzX3Ig
         ptaeycQgb62ooFpiWFYDci2mASQrPjhc4vC2gTVcBdzhhV/GadMNd8niO1LUub8BAO2d
         sXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pVMWYzSKDSb7lsl9klO/kz5BlvSpls9AhNm08IAgTtc=;
        b=kVUTsXorzRA9hROWikxneP6/uhO7DnDrLRM5SDB6014dbAVHDWTat6Y8RLQMch24O2
         APD2HyA2YFLidHRhn4Lo5lvoogQGuBNNknrqKP4+CYJG2jXFbwgeyahpsSWp55szC8+k
         hDFcaPDx3CawCvJqEavZt64sg5hDmsiTIkw9yLQZ0USmBJ/soVF159ZSJUYguaQkaYwP
         fEb3fSyJL8qhn6cdzRXatmGtjCe68HQWt5FYvYfdSrp4Dkj9NxW81XD+bduSPcNPuQux
         EgpzfGDnGQdACLMwOqUrYfpbjHe8uqxA38pxK564mUjRmKezZOPZsBo4xDrrYUJA344N
         +EGw==
X-Gm-Message-State: AOAM532NVT3Bp0lPp2O+nXl88jNk+r2XXP35TX/6xt93yuoi/lwdMvce
        Qt7w6leQxGNKZCOjE1rBA3c=
X-Google-Smtp-Source: ABdhPJzYOHC2jjRAzzqzIln/BCPn3LH2u/srZVA0eaLFBRXyTPi2OR1l1HAfkQDNZi3Sl5lCKhFihw==
X-Received: by 2002:a17:902:e88f:b0:141:f982:777 with SMTP id w15-20020a170902e88f00b00141f9820777mr20014435plg.68.1635995439314;
        Wed, 03 Nov 2021 20:10:39 -0700 (PDT)
Received: from ubuntu-hirsute.. ([162.219.34.244])
        by smtp.gmail.com with ESMTPSA id a8sm2991469pgd.8.2021.11.03.20.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 20:10:38 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     horms@verge.net.au
Cc:     ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        yangxingwu <xingwu.yang@gmail.com>,
        Chuanqi Liu <legend050709@qq.com>
Subject: [PATCH nf-next v6] netfilter: ipvs: Fix reuse connection if RS weight is 0
Date:   Thu,  4 Nov 2021 11:10:29 +0800
Message-Id: <20211104031029.157366-1-xingwu.yang@gmail.com>
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
index 128690c512df..393058a43aa7 100644
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
+		int conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
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

