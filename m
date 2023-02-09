Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C946909B3
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjBINRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBINRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:17:14 -0500
X-Greylist: delayed 607 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Feb 2023 05:16:45 PST
Received: from tretyak2.mcst.ru (tretyak2.mcst.ru [212.5.119.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA37126A1;
        Thu,  9 Feb 2023 05:16:45 -0800 (PST)
Received: from tretyak2.mcst.ru (localhost [127.0.0.1])
        by tretyak2.mcst.ru (Postfix) with ESMTP id BE1B5102394;
        Thu,  9 Feb 2023 16:00:23 +0300 (MSK)
Received: from frog.lab.sun.mcst.ru (frog.lab.sun.mcst.ru [172.16.4.50])
        by tretyak2.mcst.ru (Postfix) with ESMTP id B94F4102391;
        Thu,  9 Feb 2023 15:59:43 +0300 (MSK)
Received: from artemiev-i.lab.sun.mcst.ru (avior-1 [192.168.53.223])
        by frog.lab.sun.mcst.ru (8.13.4/8.12.11) with ESMTP id 319CxRk4001195;
        Thu, 9 Feb 2023 15:59:36 +0300
From:   Igor Artemiev <Igor.A.Artemiev@mcst.ru>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [lvc-project] [PATCH] netfilter: xt_recent: Fix attempt to update removed entry
Date:   Thu,  9 Feb 2023 15:58:31 +0300
Message-Id: <20230209125831.2674811-1-Igor.A.Artemiev@mcst.ru>
X-Mailer: git-send-email 2.39.0.152.ga5737674b6
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.39/RELEASE,
         bases: 20111107 #2745587, check: 20230209 notchecked
X-AV-Checked: ClamAV using ClamSMTP
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When both --remove and --update flag are specified, there's a code
path at which the entry to be updated is removed beforehand,
that leads to kernel crash. Update entry, if --remove flag
don't specified.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Fixes: 404bdbfd242c ("[NETFILTER]: recent match: replace by rewritten version")
---
 net/netfilter/xt_recent.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 7ddb9a78e3fc..189a413aa9d8 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -315,7 +315,8 @@ recent_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	if (info->check_set & XT_RECENT_SET ||
-	    (info->check_set & XT_RECENT_UPDATE && ret)) {
+	    (info->check_set & XT_RECENT_UPDATE && ret &&
+	     !(info->check_set & XT_RECENT_REMOVE))) {
 		recent_entry_update(t, e);
 		e->ttl = ttl;
 	}
-- 
2.30.2

