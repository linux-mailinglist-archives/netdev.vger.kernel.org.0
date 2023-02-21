Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958E469DB90
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 08:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbjBUH4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 02:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbjBUH4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 02:56:45 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0864B1DBB8;
        Mon, 20 Feb 2023 23:56:40 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VcBSN6y_1676966196;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VcBSN6y_1676966196)
          by smtp.aliyun-inc.com;
          Tue, 21 Feb 2023 15:56:36 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/2] net/smc: Introduce BPF injection capability for SMC
Date:   Tue, 21 Feb 2023 15:56:30 +0800
Message-Id: <1676966191-47736-2-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1676966191-47736-1-git-send-email-alibuda@linux.alibaba.com>
References: <1676966191-47736-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This PATCH attempts to introduce BPF injection capability for SMC.
As we all know that the SMC protocol is not suitable for all scenarios,
especially for short-lived. However, for most applications, they cannot
guarantee that there are no such scenarios at all. Therefore, apps
may need some specific strategies to decide shall we need to use SMC
or not, for example, apps can limit the scope of the SMC to a specific
IP address or port.

Based on the consideration of transparent replacement, we hope that apps
can remain transparent even if they need to formulate some specific
strategies for SMC using. That is, do not need to recompile their code.

On the other hand, we need to ensure the scalability of strategies
implementation. Although it is simple to use socket options or sysctl,
it will bring more complexity to subsequent expansion.

Fortunately, BPF can solve these concerns very well, users can write
thire own strategies in eBPF to choose whether to use SMC or not.
And it's quite easy for them to modify their strategies in the future.

This PATCH implement injection capability for SMC via struct_ops.
In that way, we can add new injection scenarios in the future.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 include/linux/btf_ids.h           |  15 +++
 include/net/smc.h                 | 254 ++++++++++++++++++++++++++++++++++++++
 kernel/bpf/bpf_struct_ops_types.h |   4 +
 net/Makefile                      |   5 +
 net/smc/af_smc.c                  |  10 +-
 net/smc/bpf_smc_struct_ops.c      | 146 ++++++++++++++++++++++
 net/smc/smc.h                     | 220 ---------------------------------
 7 files changed, 433 insertions(+), 221 deletions(-)
 create mode 100644 net/smc/bpf_smc_struct_ops.c

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 3a4f7cd..25eab1e 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -264,6 +264,21 @@ enum {
 MAX_BTF_TRACING_TYPE,
 };
 
+#if IS_ENABLED(CONFIG_SMC)
+#define BTF_SMC_TYPE_xxx		\
+	BTF_SMC_TYPE(BTF_SMC_TYPE_SOCK, smc_sock)		\
+	BTF_SMC_TYPE(BTF_SMC_TYPE_CONNECTION, smc_connection)	\
+	BTF_SMC_TYPE(BTF_SMC_TYPE_HOST_CURSOR, smc_host_cursor)
+
+enum {
+#define BTF_SMC_TYPE(name, type) name,
+BTF_SMC_TYPE_xxx
+#undef BTF_SMC_TYPE
+MAX_BTF_SMC_TYPE,
+};
+extern u32 btf_smc_ids[];
+#endif
+
 extern u32 btf_tracing_ids[];
 extern u32 bpf_cgroup_btf_id[];
 extern u32 bpf_local_storage_map_btf_id[];
diff --git a/include/net/smc.h b/include/net/smc.h
index 597cb93..912c269 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -11,13 +11,16 @@
 #ifndef _SMC_H
 #define _SMC_H
 
+#include <net/inet_connection_sock.h>
 #include <linux/device.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/bpf.h>
 #include "linux/ism.h"
 
 struct sock;
+struct smc_diag_conninfo;
 
 #define SMC_MAX_PNETID_LEN	16	/* Max. length of PNET id */
 
@@ -90,4 +93,255 @@ struct smcd_dev {
 	u8 going_away : 1;
 };
 
