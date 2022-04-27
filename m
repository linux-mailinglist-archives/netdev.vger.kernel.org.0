Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B985125F1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbiD0Wxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiD0Wx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:53:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2987F22F
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651099814; x=1682635814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nRkoJiY3YoNRchvFeRLPL3hyHfjEiXF7CewzQ6vUoUo=;
  b=P4HINOhhbkSdd/GS8Wvo1yxO8S4KVFcxN2845YTtLvanr/t7rfN1HBit
   zmIRGHwa400z+eAuSiclN21iFXe1YQaSqOtG9603XKxbJfRimr/d61vSQ
   2n3freX0fIbOWuO9FidNDZMH5Ih1nsU6TuWuzADsLEFxqwcLosZDg2Ak+
   7moQiqNhq9ZRxxrZK9Gop63jljAhG37/y3rHQfEoD7nv3KDY/Bc581CsQ
   2md2U9d7nEYQF2rP9o2HqP3uNE029wefONVcqcLqSBbTYE3xD5ReCX6RI
   gDs4w+dx0zculnnuH21PIumd+z6AP0hCk/mhwh1A/Ildays9yn30PaxLt
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="265907649"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="265907649"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="731049119"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.233.139])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:50:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Kishen Maloor <kishen.maloor@intel.com>
Subject: [PATCH net-next 3/6] mptcp: Bypass kernel PM when userspace PM is enabled
Date:   Wed, 27 Apr 2022 15:49:59 -0700
Message-Id: <20220427225002.231996-4-mathew.j.martineau@linux.intel.com>
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

When a MPTCP connection is managed by a userspace PM, bypass the kernel
PM for incoming advertisements and subflow events. Netlink events are
still sent to userspace.

v2: Remove unneeded check in mptcp_pm_rm_addr_received() (Kishen Maloor)
v3: Add and use helper function for PM mode (Paolo Abeni)

Acked-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       | 2 +-
 net/mptcp/protocol.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index f9f1bf4be95e..5320270b3926 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -208,7 +208,7 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 
 	spin_lock_bh(&pm->lock);
 
-	if (!READ_ONCE(pm->accept_addr)) {
+	if (!READ_ONCE(pm->accept_addr) || mptcp_pm_is_userspace(msk)) {
 		mptcp_pm_announce_addr(msk, addr, true);
 		mptcp_pm_add_addr_send_ack(msk);
 	} else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED)) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f65395f04f81..79606e9d3f2a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -805,6 +805,11 @@ static inline bool mptcp_pm_should_rm_signal(struct mptcp_sock *msk)
 	return READ_ONCE(msk->pm.addr_signal) & BIT(MPTCP_RM_ADDR_SIGNAL);
 }
 
+static inline bool mptcp_pm_is_userspace(const struct mptcp_sock *msk)
+{
+	return READ_ONCE(msk->pm.pm_type) == MPTCP_PM_TYPE_USERSPACE;
+}
+
 static inline unsigned int mptcp_add_addr_len(int family, bool echo, bool port)
 {
 	u8 len = TCPOLEN_MPTCP_ADD_ADDR_BASE;
-- 
2.36.0

