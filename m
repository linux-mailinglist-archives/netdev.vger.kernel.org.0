Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5890CAC977
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 23:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391825AbfIGVnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 17:43:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43412 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbfIGVnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 17:43:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87LcdEE005427;
        Sat, 7 Sep 2019 21:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=vZXaDy+FtblbrcMxU5oAntjK0EYGuQifkpT7O1SFxRE=;
 b=ZxHJoHAhapSzH05ws7zcKJZtvYSbmAA0LKSuZIiEyTg/aoLzPU1WCe6XYhIcEJeYyfHy
 bPHnKmVwf0j4YBwygaueOoI0LJG4zT5mI6ZAJaWJarLeUHEFWartHbaLpdCmd7cRZvFd
 Ys7v5FyFyGoFh+mOJbz7ZnqrqhcrcsTAloeCORZBhQx63mkULI53uPIwr6QID2ru5Ben
 savzf6BXmhWZo76TPnLVoidDZSzDK1LiGm+8bCkE9HgZpi8PbDsI5PPmlEJCYBNvdvxZ
 67uJmko8u+JGG94s7q17kupHOP9rHq/h6z3hqH5cFTEUMoA0iplCaNk7d8RJW5rLXCWW /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uvme3r17e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87LbfQK132625;
        Sat, 7 Sep 2019 21:42:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uv2kxje69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:03 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x87Lg1aQ006672;
        Sat, 7 Sep 2019 21:42:01 GMT
