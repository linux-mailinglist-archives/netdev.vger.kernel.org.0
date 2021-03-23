Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C11345BCD
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 11:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCWKUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 06:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCWKUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 06:20:37 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEBAC061574;
        Tue, 23 Mar 2021 03:20:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l3so13840517pfc.7;
        Tue, 23 Mar 2021 03:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nzcPoFXDCaYwpKQZvZ+zN63y7/5aPiJS5cAO7WVT9sE=;
        b=QYFVyiKVFfs3VKVUGIGHBP/Mr6t9JAMVXJ7MeplzC5QVUD2fQH1xgR35yapbEot6RZ
         nEVR4uJ65N/i4IffpfgTtUgvNbISbqsGXa4bwNG6HHPm58PLClsPPzYi+cdDCB84PMH+
         weEAR49rCmWvH/XZUVWsE44aYfLio8WlPTYFEefrUKEJMIhBRR+A2fed1LYCyKKD624d
         yCnpEwSbTfmNDeQZo18DS5L0AbqduA7xXQH8XPA0N3FeodG73gLXjBuTpsg9s6FiJ6BG
         3JjndOnhW5MGBgL2odPxwR5ydnzEm8O5XSPaYi6hm0G/5p4fZeUljq3HX2MgoxLNhBMH
         ZI/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nzcPoFXDCaYwpKQZvZ+zN63y7/5aPiJS5cAO7WVT9sE=;
        b=Pm3zYK//r6fpdPQ716ljLmcY+F1+i/VoaL7ge6fvb9by/UWuOlBR9Rdl77stUjJtKJ
         acD7+Y7n0iXqmDo3n3IVHAVtO/QqGJGeyfDJ6jQuic2/MPkKkFKMHUdacjlPhVZN2Sjk
         iJklPbvysOKKZOSvUnBIqLzeJVqo3PhRjrF0HAi/PGV/o/KeECkeaiU4vPxLtoRV49Ze
         5Y8svZfySTGMSucuMAIfAOGmhXnL9RRxBB93vAeftxPY49N7CplBrLg2GQT83GWggfge
         JnSTbyGaFy5p/DCodTnX7WtxjWdVd8vxfthXkE8xyP3QM09qE13ZTDX0xGj/GVRT3y/D
         q5Cg==
X-Gm-Message-State: AOAM5314tS/JRiQdv701BMwbPBtyg///REEvZFturEUtxERo5769jM/A
        /v8Dl1/i8LTJXTEVQrRN7tI=
X-Google-Smtp-Source: ABdhPJzXxVQl29n+FT1kkA6ff1CHX31psw1BbA9O9a8oYeLJF0PCLd3IQuxYOO1vH19TjJrnZoby3Q==
X-Received: by 2002:a63:5d6:: with SMTP id 205mr3338043pgf.278.1616494835986;
        Tue, 23 Mar 2021 03:20:35 -0700 (PDT)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id gm9sm2117207pjb.13.2021.03.23.03.20.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Mar 2021 03:20:35 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] net: ipv4: route.c: Remove unnecessary {else} if()
Date:   Tue, 23 Mar 2021 18:20:28 +0800
Message-Id: <20210323102028.11765-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put if and else if together, and remove unnecessary judgments, because
it's caller can make sure it is true. And add likely() in
ipv4_confirm_neigh().

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ipv4/route.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index fa68c2612252..f4ba07c5c1b1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -440,7 +440,7 @@ static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
 	struct net_device *dev = dst->dev;
 	const __be32 *pkey = daddr;
 
-	if (rt->rt_gw_family == AF_INET) {
+	if (likely(rt->rt_gw_family == AF_INET)) {
 		pkey = (const __be32 *)&rt->rt_gw4;
 	} else if (rt->rt_gw_family == AF_INET6) {
 		return __ipv6_confirm_neigh_stub(dev, &rt->rt_gw6);
@@ -814,19 +814,15 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
 
 static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst)
 {
-	struct rtable *rt = (struct rtable *)dst;
+	struct rtable *rt = container_of(dst, struct rtable, dst);
 	struct dst_entry *ret = dst;
 
-	if (rt) {
-		if (dst->obsolete > 0) {
-			ip_rt_put(rt);
-			ret = NULL;
-		} else if ((rt->rt_flags & RTCF_REDIRECTED) ||
-			   rt->dst.expires) {
-			ip_rt_put(rt);
-			ret = NULL;
-		}
+	if (dst->obsolete > 0 || rt->dst.expires ||
+	    (rt->rt_flags & RTCF_REDIRECTED)) {
+		ip_rt_put(rt);
+		ret = NULL;
 	}
+
 	return ret;
 }
 
-- 
2.29.0

