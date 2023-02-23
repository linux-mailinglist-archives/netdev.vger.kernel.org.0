Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E666A0090
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 02:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbjBWBXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 20:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjBWBXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 20:23:38 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B601627492
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 17:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677115415; x=1708651415;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jr5phxT7EozvU6n92vMmThHL9RkpJzTeLE5m6vgMV3E=;
  b=Sqr2VS1UvdP68maTW8yGXp53oaiuLqV8es5lMt/rqHULqIN1wph8zd5P
   /+8u+JauBPbBmI5Y5jrIcQN8FHhcveDuSZFx5hKjkRBbFxCBeLX58XFis
   JwD1nR+vZ2I5gvMUeG+drK0PcanhhBrJy1g8+N0CVHFTvpExkWXuq/RwN
   MDbHAd55Q6REcCrVjyvqI7MrP1aMw6oL6i0wq5gAJU2apblZIMXF6KnKb
   5GN/1yaH/RKti4uyT3jtKE3SQvN4ZL5TEbldBs3/RGxZcqn2JRF92z9jE
   6Lm3/2VbfPrRPytlgsWG28IpdXzDuJ8gVd87/6Stvp91MRS3TFMQpTYzH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="334453604"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="334453604"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 17:23:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="665560304"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="665560304"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.1])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 17:23:35 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net] net: add no-op for napi_busy_loop if CONFIG_NET_RX_BUSY_POLL=n
Date:   Wed, 22 Feb 2023 17:22:58 -0800
Message-Id: <20230223012258.1701175-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f83
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7db6b048da3b ("net: Commonize busy polling code to focus on napi_id
instead of socket") introduced napi_busy_loop and refactored sk_busy_loop
to call this new function. The commit removed the no-op implementation of
sk_busy_loop in the #else block for CONFIG_NET_RX_BUSY_POLL, and placed the
declaration of napi_busy_poll inside the # block where sk_busy_loop used to
be declared.

Because of this, if a module tries to use napi_busy_loop it must wrap the
use inside a IS_ENABLED(CONFIG_NET_RX_BUSY_POLL) check, as the function is
not declared when this is false.

The original sk_busy_loop function had both a declaration and a no-op
variant when the config flag was set to N. Do the same for napi_busy_loop
by adding a no-op implementation in the #else block as expected.

Fixes: 7db6b048da3b ("net: Commonize busy polling code to focus on napi_id instead of socket")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/net/busy_poll.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index f90f0021f5f2..8f84f6202f1c 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -58,6 +58,13 @@ static inline bool sk_can_busy_loop(struct sock *sk)
 	return false;
 }
 
+static inline void
+napi_busy_loop(unsigned int napi_id,
+	       bool (*loop_end)(void *, unsigned long),
+	       void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+{
+}
+
 #endif /* CONFIG_NET_RX_BUSY_POLL */
 
 static inline unsigned long busy_loop_current_time(void)

base-commit: 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2
-- 
2.39.1.405.gd4c25cc71f83

