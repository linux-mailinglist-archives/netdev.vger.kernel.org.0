Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5B251258C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbiD0Wx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiD0WxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:53:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6F67EA34
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651099813; x=1682635813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CNRuKBjmjxVENqUvRRSu2j5me55152i5hjFEZKIzhrg=;
  b=gNkrCdnayeOhdTD3p17Uft3oE5tVbrNHXODqi3pu0tgKIGyQej7Uhc8I
   S856IZ1QbcplLLTBctJ34Zd3ZK5X2281FV6+O+AlGVEhbUuBxGHjC5Lmp
   VV/KiOgWebjFpY9Z7Cim5gy+/WtWbmBBUHlEEsNCmD+hnqyYfrHL2fUwT
   ni/URbZVga6bd1xiQsG9U9sI2f3kpDYJM6VeXxgLupbFl1mkGRp0johq5
   xu5fLWvcZJAJbJ0KwMnKNKBSOSc2AZ6xW4OnkmHOZErFWbfgONqvv+Iqt
   D53j1EpXoTJZ7NVMHGsxOsQBX9lnoZWWsZS5N/NuDmIS3TLC1ElxKDwQT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="265907647"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="265907647"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="731049116"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.233.139])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 2/6] mptcp: Add a member to mptcp_pm_data to track kernel vs userspace mode
Date:   Wed, 27 Apr 2022 15:49:58 -0700
Message-Id: <20220427225002.231996-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427225002.231996-1-mathew.j.martineau@linux.intel.com>
References: <20220427225002.231996-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding support for netlink path management commands, the kernel
needs to know whether paths are being controlled by the in-kernel path
manager or a userspace PM.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       | 4 ++++
 net/mptcp/protocol.h | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 4de90e618be3..f9f1bf4be95e 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -424,6 +424,10 @@ void mptcp_pm_data_reset(struct mptcp_sock *msk)
 	pm->subflows = 0;
 	pm->rm_list_tx.nr = 0;
 	pm->rm_list_rx.nr = 0;
+	WRITE_ONCE(pm->pm_type, MPTCP_PM_TYPE_KERNEL);
+	/* pm->work_pending must be only be set to 'true' when
+	 * pm->pm_type is set to MPTCP_PM_TYPE_KERNEL
+	 */
 	WRITE_ONCE(pm->work_pending,
 		   (!!mptcp_pm_get_local_addr_max(msk) && subflows_allowed) ||
 		   !!mptcp_pm_get_add_addr_signal_max(msk));
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0316605de559..f65395f04f81 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -184,6 +184,14 @@ enum mptcp_pm_status {
 					 */
 };
 
+enum mptcp_pm_type {
+	MPTCP_PM_TYPE_KERNEL = 0,
+	MPTCP_PM_TYPE_USERSPACE,
+
+	__MPTCP_PM_TYPE_NR,
+	__MPTCP_PM_TYPE_MAX = __MPTCP_PM_TYPE_NR - 1,
+};
+
 /* Status bits below MPTCP_PM_ALREADY_ESTABLISHED need pm worker actions */
 #define MPTCP_PM_WORK_MASK ((1 << MPTCP_PM_ALREADY_ESTABLISHED) - 1)
 
@@ -212,6 +220,7 @@ struct mptcp_pm_data {
 	u8		add_addr_signaled;
 	u8		add_addr_accepted;
 	u8		local_addr_used;
+	u8		pm_type;
 	u8		subflows;
 	u8		status;
 	DECLARE_BITMAP(id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
-- 
2.36.0

