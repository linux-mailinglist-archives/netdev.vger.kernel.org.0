Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA1E570A7E
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiGKTQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiGKTQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:16:40 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184F157261
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 12:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657567000; x=1689103000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=joQ6Vbeab6laBXOOHJaDUI2swEi5kjt7lAQTHBmWF1s=;
  b=hACmbz3mWI5m19nYe4J98QqRZZMSpLCbiGCsitArfug04xOjZ7rR4dA7
   G3wPQLAIaKgInVZn4LW/HVoMjEyWmL27HdQLOWMJmS80NXL9Mf9yAFbHY
   ja3aSxOTpeg4YQTq241rHulHpvuphLppdpnWgNk+8ku4BwKflXLxXs4il
   kAiQuzCFRhpQ/PMKtyJPonwCmS50G/QebHBqBmziHmTIcUn1/26t3F1TU
   qhFvCZdu/KMH6hNBsMjkrc3Vkhuy3XJ1fvWShPRgIbY86q096s0QUlkoP
   rNG2C7kY8HdpCyTyBHPky+Bhrsn130reu7qjWDSORwWa3VUOL7v0+XNKR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="282300981"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="282300981"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="697742712"
Received: from eedeets-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.2.111])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 12:16:38 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/5] mptcp: address lookup improvements
Date:   Mon, 11 Jul 2022 12:16:30 -0700
Message-Id: <20220711191633.80826-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711191633.80826-1-mathew.j.martineau@linux.intel.com>
References: <20220711191633.80826-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

When looking-up a socket address in the endpoint list, we
must prefer port-based matches over address only match.

Ensure that port-based endpoints are listed first, using
head insertion for them. Additionally be sure that only
port-based endpoints carry a non zero port number.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 8e1d3aec94da..fe8e22aff7d2 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -413,7 +413,7 @@ static bool lookup_address_in_vec(const struct mptcp_addr_info *addrs, unsigned
 	int i;
 
 	for (i = 0; i < nr; i++) {
-		if (mptcp_addresses_equal(&addrs[i], addr, addr->port))
+		if (addrs[i].id == addr->id)
 			return true;
 	}
 
@@ -449,7 +449,8 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
 		mptcp_for_each_subflow(msk, subflow) {
 			ssk = mptcp_subflow_tcp_sock(subflow);
 			remote_address((struct sock_common *)ssk, &addrs[i]);
-			if (deny_id0 && mptcp_addresses_equal(&addrs[i], &remote, false))
+			addrs[i].id = subflow->remote_id;
+			if (deny_id0 && !addrs[i].id)
 				continue;
 
 			if (!lookup_address_in_vec(addrs, i, &addrs[i]) &&
@@ -919,10 +920,11 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	/* do not insert duplicate address, differentiate on port only
 	 * singled addresses
 	 */
+	if (!address_use_port(entry))
+		entry->addr.port = 0;
 	list_for_each_entry(cur, &pernet->local_addr_list, list) {
 		if (mptcp_addresses_equal(&cur->addr, &entry->addr,
-					  address_use_port(entry) &&
-					  address_use_port(cur))) {
+					  cur->addr.port || entry->addr.port)) {
 			/* allow replacing the exiting endpoint only if such
 			 * endpoint is an implicit one and the user-space
 			 * did not provide an endpoint id
@@ -968,7 +970,10 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	}
 
 	pernet->addrs++;
-	list_add_tail_rcu(&entry->list, &pernet->local_addr_list);
+	if (!entry->addr.port)
+		list_add_tail_rcu(&entry->list, &pernet->local_addr_list);
+	else
+		list_add_rcu(&entry->list, &pernet->local_addr_list);
 	ret = entry->addr.id;
 
 out:
-- 
2.37.0

