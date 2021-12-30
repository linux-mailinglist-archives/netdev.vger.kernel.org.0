Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEF7481D37
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhL3OmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:42:16 -0500
Received: from lizzy.crudebyte.com ([91.194.90.13]:39101 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240370AbhL3OmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:42:16 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 09:42:15 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=evr+Tviy1M3/uGNzt9x08PaZ+uzk9AbYvF3GmjxPwr4=; b=YYpul
        TIuY3Ae44CNKFXtylHgQiORXydPcCVIJSsX6Q78LOJ/cuqoXiJjl7IuVjxZ6sWz9v+JHlNF6xa3ta
        U9yK/FDl+pZXHPo2hGVyWNLdBvbh6hg7He1uVNj5/XIXW3fODUyY3HTKCTS7scrwPOF4Jm8aXkt9q
        oV2hcsBXZepRi76REA3RoBLnJwyxUdTPVH/2qcl7LcScCTXLPEpL3M0WckQ+emDDnTSwVEu2M5DdI
        HUcj6fBIitVb8eNbO931xu2Gp0Y+QqfdgKJ/5eyI8/76pB7V40YuPWMomVqH3/wy5Ip+K7rdpC9z/
        585UvSvxmSTv0L2QMD2AZzqxcyQsQ==;
Message-Id: <3d9eab8f55c8e4f036cbbf38bbdddb1c867432e7.1640870037.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1640870037.git.linux_oss@crudebyte.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 30 Dec 2021 14:23:18 +0100
Subject: [PATCH v4 11/12] net/9p: add p9_msg_buf_size()
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new function calculates a buffer size suitable for holding the
intended 9p request or response. For rather small message types (which
applies to almost all 9p message types actually) simply use hard coded
values. For some variable-length and potentially large message types
calculate a more precise value according to what data is actually
transmitted to avoid unnecessarily huge buffers.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/protocol.c | 154 ++++++++++++++++++++++++++++++++++++++++++++++
 net/9p/protocol.h |   2 +
 2 files changed, 156 insertions(+)

diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 3754c33e2974..49939e8cde2a 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -23,6 +23,160 @@
 
 #include <trace/events/9p.h>
 
+/* len[2] text[len] */
+#define P9_STRLEN(s) \
+	(2 + min_t(size_t, s ? strlen(s) : 0, USHRT_MAX))
+
+/**
+ * p9_msg_buf_size - Returns a buffer size sufficiently large to hold the
+ * intended 9p message.
+ * @c: client
+ * @type: message type
+ * @fmt: format template for assembling request message
+ * (see p9pdu_vwritef)
+ * @ap: variable arguments to be fed to passed format template
+ * (see p9pdu_vwritef)
+ *
+ * Note: Even for response types (P9_R*) the format template and variable
+ * arguments must always be for the originating request type (P9_T*).
+ */
+size_t p9_msg_buf_size(struct p9_client *c, enum p9_msg_t type,
+			const char *fmt, va_list ap)
+{
+	/* size[4] type[1] tag[2] */
+	const int hdr = 4 + 1 + 2;
+	/* ename[s] errno[4] */
+	const int rerror_size = hdr + P9_ERRMAX + 4;
+	/* ecode[4] */
+	const int rlerror_size = hdr + 4;
+	const int err_size =
+		c->proto_version == p9_proto_2000L ? rlerror_size : rerror_size;
+
+	switch (type) {
+
+	/* message types not used at all */
+	case P9_TERROR:
+	case P9_TLERROR:
+	case P9_TAUTH:
+	case P9_RAUTH:
+		BUG();
+
+	/* variable length & potentially large message types */
+	case P9_TATTACH:
+		BUG_ON(strcmp("ddss?u", fmt));
+		va_arg(ap, int32_t);
+		va_arg(ap, int32_t);
+		{
+			const char *uname = va_arg(ap, const char *);
+			const char *aname = va_arg(ap, const char *);
+			/* fid[4] afid[4] uname[s] aname[s] n_uname[4] */
+			return hdr + 4 + 4 + P9_STRLEN(uname) + P9_STRLEN(aname) + 4;
+		}
+	case P9_TWALK:
+		BUG_ON(strcmp("ddT", fmt));
+		va_arg(ap, int32_t);
+		va_arg(ap, int32_t);
+		{
+			uint i, nwname = max(va_arg(ap, int), 0);
+			size_t wname_all;
+			const char **wnames = va_arg(ap, const char **);
+			for (i = 0, wname_all = 0; i < nwname; ++i) {
+				wname_all += P9_STRLEN(wnames[i]);
+			}
+			/* fid[4] newfid[4] nwname[2] nwname*(wname[s]) */
+			return hdr + 4 + 4 + 2 + wname_all;
+		}
+	case P9_RWALK:
+		BUG_ON(strcmp("ddT", fmt));
+		va_arg(ap, int32_t);
+		va_arg(ap, int32_t);
+		{
+			uint nwname = va_arg(ap, int);
+			/* nwqid[2] nwqid*(wqid[13]) */
+			return max_t(size_t, hdr + 2 + nwname * 13, err_size);
+		}
+	case P9_TCREATE:
+		BUG_ON(strcmp("dsdb?s", fmt));
+		va_arg(ap, int32_t);
+		{
+			const char *name = va_arg(ap, const char *);
+			if ((c->proto_version != p9_proto_2000u) &&
+			    (c->proto_version != p9_proto_2000L))
+				/* fid[4] name[s] perm[4] mode[1] */
+				return hdr + 4 + P9_STRLEN(name) + 4 + 1;
+			{
+				va_arg(ap, int32_t);
+				va_arg(ap, int);
+				{
+					const char *ext = va_arg(ap, const char *);
+					/* fid[4] name[s] perm[4] mode[1] extension[s] */
+					return hdr + 4 + P9_STRLEN(name) + 4 + 1 + P9_STRLEN(ext);
+				}
+			}
+		}
+	case P9_TLCREATE:
+		BUG_ON(strcmp("dsddg", fmt));
+		va_arg(ap, int32_t);
+		{
+			const char *name = va_arg(ap, const char *);
+			/* fid[4] name[s] flags[4] mode[4] gid[4] */
+			return hdr + 4 + P9_STRLEN(name) + 4 + 4 + 4;
+		}
+	case P9_RREAD:
+	case P9_RREADDIR:
+		BUG_ON(strcmp("dqd", fmt));
+		va_arg(ap, int32_t);
+		va_arg(ap, int64_t);
+		{
+			const int32_t count = va_arg(ap, int32_t);
+			/* count[4] data[count] */
+			return max_t(size_t, hdr + 4 + count, err_size);
+		}
+	case P9_TWRITE:
+		BUG_ON(strcmp("dqV", fmt));
+		va_arg(ap, int32_t);
+		va_arg(ap, int64_t);
+		{
+			const int32_t count = va_arg(ap, int32_t);
+			/* fid[4] offset[8] count[4] data[count] */
+			return hdr + 4 + 8 + 4 + count;
+		}
+	case P9_TRENAMEAT:
+		BUG_ON(strcmp("dsds", fmt));
+		va_arg(ap, int32_t);
+		{
+			const char *oldname = va_arg(ap, const char *);
+			va_arg(ap, int32_t);
+			{
+				const char *newname = va_arg(ap, const char *);
+				/* olddirfid[4] oldname[s] newdirfid[4] newname[s] */
+				return hdr + 4 + P9_STRLEN(oldname) + 4 + P9_STRLEN(newname);
+			}
+		}
+	case P9_RERROR:
+		return rerror_size;
+	case P9_RLERROR:
+		return rlerror_size;
+
+	/* small message types */
+	case P9_TSTAT:
+	case P9_RSTAT:
+	case P9_TSYMLINK:
+	case P9_RREADLINK:
+	case P9_TXATTRWALK:
+	case P9_TXATTRCREATE:
+	case P9_TLINK:
+	case P9_TMKDIR:
+	case P9_TUNLINKAT:
+		return 8 * 1024;
+
+	/* tiny message types */
+	default:
+		return 4 * 1024;
+
+	}
+}
+
 static int
 p9pdu_writef(struct p9_fcall *pdu, int proto_version, const char *fmt, ...);
 
diff --git a/net/9p/protocol.h b/net/9p/protocol.h
index 6d719c30331a..ad2283d1f96b 100644
--- a/net/9p/protocol.h
+++ b/net/9p/protocol.h
@@ -8,6 +8,8 @@
  *  Copyright (C) 2008 by IBM, Corp.
  */
 
+size_t p9_msg_buf_size(struct p9_client *c, enum p9_msg_t type,
+			const char *fmt, va_list ap);
 int p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
 		  va_list ap);
 int p9pdu_readf(struct p9_fcall *pdu, int proto_version, const char *fmt, ...);
-- 
2.30.2

