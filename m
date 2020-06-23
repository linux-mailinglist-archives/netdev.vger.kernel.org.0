Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38F205702
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732988AbgFWQSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:18:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57778 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733032AbgFWQSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:18:16 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NG79Z6008834
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=pTuzhdLZBYWxI/Jrvo71AfawCckGeGczkAj434M7xdk=;
 b=DdKhjlXAE1cB8q6eZl35zZ5054O1cbqo3fVw9FetjMSJEQWxQnlnjbh2itYgDeXmMQfZ
 Mhp6/bXaZ9PhzgbyCtUah09NKAbiPUsgxtsAJ8VnavcxBD71tIbCHq+yoqhD0EPyprF/
 2/Cw9Xz+mF/NnYoCsWq/l6+9IdW9V4IciSU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk2crq40-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:14 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 09:18:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 5C8903701A38; Tue, 23 Jun 2020 09:18:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 13/15] selftests/bpf: implement sample tcp/tcp6 bpf_iter programs
Date:   Tue, 23 Jun 2020 09:18:06 -0700
Message-ID: <20200623161806.2501894-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623161749.2500196-1-yhs@fb.com>
References: <20200623161749.2500196-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_10:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In my VM, I got identical result compared to /proc/net/{tcp,tcp6}.
For tcp6:
  $ cat /proc/net/tcp6
    sl  local_address                         remote_address             =
           st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
     0: 00000000000000000000000000000000:0016 000000000000000000000000000=
00000:0000 0A 00000000:00000000 00:00000001 00000000     0        0 17955=
 1 000000003eb3102e 100 0 0 10 0

  $ cat /sys/fs/bpf/p1
    sl  local_address                         remote_address             =
           st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
     0: 00000000000000000000000000000000:0016 000000000000000000000000000=
00000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 17955=
 1 000000003eb3102e 100 0 0 10 0

For tcp:
  $ cat /proc/net/tcp
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrns=
mt   uid  timeout inode
   0: 00000000:0016 00000000:0000 0A 00000000:00000000 00:00000000 000000=
00     0        0 2666 1 000000007152e43f 100 0 0 10 0
  $ cat /sys/fs/bpf/p2
  sl  local_address                         remote_address               =
         st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
   1: 00000000:0016 00000000:0000 0A 00000000:00000000 00:00000000 000000=
00     0        0 2666 1 000000007152e43f 100 0 0 10 0

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/progs/bpf_iter.h  |  15 ++
 .../selftests/bpf/progs/bpf_iter_tcp4.c       | 234 ++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_tcp6.c       | 250 ++++++++++++++++++
 3 files changed, 499 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing=
/selftests/bpf/progs/bpf_iter.h
index 3757e88c6406..bde23e16e777 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -7,6 +7,8 @@
 #define bpf_iter__netlink bpf_iter__netlink___not_used
 #define bpf_iter__task bpf_iter__task___not_used
 #define bpf_iter__task_file bpf_iter__task_file___not_used
+#define bpf_iter__tcp bpf_iter__tcp___not_used
+#define tcp6_sock tcp6_sock___not_used
 #include "vmlinux.h"
 #undef bpf_iter_meta
 #undef bpf_iter__bpf_map
@@ -14,6 +16,8 @@
 #undef bpf_iter__netlink
 #undef bpf_iter__task
 #undef bpf_iter__task_file
