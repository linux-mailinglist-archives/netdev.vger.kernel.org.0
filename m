Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ECE67859E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjAWS7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjAWS7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:59:04 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845534C3A
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:58:32 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id d16so10522142qtw.8
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UpYH1WO6hCVqsfBRvgjmR9Gy5XQT/XcOlzdUlx0tWWo=;
        b=EanuKx2CcayUmyTTluIQpmcLJy2WjSh2bTn5I7osmFnK7utMh8+gvhcqnx2rJuukVo
         w2euQ08Lg+QUgSAbWiLGUe0W000Qkqtfct8a1zKw3tgj9c0OMdRz3QKGeg3iDmf9OdxG
         A+qqaYyBSqwnva44XcFppZmkhk/wDNSIdnXlezG9iL3754N05DiIQwOrayiahxR25PdL
         rgjV9g1lWyR55HqUMOGMx36Hb5F9Ay50je4PZD4YuUNw2f5/V7EIzu805/1saBarpvqU
         A8jZ3cR+kdCozittzyK8qtxrTbK31EdjbT5pOC1oT3tGXAE/Xkz0lAFI6pW2u0PQtoQ6
         RuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UpYH1WO6hCVqsfBRvgjmR9Gy5XQT/XcOlzdUlx0tWWo=;
        b=DHB/i5b3gRw/40VBytTPWvks9pBSylRXeUvrh2igfAGCcIvduU5DMF1/7b7ZyvH18P
         axyBLBIurHLIzE4IplE6XNBWA0bKtSaCIbCrotgAJVh4EGEDBicis1DO7Ldh7enNwNXw
         RQKq5GgTVqkTtFYcKkx3GbgF8ekll8r750eLFFovVnrtZUSF0gL/quzll/Czh7Wx4qb5
         H7Tghx794QxaPkA/AjT8yZwLTj6Nts35KzqPnqlBB3NcWSXg1tMNRhjHPmoQpn1O9Ymw
         Q++vnt9SFVpIdTjWkjhYcRSsOXYWPIxnwOnhPFnc/kKLJeizQ6iMLY+jiTAqZ8cvSa+n
         XEew==
X-Gm-Message-State: AFqh2kr253g568xas/fH8SEH5eh7JAhZ5lMBZ42Bws0vNmcSLtGMFGwN
        WZcJ75Y59LjZpV14KPovXCA=
X-Google-Smtp-Source: AMrXdXv8xWZGi+iq51s4VtCSMj11i0QgUPBIysAdOMAAVR4MpZb5sP7/jAukx3QCrV8pCAdjh5M0xw==
X-Received: by 2002:ac8:6618:0:b0:3b6:45b7:c7ac with SMTP id c24-20020ac86618000000b003b645b7c7acmr34453369qtp.19.1674500310985;
        Mon, 23 Jan 2023 10:58:30 -0800 (PST)
Received: from r.. ([2601:18f:700:287c::1006])
        by smtp.gmail.com with ESMTPSA id x24-20020ac87ed8000000b003b323387c1asm15203272qtj.18.2023.01.23.10.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 10:58:30 -0800 (PST)
From:   Brian Haley <haleyb.dev@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] neighbor: fix proxy_delay usage when it is zero
Date:   Mon, 23 Jan 2023 13:58:29 -0500
Message-Id: <20230123185829.238909-1-haleyb.dev@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When set to zero, the neighbor sysctl proxy_delay value
does not cause an immediate reply for ARP/ND requests
as expected, it instead causes a random delay between
[0, U32_MAX]. Looking at this comment from
__get_random_u32_below() explains the reason:

/*
 * This function is technically undefined for ceil == 0, and in fact
 * for the non-underscored constant version in the header, we build bug
 * on that. But for the non-constant case, it's convenient to have that
 * evaluate to being a straight call to get_random_u32(), so that
 * get_random_u32_inclusive() can work over its whole range without
 * undefined behavior.
 */

Added helper function that does not call get_random_u32_below()
if proxy_delay is zero and just uses the current value of
jiffies instead, causing pneigh_enqueue() to respond
immediately.

Also added definition of proxy_delay to ip-sysctl.txt since
it was missing.

Signed-off-by: Brian Haley <haleyb.dev@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  6 ++++++
 net/core/neighbour.c                   | 15 +++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7fbd060d6047..34183fb38b20 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1589,6 +1589,12 @@ proxy_arp_pvlan - BOOLEAN
 	  Hewlett-Packard call it Source-Port filtering or port-isolation.
 	  Ericsson call it MAC-Forced Forwarding (RFC Draft).
 
+proxy_delay - INTEGER
+	Delay proxy response.
+
+	The maximum number of jiffies to delay a response to a neighbor
+	solicitation when proxy_arp or proxy_ndp is enabled. Defaults to 80.
+
 shared_media - BOOLEAN
 	Send(router) or accept(host) RFC1620 shared media redirects.
 	Overrides secure_redirects.
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f00a79fc301b..8bd8aaae6d5e 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1662,11 +1662,22 @@ static void neigh_proxy_process(struct timer_list *t)
 	spin_unlock(&tbl->proxy_queue.lock);
 }
 
+static __inline__ unsigned long neigh_proxy_delay(struct neigh_parms *p)
+{
+	/*
+	 * If proxy_delay is zero, do not call get_random_u32_below()
+	 * as it is undefined behavior.
+	 */
+	unsigned long proxy_delay = NEIGH_VAR(p, PROXY_DELAY);
+	return proxy_delay ?
+	       jiffies + get_random_u32_below(NEIGH_VAR(p, PROXY_DELAY)) :
+	       jiffies;
+}
+
 void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
 		    struct sk_buff *skb)
 {
-	unsigned long sched_next = jiffies +
-			get_random_u32_below(NEIGH_VAR(p, PROXY_DELAY));
+	unsigned long sched_next = neigh_proxy_delay(p);
 
 	if (p->qlen > NEIGH_VAR(p, PROXY_QLEN)) {
 		kfree_skb(skb);
-- 
2.34.1

