Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BFDAC981
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 23:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395291AbfIGVni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 17:43:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47872 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfIGVni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 17:43:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87LeO1r184992;
        Sat, 7 Sep 2019 21:41:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=2KBRlUWT4ksmvNSW05OqNn57DbrWSjLKL1wfx9ktXpc=;
 b=DL29CgIZY0aeH+1YF3g7Dkob+pAD5ciTRDYG0Tm1FhbuTi45cA3tMuniO1qIyFZsArMK
 DeiR3rNESKMsnVxiytk/oWmY9RLcPUKzb9PThWjjs5k2JzoQvGjy+kFERs86nDGNkmem
 rvUHiJBuaOy6lD+qgmd7W61g41WrRiMD+BVw/lZD82UpKbHQizZbdRlWhh6naIjxgobP
 bWCWrvGHot8WPrRszVRnJtJhPKOb5zPOfik2MTzug9w3vm4TgkfEfk0Qjt1EFrewVhLq
 UyyJP3DlN1N+8ZkmM3EvsXjMzwWKbivgX7ls6DSkXHt+/Y6SnAWzVnq3bg96N7rF9k6n bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uvmef010e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:41:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Lbfgf132661;
        Sat, 7 Sep 2019 21:41:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uv2kxje45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:41:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x87LfjF9006616;
        Sat, 7 Sep 2019 21:41:45 GMT
Received: from dhcp-10-175-169-153.vpn.oracle.com (/10.175.169.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 14:41:44 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        quentin.monnet@netronome.com, rdna@fb.com, joe@wand.net.nz,
        acme@redhat.com, jolsa@kernel.org, alexey.budankov@linux.intel.com,
        gregkh@linuxfoundation.org, namhyung@kernel.org, sdf@google.com,
        f.fainelli@gmail.com, shuah@kernel.org, peter@lekensteyn.nl,
        ivan@cloudflare.com, andriin@fb.com,
        bhole_prashant_q7@lab.ntt.co.jp, david.calavera@gmail.com,
        danieltimlee@gmail.com, ctakshak@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 1/7] bpf: add bpf_pcap() helper to simplify packet capture
Date:   Sat,  7 Sep 2019 22:40:38 +0100
Message-Id: <1567892444-16344-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_pcap() simplifies packet capture for skb and XDP
BPF programs by creating a BPF perf event containing information
relevant for packet capture (protocol, actual/captured packet
size, time of capture, etc) along with the packet payload itself.
All of this is stored in a "struct bpf_pcap_hdr".

This header information can then be retrieved from the perf
event map and used by packet capture frameworks such as libpcap
to carry out packet capture.

skb and XDP programs currently deal in Ethernet-based traffic
exclusively, so should specify BPF_PCAP_TYPE_ETH or
BPF_PCAP_TYPE_UNSET.  The protocol parameter will be used
in a later commit.

Note that libpcap assumes times are relative to the epoch while
we record nanoseconds since boot; as a result any times need
to be normalized with respect to the boot time for libpcap
storage; sysinfo(2) can be used to retrieve boot time to normalize
values appropriately.

Example usage for a tc-bpf program:

struct bpf_map_def SEC("maps") pcap_map = {
	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 1024,
};

SEC("cap")
int cap(struct __sk_buff *skb)
{
	bpf_pcap(skb, 1514, &pcap_map, BPF_PCAP_TYPE_ETH, 0);

	return TC_ACT_OK;
}

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/bpf.h      | 20 +++++++++++++
 include/uapi/linux/bpf.h | 75 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/bpf/verifier.c    |  4 ++-
 net/core/filter.c        | 67 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 164 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b9d223..033c9cf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1145,4 +1145,24 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
 }
 #endif /* CONFIG_INET */
 
