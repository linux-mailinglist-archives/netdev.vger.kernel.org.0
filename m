Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCACF244B0
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 01:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfETXvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 19:51:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbfETXvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 19:51:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNiic1157571;
        Mon, 20 May 2019 23:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=+v0/nyHMonwIDyYa9VwbpsDWKkbjJtsdeNgieF+lGp8=;
 b=XKtQdGw9AyR+ypXt5JT6zyfqL0flPXw0+qHPVCMLd9/Gm7tGWf4s56y5475gl3hNa6eb
 lvjgAU57Jrwyhj59jbosRyzcVudEBvRhMfqIPtL9iAygL1WEZS9P+mNWemA54md68/Zd
 zbE6BrvPJtKz2LpTZiHIUiBuL2yEFrLbmM7GfD69/DydHQngTUULwCyadZTOQoUQjJ6G
 S2Hxy0mnMTTdOoMXERGYG3KtF61C/uz/+TwkJ4RrTlkmcAnC3F5fjQNBFImEjnNbj+eH
 7lBHO2KgISnnwxk+t+aFmMd62vdLy6M6tEBwl2zpo/C54HiOU6KHS7bi+ixVehiQ8/Ti BA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sj9fta360-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:50:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNnomx184684;
        Mon, 20 May 2019 23:50:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2sks1xvk9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 May 2019 23:50:50 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4KNoo2v186770;
        Mon, 20 May 2019 23:50:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2sks1xvk9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:50:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KNonxk016788;
        Mon, 20 May 2019 23:50:49 GMT
Message-Id: <201905202350.x4KNonxk016788@aserv0122.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Mon, 20 May 2019 23:50:49 +0000
MIME-Version: 1.0
Date:   Mon, 20 May 2019 23:50:49 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 02/11] bpf: add BPF_PROG_TYPE_DTRACE
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new BPF program type for DTrace.  The program type is not compiled
right now because the CONFIG_DTRACE option does not exist yet.  It will
be added in a following commit.

Three commits are involved here:

1. add the BPF program type (conditional on a to-be-added option)
2. add the BPF_PROG_TYPE_DTRACE implementation (building not enabled)
3. add the CONFIG_DTRACE option and enable compilation of the prog type
   implementation

The reason for this sequence is to ensure that the kernel tree remains
buildable between these commits.

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 include/linux/bpf_types.h      |  3 +++
 include/uapi/linux/bpf.h       |  1 +
 samples/bpf/bpf_load.c         | 10 +++++++---
 tools/include/uapi/linux/bpf.h |  1 +
 tools/lib/bpf/libbpf.c         |  2 ++
 tools/lib/bpf/libbpf_probes.c  |  1 +
 6 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 5a9975678d6f..908f2e4f597e 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -26,6 +26,9 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_TRACEPOINT, tracepoint)
 BPF_PROG_TYPE(BPF_PROG_TYPE_PERF_EVENT, perf_event)
 BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT, raw_tracepoint)
 BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE, raw_tracepoint_writable)
+#ifdef CONFIG_DTRACE
+BPF_PROG_TYPE(BPF_PROG_TYPE_DTRACE, dtrace)
+#endif
 #endif
 #ifdef CONFIG_CGROUP_BPF
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 61abe6b56948..7bcb707539d1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_DTRACE,
 };
 
 enum bpf_attach_type {
diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index eae7b635343d..4812295484a1 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -87,6 +87,7 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 	bool is_sockops = strncmp(event, "sockops", 7) == 0;
 	bool is_sk_skb = strncmp(event, "sk_skb", 6) == 0;
 	bool is_sk_msg = strncmp(event, "sk_msg", 6) == 0;
+	bool is_dtrace = strncmp(event, "dtrace", 6) == 0;
 	size_t insns_cnt = size / sizeof(struct bpf_insn);
 	enum bpf_prog_type prog_type;
 	char buf[256];
@@ -120,6 +121,8 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 		prog_type = BPF_PROG_TYPE_SK_SKB;
 	} else if (is_sk_msg) {
 		prog_type = BPF_PROG_TYPE_SK_MSG;
+	} else if (is_dtrace) {
+		prog_type = BPF_PROG_TYPE_DTRACE;
 	} else {
 		printf("Unknown event '%s'\n", event);
 		return -1;
@@ -140,8 +143,8 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 	if (is_xdp || is_perf_event || is_cgroup_skb || is_cgroup_sk)
 		return 0;
 
-	if (is_socket || is_sockops || is_sk_skb || is_sk_msg) {
-		if (is_socket)
+	if (is_socket || is_sockops || is_sk_skb || is_sk_msg || is_dtrace) {
+		if (is_socket || is_dtrace)
 			event += 6;
 		else
 			event += 7;
@@ -643,7 +646,8 @@ static int do_load_bpf_file(const char *path, fixup_map_cb fixup_map)
 		    memcmp(shname, "cgroup/", 7) == 0 ||
 		    memcmp(shname, "sockops", 7) == 0 ||
 		    memcmp(shname, "sk_skb", 6) == 0 ||
-		    memcmp(shname, "sk_msg", 6) == 0) {
+		    memcmp(shname, "sk_msg", 6) == 0 ||
+		    memcmp(shname, "dtrace", 6) == 0) {
 			ret = load_and_attach(shname, data->d_buf,
 					      data->d_size);
 			if (ret != 0)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 61abe6b56948..7bcb707539d1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_DTRACE,
 };
 
 enum bpf_attach_type {
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7e3b79d7c25f..44704a7d395d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2269,6 +2269,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 		return false;
 	case BPF_PROG_TYPE_KPROBE:
+	case BPF_PROG_TYPE_DTRACE:
 	default:
 		return true;
 	}
@@ -3209,6 +3210,7 @@ static const struct {
 						BPF_CGROUP_UDP6_SENDMSG),
 	BPF_EAPROG_SEC("cgroup/sysctl",		BPF_PROG_TYPE_CGROUP_SYSCTL,
 						BPF_CGROUP_SYSCTL),
+	BPF_PROG_SEC("dtrace/",			BPF_PROG_TYPE_DTRACE),
 };
 
 #undef BPF_PROG_SEC_IMPL
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 5e2aa83f637a..544d8530915e 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -101,6 +101,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_SK_REUSEPORT:
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_DTRACE:
 	default:
 		break;
 	}
-- 
2.20.1

