Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5AC16AB5F
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgBXQ20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:28:26 -0500
Received: from gateway32.websitewelcome.com ([192.185.145.170]:28263 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727299AbgBXQ2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:28:25 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id BF791EF6C6
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 10:27:36 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6Ga0jY5oYRP4z6Ga0jxHDi; Mon, 24 Feb 2020 10:27:36 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eERgKM5oKr/xria19xzaa6uu8WoxY0LDppBY2y6tpC8=; b=DIhFa3aj1agmdLvg3GKSIuWGLQ
        vfKBppUp97ltm4HaDnPO4t6nNeRHQP9eTEOgKE6cwe8GDHkCyq9B+dYw68FsKKhwLSO/mhpafNgDl
        R+1BG75FdOkOLxJopW7HN3ManworJDdfNxZzj5uDpWMYZcWc43/2hpinEVXghbAnytVvcRsGSzRB4
        KmtnM6ToGqXMtZJSGPDnDl0JpjnwWdCwF7w9/IKfh1ZWcyiI4jvOQ+8sBhhwfZEorpTYHPkgL2P9p
        jmgTQRyTQroFN9Ge7+2sRVl+tswIZEAZgBZd21d+tRYpEYTQFIXfSsy26lutEw+4yeBdxnhziRKAj
        9N33kbhQ==;
Received: from [200.68.140.135] (port=22740 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6GZy-002myu-V2; Mon, 24 Feb 2020 10:27:35 -0600
Date:   Mon, 24 Feb 2020 10:30:24 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] chelsio: Replace zero-length array with
 flexible-array member
Message-ID: <20200224163024.GA27867@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.135
X-Source-L: No
X-Exim-ID: 1j6GZy-002myu-V2
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.135]:22740
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 39
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_ioctl.h        | 2 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_cpl.h             | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h           | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h       | 8 ++++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c      | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h      | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/sched.h              | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/smt.h                | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h             | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h           | 2 +-
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h      | 4 ++--
 13 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_ioctl.h b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_ioctl.h
