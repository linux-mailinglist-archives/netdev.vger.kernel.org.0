Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125138046C
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 06:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfHCEno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 00:43:44 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42498 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHCEno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 00:43:44 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so80242829otn.9;
        Fri, 02 Aug 2019 21:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nOYwZv+mwmweSdnFak7Vi1Mik6yWaJoID5jXVgNR6DM=;
        b=GrcJi+K1+Cuy+cxT9d51yIa56OknOL0LvlbU7P4kqVeVqmiy2pXRBi1gyCTn4uLW4m
         x0SFBVxK/BDlUCrRcOPYZNN6nmVQErBPUwfym1RG8B2hVIUueg/7O2Btc4aFy48KPlnY
         le7IZykA1WGkbSBuJfKt9R/Xb4V2h5HlpKwU8mK4Cf9GIgmFUIgF6QSvLhbc9iwN1xJg
         0q8H9+fGYqPc/dWszsj7F5N8txlyP7SG0YIK1+f/apn74/6pLsfvnYq7PZrHT/dvxOp/
         Q6E3iHm2nm7d1ZANJiQ9uFgCm5SIGdbGjEl/iC8Clw8v3tbfHBh/cPlzSKdPed5mh+8o
         tI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nOYwZv+mwmweSdnFak7Vi1Mik6yWaJoID5jXVgNR6DM=;
        b=TrXjW1lNnb/HRdXsKUvPEVetiIaa3VyHWLyPp7XcffbzwJcTWoR3K3DanInp4sL/DK
         HCcc3lgyJa0pYidlt8P17ECyV/v67pZI6HusxcDkZavLoPGR406OCjAPwlt50rEsWsVp
         jEiGeybWJyJdyKi4axjOyJ05sVbfp9XSJFhNPhMvpsdrQRpmthrEYWHFVtNtfKWKKt3m
         AuuS1BY2yu0Is0m1Y4wC14TzVRrDIYELQtEdSk27i2wMGMgVDpDou+c3471tMq8Dl2jG
         lOpyGbNKV+qtiM/QQRbtF7Satgt5GxjcsUDI0Zf0HTF1eSnO3O3j45x4iwxlUhHcxU+T
         lV/g==
X-Gm-Message-State: APjAAAWIehUvNzqN5/JOzXQ+3m9ZbEpO+18NSSaMo5ob7orakQ0Wa4aW
        SP/83FQ+nFyy8SDP2fg3VZjIRHFC
X-Google-Smtp-Source: APXvYqw+nM/e8Q56jDAokNlNaPir0kgsUM2+tjbnJG/45XNrrdwI/1VpW7HR8cWxE5rGbkIazOlqWQ==
X-Received: by 2002:a9d:3e3:: with SMTP id f90mr20234906otf.202.1564807423049;
        Fri, 02 Aug 2019 21:43:43 -0700 (PDT)
Received: from fmzakari-linux.localdomain (76-242-91-200.lightspeed.sntcca.sbcglobal.net. [76.242.91.200])
        by smtp.gmail.com with ESMTPSA id 93sm26540379ota.77.2019.08.02.21.43.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 21:43:42 -0700 (PDT)
From:   Farid Zakaria <farid.m.zakaria@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: [PATCH 1/1] bpf: introduce new helper udp_flow_src_port
Date:   Fri,  2 Aug 2019 21:43:20 -0700
Message-Id: <20190803044320.5530-2-farid.m.zakaria@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190803044320.5530-1-farid.m.zakaria@gmail.com>
References: <20190803044320.5530-1-farid.m.zakaria@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Foo over UDP uses UDP encapsulation to add additional entropy
into the packets so that they get beter distribution across EMCP
routes.

