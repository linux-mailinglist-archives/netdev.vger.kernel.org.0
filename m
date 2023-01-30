Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C24681763
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237445AbjA3RPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237510AbjA3RPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:15:05 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBD62BEE3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:15:03 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id bb40so3243553qtb.2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ROW0zLtUY9bhfzUZxzIFt9rWMfvaxC7EIUx1pQ5A+k8=;
        b=BSli/DStRa648tBaQtXNI6LT5QeUBzhTH+B0ffVqIXzjLq1PY7Wr2Y9OtX8q7PDxav
         kI2EJpqcjMEiFjLnRSYnFWQMyurPni4p8r4cy7UlDgktqpZM2RMFBu7SjceFrKll+QYv
         6VOkO31sVFc6D1R2YxWJqr8pC4+4IBY8ctRY/lH+FnmwuHZ3Pf4D7zac0ur0SDgCYsOc
         cFv61sU8vhCacWF/zL9HPVFn5hf+fTp4F8TJWafrEpo4MEX2mzi73YY4RNULEfQtb0t9
         oltHnqn42BgeDHfMVYpPIehaQIEs/faEWOPDkL178PZNNX30h3wzScoXPuX3uA5qOzEo
         FpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ROW0zLtUY9bhfzUZxzIFt9rWMfvaxC7EIUx1pQ5A+k8=;
        b=taav+w7xRwn/NTD6KHTA3YJXN41M9QZ1ZXWThuhOgs6gyZ0DVvEIskzuRp4p8rT165
         50+JIIq+pOkxKD8E1jl2ug54VLSbAvI3gBzWcm+TORbdX88Is8mohLHWSaPboLR/HEc/
         +iQb46AHYDWzjLeTNajv7Wb/ZHfRQwIP3iauzAgaub0e2lxwsiLxkyM4zLqF9Z6MS7qx
         PFvQNJcAey7VPRD+G3M9Q5TOYe//ftLkB9y6S61eZ2VaLWO8d9pAGCaxKq7ko9Gncy4X
         dxzQYpF65/758cN7Nyh5rzlv1ovzF1MkQ5+nOzRVm50FT6eVYWJSOWk3NtfdYXzqnrMk
         iEfw==
X-Gm-Message-State: AO0yUKX/cI4aGFtRVDvR3Hy559bXz70MjSGBV+Jt0GudgV+T4fOp7ejT
        BGsGo1skBlTM06rtREeVPT0=
X-Google-Smtp-Source: AK7set+YoAgtpwQux/kIOa3aCD9kinWpJP/e4dtnxHG0+K0uLJyySNJRSaKNxLLCgP/l4DAY1B6RKQ==
X-Received: by 2002:ac8:5c85:0:b0:3b8:6b96:de6d with SMTP id r5-20020ac85c85000000b003b86b96de6dmr6192725qta.18.1675098902313;
        Mon, 30 Jan 2023 09:15:02 -0800 (PST)
Received: from localhost.localdomain ([2601:18f:700:287c::1006])
        by smtp.gmail.com with ESMTPSA id bs18-20020ac86f12000000b003b8558eabd0sm3863289qtb.23.2023.01.30.09.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 09:15:01 -0800 (PST)
From:   Brian Haley <haleyb.dev@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v3] neighbor: fix proxy_delay usage when it is zero
Date:   Mon, 30 Jan 2023 12:14:28 -0500
Message-Id: <20230130171428.367111-1-haleyb.dev@gmail.com>
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
[0, U32_MAX). Looking at this comment from
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
 Documentation/networking/ip-sysctl.rst |  8 ++++++++
 net/core/neighbour.c                   | 14 ++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7fbd060d6047..58f74051e07b 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1589,6 +1589,14 @@ proxy_arp_pvlan - BOOLEAN
 	  Hewlett-Packard call it Source-Port filtering or port-isolation.
 	  Ericsson call it MAC-Forced Forwarding (RFC Draft).
 
+proxy_delay - INTEGER
+	Delay proxy response.
+
+	Delay response to a neighbor solicitation when proxy_arp
+	or proxy_ndp is enabled. A random value between [0, proxy_delay)
+	will be chosen, setting to zero means reply with no delay.
+	Value in jiffies. Defaults to 80.
+
 shared_media - BOOLEAN
 	Send(router) or accept(host) RFC1620 shared media redirects.
 	Overrides secure_redirects.
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f00a79fc301b..57258110bccd 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1662,11 +1662,21 @@ static void neigh_proxy_process(struct timer_list *t)
 	spin_unlock(&tbl->proxy_queue.lock);
 }
 
+static unsigned long neigh_proxy_delay(struct neigh_parms *p)
+{
+	/* If proxy_delay is zero, do not call get_random_u32_below()
+	 * as it is undefined behavior.
+	 */
+	unsigned long proxy_delay = NEIGH_VAR(p, PROXY_DELAY);
+
+	return proxy_delay ?
+	       jiffies + get_random_u32_below(proxy_delay) : jiffies;
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

