Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA92244D6
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 01:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfETXzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 19:55:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49014 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfETXzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 19:55:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNirUO157600;
        Mon, 20 May 2019 23:54:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=nNWD1RaJ4Mnuvxj6CYJ/9h+G++k56gswIg/ChEIRvEg=;
 b=1Z7AEGQYss8iaW6qUblq1vtcD6yFLvoEaqPeDaHNUTjdVBoawuEyS6ix6MOnAkPpSLxM
 5QD95Yp1VY6A0AEpZ15JWHZdFX45VPdqotkoItKTs6OrB+nb97+4cCmrByJaKvYhGKyR
 n578j4qylXbP4VVn6sVyUFnbOhPQV7fnN6JIm+MgT+ov+1yZQ5qlemquKD0Ee/CyBIq0
 oC1vqTqYKb9RFJpJiWa/q/ZRs0At3BF0GHfPQpNFAfS+tGDZgCEWd0RutOeuzcLK7h0u
 nx2t3Oo3a5S7567huH9YFqxeHk16OT3i2noLvqq8K/nNVG1RlmGe+c7rsD77GZ4rXM6X Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sj9fta3e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:54:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNsVS9144706;
        Mon, 20 May 2019 23:54:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2skudb2kyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 May 2019 23:54:58 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4KNswtd145393;
        Mon, 20 May 2019 23:54:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2skudb2kyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:54:58 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNsvcf001229;
        Mon, 20 May 2019 23:54:57 GMT
Message-Id: <201905202354.x4KNsvcf001229@aserv0121.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Mon, 20 May 2019 23:54:56 +0000
MIME-Version: 1.0
Date:   Mon, 20 May 2019 23:54:56 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 10/11] bpf: add bpf_buffer_reserve and bpf_buffer_commit
 helpers
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

Add two helpers that are primarily used in combination with the
writable-buffer support.  The bpf_buffer_reserve() helper sets aside
a chunk of buffer space that can be written to, and once all data
has been written, the bpf_buffer_commit() helper is used to make the
data in the ring buffer visible to userspace.

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 include/uapi/linux/bpf.h                  | 39 ++++++++++++++++++++++-
 kernel/bpf/verifier.c                     |  6 +++-
 tools/include/uapi/linux/bpf.h            | 39 ++++++++++++++++++++++-
 tools/testing/selftests/bpf/bpf_helpers.h |  4 +++
 4 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7bcb707539d1..2b7772aa00b6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2681,6 +2681,41 @@ union bpf_attr {
  *		the implementing program type.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_buffer_reserve(void *ctx, int id, struct bpf_map *map, int size)
+ *	Description
+ *		Reserve *size* bytes in the output buffer for the special BPF
+ *		BPF perf event referenced by *map*, a BPF map of type
+ *		**BPF_MAP_TYPE_PERF_EVENT_ARRAY**. The perf event must have
+ *		the attributes: **PERF_SAMPLE_RAW** as **sample_type**,
+ *		**PERF_TYPE_SOFTWARE** as **type**, and
+ *		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.  The reserved space
+ *		will be available as the writable buffer identified with
+ *		numeric ID **id** in the context.
+ *
+ *		The amount of reserved bytes cannot exceed the page size.
+ *		The chunk of buffer space will be reserved within a single
+ *		page, and if this results in unused space at the end of the
+ *		previous page in the ring-buffer, that unsused space will be
+ *		filled with zeros.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_buffer_commit(void *ctx, int id, struct bpf_map *map)
+ *	Description
+ *		FInalize the previously reserved space in the output buffer
+ *		for the special BPF perf event referenced by *map*, a BPF map
+ *		of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. The perf event must
+ *		have the attributes: **PERF_SAMPLE_RAW** as **sample_type**,
+ *		**PERF_TYPE_SOFTWARE** as **type**, and
+ *		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.
+ *
+ *		The writable buffer identified with numeric ID **id** in the
+ *		context will be invalidated, and can no longer be used to
+ *		write data to until a new **bpf_buffer_reserve**\ () has been
+ *		invoked.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2792,7 +2827,9 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(finalize_context),
+	FN(finalize_context),		\
+	FN(buffer_reserve),		\
+	FN(buffer_commit),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 90ae04b4d5c7..ff73ed743a58 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2763,7 +2763,9 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_PERF_EVENT_ARRAY:
 		if (func_id != BPF_FUNC_perf_event_read &&
 		    func_id != BPF_FUNC_perf_event_output &&
-		    func_id != BPF_FUNC_perf_event_read_value)
+		    func_id != BPF_FUNC_perf_event_read_value &&
+		    func_id != BPF_FUNC_buffer_reserve &&
+		    func_id != BPF_FUNC_buffer_commit)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_STACK_TRACE:
@@ -2848,6 +2850,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_FUNC_perf_event_read:
 	case BPF_FUNC_perf_event_output:
 	case BPF_FUNC_perf_event_read_value:
+	case BPF_FUNC_buffer_reserve:
+	case BPF_FUNC_buffer_commit:
 		if (map->map_type != BPF_MAP_TYPE_PERF_EVENT_ARRAY)
 			goto error;
 		break;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7bcb707539d1..2b7772aa00b6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2681,6 +2681,41 @@ union bpf_attr {
  *		the implementing program type.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_buffer_reserve(void *ctx, int id, struct bpf_map *map, int size)
+ *	Description
+ *		Reserve *size* bytes in the output buffer for the special BPF
+ *		BPF perf event referenced by *map*, a BPF map of type
+ *		**BPF_MAP_TYPE_PERF_EVENT_ARRAY**. The perf event must have
+ *		the attributes: **PERF_SAMPLE_RAW** as **sample_type**,
+ *		**PERF_TYPE_SOFTWARE** as **type**, and
+ *		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.  The reserved space
+ *		will be available as the writable buffer identified with
+ *		numeric ID **id** in the context.
+ *
+ *		The amount of reserved bytes cannot exceed the page size.
+ *		The chunk of buffer space will be reserved within a single
+ *		page, and if this results in unused space at the end of the
+ *		previous page in the ring-buffer, that unsused space will be
+ *		filled with zeros.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_buffer_commit(void *ctx, int id, struct bpf_map *map)
+ *	Description
+ *		FInalize the previously reserved space in the output buffer
+ *		for the special BPF perf event referenced by *map*, a BPF map
+ *		of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. The perf event must
+ *		have the attributes: **PERF_SAMPLE_RAW** as **sample_type**,
+ *		**PERF_TYPE_SOFTWARE** as **type**, and
+ *		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.
+ *
+ *		The writable buffer identified with numeric ID **id** in the
+ *		context will be invalidated, and can no longer be used to
+ *		write data to until a new **bpf_buffer_reserve**\ () has been
+ *		invoked.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2792,7 +2827,9 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(finalize_context),
+	FN(finalize_context),		\
+	FN(buffer_reserve),		\
+	FN(buffer_commit),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index d98a62b3b56c..72af8157d4db 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -218,6 +218,10 @@ static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 	(void *)BPF_FUNC_sk_storage_delete;
 static int (*bpf_finalize_context)(void *ctx, void *map) =
 	(void *) BPF_FUNC_finalize_context;
+static int (*bpf_buffer_reserve)(void *ctx, int id, void *map, int size) =
+	(void *) BPF_FUNC_buffer_reserve;
+static int (*bpf_buffer_commit)(void *ctx, int id, void *map) =
+	(void *) BPF_FUNC_buffer_commit;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
-- 
2.20.1

