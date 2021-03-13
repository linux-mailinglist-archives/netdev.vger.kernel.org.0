Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13869339AC3
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhCMBQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:32 -0500
Received: from mga17.intel.com ([192.55.52.151]:1166 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhCMBQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:27 -0500
IronPort-SDR: gZBWiW8AOGIpdpQltAhm1CLg1L2ErqlaAxBYVSGhl2owwPCgaMT+r9ca4IZRZh38jg1a6aBwbE
 o11Snm/5Jhiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828239"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828239"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
IronPort-SDR: pIvwKad6fl+fbbMgBnbxx5OxamHPyABqah7JEUTBlPgOFqrkohsJd3BBHNL2LAVqmBru5QpAR/
 XThDOmHerY0g==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197367"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/11] mptcp: add rm_list in mptcp_out_options
Date:   Fri, 12 Mar 2021 17:16:11 -0800
Message-Id: <20210313011621.211661-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch defined a new struct mptcp_rm_list, the ids field was an
array of the removing address ids, the nr field was the valid number of
removing address ids in the array. The array size was definced as a new
macro MPTCP_RM_IDS_MAX. Changed the member rm_id of struct
mptcp_out_options to rm_list.

In mptcp_established_options_rm_addr, invoked mptcp_pm_rm_addr_signal to
get the rm_list. According the number of addresses in it, calculated
the padded RM_ADDR suboption length. And saved the ids array in struct
mptcp_out_options's rm_list member.

In mptcp_write_options, iterated each address id from struct
mptcp_out_options's rm_list member, set the invalid ones as TCPOPT_NOP,
then filled them into the RM_ADDR suboption.

Changed TCPOLEN_MPTCP_RM_ADDR_BASE from 4 to 3.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h  |  9 ++++++++-
 net/mptcp/options.c  | 35 +++++++++++++++++++++++++++--------
 net/mptcp/pm.c       |  5 +++--
 net/mptcp/protocol.h | 12 ++++++++++--
 4 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 5694370be3d4..cea69c801595 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -34,6 +34,13 @@ struct mptcp_ext {
 	/* one byte hole */
 };
 
+#define MPTCP_RM_IDS_MAX	8
+
+struct mptcp_rm_list {
+	u8 ids[MPTCP_RM_IDS_MAX];
+	u8 nr;
+};
+
 struct mptcp_out_options {
 #if IS_ENABLED(CONFIG_MPTCP)
 	u16 suboptions;
@@ -48,7 +55,7 @@ struct mptcp_out_options {
 	u8 addr_id;
 	u16 port;
 	u64 ahmac;
-	u8 rm_id;
+	struct mptcp_rm_list rm_list;
 	u8 join_id;
 	u8 backup;
 	u32 nonce;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 444a38681e93..e74d0513187f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -674,20 +674,25 @@ static bool mptcp_established_options_rm_addr(struct sock *sk,
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
-	u8 rm_id;
+	struct mptcp_rm_list rm_list;
+	int i, len;
 
 	if (!mptcp_pm_should_rm_signal(msk) ||
-	    !(mptcp_pm_rm_addr_signal(msk, remaining, &rm_id)))
+	    !(mptcp_pm_rm_addr_signal(msk, remaining, &rm_list)))
 		return false;
 
-	if (remaining < TCPOLEN_MPTCP_RM_ADDR_BASE)
+	len = mptcp_rm_addr_len(&rm_list);
+	if (len < 0)
+		return false;
+	if (remaining < len)
 		return false;
 
-	*size = TCPOLEN_MPTCP_RM_ADDR_BASE;
+	*size = len;
 	opts->suboptions |= OPTION_MPTCP_RM_ADDR;
-	opts->rm_id = rm_id;
+	opts->rm_list = rm_list;
 
-	pr_debug("rm_id=%d", opts->rm_id);
+	for (i = 0; i < opts->rm_list.nr; i++)
+		pr_debug("rm_list_ids[%d]=%d", i, opts->rm_list.ids[i]);
 
 	return true;
 }
@@ -1217,9 +1222,23 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 	}
 
 	if (OPTION_MPTCP_RM_ADDR & opts->suboptions) {
+		u8 i = 1;
+
 		*ptr++ = mptcp_option(MPTCPOPT_RM_ADDR,
-				      TCPOLEN_MPTCP_RM_ADDR_BASE,
-				      0, opts->rm_id);
+				      TCPOLEN_MPTCP_RM_ADDR_BASE + opts->rm_list.nr,
+				      0, opts->rm_list.ids[0]);
+
+		while (i < opts->rm_list.nr) {
+			u8 id1, id2, id3, id4;
+
+			id1 = opts->rm_list.ids[i];
+			id2 = i + 1 < opts->rm_list.nr ? opts->rm_list.ids[i + 1] : TCPOPT_NOP;
+			id3 = i + 2 < opts->rm_list.nr ? opts->rm_list.ids[i + 2] : TCPOPT_NOP;
+			id4 = i + 3 < opts->rm_list.nr ? opts->rm_list.ids[i + 3] : TCPOPT_NOP;
+			put_unaligned_be32(id1 << 24 | id2 << 16 | id3 << 8 | id4, ptr);
+			ptr += 1;
+			i += 4;
+		}
 	}
 
 	if (OPTION_MPTCP_PRIO & opts->suboptions) {
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 6fd4b2c1b076..0654c86cd5ff 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -258,7 +258,7 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 }
 
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			     u8 *rm_id)
+			     struct mptcp_rm_list *rm_list)
 {
 	int ret = false;
 
@@ -271,7 +271,8 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 	if (remaining < TCPOLEN_MPTCP_RM_ADDR_BASE)
 		goto out_unlock;
 
-	*rm_id = msk->pm.rm_id;
+	rm_list->ids[0] = msk->pm.rm_id;
+	rm_list->nr = 1;
 	WRITE_ONCE(msk->pm.addr_signal, 0);
 	ret = true;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e21a5bc36cf0..c896bcf3e70f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -61,7 +61,7 @@
 #define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	22
 #define TCPOLEN_MPTCP_PORT_LEN		2
 #define TCPOLEN_MPTCP_PORT_ALIGN	2
-#define TCPOLEN_MPTCP_RM_ADDR_BASE	4
+#define TCPOLEN_MPTCP_RM_ADDR_BASE	3
 #define TCPOLEN_MPTCP_PRIO		3
 #define TCPOLEN_MPTCP_PRIO_ALIGN	4
 #define TCPOLEN_MPTCP_FASTCLOSE		12
@@ -709,10 +709,18 @@ static inline unsigned int mptcp_add_addr_len(int family, bool echo, bool port)
 	return len;
 }
 
+static inline int mptcp_rm_addr_len(const struct mptcp_rm_list *rm_list)
+{
+	if (rm_list->nr == 0 || rm_list->nr > MPTCP_RM_IDS_MAX)
+		return -EINVAL;
+
+	return TCPOLEN_MPTCP_RM_ADDR_BASE + roundup(rm_list->nr - 1, 4) + 1;
+}
+
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			      struct mptcp_addr_info *saddr, bool *echo, bool *port);
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			     u8 *rm_id);
+			     struct mptcp_rm_list *rm_list);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 
 void __init mptcp_pm_nl_init(void);
-- 
2.30.2