+#undef bpf_iter__tcp
+#undef tcp6_sock
=20
 struct bpf_iter_meta {
 	struct seq_file *seq;
@@ -47,3 +51,14 @@ struct bpf_iter__bpf_map {
 	struct bpf_iter_meta *meta;
 	struct bpf_map *map;
 } __attribute__((preserve_access_index));
+
+struct bpf_iter__tcp {
+	struct bpf_iter_meta *meta;
+	struct sock_common *sk_common;
+	uid_t uid;
+} __attribute__((preserve_access_index));
+
+struct tcp6_sock {
+	struct tcp_sock	tcp;
+	struct ipv6_pinfo inet6;
+} __attribute__((preserve_access_index));
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c b/tools/te=
sting/selftests/bpf/progs/bpf_iter_tcp4.c
new file mode 100644
index 000000000000..30fd587cb325
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include "bpf_tracing_net.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+static int hlist_unhashed_lockless(const struct hlist_node *h)
+{
+        return !(h->pprev);
+}
+
+static int timer_pending(const struct timer_list * timer)
+{
+	return !hlist_unhashed_lockless(&timer->entry);
+}
+
+extern unsigned CONFIG_HZ __kconfig;
+
+#define USER_HZ		100
+#define NSEC_PER_SEC	1000000000ULL
+static clock_t jiffies_to_clock_t(unsigned long x)
+{
+	/* The implementation here tailored to a particular
+	 * setting of USER_HZ.
+	 */
+	u64 tick_nsec =3D (NSEC_PER_SEC + CONFIG_HZ/2) / CONFIG_HZ;
+	u64 user_hz_nsec =3D NSEC_PER_SEC / USER_HZ;
+
+	if ((tick_nsec % user_hz_nsec) =3D=3D 0) {
+		if (CONFIG_HZ < USER_HZ)
+			return x * (USER_HZ / CONFIG_HZ);
+		else
+			return x / (CONFIG_HZ / USER_HZ);
+	}
+	return x * tick_nsec/user_hz_nsec;
+}
+
+static clock_t jiffies_delta_to_clock_t(long delta)
+{
+	if (delta <=3D 0)
+		return 0;
+
+	return jiffies_to_clock_t(delta);
+}
+
+static long sock_i_ino(const struct sock *sk)
+{
+	const struct socket *sk_socket =3D sk->sk_socket;
+	const struct inode *inode;
+	unsigned long ino;
+
+	if (!sk_socket)
+		return 0;
+
+	inode =3D &container_of(sk_socket, struct socket_alloc, socket)->vfs_in=
ode;
+	bpf_probe_read(&ino, sizeof(ino), &inode->i_ino);
+	return ino;
+}
+
+static bool
+inet_csk_in_pingpong_mode(const struct inet_connection_sock *icsk)
+{
+	return icsk->icsk_ack.pingpong >=3D TCP_PINGPONG_THRESH;
+}
+
+static bool tcp_in_initial_slowstart(const struct tcp_sock *tcp)
+{
+	return tcp->snd_ssthresh >=3D TCP_INFINITE_SSTHRESH;
+}
+
+static int dump_tcp_sock(struct seq_file *seq, struct tcp_sock *tp,
+			 uid_t uid, __u32 seq_num)
+{
+	const struct inet_connection_sock *icsk;
+	const struct fastopen_queue *fastopenq;
+	const struct inet_sock *inet;
+	unsigned long timer_expires;
+	const struct sock *sp;
+	__u16 destp, srcp;
+	__be32 dest, src;
+	int timer_active;
+	int rx_queue;
+	int state;
+
+	icsk =3D &tp->inet_conn;
+	inet =3D &icsk->icsk_inet;
+	sp =3D &inet->sk;
+	fastopenq =3D &icsk->icsk_accept_queue.fastopenq;
+
+	dest =3D inet->inet_daddr;
+	src =3D inet->inet_rcv_saddr;
+	destp =3D bpf_ntohs(inet->inet_dport);
+	srcp =3D bpf_ntohs(inet->inet_sport);
+
+	if (icsk->icsk_pending =3D=3D ICSK_TIME_RETRANS ||
+	    icsk->icsk_pending =3D=3D ICSK_TIME_REO_TIMEOUT ||
+	    icsk->icsk_pending =3D=3D ICSK_TIME_LOSS_PROBE) {
+		timer_active =3D 1;
+		timer_expires =3D icsk->icsk_timeout;
+	} else if (icsk->icsk_pending =3D=3D ICSK_TIME_PROBE0) {
+		timer_active =3D 4;
+		timer_expires =3D icsk->icsk_timeout;
+	} else if (timer_pending(&sp->sk_timer)) {
+		timer_active =3D 2;
+		timer_expires =3D sp->sk_timer.expires;
+	} else {
+		timer_active =3D 0;
+		timer_expires =3D bpf_jiffies64();
+	}
+
+	state =3D sp->sk_state;
+	if (state =3D=3D TCP_LISTEN) {
+		rx_queue =3D sp->sk_ack_backlog;
+	} else {
+		rx_queue =3D tp->rcv_nxt - tp->copied_seq;
+		if (rx_queue < 0)
+			rx_queue =3D 0;
+	}
+
+	BPF_SEQ_PRINTF(seq, "%4d: %08X:%04X %08X:%04X ",
+		       seq_num, src, srcp, destp, destp);
+	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d ",
+		       state,
+		       tp->write_seq - tp->snd_una, rx_queue,
+		       timer_active,
+		       jiffies_delta_to_clock_t(timer_expires - bpf_jiffies64()),
+		       icsk->icsk_retransmits, uid,
+		       icsk->icsk_probes_out,
+		       sock_i_ino(sp),
+		       sp->sk_refcnt.refs.counter);
+	BPF_SEQ_PRINTF(seq, "%pK %lu %lu %u %u %d\n",
+		       tp,
+		       jiffies_to_clock_t(icsk->icsk_rto),
+		       jiffies_to_clock_t(icsk->icsk_ack.ato),
+		       (icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(icsk),
+		       tp->snd_cwnd,
+		       state =3D=3D TCP_LISTEN ? fastopenq->max_qlen
+				: (tcp_in_initial_slowstart(tp) ? -1 : tp->snd_ssthresh)
+		      );
+
+	return 0;
+}
+
+static int dump_tw_sock(struct seq_file *seq, struct tcp_timewait_sock *=
ttw,
+			uid_t uid, __u32 seq_num)
+{
+	struct inet_timewait_sock *tw =3D &ttw->tw_sk;
+	__u16 destp, srcp;
+	__be32 dest, src;
+	long delta;
+
+	delta =3D tw->tw_timer.expires - bpf_jiffies64();
+	dest =3D tw->tw_daddr;
+	src  =3D tw->tw_rcv_saddr;
+	destp =3D bpf_ntohs(tw->tw_dport);
+	srcp  =3D bpf_ntohs(tw->tw_sport);
+
+	BPF_SEQ_PRINTF(seq, "%4d: %08X:%04X %08X:%04X ",
+		       seq_num, src, srcp, dest, destp);
+
+	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK\n=
",
+		       tw->tw_substate, 0, 0,
+		       3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
+		       tw->tw_refcnt.refs.counter, tw);
+
+	return 0;
+}
+
+static int dump_req_sock(struct seq_file *seq, struct tcp_request_sock *=
treq,
+			 uid_t uid, __u32 seq_num)
+{
+	struct inet_request_sock *irsk =3D &treq->req;
+	struct request_sock *req =3D &irsk->req;
+	long ttd;
+
+	ttd =3D req->rsk_timer.expires - bpf_jiffies64();
+
+	if (ttd < 0)
+		ttd =3D 0;
+
+	BPF_SEQ_PRINTF(seq, "%4d: %08X:%04X %08X:%04X ",
+		       seq_num, irsk->ir_loc_addr,
+		       irsk->ir_num, irsk->ir_rmt_addr,
+		       bpf_ntohs(irsk->ir_rmt_port));
+	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK\n=
",
+		       TCP_SYN_RECV, 0, 0, 1, jiffies_to_clock_t(ttd),
+		       req->num_timeout, uid, 0, 0, 0, req);
+
+	return 0;
+}
+
+SEC("iter/tcp")
+int dump_tcp4(struct bpf_iter__tcp *ctx)
+{
+	struct sock_common *sk_common =3D ctx->sk_common;
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct tcp_timewait_sock *tw;
+	struct tcp_request_sock *req;
+	struct tcp_sock *tp;
+	uid_t uid =3D ctx->uid;
+	__u32 seq_num;
+
+	if (sk_common =3D=3D (void *)0)
+		return 0;
+
+	seq_num =3D ctx->meta->seq_num;
+	if (seq_num =3D=3D 0)
+		BPF_SEQ_PRINTF(seq, "  sl  "
+				    "local_address "
+				    "rem_address   "
+				    "st tx_queue rx_queue tr tm->when retrnsmt"
+				    "   uid  timeout inode\n");
+
+	if (sk_common->skc_family !=3D AF_INET)
+		return 0;
+
+	tp =3D bpf_skc_to_tcp_sock(sk_common);
+	if (tp)
+		return dump_tcp_sock(seq, tp, uid, seq_num);
+
+	tw =3D bpf_skc_to_tcp_timewait_sock(sk_common);
+	if (tw)
+		return dump_tw_sock(seq, tw, uid, seq_num);
+
+	req =3D bpf_skc_to_tcp_request_sock(sk_common);
+	if (req)
+		return dump_req_sock(seq, req, uid, seq_num);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c b/tools/te=
sting/selftests/bpf/progs/bpf_iter_tcp6.c
new file mode 100644
index 000000000000..10dec4392031
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include "bpf_tracing_net.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+static int hlist_unhashed_lockless(const struct hlist_node *h)
+{
+        return !(h->pprev);
+}
+
+static int timer_pending(const struct timer_list * timer)
+{
+	return !hlist_unhashed_lockless(&timer->entry);
+}
+
+extern unsigned CONFIG_HZ __kconfig;
+
+#define USER_HZ		100
+#define NSEC_PER_SEC	1000000000ULL
+static clock_t jiffies_to_clock_t(unsigned long x)
+{
+	/* The implementation here tailored to a particular
+	 * setting of USER_HZ.
+	 */
+	u64 tick_nsec =3D (NSEC_PER_SEC + CONFIG_HZ/2) / CONFIG_HZ;
+	u64 user_hz_nsec =3D NSEC_PER_SEC / USER_HZ;
+
+	if ((tick_nsec % user_hz_nsec) =3D=3D 0) {
+		if (CONFIG_HZ < USER_HZ)
+			return x * (USER_HZ / CONFIG_HZ);
+		else
+			return x / (CONFIG_HZ / USER_HZ);
+	}
+	return x * tick_nsec/user_hz_nsec;
+}
+
+static clock_t jiffies_delta_to_clock_t(long delta)
+{
+	if (delta <=3D 0)
+		return 0;
+
+	return jiffies_to_clock_t(delta);
+}
+
+static long sock_i_ino(const struct sock *sk)
+{
+	const struct socket *sk_socket =3D sk->sk_socket;
+	const struct inode *inode;
+	unsigned long ino;
+
+	if (!sk_socket)
+		return 0;
+
+	inode =3D &container_of(sk_socket, struct socket_alloc, socket)->vfs_in=
ode;
+	bpf_probe_read(&ino, sizeof(ino), &inode->i_ino);
+	return ino;
+}
+
+static bool
+inet_csk_in_pingpong_mode(const struct inet_connection_sock *icsk)
+{
+	return icsk->icsk_ack.pingpong >=3D TCP_PINGPONG_THRESH;
+}
+
+static bool tcp_in_initial_slowstart(const struct tcp_sock *tcp)
+{
+	return tcp->snd_ssthresh >=3D TCP_INFINITE_SSTHRESH;
+}
+
+static int dump_tcp6_sock(struct seq_file *seq, struct tcp6_sock *tp,
+			 uid_t uid, __u32 seq_num)
+{
+	const struct inet_connection_sock *icsk;
+	const struct fastopen_queue *fastopenq;
+	const struct in6_addr *dest, *src;
+	const struct inet_sock *inet;
+	unsigned long timer_expires;
+	const struct sock *sp;
+	__u16 destp, srcp;
+	int timer_active;
+	int rx_queue;
+	int state;
+
+	icsk =3D &tp->tcp.inet_conn;
+	inet =3D &icsk->icsk_inet;
+	sp =3D &inet->sk;
+	fastopenq =3D &icsk->icsk_accept_queue.fastopenq;
+
+	dest =3D &sp->sk_v6_daddr;
+	src =3D &sp->sk_v6_rcv_saddr;
+	destp =3D bpf_ntohs(inet->inet_dport);
+	srcp =3D bpf_ntohs(inet->inet_sport);
+
+	if (icsk->icsk_pending =3D=3D ICSK_TIME_RETRANS ||
+	    icsk->icsk_pending =3D=3D ICSK_TIME_REO_TIMEOUT ||
+	    icsk->icsk_pending =3D=3D ICSK_TIME_LOSS_PROBE) {
+		timer_active =3D 1;
+		timer_expires =3D icsk->icsk_timeout;
+	} else if (icsk->icsk_pending =3D=3D ICSK_TIME_PROBE0) {
+		timer_active =3D 4;
+		timer_expires =3D icsk->icsk_timeout;
+	} else if (timer_pending(&sp->sk_timer)) {
+		timer_active =3D 2;
+		timer_expires =3D sp->sk_timer.expires;
+	} else {
+		timer_active =3D 0;
+		timer_expires =3D bpf_jiffies64();
+	}
+
+	state =3D sp->sk_state;
+	if (state =3D=3D TCP_LISTEN) {
+		rx_queue =3D sp->sk_ack_backlog;
+	} else {
+		rx_queue =3D tp->tcp.rcv_nxt - tp->tcp.copied_seq;
+		if (rx_queue < 0)
+			rx_queue =3D 0;
+	}
+
+	BPF_SEQ_PRINTF(seq, "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "=
,
+		       seq_num,
+		       src->s6_addr32[0], src->s6_addr32[1],
+		       src->s6_addr32[2], src->s6_addr32[3], srcp,
+		       dest->s6_addr32[0], dest->s6_addr32[1],
+		       dest->s6_addr32[2], dest->s6_addr32[3], destp);
+	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d ",
+		       state,
+		       tp->tcp.write_seq - tp->tcp.snd_una, rx_queue,
+		       timer_active,
+		       jiffies_delta_to_clock_t(timer_expires - bpf_jiffies64()),
+		       icsk->icsk_retransmits, uid,
+		       icsk->icsk_probes_out,
+		       sock_i_ino(sp),
+		       sp->sk_refcnt.refs.counter);
+	BPF_SEQ_PRINTF(seq, "%pK %lu %lu %u %u %d\n",
+		       tp,
+		       jiffies_to_clock_t(icsk->icsk_rto),
+		       jiffies_to_clock_t(icsk->icsk_ack.ato),
+		       (icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(icsk),
+		       tp->tcp.snd_cwnd,
+		       state =3D=3D TCP_LISTEN ? fastopenq->max_qlen
+				: (tcp_in_initial_slowstart(&tp->tcp) ? -1
+								      : tp->tcp.snd_ssthresh)
+		      );
+
+	return 0;
+}
+
+static int dump_tw_sock(struct seq_file *seq, struct tcp_timewait_sock *=
ttw,
+			uid_t uid, __u32 seq_num)
+{
+	struct inet_timewait_sock *tw =3D &ttw->tw_sk;
+	const struct in6_addr *dest, *src;
+	__u16 destp, srcp;
+	long delta;
+
+	delta =3D tw->tw_timer.expires - bpf_jiffies64();
+	dest =3D &tw->tw_v6_daddr;
+	src  =3D &tw->tw_v6_rcv_saddr;
+	destp =3D bpf_ntohs(tw->tw_dport);
+	srcp  =3D bpf_ntohs(tw->tw_sport);
+
+	BPF_SEQ_PRINTF(seq, "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "=
,
+		       seq_num,
+		       src->s6_addr32[0], src->s6_addr32[1],
+		       src->s6_addr32[2], src->s6_addr32[3], srcp,
+		       dest->s6_addr32[0], dest->s6_addr32[1],
+		       dest->s6_addr32[2], dest->s6_addr32[3], destp);
+
+	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK\n=
",
+		       tw->tw_substate, 0, 0,
+		       3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
+		       tw->tw_refcnt.refs.counter, tw);
+
+	return 0;
+}
+
+static int dump_req_sock(struct seq_file *seq, struct tcp_request_sock *=
treq,
+			 uid_t uid, __u32 seq_num)
+{
+	struct inet_request_sock *irsk =3D &treq->req;
+	struct request_sock *req =3D &irsk->req;
+	struct in6_addr *src, *dest;
+	long ttd;
+
+	ttd =3D req->rsk_timer.expires - bpf_jiffies64();
+	src =3D &irsk->ir_v6_loc_addr;
+	dest =3D &irsk->ir_v6_rmt_addr;
+
+	if (ttd < 0)
+		ttd =3D 0;
+
+	BPF_SEQ_PRINTF(seq, "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "=
,
+		       seq_num,
+		       src->s6_addr32[0], src->s6_addr32[1],
+		       src->s6_addr32[2], src->s6_addr32[3],
+		       irsk->ir_num,
+		       dest->s6_addr32[0], dest->s6_addr32[1],
+		       dest->s6_addr32[2], dest->s6_addr32[3],
+		       bpf_ntohs(irsk->ir_rmt_port));
+	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK\n=
",
+		       TCP_SYN_RECV, 0, 0, 1, jiffies_to_clock_t(ttd),
+		       req->num_timeout, uid, 0, 0, 0, req);
+
+	return 0;
+}
+
+SEC("iter/tcp")
+int dump_tcp6(struct bpf_iter__tcp *ctx)
+{
+	struct sock_common *sk_common =3D ctx->sk_common;
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct tcp_timewait_sock *tw;
+	struct tcp_request_sock *req;
+	struct tcp6_sock *tp;
+	uid_t uid =3D ctx->uid;
+	__u32 seq_num;
+
+	if (sk_common =3D=3D (void *)0)
+		return 0;
+
+	seq_num =3D ctx->meta->seq_num;
+	if (seq_num =3D=3D 0)
+		BPF_SEQ_PRINTF(seq, "  sl  "
+				    "local_address                         "
+				    "remote_address                        "
+				    "st tx_queue rx_queue tr tm->when retrnsmt"
+				    "   uid  timeout inode\n");
+
+	if (sk_common->skc_family !=3D AF_INET6)
+		return 0;
+
+	tp =3D bpf_skc_to_tcp6_sock(sk_common);
+	if (tp)
+		return dump_tcp6_sock(seq, tp, uid, seq_num);
+
+	tw =3D bpf_skc_to_tcp_timewait_sock(sk_common);
+	if (tw)
+		return dump_tw_sock(seq, tw, uid, seq_num);
+
+	req =3D bpf_skc_to_tcp_request_sock(sk_common);
+	if (req)
+		return dump_req_sock(seq, req, uid, seq_num);
+
+	return 0;
+}
--=20
2.24.1

