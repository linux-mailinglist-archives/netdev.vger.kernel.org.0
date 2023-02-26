Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544406A304A
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjBZOsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjBZOsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:48:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C08313DF2;
        Sun, 26 Feb 2023 06:47:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63777B80BA8;
        Sun, 26 Feb 2023 14:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256ECC433EF;
        Sun, 26 Feb 2023 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422764;
        bh=lgMByjNARYrLIqZM9HrSpx05mNEpzqawg8FJtKZXzXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PALv+B1AQ+okM4UG0pimCNQIGW2fm53j2akL5zapEF4xbiuE1n8YNNdleF7wtRJ3z
         nhjH4UqtALPHtNPnIwf0qjAJ+ei0lLybHPZ6KERx63rVH7C27CZNK4Oh2uvHSfQlWc
         7dxt+8FQrBC+n6A7kQ7WSDg5gihTcmMoSSgQMgKV/V2h+LmsOVAyFBQFLHhWDg5165
         0FXpve77icv2RQxkmvnRdgTteobAvIgh8rZ8XvpQZpW7x0AHyvJYr8ICk9v3yvH1F+
         Ato1/KQQYBBVRu38NcEWFGvRJ9vfCIQ4z9c0TegjYrhBjiejAxzJaD8G5cF5WdC6eZ
         sHW8uhWXTAxyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Haley <haleyb.dev@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, corbet@lwn.net,
        den@openvz.org, razor@blackwall.org, ulf.hansson@linaro.org,
        Jason@zx2c4.com, wangyuweihx@gmail.com, daniel@iogearbox.net,
        thomas.zeitlhofer+lkml@ze-it.at, alexander@mihalicyn.com,
        ja@ssi.bg, netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 31/53] neighbor: fix proxy_delay usage when it is zero
Date:   Sun, 26 Feb 2023 09:44:23 -0500
Message-Id: <20230226144446.824580-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Haley <haleyb.dev@gmail.com>

[ Upstream commit 62e395f82d04510b0f86e5e603e29412be88596f ]

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
Link: https://lore.kernel.org/r/20230130171428.367111-1-haleyb.dev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst |  8 ++++++++
 net/core/neighbour.c                   | 14 ++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7fbd060d60470..f0bf509d2321b 100644
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
index 4edd2176e2385..6798f6d2423b9 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1674,11 +1674,21 @@ static void neigh_proxy_process(struct timer_list *t)
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
2.39.0

