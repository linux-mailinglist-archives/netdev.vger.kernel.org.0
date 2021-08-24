Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8BA3F6C31
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhHXX1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:27:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:39250 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233252AbhHXX1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 19:27:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="217448929"
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="217448929"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 16:26:32 -0700
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="515847898"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.40.105])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 16:26:32 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, geliangtang@xiaomi.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/7] mptcp: shrink mptcp_out_options struct
Date:   Tue, 24 Aug 2021 16:26:14 -0700
Message-Id: <20210824232619.136912-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210824232619.136912-1-mathew.j.martineau@linux.intel.com>
References: <20210824232619.136912-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

After the previous patch we can alias with a union several
fields in mptcp_out_options. Such struct is stack allocated and
memset() for each plain TCP out packet. Every saved byted counts.

Before:
pahole -EC mptcp_out_options
 # ...
/* size: 136, cachelines: 3, members: 17 */

After:
pahole -EC mptcp_out_options
 # ...
/* size: 56, cachelines: 1, members: 9 */

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 8b5af683a818..3236010afa29 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -58,10 +58,6 @@ struct mptcp_addr_info {
 struct mptcp_out_options {
 #if IS_ENABLED(CONFIG_MPTCP)
 	u16 suboptions;
-	u64 sndr_key;
-	u64 rcvr_key;
-	u64 ahmac;
-	struct mptcp_addr_info addr;
 	struct mptcp_rm_list rm_list;
 	u8 join_id;
 	u8 backup;
@@ -69,11 +65,23 @@ struct mptcp_out_options {
 	   reset_transient:1,
 	   csum_reqd:1,
 	   allow_join_id0:1;
-	u32 nonce;
-	u64 thmac;
-	u32 token;
-	u8 hmac[20];
-	struct mptcp_ext ext_copy;
+	union {
+		struct {
+			u64 sndr_key;
+			u64 rcvr_key;
+		};
+		struct {
+			struct mptcp_addr_info addr;
+			u64 ahmac;
+		};
+		struct mptcp_ext ext_copy;
+		struct {
+			u32 nonce;
+			u32 token;
+			u64 thmac;
+			u8 hmac[20];
+		};
+	};
 #endif
 };
 
-- 
2.33.0