Received: from dhcp-10-175-169-153.vpn.oracle.com (/10.175.169.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 14:42:01 -0700
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
Subject: [RFC bpf-next 2/7] bpf: extend bpf_pcap support to tracing programs
Date:   Sat,  7 Sep 2019 22:40:39 +0100
Message-Id: <1567892444-16344-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

packet capture is especially valuable in tracing contexts, so
extend bpf_pcap helper to take a tracing-derived skb pointer
as an argument.

In the case of tracing programs, the starting protocol
(corresponding to libpcap DLT_* values; 1 for Ethernet, 12 for
IP, etc) needs to be specified and should reflect the protocol
type which is pointed to by the skb->data pointer; i.e. the
start of the packet.  This can derived in a limited set of cases,
but should be specified where possible.  For skb and xdp programs
this protocol will nearly always be 1 (BPF_PCAP_TYPE_ETH).

Example usage for a tracing program, where we use a
struct bpf_pcap_hdr array map to pass in preferences for
protocol and max len:

struct bpf_map_def SEC("maps") pcap_conf_map = {
	.type = BPF_MAP_TYPE_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(struct bpf_pcap_hdr),
	.max_entries = 1,
};

struct bpf_map_def SEC("maps") pcap_map = {
	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 1024,
};

SEC("kprobe/kfree_skb")
int probe_kfree_skb(struct pt_regs *ctx)
{
	struct bpf_pcap_hdr *conf;
	int key = 0;

	conf = bpf_map_lookup_elem(&pcap_conf_map, &key);
	if (!conf)
		return 0;

	bpf_pcap((void *)PT_REGS_PARM1(ctx), conf->cap_len, &pcap_map,
		 conf->protocol, BPF_F_CURRENT_CPU);
	return 0;
}

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/uapi/linux/bpf.h |  21 ++++-
 kernel/trace/bpf_trace.c | 214 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 233 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a27e58e..13f86d3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2758,7 +2758,9 @@ struct bpf_stack_build_id {
  *              held by *map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This
  *		perf event has the same attributes as perf events generated
  *		by bpf_perf_event_output.  For skb and xdp programs, *data*
- *		is the relevant context.
+ *		is the relevant context, while for tracing programs,
+ *		*data* must be a pointer to a **struct sk_buff** derived
+ *		from kprobe or tracepoint arguments.
  *
  *		Metadata for this event is a **struct bpf_pcap_hdr**; this
  *		contains the capture length, actual packet length and
@@ -2771,6 +2773,14 @@ struct bpf_stack_build_id {
  *		to 48 bits; the id can be used to correlate captured packets
  *		with other trace data, since the passed-in flags value is stored
  *		stored in the **struct bpf_pcap_hdr** in the **flags** field.
+ *		Specifying **BPF_F_PCAP_ID_IIFINDEX** and a non-zero value in
+ *		the id portion of the flags limits capture events to skbs
+ *		with the specified incoming ifindex, allowing limiting of
+ *		tracing to the the associated interface.  Specifying
+ *		**BPF_F_PCAP_STRICT_TYPE** will cause *bpf_pcap* to return
+ *		-EPROTO and skip capture if a specific protocol is specified
+ *		and it does not match the current skb.  These additional flags
+ *		are only valid (and useful) for tracing programs.
  *
  *		The *protocol* value specifies the protocol type of the start
  *		of the packet so that packet capture can carry out
@@ -2780,7 +2790,12 @@ struct bpf_stack_build_id {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *		-ENOENT will be returned if the associated perf event
- *		map entry is empty, or the skb is zero-length.
+ *		map entry is empty, the skb is zero-length,  or the incoming
+ *		ifindex was specified and we failed to match.
+ *		-EPROTO will be returned if **BPF_PCAP_TYPE_UNSET** is specified
+ *		and no protocol can be determined, or if we specify a protocol
+ *		along with **BPF_F_PCAP_STRICT_TYPE** and the skb protocol does
+ *		not match.
  *		-EINVAL will be returned if the flags value is invalid.
  *
  */
@@ -2977,6 +2992,8 @@ enum bpf_func_id {
 
 /* BPF_FUNC_pcap flags */
 #define	BPF_F_PCAP_ID_MASK		0xffffffffffff
+#define BPF_F_PCAP_ID_IIFINDEX		(1ULL << 48)
+#define BPF_F_PCAP_STRICT_TYPE         (1ULL << 56)
 
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1255d..311883b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -13,6 +13,8 @@
 #include <linux/kprobes.h>
 #include <linux/syscalls.h>
 #include <linux/error-injection.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
 
 #include <asm/tlb.h>
 
@@ -530,6 +532,216 @@ u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 	return __bpf_perf_event_output(regs, map, flags, sd);
 }
 
+/* Essentially just skb_copy_bits() using probe_kernel_read() where needed. */
+static unsigned long bpf_trace_skb_copy(void *tobuf, const void *from,
+					unsigned long offset,
+					unsigned long len)
+{
+	const struct sk_buff *frag_iterp, *skb = from;
+	struct skb_shared_info *shinfop, shinfo;
+	struct sk_buff frag_iter;
+	unsigned long copy, start;
+	void *to = tobuf;
+	int i, ret;
+
+	start = skb_headlen(skb);
+
+	copy = start - offset;
+	if (copy > 0) {
+		if (copy > len)
+			copy = len;
+		ret = probe_kernel_read(to, skb->data, copy);
+		if (unlikely(ret < 0))
+			goto out;
+		len -= copy;
+		if (len == 0)
+			return 0;
+		offset += copy;
+		to += copy;
+	}
+
+	if (skb->data_len == 0)
+		goto out;
+
+	shinfop = skb_shinfo(skb);
+
+	ret = probe_kernel_read(&shinfo, shinfop, sizeof(shinfo));
+	if (unlikely(ret < 0))
+		goto out;
+
+	if (shinfo.nr_frags > MAX_SKB_FRAGS) {
+		ret = -EINVAL;
+		goto out;
+	}
+	for (i = 0; i < shinfo.nr_frags; i++) {
+		skb_frag_t *f = &shinfo.frags[i];
+		int end;
+
+		if (start > offset + len) {
+			ret = -E2BIG;
+			goto out;
+		}
+
+		end = start + skb_frag_size(f);
+		copy = end - offset;
+		if (copy > 0) {
+			u32 poff, p_len, copied;
+			struct page *p;
+			u8 *vaddr;
+
+			if (copy > len)
+				copy = len;
+
+			skb_frag_foreach_page(f,
+					      skb_frag_off(f) + offset - start,
+					      copy, p, poff, p_len, copied) {
+
+				vaddr = kmap_atomic(p);
+				ret = probe_kernel_read(to + copied,
+							vaddr + poff, p_len);
+				kunmap_atomic(vaddr);
+
+				if (unlikely(ret < 0))
+					goto out;
+			}
+			len -= copy;
+			if (len == 0)
+				return 0;
+			offset += copy;
+			to += copy;
+		}
+		start = end;
+	}
+
+	for (frag_iterp = shinfo.frag_list; frag_iterp;
+	     frag_iterp = frag_iter.next) {
+		int end;
+
+		if (start > offset + len) {
+			ret = -E2BIG;
+			goto out;
+		}
+		ret = probe_kernel_read(&frag_iter, frag_iterp,
+					sizeof(frag_iter));
+		if (ret)
+			goto out;
+
+		end = start + frag_iter.len;
+		copy = end - offset;
+		if (copy > 0) {
+			if (copy > len)
+				copy = len;
+			ret = bpf_trace_skb_copy(to, &frag_iter,
+						offset - start,
+						copy);
+			if (ret)
+				goto out;
+
+			len -= copy;
+			if (len == 0)
+				return 0;
+			offset += copy;
+			to += copy;
+		}
+		start = end;
+	}
+out:
+	if (ret)
+		memset(tobuf, 0, len);
+
+	return ret;
+}
+
+/* Derive protocol for some of the easier cases.  For tracing, a probe point
+ * may be dealing with packets in various states. Common cases are IP
+ * packets prior to adding MAC header (_PCAP_TYPE_IP) and a full packet
+ * (_PCAP_TYPE_ETH).  For other cases the caller must specify the
+ * protocol they expect.  Other heuristics for packet identification
+ * should be added here as needed, since determining the packet type
+ * ensures we do not capture packets that fail to match the desired
+ * pcap type in BPF_F_PCAP_STRICT_TYPE mode.
+ */
+static inline int bpf_skb_protocol_get(struct sk_buff *skb)
+{
+	switch (htons(skb->protocol)) {
+	case ETH_P_IP:
+	case ETH_P_IPV6:
+		if (skb_network_header(skb) == skb->data)
+			return BPF_PCAP_TYPE_IP;
+		else
+			return BPF_PCAP_TYPE_ETH;
+	default:
+		return BPF_PCAP_TYPE_UNSET;
+	}
+}
+
+BPF_CALL_5(bpf_trace_pcap, void *, data, u32, size, struct bpf_map *, map,
+	   int, protocol_wanted, u64, flags)
+{
+	struct bpf_pcap_hdr pcap;
+	struct sk_buff skb;
+	int protocol;
+	int ret;
+
+	if (unlikely(flags & ~(BPF_F_PCAP_ID_IIFINDEX | BPF_F_PCAP_ID_MASK |
+			       BPF_F_PCAP_STRICT_TYPE)))
+		return -EINVAL;
+
+	ret = probe_kernel_read(&skb, data, sizeof(skb));
+	if (unlikely(ret < 0))
+		return ret;
+
+	/* Sanity check skb len in case we get bogus data. */
+	if (unlikely(!skb.len))
+		return -ENOENT;
+	if (unlikely(skb.len > GSO_MAX_SIZE || skb.data_len > skb.len))
+		return -E2BIG;
+
+	protocol = bpf_skb_protocol_get(&skb);
+
+	if (protocol_wanted == BPF_PCAP_TYPE_UNSET) {
+		/* If we cannot determine protocol type, bail. */
+		if (protocol == BPF_PCAP_TYPE_UNSET)
+			return -EPROTO;
+	} else {
+		/* if we determine protocol type, and it's not what we asked
+		 * for _and_ we are in strict mode, bail.  Otherwise we assume
+		 * the packet is the requested protocol type and drive on.
+		 */
+		if (flags & BPF_F_PCAP_STRICT_TYPE &&
+		    protocol != BPF_PCAP_TYPE_UNSET &&
+		    protocol != protocol_wanted)
+			return -EPROTO;
+		protocol = protocol_wanted;
+	}
+
+	/* If we specified a matching incoming ifindex, bail if not a match. */
+	if (flags & BPF_F_PCAP_ID_IIFINDEX) {
+		int iif = flags & BPF_F_PCAP_ID_MASK;
+
+		if (iif && skb.skb_iif != iif)
+			return -ENOENT;
+	}
+
+	ret = bpf_pcap_prepare(protocol, size, skb.len, flags, &pcap);
+	if (ret)
+		return ret;
+
+	return bpf_event_output(map, BPF_F_CURRENT_CPU, &pcap, sizeof(pcap),
+				&skb, pcap.cap_len, bpf_trace_skb_copy);
+}
+
+static const struct bpf_func_proto bpf_trace_pcap_proto = {
+	.func		= bpf_trace_pcap,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_CONST_MAP_PTR,
+	.arg4_type	= ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_0(bpf_get_current_task)
 {
 	return (long) current;
@@ -709,6 +921,8 @@ static void do_bpf_send_signal(struct irq_work *entry)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_pcap:
+		return &bpf_trace_pcap_proto;
 	default:
 		return NULL;
 	}
-- 
1.8.3.1

