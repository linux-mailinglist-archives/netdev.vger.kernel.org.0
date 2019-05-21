Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD5225942
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfEUUlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:41:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfEUUkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:40:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKdKcp007813;
        Tue, 21 May 2019 20:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=nNWD1RaJ4Mnuvxj6CYJ/9h+G++k56gswIg/ChEIRvEg=;
 b=KMJEuO5sMeMBO9RvF1qvCVQrfbXs03rdCugicEci4R4GR9xlrJepG5UD2Viys1JcL604
 w7Rfq47iBBjGvDcC93EYTiqvY8IqINWdtvizpn2N6dyUwXxH5QUN/CRTw8oOp1pK/CxO
 k+5DPfxyXEu+LL/i0UPbmGM72K3NO42gIdGDi0myLrWKJNLai0EZATWEzUsgjHdIhvPA
 6jz00OJSRQv0/xY8z2VCBrtIzbOo/VNG6F2amgQo5uOrHhTs8t1QmuN5ji8PmvSLihti
 6lgnIYR7hL3hYEN0ZoKgkuyVp59HVe0s6lrj7K6RrM9dMy8EjUO93zumbPh+Mcbndj3u OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sjapqfvwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:40:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKddjP128579;
        Tue, 21 May 2019 20:40:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2sks1ydpjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 20:40:00 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4LKe0I3129256;
        Tue, 21 May 2019 20:40:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2sks1ydpjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:40:00 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4LKdxnH023514;
        Tue, 21 May 2019 20:39:59 GMT
Message-Id: <201905212039.x4LKdxnH023514@aserv0121.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 21 May 2019 20:39:59 +0000
MIME-Version: 1.0
Date:   Tue, 21 May 2019 20:39:59 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 10/11] bpf: add bpf_buffer_reserve and bpf_buffer_commit
In-Reply-To: <201905202347.x4KNl0cs030532@aserv0121.oracle.com> <helpers>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210129
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