index b19e4376ba76..401827b82aa1 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_ioctl.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_ioctl.h
@@ -79,7 +79,7 @@ struct ch_mem_range {
 	uint32_t addr;
 	uint32_t len;
 	uint32_t version;
-	uint8_t buf[0];
+	uint8_t buf[];
 };
 
 struct ch_qset_params {
diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_cpl.h b/drivers/net/ethernet/chelsio/cxgb3/t3_cpl.h
index 852c399a8b0a..68bb5f39f3f1 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_cpl.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_cpl.h
@@ -1448,7 +1448,7 @@ struct cpl_rdma_terminate {
 #endif
 	__be32 msn;
 	__be32 mo;
-	__u8 data[0];
+	__u8 data[];
 };
 
 /* cpl_rdma_terminate.tid_len fields */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h
index a0e0ae19649f..290c1058069a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h
@@ -29,7 +29,7 @@ struct clip_tbl {
 	atomic_t nfree;
 	struct list_head ce_free_head;
 	void *cl_list;
-	struct list_head hash_list[0];
+	struct list_head hash_list[];
 };
 
 enum {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
index f5be3ee1bdb4..dcab94cc2dee 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
@@ -82,7 +82,7 @@ struct cudbg_ulprx_la {
 struct cudbg_tp_la {
 	u32 size;
 	u32 mode;
-	u8 data[0];
+	u8 data[];
 };
 
 static const char * const cudbg_region[] = {
@@ -134,7 +134,7 @@ struct cudbg_meminfo {
 
 struct cudbg_cim_pif_la {
 	int size;
-	u8 data[0];
+	u8 data[];
 };
 
 struct cudbg_clk_info {
@@ -339,13 +339,13 @@ struct cudbg_qdesc_entry {
 	u32 qid;
 	u32 desc_size;
 	u32 num_desc;
-	u8 data[0]; /* Must be last */
+	u8 data[]; /* Must be last */
 };
 
 struct cudbg_qdesc_info {
 	u32 qdesc_entry_size;
 	u32 num_queues;
-	u8 data[0]; /* Must be last */
+	u8 data[]; /* Must be last */
 };
 
 #define IREG_NUM_ELEM 4
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index de30d61af065..fe883cb1a7af 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -984,7 +984,7 @@ static const char * const devlog_facility_strings[] = {
 struct devlog_info {
 	unsigned int nentries;		/* number of entries in log[] */
 	unsigned int first;		/* first [temporal] entry in log[] */
-	struct fw_devlog_e log[0];	/* Firmware Device Log */
+	struct fw_devlog_e log[];	/* Firmware Device Log */
 };
 
 /* Dump a Firmaware Device Log entry.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h
index ba95e13d52da..1471cf0deb58 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h
@@ -49,7 +49,7 @@ struct seq_tab {
 	unsigned int rows;        /* # of entries */
 	unsigned char width;      /* size in bytes of each entry */
 	unsigned char skip_first; /* whether the first line is a header */
-	char data[0];             /* the table data */
+	char data[];             /* the table data */
 };
 
 static inline unsigned int hex2val(char c)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h
index a4b99edcc339..125868c6770a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h
@@ -289,6 +289,6 @@ struct cxgb4_link {
 
 struct cxgb4_tc_u32_table {
 	unsigned int size;          /* number of entries in table */
-	struct cxgb4_link table[0]; /* Jump table */
+	struct cxgb4_link table[]; /* Jump table */
 };
 #endif /* __CXGB4_TC_U32_PARSE_H */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index 1a16449e9deb..12c3354172cd 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -59,7 +59,7 @@ struct l2t_data {
 	rwlock_t lock;
 	atomic_t nfree;             /* number of free entries */
 	struct l2t_entry *rover;    /* starting point for next allocation */
-	struct l2t_entry l2tab[0];  /* MUST BE LAST */
+	struct l2t_entry l2tab[];  /* MUST BE LAST */
 };
 
 static inline unsigned int vlan_prio(const struct l2t_entry *e)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.h b/drivers/net/ethernet/chelsio/cxgb4/sched.h
index 5cc74a5a1774..5f8b871d79af 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.h
@@ -82,7 +82,7 @@ struct sched_class {
 
 struct sched_table {      /* per port scheduling table */
 	u8 sched_size;
-	struct sched_class tab[0];
+	struct sched_class tab[];
 };
 
 static inline bool can_sched(struct net_device *dev)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.h b/drivers/net/ethernet/chelsio/cxgb4/smt.h
index 1268d6e93a47..541249d78914 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.h
@@ -66,7 +66,7 @@ struct smt_entry {
 struct smt_data {
 	unsigned int smt_size;
 	rwlock_t lock;
-	struct smt_entry smtab[0];
+	struct smt_entry smtab[];
 };
 
 struct smt_data *t4_init_smt(void);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index 575c6abcdae7..7d874f03d6c5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -1511,7 +1511,7 @@ struct ulptx_sgl {
 	__be32 cmd_nsge;
 	__be32 len0;
 	__be64 addr0;
-	struct ulptx_sge_pair sge[0];
+	struct ulptx_sge_pair sge[];
 };
 
 struct ulptx_idata {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index accad1101ad1..703effc00a05 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -737,7 +737,7 @@ struct fw_flowc_mnemval {
 struct fw_flowc_wr {
 	__be32 op_to_nparams;
 	__be32 flowid_len16;
-	struct fw_flowc_mnemval mnemval[0];
+	struct fw_flowc_mnemval mnemval[];
 };
 
 #define FW_FLOWC_WR_NPARAMS_S           0
diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h
index 7b02c200dd1e..1b4156461ba1 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h
@@ -122,7 +122,7 @@ struct cxgbi_ppm_pool {
 	unsigned int base;		/* base index */
 	unsigned int next;		/* next possible free index */
 	spinlock_t lock;		/* ppm pool lock */
-	unsigned long bmap[0];
+	unsigned long bmap[];
 } ____cacheline_aligned_in_smp;
 
 struct cxgbi_ppm {
@@ -145,7 +145,7 @@ struct cxgbi_ppm {
 	unsigned int next;
 	unsigned int max_index_in_edram;
 	unsigned long *ppod_bmap;
-	struct cxgbi_ppod_data ppod_data[0];
+	struct cxgbi_ppod_data ppod_data[];
 };
 
 #define DDP_THRESHOLD		512
-- 
2.25.0