+
+static inline int bpf_pcap_prepare(int protocol, u32 cap_len, u32 tot_len,
+				   u64 flags, struct bpf_pcap_hdr *pcap)
+{
+	if (protocol < 0 || pcap == NULL)
+		return -EINVAL;
+
+	pcap->magic = BPF_PCAP_MAGIC;
+	pcap->protocol = protocol;
+	pcap->flags = flags;
+
+	if (cap_len == 0 || tot_len < cap_len)
+		cap_len = tot_len;
+	pcap->cap_len = cap_len;
+	pcap->tot_len = tot_len;
+	pcap->ktime_ns = ktime_get_mono_fast_ns();
+
+	return 0;
+}
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 77c6be9..a27e58e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2750,6 +2750,39 @@ struct bpf_stack_build_id {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_pcap(void *data, u32 size, struct bpf_map *map, int protocol,
+ *		u64 flags)
+ *	Description
+ *		Write packet data from *data* into a special BPF perf event
+ *              held by *map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This
+ *		perf event has the same attributes as perf events generated
+ *		by bpf_perf_event_output.  For skb and xdp programs, *data*
+ *		is the relevant context.
+ *
+ *		Metadata for this event is a **struct bpf_pcap_hdr**; this
+ *		contains the capture length, actual packet length and
+ *		the starting protocol.
+ *
+ *		The max number of bytes of context to store is specified via
+ *		*size*.
+ *
+ *		The flags value can be used to specify an id value of up
+ *		to 48 bits; the id can be used to correlate captured packets
+ *		with other trace data, since the passed-in flags value is stored
+ *		stored in the **struct bpf_pcap_hdr** in the **flags** field.
+ *
+ *		The *protocol* value specifies the protocol type of the start
+ *		of the packet so that packet capture can carry out
+ *		interpretation.  See **pcap-linktype** (7) for details on
+ *		the supported values.
+ *
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *		-ENOENT will be returned if the associated perf event
+ *		map entry is empty, or the skb is zero-length.
+ *		-EINVAL will be returned if the flags value is invalid.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2862,7 +2895,8 @@ struct bpf_stack_build_id {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(pcap),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -2941,6 +2975,9 @@ enum bpf_func_id {
 /* BPF_FUNC_sk_storage_get flags */
 #define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
 
+/* BPF_FUNC_pcap flags */
+#define	BPF_F_PCAP_ID_MASK		0xffffffffffff
+
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
 	BPF_ADJ_ROOM_NET,
@@ -3613,4 +3650,40 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+/* bpf_pcap_hdr contains information related to a particular packet capture
+ * flow.  It specifies
+ *
+ * - a magic number BPF_PCAP_MAGIC which identifies the perf event as
+ *   a pcap-related event.
+ * - a starting protocol is the protocol associated with the header
+ * - a flags value, copied from the flags value passed into bpf_pcap().
+ *   IDs can be used to correlate packet capture data and other tracing data.
+ *
+ * bpf_pcap_hdr also contains the information relating to the to-be-captured
+ * packet, and closely corresponds to the struct pcap_pkthdr used by
+ * pcap_dump (3PCAP).  The bpf_pcap helper sets ktime_ns (nanoseconds since
+ * boot) to the ktime_ns value; to get sensible pcap times this value should
+ * be converted to a struct timeval time since epoch in the struct pcap_pkthdr.
+ *
+ * When bpf_pcap() is used, a "struct bpf_pcap_hdr" is stored as we
+ * need both information about the particular packet and the protocol
+ * we are capturing.
+ */
+
+#define BPF_PCAP_MAGIC		0xb7fca7
+
+struct bpf_pcap_hdr {
+	__u32			magic;
+	int			protocol;
+	__u64			flags;
+	__u64			ktime_ns;
+	__u32			tot_len;
+	__u32			cap_len;
+	__u8			data[0];
+};
+
+#define BPF_PCAP_TYPE_UNSET	-1
+#define BPF_PCAP_TYPE_ETH	1
+#define	BPF_PCAP_TYPE_IP	12
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3fb5075..a33ed24 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3440,7 +3440,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_PERF_EVENT_ARRAY:
 		if (func_id != BPF_FUNC_perf_event_read &&
 		    func_id != BPF_FUNC_perf_event_output &&
-		    func_id != BPF_FUNC_perf_event_read_value)
+		    func_id != BPF_FUNC_perf_event_read_value &&
+		    func_id != BPF_FUNC_pcap)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_STACK_TRACE:
@@ -3527,6 +3528,7 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_FUNC_perf_event_read:
 	case BPF_FUNC_perf_event_output:
 	case BPF_FUNC_perf_event_read_value:
+	case BPF_FUNC_pcap:
 		if (map->map_type != BPF_MAP_TYPE_PERF_EVENT_ARRAY)
 			goto error;
 		break;
diff --git a/net/core/filter.c b/net/core/filter.c
index ed65636..e0e23ee 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4158,6 +4158,35 @@ static unsigned long bpf_xdp_copy(void *dst_buff, const void *src_buff,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+BPF_CALL_5(bpf_xdp_pcap, struct xdp_buff *, xdp, u32, size,
+	   struct bpf_map *, map, int, protocol, u64, flags)
+{
+	unsigned long len = (unsigned long)(xdp->data_end - xdp->data);
+	struct bpf_pcap_hdr pcap;
+	int ret;
+
+	if (unlikely(flags & ~BPF_F_PCAP_ID_MASK))
+		return -EINVAL;
+
+	ret = bpf_pcap_prepare(protocol, size, len, flags, &pcap);
+	if (ret)
+		return ret;
+
+	return bpf_event_output(map, BPF_F_CURRENT_CPU, &pcap, sizeof(pcap),
+				xdp->data, pcap.cap_len, bpf_xdp_copy);
+}
+
+static const struct bpf_func_proto bpf_xdp_pcap_proto = {
+	.func		= bpf_xdp_pcap,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_CONST_MAP_PTR,
+	.arg4_type	= ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_1(bpf_get_socket_cookie, struct sk_buff *, skb)
 {
 	return skb->sk ? sock_gen_cookie(skb->sk) : 0;
@@ -5926,6 +5955,34 @@ u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
 
 #endif /* CONFIG_INET */
 
+BPF_CALL_5(bpf_skb_pcap, struct sk_buff *, skb, u32, size,
+	   struct bpf_map *, map, int, protocol, u64, flags)
+{
+	struct bpf_pcap_hdr pcap;
+	int ret;
+
+	if (unlikely(flags & ~BPF_F_PCAP_ID_MASK))
+		return -EINVAL;
+
+	ret = bpf_pcap_prepare(protocol, size, skb->len, flags, &pcap);
+	if (ret)
+		return ret;
+
+	return bpf_event_output(map, BPF_F_CURRENT_CPU, &pcap, sizeof(pcap),
+				skb, pcap.cap_len, bpf_skb_copy);
+}
+
+static const struct bpf_func_proto bpf_skb_pcap_proto = {
+	.func		= bpf_skb_pcap,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_CONST_MAP_PTR,
+	.arg4_type      = ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
 bool bpf_helper_changes_pkt_data(void *func)
 {
 	if (func == bpf_skb_vlan_push ||
@@ -6075,6 +6132,8 @@ bool bpf_helper_changes_pkt_data(void *func)
 		return &bpf_get_socket_uid_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_skb_event_output_proto;
+	case BPF_FUNC_pcap:
+		return &bpf_skb_pcap_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -6216,6 +6275,8 @@ bool bpf_helper_changes_pkt_data(void *func)
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
 #endif
+	case BPF_FUNC_pcap:
+		return &bpf_skb_pcap_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -6256,6 +6317,8 @@ bool bpf_helper_changes_pkt_data(void *func)
 		return &bpf_tcp_check_syncookie_proto;
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
+	case BPF_FUNC_pcap:
+		return &bpf_xdp_pcap_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
@@ -6361,6 +6424,8 @@ bool bpf_helper_changes_pkt_data(void *func)
 	case BPF_FUNC_skc_lookup_tcp:
 		return &bpf_skc_lookup_tcp_proto;
 #endif
+	case BPF_FUNC_pcap:
+		return &bpf_skb_pcap_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -6399,6 +6464,8 @@ bool bpf_helper_changes_pkt_data(void *func)
 		return &bpf_get_smp_processor_id_proto;
 	case BPF_FUNC_skb_under_cgroup:
 		return &bpf_skb_under_cgroup_proto;
+	case BPF_FUNC_pcap:
+		return &bpf_skb_pcap_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
-- 
1.8.3.1