Expose udp_flow_src_port as a bpf helper so that tunnel filters
can benefit from the helper.

Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
---
 include/uapi/linux/bpf.h                      | 21 +++++++--
 net/core/filter.c                             | 20 ++++++++
 tools/include/uapi/linux/bpf.h                | 21 +++++++--
 tools/testing/selftests/bpf/bpf_helpers.h     |  2 +
 .../bpf/prog_tests/udp_flow_src_port.c        | 28 +++++++++++
 .../bpf/progs/test_udp_flow_src_port_kern.c   | 47 +++++++++++++++++++
 6 files changed, 131 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4393bd4b2419..90e814153dec 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2545,9 +2545,21 @@ union bpf_attr {
  * 		*th* points to the start of the TCP header, while *th_len*
  * 		contains **sizeof**\ (**struct tcphdr**).
  *
- * 	Return
- * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
- * 		error otherwise.
+ *  Return
+ *      0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
+ *      error otherwise.
+ *
+ * int bpf_udp_flow_src_port(struct sk_buff *skb, int min, int max, int use_eth)
+ *  Description
+ *      It's common to implement tunnelling inside a UDP protocol to provide
+ *      additional randomness to the packet. The destination port of the UDP
+ *      header indicates the inner packet type whereas the source port is used
+ *      for additional entropy.
+ *
+ *  Return
+ *      An obfuscated hash of the packet that falls within the
+ *      min & max port range.
+ *      If min >= max, the default port range is used
  *
  * int bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
  *	Description
@@ -2853,7 +2865,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),  \
+	FN(udp_flow_src_port),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index 5a2707918629..fdf0ebb8c2c8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2341,6 +2341,24 @@ static const struct bpf_func_proto bpf_msg_pull_data_proto = {
 	.arg4_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_4(bpf_udp_flow_src_port, struct sk_buff *, skb, int, min,
+	   int, max, int, use_eth)
+{
+	struct net *net = dev_net(skb->dev);
+
+	return udp_flow_src_port(net, skb, min, max, use_eth);
+}
+
+static const struct bpf_func_proto bpf_udp_flow_src_port_proto = {
+	.func           = bpf_udp_flow_src_port,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type		= ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_ANYTHING,
+	.arg3_type		= ARG_ANYTHING,
+	.arg4_type		= ARG_ANYTHING,
+};
+
 BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 	   u32, len, u64, flags)
 {
@@ -6186,6 +6204,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
 		return &bpf_sk_storage_delete_proto;
+	case BPF_FUNC_udp_flow_src_port:
+		return &bpf_udp_flow_src_port_proto;
 #ifdef CONFIG_XFRM
 	case BPF_FUNC_skb_get_xfrm_state:
 		return &bpf_skb_get_xfrm_state_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4393bd4b2419..90e814153dec 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2545,9 +2545,21 @@ union bpf_attr {
  * 		*th* points to the start of the TCP header, while *th_len*
  * 		contains **sizeof**\ (**struct tcphdr**).
  *
- * 	Return
- * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
- * 		error otherwise.
+ *  Return
+ *      0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
+ *      error otherwise.
+ *
+ * int bpf_udp_flow_src_port(struct sk_buff *skb, int min, int max, int use_eth)
+ *  Description
+ *      It's common to implement tunnelling inside a UDP protocol to provide
+ *      additional randomness to the packet. The destination port of the UDP
+ *      header indicates the inner packet type whereas the source port is used
+ *      for additional entropy.
+ *
+ *  Return
+ *      An obfuscated hash of the packet that falls within the
+ *      min & max port range.
+ *      If min >= max, the default port range is used
  *
  * int bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
  *	Description
@@ -2853,7 +2865,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),  \
+	FN(udp_flow_src_port),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 120aa86c58d3..385bfd8b7436 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -313,6 +313,8 @@ static unsigned int (*bpf_set_hash)(void *ctx, __u32 hash) =
 static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 				  unsigned long long flags) =
 	(void *) BPF_FUNC_skb_adjust_room;
+static int (*bpf_udp_flow_src_port)(void *ctx, int min, int max, int use_eth) =
+	(void *) BPF_FUNC_udp_flow_src_port;
 
 /* Scan the ARCH passed in from ARCH env variable (see Makefile) */
 #if defined(__TARGET_ARCH_x86)
diff --git a/tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c b/tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c
new file mode 100644
index 000000000000..0f7303b51d1d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c
@@ -0,0 +1,28 @@
+#include <test_progs.h>
+#include <linux/pkt_cls.h>
+
+void test_udp_flow_src_port(void)
+{
+	const char *file = "./test_udp_flow_src_port_kern.o";
+	struct bpf_object *obj;
+	__u32 duration, retval, size;
+	int err, prog_fd;
+    char buf[128];
+    struct tcphdr *tcph = (void *)buf + sizeof(struct ethhdr) + sizeof(struct iphdr);
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
+	if (err) {
+		error_cnt++;
+		return;
+	}
+
+    short original = tcph->source;
+
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				buf, &size, &retval, &duration);
+	CHECK(err || retval != TC_ACT_OK || tcph->source == original, "ipv4",
+	      "err %d errno %d retval %d sport %d duration %d\n",
+	      err, errno, retval, tcph->source, duration);
+
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c b/tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c
new file mode 100644
index 000000000000..6238bd5fa856
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c
@@ -0,0 +1,47 @@
+#include <stddef.h>
+#include <stdbool.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/pkt_cls.h>
+#include <linux/tcp.h>
+#include "bpf_helpers.h"
+#include "bpf_endian.h"
+
+int _version SEC("version") = 1;
+char _license[] SEC("license") = "GPL";
+
+SEC("skb_udp_flow")
+int process(struct __sk_buff *skb)
+{
+    void *data = (void *)(size_t)skb->data;
+    void *data_end = (void *)(size_t)skb->data_end;
+    /* Is it an Ethernet frame? */
+    struct ethhdr *ethernet_header = (struct ethhdr *)data;
+    data += sizeof(*ethernet_header);
+    if (data > data_end) {
+        return TC_ACT_SHOT;
+    }
+
+    struct iphdr *ip_header = (struct iphdr *)data;
+    data += sizeof(*ip_header);
+    if (data > data_end) {
+        return TC_ACT_SHOT;
+    }
+
+    struct tcphdr *tcp_header = (struct tcphdr*)data;
+    data += sizeof(*tcp_header);
+    if (data > data_end) {
+        return TC_ACT_SHOT;
+    }
+
+    //lets assign the calculated source port in the
+    // tcp packet and verify it in the test
+    int sport = bpf_udp_flow_src_port(skb, 0, 0, 0);
+    tcp_header->source = sport;
+
+    return TC_ACT_OK;
+}
-- 
2.21.0