+#if IS_ENABLED(CONFIG_SMC)
+
+struct smc_wr_rx_hdr {	/* common prefix part of LLC and CDC to demultiplex */
+	union {
+		u8 type;
+#if defined(__BIG_ENDIAN_BITFIELD)
+		struct {
+			u8 llc_version:4,
+			   llc_type:4;
+		};
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		struct {
+			u8 llc_type:4,
+			   llc_version:4;
+		};
+#endif
+	};
+} __aligned(1);
+
+struct smc_cdc_conn_state_flags {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8	peer_done_writing : 1;	/* Sending done indicator */
+	u8	peer_conn_closed : 1;	/* Peer connection closed indicator */
+	u8	peer_conn_abort : 1;	/* Abnormal close indicator */
+	u8	reserved : 5;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8	reserved : 5;
+	u8	peer_conn_abort : 1;
+	u8	peer_conn_closed : 1;
+	u8	peer_done_writing : 1;
+#endif
+};
+
+struct smc_cdc_producer_flags {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8	write_blocked : 1;	/* Writing Blocked, no rx buf space */
+	u8	urg_data_pending : 1;	/* Urgent Data Pending */
+	u8	urg_data_present : 1;	/* Urgent Data Present */
+	u8	cons_curs_upd_req : 1;	/* cursor update requested */
+	u8	failover_validation : 1;/* message replay due to failover */
+	u8	reserved : 3;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8	reserved : 3;
+	u8	failover_validation : 1;
+	u8	cons_curs_upd_req : 1;
+	u8	urg_data_present : 1;
+	u8	urg_data_pending : 1;
+	u8	write_blocked : 1;
+#endif
+};
+
+enum smc_urg_state {
+	SMC_URG_VALID	= 1,			/* data present */
+	SMC_URG_NOTYET	= 2,			/* data pending */
+	SMC_URG_READ	= 3,			/* data was already read */
+};
+
+/* in host byte order */
+union smc_host_cursor {	/* SMC cursor - an offset in an RMBE */
+	struct {
+		u16	reserved;
+		u16	wrap;		/* window wrap sequence number */
+		u32	count;		/* cursor (= offset) part */
+	};
+#ifdef ATOMIC64_INIT
+	atomic64_t		acurs;	/* for atomic processing */
+#else
+	u64			acurs;	/* for atomic processing */
+#endif
+} __aligned(8);
+
+/* in host byte order, except for flag bitfields in network byte order */
+struct smc_host_cdc_msg {		/* Connection Data Control message */
+	struct smc_wr_rx_hdr		common; /* .type = 0xFE */
+	u8				len;	/* length = 44 */
+	u16				seqno;	/* connection seq # */
+	u32				token;	/* alert_token */
+	union smc_host_cursor		prod;		/* producer cursor */
+	union smc_host_cursor		cons;		/* consumer cursor,
+							 * piggy backed "ack"
+							 */
+	struct smc_cdc_producer_flags	prod_flags;	/* conn. tx/rx status */
+	struct smc_cdc_conn_state_flags	conn_state_flags; /* peer conn. status*/
+	u8				reserved[18];
+} __aligned(8);
+
+struct smc_connection {
+	struct rb_node		alert_node;
+	struct smc_link_group	*lgr;		/* link group of connection */
+	struct smc_link		*lnk;		/* assigned SMC-R link */
+	u32			alert_token_local; /* unique conn. id */
+	u8			peer_rmbe_idx;	/* from tcp handshake */
+	int			peer_rmbe_size;	/* size of peer rx buffer */
+	atomic_t		peer_rmbe_space;/* remaining free bytes in peer
+						 * rmbe
+						 */
+	int			rtoken_idx;	/* idx to peer RMB rkey/addr */
+
+	struct smc_buf_desc	*sndbuf_desc;	/* send buffer descriptor */
+	struct smc_buf_desc	*rmb_desc;	/* RMBE descriptor */
+	int			rmbe_size_short;/* compressed notation */
+	int			rmbe_update_limit;
+						/* lower limit for consumer
+						 * cursor update
+						 */
+
+	struct smc_host_cdc_msg	local_tx_ctrl;	/* host byte order staging
+						 * buffer for CDC msg send
+						 * .prod cf. TCP snd_nxt
+						 * .cons cf. TCP sends ack
+						 */
+	union smc_host_cursor	local_tx_ctrl_fin;
+						/* prod crsr - confirmed by peer
+						 */
+	union smc_host_cursor	tx_curs_prep;	/* tx - prepared data
+						 * snd_max..wmem_alloc
+						 */
+	union smc_host_cursor	tx_curs_sent;	/* tx - sent data
+						 * snd_nxt ?
+						 */
+	union smc_host_cursor	tx_curs_fin;	/* tx - confirmed by peer
+						 * snd-wnd-begin ?
+						 */
+	atomic_t		sndbuf_space;	/* remaining space in sndbuf */
+	u16			tx_cdc_seq;	/* sequence # for CDC send */
+	u16			tx_cdc_seq_fin;	/* sequence # - tx completed */
+	spinlock_t		send_lock;	/* protect wr_sends */
+	atomic_t		cdc_pend_tx_wr; /* number of pending tx CDC wqe
+						 * - inc when post wqe,
+						 * - dec on polled tx cqe
+						 */
+	wait_queue_head_t	cdc_pend_tx_wq; /* wakeup on no cdc_pend_tx_wr*/
+	atomic_t		tx_pushing;     /* nr_threads trying tx push */
+	struct delayed_work	tx_work;	/* retry of smc_cdc_msg_send */
+	u32			tx_off;		/* base offset in peer rmb */
+
+	struct smc_host_cdc_msg	local_rx_ctrl;	/* filled during event_handl.
+						 * .prod cf. TCP rcv_nxt
+						 * .cons cf. TCP snd_una
+						 */
+	union smc_host_cursor	rx_curs_confirmed; /* confirmed to peer
+						    * source of snd_una ?
+						    */
+	union smc_host_cursor	urg_curs;	/* points at urgent byte */
+	enum smc_urg_state	urg_state;
+	bool			urg_tx_pend;	/* urgent data staged */
+	bool			urg_rx_skip_pend;
+						/* indicate urgent oob data
+						 * read, but previous regular
+						 * data still pending
+						 */
+	char			urg_rx_byte;	/* urgent byte */
+	bool			tx_in_release_sock;
+						/* flush pending tx data in
+						 * sock release_cb()
+						 */
+	atomic_t		bytes_to_rcv;	/* arrived data,
+						 * not yet received
+						 */
+	atomic_t		splice_pending;	/* number of spliced bytes
+						 * pending processing
+						 */
+#ifndef KERNEL_HAS_ATOMIC64
+	spinlock_t		acurs_lock;	/* protect cursors */
+#endif
+	struct work_struct	close_work;	/* peer sent some closing */
+	struct work_struct	abort_work;	/* abort the connection */
+	struct tasklet_struct	rx_tsklet;	/* Receiver tasklet for SMC-D */
+	u8			rx_off;		/* receive offset:
+						 * 0 for SMC-R, 32 for SMC-D
+						 */
+	u64			peer_token;	/* SMC-D token of peer */
+	u8			killed : 1;	/* abnormal termination */
+	u8			freed : 1;	/* normal termiation */
+	u8			out_of_sync : 1; /* out of sync with peer */
+};
+
+struct smc_sock {				/* smc sock container */
+	struct sock		sk;
+	struct socket		*clcsock;	/* internal tcp socket */
+	void			(*clcsk_state_change)(struct sock *sk);
+						/* original stat_change fct. */
+	void			(*clcsk_data_ready)(struct sock *sk);
+						/* original data_ready fct. */
+	void			(*clcsk_write_space)(struct sock *sk);
+						/* original write_space fct. */
+	void			(*clcsk_error_report)(struct sock *sk);
+						/* original error_report fct. */
+	struct smc_connection	conn;		/* smc connection */
+	struct smc_sock		*listen_smc;	/* listen parent */
+	struct work_struct	connect_work;	/* handle non-blocking connect*/
+	struct work_struct	tcp_listen_work;/* handle tcp socket accepts */
+	struct work_struct	smc_listen_work;/* prepare new accept socket */
+	struct list_head	accept_q;	/* sockets to be accepted */
+	spinlock_t		accept_q_lock;	/* protects accept_q */
+	bool			limit_smc_hs;	/* put constraint on handshake */
+	bool			use_fallback;	/* fallback to tcp */
+	int			fallback_rsn;	/* reason for fallback */
+	u32			peer_diagnosis; /* decline reason from peer */
+	atomic_t                queued_smc_hs;  /* queued smc handshakes */
+	struct inet_connection_sock_af_ops		af_ops;
+	const struct inet_connection_sock_af_ops	*ori_af_ops;
+						/* original af ops */
+	int			sockopt_defer_accept;
+						/* sockopt TCP_DEFER_ACCEPT
+						 * value
+						 */
+	u8			wait_close_tx_prepared : 1;
+						/* shutdown wr or close
+						 * started, waiting for unsent
+						 * data to be sent
+						 */
+	u8			connect_nonblock : 1;
+						/* non-blocking connect in
+						 * flight
+						 */
+	struct mutex            clcsock_release_lock;
+						/* protects clcsock of a listen
+						 * socket
+						 */
+};
+
+#define SMC_SOCK_CLOSED_TIMING	(0)
+
+/* BPF struct ops for smc protocol negotiator */
+struct smc_sock_negotiator_ops {
+	/* ret for negotiate */
+	int (*negotiate)(struct smc_sock *sk);
+
+	/* info gathering timing */
+	void (*collect_info)(struct smc_sock *sk, int timing);
+};
+
+/* Query if current sock should go with SMC protocol
+ * SK_PASS for yes, otherwise for no.
+ */
+int smc_sock_should_select_smc(const struct smc_sock *smc);
+
+/* At some specific points in time,
+ * let negotiator can perform info gathering
+ * on target sock.
+ */
+void smc_sock_perform_collecting_info(const struct smc_sock *smc, int timing);
+
+#else
+struct smc_sock {};
+struct smc_connection {};
+struct smc_sock_negotiator_ops {};
+union smc_host_cursor {};
+#endif /* CONFIG_SMC */
+
 #endif	/* _SMC_H */
diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
index 5678a9d..35cdd15 100644
--- a/kernel/bpf/bpf_struct_ops_types.h
+++ b/kernel/bpf/bpf_struct_ops_types.h
@@ -9,4 +9,8 @@
 #include <net/tcp.h>
 BPF_STRUCT_OPS_TYPE(tcp_congestion_ops)
 #endif
+#if IS_ENABLED(CONFIG_SMC)
+#include <net/smc.h>
+BPF_STRUCT_OPS_TYPE(smc_sock_negotiator_ops)
+#endif
 #endif
diff --git a/net/Makefile b/net/Makefile
index 0914bea..47a4c00 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -52,6 +52,11 @@ obj-$(CONFIG_TIPC)		+= tipc/
 obj-$(CONFIG_NETLABEL)		+= netlabel/
 obj-$(CONFIG_IUCV)		+= iucv/
 obj-$(CONFIG_SMC)		+= smc/
+ifneq ($(CONFIG_SMC),)
+ifeq ($(CONFIG_BPF_SYSCALL),y)
+obj-y				+= smc/bpf_smc_struct_ops.o
+endif
+endif
 obj-$(CONFIG_RFKILL)		+= rfkill/
 obj-$(CONFIG_NET_9P)		+= 9p/
 obj-$(CONFIG_CAIF)		+= caif/
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d7a7420..98651b85 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -166,6 +166,9 @@ static bool smc_hs_congested(const struct sock *sk)
 	if (workqueue_congested(WORK_CPU_UNBOUND, smc_hs_wq))
 		return true;
 
