Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18101F2DF5
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbgFIAiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729439AbgFHXNd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06C09212CC;
        Mon,  8 Jun 2020 23:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658012;
        bh=GY94fw2tmRpgKnavShB9H5aWlS1x0zlJD2H7yvEEPJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmRXp1W7r8xMc1fGZOU9syO0Z/TfDJv909MUtIwmYXsJLxmiw/hcf/yj9WCzDsbTi
         UQcv7yYKj893ARVHJkE1XZRJjyo/glSiQn3/CI/3lduQuDxi5ajPBq4v7qls/ov+90
         KYjMQcC56YXqswdjkSu0bMe3tlrNWiZxDfh/ZQM0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 067/606] SUNRPC: Revert 241b1f419f0e ("SUNRPC: Remove xdr_buf_trim()")
Date:   Mon,  8 Jun 2020 19:03:12 -0400
Message-Id: <20200608231211.3363633-67-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 0a8e7b7d08466b5fc52f8e96070acc116d82a8bb upstream.

I've noticed that when krb5i or krb5p security is in use,
retransmitted requests are missing the server's duplicate reply
cache. The computed checksum on the retransmitted request does not
match the cached checksum, resulting in the server performing the
retransmitted request again instead of returning the cached reply.

The assumptions made when removing xdr_buf_trim() were not correct.
In the send paths, the upper layer has already set the segment
lengths correctly, and shorting the buffer's content is simply a
matter of reducing buf->len.

xdr_buf_trim() is the right answer in the receive/unwrap path on
both the client and the server. The buffer segment lengths have to
be shortened one-by-one.

On the server side in particular, head.iov_len needs to be updated
correctly to enable nfsd_cache_csum() to work correctly. The simple
buf->len computation doesn't do that, and that results in
checksumming stale data in the buffer.

The problem isn't noticed until there's significant instability of
the RPC transport. At that point, the reliability of retransmit
detection on the server becomes crucial.

Fixes: 241b1f419f0e ("SUNRPC: Remove xdr_buf_trim()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/xdr.h          |  1 +
 net/sunrpc/auth_gss/gss_krb5_wrap.c |  7 +++--
 net/sunrpc/auth_gss/svcauth_gss.c   |  2 +-
 net/sunrpc/xdr.c                    | 41 +++++++++++++++++++++++++++++
 4 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index b41f34977995..ae2b1449dc09 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -184,6 +184,7 @@ xdr_adjust_iovec(struct kvec *iov, __be32 *p)
 extern void xdr_shift_buf(struct xdr_buf *, size_t);
 extern void xdr_buf_from_iov(struct kvec *, struct xdr_buf *);
 extern int xdr_buf_subsegment(struct xdr_buf *, struct xdr_buf *, unsigned int, unsigned int);
+extern void xdr_buf_trim(struct xdr_buf *, unsigned int);
 extern int xdr_buf_read_mic(struct xdr_buf *, struct xdr_netobj *, unsigned int);
 extern int read_bytes_from_xdr_buf(struct xdr_buf *, unsigned int, void *, unsigned int);
 extern int write_bytes_to_xdr_buf(struct xdr_buf *, unsigned int, void *, unsigned int);
diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index 4905652e7567..cf0fd170ac18 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -580,15 +580,14 @@ gss_unwrap_kerberos_v2(struct krb5_ctx *kctx, int offset, int len,
 	 */
 	movelen = min_t(unsigned int, buf->head[0].iov_len, len);
 	movelen -= offset + GSS_KRB5_TOK_HDR_LEN + headskip;
-	if (offset + GSS_KRB5_TOK_HDR_LEN + headskip + movelen >
-	    buf->head[0].iov_len)
-		return GSS_S_FAILURE;
+	BUG_ON(offset + GSS_KRB5_TOK_HDR_LEN + headskip + movelen >
+							buf->head[0].iov_len);
 	memmove(ptr, ptr + GSS_KRB5_TOK_HDR_LEN + headskip, movelen);
 	buf->head[0].iov_len -= GSS_KRB5_TOK_HDR_LEN + headskip;
 	buf->len = len - GSS_KRB5_TOK_HDR_LEN + headskip;
 
 	/* Trim off the trailing "extra count" and checksum blob */
-	buf->len -= ec + GSS_KRB5_TOK_HDR_LEN + tailskip;
+	xdr_buf_trim(buf, ec + GSS_KRB5_TOK_HDR_LEN + tailskip);
 
 	*align = XDR_QUADLEN(GSS_KRB5_TOK_HDR_LEN + headskip);
 	*slack = *align + XDR_QUADLEN(ec + GSS_KRB5_TOK_HDR_LEN + tailskip);
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 559053646e12..322fd48887f9 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -900,7 +900,7 @@ unwrap_integ_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct g
 	if (svc_getnl(&buf->head[0]) != seq)
 		goto out;
 	/* trim off the mic and padding at the end before returning */
-	buf->len -= 4 + round_up_to_quad(mic.len);
+	xdr_buf_trim(buf, round_up_to_quad(mic.len) + 4);
 	stat = 0;
 out:
 	kfree(mic.data);
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index e5497dc2475b..f6da616267ce 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -1150,6 +1150,47 @@ xdr_buf_subsegment(struct xdr_buf *buf, struct xdr_buf *subbuf,
 }
 EXPORT_SYMBOL_GPL(xdr_buf_subsegment);
 
+/**
+ * xdr_buf_trim - lop at most "len" bytes off the end of "buf"
+ * @buf: buf to be trimmed
+ * @len: number of bytes to reduce "buf" by
+ *
+ * Trim an xdr_buf by the given number of bytes by fixing up the lengths. Note
+ * that it's possible that we'll trim less than that amount if the xdr_buf is
+ * too small, or if (for instance) it's all in the head and the parser has
+ * already read too far into it.
+ */
+void xdr_buf_trim(struct xdr_buf *buf, unsigned int len)
+{
+	size_t cur;
+	unsigned int trim = len;
+
+	if (buf->tail[0].iov_len) {
+		cur = min_t(size_t, buf->tail[0].iov_len, trim);
+		buf->tail[0].iov_len -= cur;
+		trim -= cur;
+		if (!trim)
+			goto fix_len;
+	}
+
+	if (buf->page_len) {
+		cur = min_t(unsigned int, buf->page_len, trim);
+		buf->page_len -= cur;
+		trim -= cur;
+		if (!trim)
+			goto fix_len;
+	}
+
+	if (buf->head[0].iov_len) {
+		cur = min_t(size_t, buf->head[0].iov_len, trim);
+		buf->head[0].iov_len -= cur;
+		trim -= cur;
+	}
+fix_len:
+	buf->len -= (len - trim);
+}
+EXPORT_SYMBOL_GPL(xdr_buf_trim);
+
 static void __read_bytes_from_xdr_buf(struct xdr_buf *subbuf, void *obj, unsigned int len)
 {
 	unsigned int this_len;
-- 
2.25.1

