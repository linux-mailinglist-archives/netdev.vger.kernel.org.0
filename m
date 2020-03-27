Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04708195A6D
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 16:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgC0P7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 11:59:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:50924 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727549AbgC0P7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 11:59:14 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHrO4-0007n5-Fh; Fri, 27 Mar 2020 16:59:12 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     m@lambda.lt, joe@wand.net.nz, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 2/7] bpf: enable perf event rb output for bpf cgroup progs
Date:   Fri, 27 Mar 2020 16:58:51 +0100
Message-Id: <69c39daf87e076b31e52473c902e9bfd37559124.1585323121.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1585323121.git.daniel@iogearbox.net>
References: <cover.1585323121.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, connect(), sendmsg(), recvmsg() and bind-related hooks
are all lacking perf event rb output in order to push notifications
or monitoring events up to user space. Back in commit a5a3a828cd00
("bpf: add perf event notificaton support for sock_ops"), I've worked
with Sowmini to enable them for sock_ops where the context part is
not used (as opposed to skbs for example where the packet data can
be appended). Make the bpf_sockopt_event_output() helper generic and
enable it for mentioned hooks.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 net/core/filter.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 0b6682517d45..6cb7e0e24473 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4159,8 +4159,8 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
 
-BPF_CALL_5(bpf_sockopt_event_output, struct bpf_sock_ops_kern *, bpf_sock,
-	   struct bpf_map *, map, u64, flags, void *, data, u64, size)
+BPF_CALL_5(bpf_event_output_data, void *, ctx, struct bpf_map *, map, u64, flags,
+	   void *, data, u64, size)
 {
 	if (unlikely(flags & ~(BPF_F_INDEX_MASK)))
 		return -EINVAL;
@@ -4168,8 +4168,8 @@ BPF_CALL_5(bpf_sockopt_event_output, struct bpf_sock_ops_kern *, bpf_sock,
 	return bpf_event_output(map, flags, data, size, NULL, 0, NULL);
 }
 
-static const struct bpf_func_proto bpf_sockopt_event_output_proto =  {
-	.func		= bpf_sockopt_event_output,
+static const struct bpf_func_proto bpf_event_output_data_proto =  {
+	.func		= bpf_event_output_data,
 	.gpl_only       = true,
 	.ret_type       = RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
@@ -5968,6 +5968,8 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_local_storage_proto;
 	case BPF_FUNC_get_socket_cookie:
 		return &bpf_get_socket_cookie_sock_proto;
+	case BPF_FUNC_perf_event_output:
+		return &bpf_event_output_data_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -5994,6 +5996,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_socket_cookie_sock_addr_proto;
 	case BPF_FUNC_get_local_storage:
 		return &bpf_get_local_storage_proto;
+	case BPF_FUNC_perf_event_output:
+		return &bpf_event_output_data_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_tcp:
 		return &bpf_sock_addr_sk_lookup_tcp_proto;
@@ -6236,7 +6240,7 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_local_storage:
 		return &bpf_get_local_storage_proto;
 	case BPF_FUNC_perf_event_output:
-		return &bpf_sockopt_event_output_proto;
+		return &bpf_event_output_data_proto;
 	case BPF_FUNC_sk_storage_get:
 		return &bpf_sk_storage_get_proto;
 	case BPF_FUNC_sk_storage_delete:
-- 
2.21.0

