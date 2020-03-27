Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF635195A77
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 16:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgC0P7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 11:59:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:50928 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgC0P7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 11:59:15 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHrO3-0007my-V1; Fri, 27 Mar 2020 16:59:12 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     m@lambda.lt, joe@wand.net.nz, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 1/7] bpf: enable retrieval of socket cookie for bind/post-bind hook
Date:   Fri, 27 Mar 2020 16:58:50 +0100
Message-Id: <e9d71f310715332f12d238cc650c1edc5be55119.1585323121.git.daniel@iogearbox.net>
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

We currently make heavy use of the socket cookie in BPF's connect(),
sendmsg() and recvmsg() hooks for load-balancing decisions. However,
it is currently not enabled/implemented in BPF {post-}bind hooks
where it can later be used in combination for correlation in the tc
egress path, for example.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 net/core/filter.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 96350a743539..0b6682517d45 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4117,6 +4117,18 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_addr_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_1(bpf_get_socket_cookie_sock, struct sock *, ctx)
+{
+	return sock_gen_cookie(ctx);
+}
+
+static const struct bpf_func_proto bpf_get_socket_cookie_sock_proto = {
+	.func		= bpf_get_socket_cookie_sock,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 BPF_CALL_1(bpf_get_socket_cookie_sock_ops, struct bpf_sock_ops_kern *, ctx)
 {
 	return sock_gen_cookie(ctx->sk);
@@ -5954,6 +5966,8 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_current_uid_gid_proto;
 	case BPF_FUNC_get_local_storage:
 		return &bpf_get_local_storage_proto;
+	case BPF_FUNC_get_socket_cookie:
+		return &bpf_get_socket_cookie_sock_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
-- 
2.21.0

