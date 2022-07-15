Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A263576AE0
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiGOXzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGOXza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:55:30 -0400
X-Greylist: delayed 1768 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 16:55:29 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D958A904DA
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 16:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=j9ZK5/8em2J09Xvp8SH5yLZ1F2h2S7F/vFPCjrQUVs4=; b=Df7kV
        EVpO6S9AG0idczWFWt1AImgG2NplBHukeLmzSFnZC7zUX9wtEIcglKKRuUDg0dDKtj0lUvrMgimY5
        iu8Cq/F3i1AsiU7VVm3kbWR+hIXX/K+kCzrgLBAvgKH+597k30WnK3/NvoL1Lc9ghRBkKPAoiLGPE
        oW4wxluZEeFRB6Vfl2KZz9zwr9QZW9RGbjLTibWg4Gj9+I8h/aTwqvFUqMDJVgbKbkUkV7kVlddVS
        iN2oS40bmeTnHEwb/hkxWq5z+2MZCZqHvG56b9aNKr+wyIFjGTDyp5Hnk+jySSzmwIzxAVdwXs58y
        zcYn9dj+NvD+SszImuyieCMUqQQzA==;
Message-Id: <bd6be891cf67e867688e8c8796d06408bfafa0d9.1657920926.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657920926.git.linux_oss@crudebyte.com>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Fri, 15 Jul 2022 23:32:34 +0200
Subject: [PATCH v6 09/11] net/9p: add p9_msg_buf_size()
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new function calculates a buffer size suitable for holding the
intended 9p request or response. For rather small message types (which
applies to almost all 9p message types actually) simply use hard coded
values. For some variable-length and potentially large message types
calculate a more precise value according to what data is actually
transmitted to avoid unnecessarily huge buffers.

So p9_msg_buf_size() divides the individual 9p message types into 3
message size categories:

  - dynamically calculated message size (i.e. potentially large)
  - 8k hard coded message size
  - 4k hard coded message size

As for the latter two hard coded message types: for most 9p message
types it is pretty obvious whether they would always fit into 4k or
8k. But for some of them it depends on the maximum directory entry
name length allowed by OS and filesystem for determining into which
of the two size categories they would fit into. Currently Linux
supports directory entry names up to NAME_MAX (255), however when
comparing the limitation of individual filesystems, ReiserFS
theoretically supports up to slightly below 4k long names. So in
order to make this code more future proof, and as revisiting it
later on is a bit tedious and has the potential to miss out details,
the decision [1] was made to take 4k as basis as for max. name length.

Link: https://lore.kernel.org/all/5564296.oo812IJUPE@silver/ [1]
Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/protocol.c | 167 ++++++++++++++++++++++++++++++++++++++++++++++
 net/9p/protocol.h |   2 +
 2 files changed, 169 insertions(+)

diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 3754c33e2974..1b7fea87fbe9 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -23,6 +23,173 @@
 
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
+	static_assert(NAME_MAX <= 4*1024, "p9_msg_buf_size() currently assumes "
+				  "a max. allowed directory entry name length of 4k");
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
+			uint i, nwname = va_arg(ap, int);
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
+			if (c->proto_version == p9_proto_legacy) {
+				/* fid[4] name[s] perm[4] mode[1] */
+				return hdr + 4 + P9_STRLEN(name) + 4 + 1;
+			} else {
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
+			const char *oldname, *newname;
+			oldname = va_arg(ap, const char *);
+			va_arg(ap, int32_t);
+			newname = va_arg(ap, const char *);
+			/* olddirfid[4] oldname[s] newdirfid[4] newname[s] */
+			return hdr + 4 + P9_STRLEN(oldname) + 4 + P9_STRLEN(newname);
+		}
+	case P9_TSYMLINK:
+		BUG_ON(strcmp("dssg", fmt));
+		va_arg(ap, int32_t);
+		{
+			const char *name = va_arg(ap, const char *);
+			const char *symtgt = va_arg(ap, const char *);
+			/* fid[4] name[s] symtgt[s] gid[4] */
+			return hdr + 4 + P9_STRLEN(name) + P9_STRLEN(symtgt) + 4;
+		}
+
+	case P9_RERROR:
+		return rerror_size;
+	case P9_RLERROR:
+		return rlerror_size;
+
+	/* small message types */
+	case P9_TWSTAT:
+	case P9_RSTAT:
+	case P9_RREADLINK:
+	case P9_TXATTRWALK:
+	case P9_TXATTRCREATE:
+	case P9_TLINK:
+	case P9_TMKDIR:
+	case P9_TMKNOD:
+	case P9_TRENAME:
+	case P9_TUNLINKAT:
+	case P9_TLOCK:
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