+	if (!smc_sock_should_select_smc(smc))
+		return true;
+
 	return false;
 }
 
@@ -320,6 +323,9 @@ static int smc_release(struct socket *sock)
 	sock_hold(sk); /* sock_put below */
 	smc = smc_sk(sk);
 
+	/* trigger info gathering if needed.*/
+	smc_sock_perform_collecting_info(smc, SMC_SOCK_CLOSED_TIMING);
+
 	old_state = sk->sk_state;
 
 	/* cleanup for a dangling non-blocking connect */
@@ -1627,7 +1633,9 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 	}
 
 	smc_copy_sock_settings_to_clc(smc);
-	tcp_sk(smc->clcsock->sk)->syn_smc = 1;
+	tcp_sk(smc->clcsock->sk)->syn_smc = (smc_sock_should_select_smc(smc) == SK_PASS) ?
+		1 : 0;
+
 	if (smc->connect_nonblock) {
 		rc = -EALREADY;
 		goto out;
diff --git a/net/smc/bpf_smc_struct_ops.c b/net/smc/bpf_smc_struct_ops.c
new file mode 100644
index 0000000..ce0cfe1
--- /dev/null
+++ b/net/smc/bpf_smc_struct_ops.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf_ids.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <net/sock.h>
+#include <net/smc.h>
+
+extern struct bpf_struct_ops smc_sock_negotiator_ops;
+
+DEFINE_RWLOCK(smc_sock_negotiator_ops_rwlock);
+struct smc_sock_negotiator_ops *negotiator;
+
+/* convert sk to smc_sock */
+static inline struct smc_sock *smc_sk(const struct sock *sk)
+{
+	return (struct smc_sock *)sk;
+}
+
+/* register ops */
+static inline void smc_reg_passive_sk_ops(struct smc_sock_negotiator_ops *ops)
+{
+	write_lock_bh(&smc_sock_negotiator_ops_rwlock);
+	negotiator = ops;
+	write_unlock_bh(&smc_sock_negotiator_ops_rwlock);
+}
+
+/* unregister ops */
+static inline void smc_unreg_passive_sk_ops(struct smc_sock_negotiator_ops *ops)
+{
+	write_lock_bh(&smc_sock_negotiator_ops_rwlock);
+	if (negotiator == ops)
+		negotiator = NULL;
+	write_unlock_bh(&smc_sock_negotiator_ops_rwlock);
+}
+
+int smc_sock_should_select_smc(const struct smc_sock *smc)
+{
+	int ret = SK_PASS;
+
+	read_lock_bh(&smc_sock_negotiator_ops_rwlock);
+	if (negotiator && negotiator->negotiate)
+		ret = negotiator->negotiate((struct smc_sock *)smc);
+	read_unlock_bh(&smc_sock_negotiator_ops_rwlock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(smc_sock_should_select_smc);
+
+void smc_sock_perform_collecting_info(const struct smc_sock *smc, int timing)
+{
+	read_lock_bh(&smc_sock_negotiator_ops_rwlock);
+	if (negotiator && negotiator->collect_info)
+		negotiator->collect_info((struct smc_sock *)smc, timing);
+	read_unlock_bh(&smc_sock_negotiator_ops_rwlock);
+}
+EXPORT_SYMBOL_GPL(smc_sock_perform_collecting_info);
+
+/* define global smc ID for smc_struct_ops */
+BTF_ID_LIST_GLOBAL(btf_smc_ids, BTF_SMC_TYPE_MAX)
+#define BTF_SMC_TYPE(name, type) BTF_ID(struct, type)
+BTF_SMC_TYPE_xxx
+#undef BTF_SMC_TYPE
+
+static int bpf_smc_passive_sk_init(struct btf *btf)
+{
+	return 0;
+}
+
+/* register ops by BPF */
+static int bpf_smc_passive_sk_ops_reg(void *kdata)
+{
+	struct smc_sock_negotiator_ops *ops = kdata;
+
+	/* at least one ops need implement */
+	if (!ops->negotiate || !ops->collect_info) {
+		pr_err("At least one ops need implement.\n");
+		return -EINVAL;
+	}
+
+	smc_reg_passive_sk_ops(ops);
+	/* always success now */
+	return 0;
+}
+
+/* unregister ops by BPF */
+static void bpf_smc_passive_sk_ops_unreg(void *kdata)
+{
+	smc_unreg_passive_sk_ops(kdata);
+}
+
+static int bpf_smc_passive_sk_ops_check_member(const struct btf_type *t,
+					       const struct btf_member *member,
+					       const struct bpf_prog *prog)
+{
+	return 0;
+}
+
+static int bpf_smc_passive_sk_ops_init_member(const struct btf_type *t,
+					      const struct btf_member *member,
+					      void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static const struct bpf_func_proto *
+smc_passive_sk_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
+}
+
+static bool smc_passive_sk_ops_prog_is_valid_access(int off, int size, enum bpf_access_type type,
+						    const struct bpf_prog *prog,
+						    struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static int smc_passive_sk_ops_prog_struct_access(struct bpf_verifier_log *log,
+						 const struct bpf_reg_state *reg,
+						 int off, int size, enum bpf_access_type atype,
+						 u32 *next_btf_id, enum bpf_type_flag *flag)
+{
+	/* only allow read now*/
+	if (atype == BPF_READ)
+		return btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
+
+	return -EACCES;
+}
+
+static const struct bpf_verifier_ops bpf_smc_passive_sk_verifier_ops = {
+	.get_func_proto  = smc_passive_sk_prog_func_proto,
+	.is_valid_access = smc_passive_sk_ops_prog_is_valid_access,
+	.btf_struct_access = smc_passive_sk_ops_prog_struct_access
+};
+
+struct bpf_struct_ops bpf_smc_sock_negotiator_ops = {
+	.verifier_ops = &bpf_smc_passive_sk_verifier_ops,
+	.init = bpf_smc_passive_sk_init,
+	.check_member = bpf_smc_passive_sk_ops_check_member,
+	.init_member = bpf_smc_passive_sk_ops_init_member,
+	.reg = bpf_smc_passive_sk_ops_reg,
+	.unreg = bpf_smc_passive_sk_ops_unreg,
+	.name = "smc_sock_negotiator_ops",
+};
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 5ed765e..349b193 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -57,232 +57,12 @@ enum smc_state {		/* possible states of an SMC socket */
 
 struct smc_link_group;
 
-struct smc_wr_rx_hdr {	/* common prefix part of LLC and CDC to demultiplex */
-	union {
-		u8 type;
-#if defined(__BIG_ENDIAN_BITFIELD)
-		struct {
-			u8 llc_version:4,
-			   llc_type:4;
-		};
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-		struct {
-			u8 llc_type:4,
-			   llc_version:4;
-		};
-#endif
-	};
-} __aligned(1);
-
-struct smc_cdc_conn_state_flags {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u8	peer_done_writing : 1;	/* Sending done indicator */
-	u8	peer_conn_closed : 1;	/* Peer connection closed indicator */
-	u8	peer_conn_abort : 1;	/* Abnormal close indicator */
-	u8	reserved : 5;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	u8	reserved : 5;
-	u8	peer_conn_abort : 1;
-	u8	peer_conn_closed : 1;
-	u8	peer_done_writing : 1;
-#endif
-};
-
-struct smc_cdc_producer_flags {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u8	write_blocked : 1;	/* Writing Blocked, no rx buf space */
-	u8	urg_data_pending : 1;	/* Urgent Data Pending */
-	u8	urg_data_present : 1;	/* Urgent Data Present */
-	u8	cons_curs_upd_req : 1;	/* cursor update requested */
-	u8	failover_validation : 1;/* message replay due to failover */
-	u8	reserved : 3;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	u8	reserved : 3;
-	u8	failover_validation : 1;
-	u8	cons_curs_upd_req : 1;
-	u8	urg_data_present : 1;
-	u8	urg_data_pending : 1;
-	u8	write_blocked : 1;
-#endif
-};
-
-/* in host byte order */
-union smc_host_cursor {	/* SMC cursor - an offset in an RMBE */
-	struct {
-		u16	reserved;
-		u16	wrap;		/* window wrap sequence number */
-		u32	count;		/* cursor (= offset) part */
-	};
-#ifdef KERNEL_HAS_ATOMIC64
-	atomic64_t		acurs;	/* for atomic processing */
-#else
-	u64			acurs;	/* for atomic processing */
-#endif
-} __aligned(8);
-
-/* in host byte order, except for flag bitfields in network byte order */
-struct smc_host_cdc_msg {		/* Connection Data Control message */
-	struct smc_wr_rx_hdr		common; /* .type = 0xFE */
-	u8				len;	/* length = 44 */
-	u16				seqno;	/* connection seq # */
-	u32				token;	/* alert_token */
-	union smc_host_cursor		prod;		/* producer cursor */
-	union smc_host_cursor		cons;		/* consumer cursor,
-							 * piggy backed "ack"
-							 */
-	struct smc_cdc_producer_flags	prod_flags;	/* conn. tx/rx status */
-	struct smc_cdc_conn_state_flags	conn_state_flags; /* peer conn. status*/
-	u8				reserved[18];
-} __aligned(8);
-
-enum smc_urg_state {
-	SMC_URG_VALID	= 1,			/* data present */
-	SMC_URG_NOTYET	= 2,			/* data pending */
-	SMC_URG_READ	= 3,			/* data was already read */
-};
-
 struct smc_mark_woken {
 	bool woken;
 	void *key;
 	wait_queue_entry_t wait_entry;
 };
 
-struct smc_connection {
-	struct rb_node		alert_node;
-	struct smc_link_group	*lgr;		/* link group of connection */
-	struct smc_link		*lnk;		/* assigned SMC-R link */
-	u32			alert_token_local; /* unique conn. id */
-	u8			peer_rmbe_idx;	/* from tcp handshake */
-	int			peer_rmbe_size;	/* size of peer rx buffer */
-	atomic_t		peer_rmbe_space;/* remaining free bytes in peer
-						 * rmbe
-						 */
-	int			rtoken_idx;	/* idx to peer RMB rkey/addr */
-
-	struct smc_buf_desc	*sndbuf_desc;	/* send buffer descriptor */
-	struct smc_buf_desc	*rmb_desc;	/* RMBE descriptor */
-	int			rmbe_size_short;/* compressed notation */
-	int			rmbe_update_limit;
-						/* lower limit for consumer
-						 * cursor update
-						 */
-
-	struct smc_host_cdc_msg	local_tx_ctrl;	/* host byte order staging
-						 * buffer for CDC msg send
-						 * .prod cf. TCP snd_nxt
-						 * .cons cf. TCP sends ack
-						 */
-	union smc_host_cursor	local_tx_ctrl_fin;
-						/* prod crsr - confirmed by peer
-						 */
-	union smc_host_cursor	tx_curs_prep;	/* tx - prepared data
-						 * snd_max..wmem_alloc
-						 */
-	union smc_host_cursor	tx_curs_sent;	/* tx - sent data
-						 * snd_nxt ?
-						 */
-	union smc_host_cursor	tx_curs_fin;	/* tx - confirmed by peer
-						 * snd-wnd-begin ?
-						 */
-	atomic_t		sndbuf_space;	/* remaining space in sndbuf */
-	u16			tx_cdc_seq;	/* sequence # for CDC send */
-	u16			tx_cdc_seq_fin;	/* sequence # - tx completed */
-	spinlock_t		send_lock;	/* protect wr_sends */
-	atomic_t		cdc_pend_tx_wr; /* number of pending tx CDC wqe
-						 * - inc when post wqe,
-						 * - dec on polled tx cqe
-						 */
-	wait_queue_head_t	cdc_pend_tx_wq; /* wakeup on no cdc_pend_tx_wr*/
-	atomic_t		tx_pushing;     /* nr_threads trying tx push */
-	struct delayed_work	tx_work;	/* retry of smc_cdc_msg_send */
-	u32			tx_off;		/* base offset in peer rmb */
-
-	struct smc_host_cdc_msg	local_rx_ctrl;	/* filled during event_handl.
-						 * .prod cf. TCP rcv_nxt
-						 * .cons cf. TCP snd_una
-						 */
-	union smc_host_cursor	rx_curs_confirmed; /* confirmed to peer
-						    * source of snd_una ?
-						    */
-	union smc_host_cursor	urg_curs;	/* points at urgent byte */
-	enum smc_urg_state	urg_state;
-	bool			urg_tx_pend;	/* urgent data staged */
-	bool			urg_rx_skip_pend;
-						/* indicate urgent oob data
-						 * read, but previous regular
-						 * data still pending
-						 */
-	char			urg_rx_byte;	/* urgent byte */
-	bool			tx_in_release_sock;
-						/* flush pending tx data in
-						 * sock release_cb()
-						 */
-	atomic_t		bytes_to_rcv;	/* arrived data,
-						 * not yet received
-						 */
-	atomic_t		splice_pending;	/* number of spliced bytes
-						 * pending processing
-						 */
-#ifndef KERNEL_HAS_ATOMIC64
-	spinlock_t		acurs_lock;	/* protect cursors */
-#endif
-	struct work_struct	close_work;	/* peer sent some closing */
-	struct work_struct	abort_work;	/* abort the connection */
-	struct tasklet_struct	rx_tsklet;	/* Receiver tasklet for SMC-D */
-	u8			rx_off;		/* receive offset:
-						 * 0 for SMC-R, 32 for SMC-D
-						 */
-	u64			peer_token;	/* SMC-D token of peer */
-	u8			killed : 1;	/* abnormal termination */
-	u8			freed : 1;	/* normal termiation */
-	u8			out_of_sync : 1; /* out of sync with peer */
-};
-
-struct smc_sock {				/* smc sock container */
-	struct sock		sk;
-	struct socket		*clcsock;	/* internal tcp socket */
-	void			(*clcsk_state_change)(struct sock *sk);
-						/* original stat_change fct. */
-	void			(*clcsk_data_ready)(struct sock *sk);
-						/* original data_ready fct. */
-	void			(*clcsk_write_space)(struct sock *sk);
-						/* original write_space fct. */
-	void			(*clcsk_error_report)(struct sock *sk);
-						/* original error_report fct. */
-	struct smc_connection	conn;		/* smc connection */
-	struct smc_sock		*listen_smc;	/* listen parent */
-	struct work_struct	connect_work;	/* handle non-blocking connect*/
-	struct work_struct	tcp_listen_work;/* handle tcp socket accepts */
-	struct work_struct	smc_listen_work;/* prepare new accept socket */
-	struct list_head	accept_q;	/* sockets to be accepted */
-	spinlock_t		accept_q_lock;	/* protects accept_q */
-	bool			limit_smc_hs;	/* put constraint on handshake */
-	bool			use_fallback;	/* fallback to tcp */
-	int			fallback_rsn;	/* reason for fallback */
-	u32			peer_diagnosis; /* decline reason from peer */
-	atomic_t                queued_smc_hs;  /* queued smc handshakes */
-	struct inet_connection_sock_af_ops		af_ops;
-	const struct inet_connection_sock_af_ops	*ori_af_ops;
-						/* original af ops */
-	int			sockopt_defer_accept;
-						/* sockopt TCP_DEFER_ACCEPT
-						 * value
-						 */
-	u8			wait_close_tx_prepared : 1;
-						/* shutdown wr or close
-						 * started, waiting for unsent
-						 * data to be sent
-						 */
-	u8			connect_nonblock : 1;
-						/* non-blocking connect in
-						 * flight
-						 */
-	struct mutex            clcsock_release_lock;
-						/* protects clcsock of a listen
-						 * socket
-						 * */
-};
-
 static inline struct smc_sock *smc_sk(const struct sock *sk)
 {
 	return (struct smc_sock *)sk;
-- 
1.8.3.1

