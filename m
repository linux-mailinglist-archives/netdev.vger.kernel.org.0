Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6C251789B
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 22:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387525AbiEBU4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 16:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiEBU4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 16:56:14 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35736584
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 13:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651524764; x=1683060764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ZNXtLvhcp5bF7tlcfkg+UESgvpjmFh340RfFxsO+X8=;
  b=Tt0q9U/QaRfm9cqMMFjsuGYGwI9XkmGbg22jZ5bVUXrcqfnyqzJcOprq
   xWPHT8wcfM6dO3AUcJNX317XGWIBDnBiKfne4ye72b6o+bI3v/rnIPNUO
   ZxJQPu0ahPlHEj+pZKMCaOOgWAJstb5aAchikcRFbD1+hisJ61MLuEHjy
   d051OyVi6dVEtCoOW/GXJuN8g0fcDs/3l47H1xAnh6NqB1FQKa9xA8S9K
   LbIQNFpG0n9YQbFjqjZ2l2sjpz8Ht3lf+s7502Nyiud8JaovL78V2nW5f
   +FkRHSQZB18u43odY4tHx7828J4b96gXGbN74NGL2LoGc2ndb1XEuvztI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="254785531"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="254785531"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="733619592"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.141.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:44 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/7] mptcp: allow ADD_ADDR reissuance by userspace PMs
Date:   Mon,  2 May 2022 13:52:37 -0700
Message-Id: <20220502205237.129297-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
References: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

This change allows userspace PM implementations to reissue ADD_ADDR
announcements (if necessary) based on their chosen policy.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index a4430c576ce9..98b205c2c101 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -369,8 +369,16 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 
 	lockdep_assert_held(&msk->pm.lock);
 
-	if (mptcp_lookup_anno_list_by_saddr(msk, &entry->addr))
-		return false;
+	add_entry = mptcp_lookup_anno_list_by_saddr(msk, &entry->addr);
+
+	if (add_entry) {
+		if (mptcp_pm_is_kernel(msk))
+			return false;
+
+		sk_reset_timer(sk, &add_entry->add_timer,
+			       jiffies + mptcp_get_add_addr_timeout(net));
+		return true;
+	}
 
 	add_entry = kmalloc(sizeof(*add_entry), GFP_ATOMIC);
 	if (!add_entry)
-- 
2.36.0

