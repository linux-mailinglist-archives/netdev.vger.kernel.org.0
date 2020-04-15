Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87481A9D9B
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 13:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406143AbgDOLqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409272AbgDOLqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:46:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 019A82137B;
        Wed, 15 Apr 2020 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951173;
        bh=2qPNIb5KmlO0oacho3IP77Yk/ManbrQU4GWchRduLz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUDemhAF6gn53JoxEPtKtec5sJ7ZyFucGB5Ob+R13b3YKMwA8n+L/5wV1NBUhiv3F
         NbA7pfZJ1cwQnGiLxQcIpqTmBQSZWDMFk6NtvIZiGYh51vt+BK9jSFpuNkC4ZfxmT2
         rOBP7EerPwTbiSAs6lhoEY271znT7EXjaN8qkpGc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 77/84] sunrpc: Fix gss_unwrap_resp_integ() again
Date:   Wed, 15 Apr 2020 07:44:34 -0400
Message-Id: <20200415114442.14166-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4047aa909c4a40fceebc36fff708d465a4d3c6e2 ]

xdr_buf_read_mic() tries to find unused contiguous space in a
received xdr_buf in order to linearize the checksum for the call
to gss_verify_mic. However, the corner cases in this code are
numerous and we seem to keep missing them. I've just hit yet
another buffer overrun related to it.

This overrun is at the end of xdr_buf_read_mic():

1284         if (buf->tail[0].iov_len != 0)
1285                 mic->data = buf->tail[0].iov_base + buf->tail[0].iov_len;
1286         else
1287                 mic->data = buf->head[0].iov_base + buf->head[0].iov_len;
1288         __read_bytes_from_xdr_buf(&subbuf, mic->data, mic->len);
1289         return 0;

This logic assumes the transport has set the length of the tail
based on the size of the received message. base + len is then
supposed to be off the end of the message but still within the
actual buffer.

In fact, the length of the tail is set by the upper layer when the
Call is encoded so that the end of the tail is actually the end of
the allocated buffer itself. This causes the logic above to set
mic->data to point past the end of the receive buffer.

The "mic->data = head" arm of this if statement is no less fragile.

As near as I can tell, this has been a problem forever. I'm not sure
that minimizing au_rslack recently changed this pathology much.

So instead, let's use a more straightforward approach: kmalloc a
separate buffer to linearize the checksum. This is similar to
how gss_validate() currently works.

Coming back to this code, I had some trouble understanding what
was going on. So I've cleaned up the variable naming and added
a few comments that point back to the XDR definition in RFC 2203
to help guide future spelunkers, including myself.

As an added clean up, the functionality that was in
xdr_buf_read_mic() is folded directly into gss_unwrap_resp_integ(),
as that is its only caller.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/auth_gss.c | 77 +++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 19 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index f9e1a7e61eda0..ff5fcb3e12084 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1935,35 +1935,69 @@ gss_unwrap_resp_auth(struct rpc_cred *cred)
 	return 0;
 }
 
+/*
+ * RFC 2203, Section 5.3.2.2
+ *
+ *	struct rpc_gss_integ_data {
+ *		opaque databody_integ<>;
+ *		opaque checksum<>;
+ *	};
+ *
+ *	struct rpc_gss_data_t {
+ *		unsigned int seq_num;
+ *		proc_req_arg_t arg;
+ *	};
+ */
 static int
 gss_unwrap_resp_integ(struct rpc_task *task, struct rpc_cred *cred,
 		      struct gss_cl_ctx *ctx, struct rpc_rqst *rqstp,
 		      struct xdr_stream *xdr)
 {
-	struct xdr_buf integ_buf, *rcv_buf = &rqstp->rq_rcv_buf;
-	u32 data_offset, mic_offset, integ_len, maj_stat;
+	struct xdr_buf gss_data, *rcv_buf = &rqstp->rq_rcv_buf;
 	struct rpc_auth *auth = cred->cr_auth;
+	u32 len, offset, seqno, maj_stat;
 	struct xdr_netobj mic;
-	__be32 *p;
+	int ret;
 
-	p = xdr_inline_decode(xdr, 2 * sizeof(*p));
-	if (unlikely(!p))
+	ret = -EIO;
+	mic.data = NULL;
+
+	/* opaque databody_integ<>; */
+	if (xdr_stream_decode_u32(xdr, &len))
 		goto unwrap_failed;
-	integ_len = be32_to_cpup(p++);
-	if (integ_len & 3)
+	if (len & 3)
 		goto unwrap_failed;
-	data_offset = (u8 *)(p) - (u8 *)rcv_buf->head[0].iov_base;
-	mic_offset = integ_len + data_offset;
-	if (mic_offset > rcv_buf->len)
+	offset = rcv_buf->len - xdr_stream_remaining(xdr);
+	if (xdr_stream_decode_u32(xdr, &seqno))
 		goto unwrap_failed;
-	if (be32_to_cpup(p) != rqstp->rq_seqno)
+	if (seqno != rqstp->rq_seqno)
 		goto bad_seqno;
+	if (xdr_buf_subsegment(rcv_buf, &gss_data, offset, len))
+		goto unwrap_failed;
 
-	if (xdr_buf_subsegment(rcv_buf, &integ_buf, data_offset, integ_len))
+	/*
+	 * The xdr_stream now points to the beginning of the
+	 * upper layer payload, to be passed below to
+	 * rpcauth_unwrap_resp_decode(). The checksum, which
+	 * follows the upper layer payload in @rcv_buf, is
+	 * located and parsed without updating the xdr_stream.
+	 */
+
+	/* opaque checksum<>; */
+	offset += len;
+	if (xdr_decode_word(rcv_buf, offset, &len))
+		goto unwrap_failed;
+	offset += sizeof(__be32);
+	if (offset + len > rcv_buf->len)
 		goto unwrap_failed;
-	if (xdr_buf_read_mic(rcv_buf, &mic, mic_offset))
+	mic.len = len;
+	mic.data = kmalloc(len, GFP_NOFS);
+	if (!mic.data)
+		goto unwrap_failed;
+	if (read_bytes_from_xdr_buf(rcv_buf, offset, mic.data, mic.len))
 		goto unwrap_failed;
-	maj_stat = gss_verify_mic(ctx->gc_gss_ctx, &integ_buf, &mic);
+
+	maj_stat = gss_verify_mic(ctx->gc_gss_ctx, &gss_data, &mic);
 	if (maj_stat == GSS_S_CONTEXT_EXPIRED)
 		clear_bit(RPCAUTH_CRED_UPTODATE, &cred->cr_flags);
 	if (maj_stat != GSS_S_COMPLETE)
@@ -1971,16 +2005,21 @@ gss_unwrap_resp_integ(struct rpc_task *task, struct rpc_cred *cred,
 
 	auth->au_rslack = auth->au_verfsize + 2 + 1 + XDR_QUADLEN(mic.len);
 	auth->au_ralign = auth->au_verfsize + 2;
-	return 0;
+	ret = 0;
+
+out:
+	kfree(mic.data);
+	return ret;
+
 unwrap_failed:
 	trace_rpcgss_unwrap_failed(task);
-	return -EIO;
+	goto out;
 bad_seqno:
-	trace_rpcgss_bad_seqno(task, rqstp->rq_seqno, be32_to_cpup(p));
-	return -EIO;
+	trace_rpcgss_bad_seqno(task, rqstp->rq_seqno, seqno);
+	goto out;
 bad_mic:
 	trace_rpcgss_verify_mic(task, maj_stat);
-	return -EIO;
+	goto out;
 }
 
 static int
-- 
2.20.1

