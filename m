Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BC31539A2
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 21:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgBEUlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 15:41:14 -0500
Received: from mx1.cock.li ([185.10.68.5]:45703 "EHLO cock.li"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbgBEUlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 15:41:13 -0500
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on cock.li
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NO_RECEIVED,NO_RELAYS shortcircuit=_SCTYPE_
        autolearn=disabled version=3.4.2
From:   Sergey Alirzaev <l29ah@cock.li>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cock.li; s=mail;
        t=1580935270; bh=ntRFvU3hcsMEE34oypcg9/W6Ep/xOHm+MQXdA0Es7h4=;
        h=From:To:Cc:Subject:Date:From;
        b=NW7pcRwCupXSD4j8s711wENm+UqaKYaVIKzE4QcwCDYYhcWJmDlASquy90LYs00Wr
         n515bEcisaEFfsw8CAxCbBakEl7EHaAgYB17BtTVG9hMcCzEydQTVKw/847pytpLiY
         qLMLrvl5DePK1tWkqygcuVe3zig4jJAYWgtDCdhKwqumZOOMpa6U7kT+k3iRZiEcRX
         ABKl30NZVG+ytvPOVg0h3OFYGja/ZnFFJKC1+iHEEY6DcoKtHYWz4xF22JMPXNChYT
         tf2x3PyS1OcxHRipU7rQG7ZmBmHtmvF3JEZvsN3is1Ozk9cu1YNgZb7SlD5uuJ1YX0
         XxoGy8oxzjguA==
To:     v9fs-developer@lists.sourceforge.net
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sergey Alirzaev <l29ah@cock.li>
Subject: [PATCH] 9pnet: allow making incomplete read requests
Date:   Wed,  5 Feb 2020 23:40:53 +0300
Message-Id: <20200205204053.12751-1-l29ah@cock.li>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user doesn't necessarily want to wait for all the requested data to
be available, since the waiting time for each request is unbounded.

The new method permits sending one read request at a time and getting
the response ASAP, allowing to use 9pnet with synthetic file systems
representing arbitrary data streams.

Signed-off-by: Sergey Alirzaev <l29ah@cock.li>
---
 include/net/9p/client.h |   2 +
 net/9p/client.c         | 135 ++++++++++++++++++++++------------------
 2 files changed, 76 insertions(+), 61 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index acc60d8a3b3b..f6c890e94f87 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -200,6 +200,8 @@ int p9_client_fsync(struct p9_fid *fid, int datasync);
 int p9_client_remove(struct p9_fid *fid);
 int p9_client_unlinkat(struct p9_fid *dfid, const char *name, int flags);
 int p9_client_read(struct p9_fid *fid, u64 offset, struct iov_iter *to, int *err);
+int p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
+		int *err);
 int p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err);
 int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset);
 int p9dirent_read(struct p9_client *clnt, char *buf, int len,
diff --git a/net/9p/client.c b/net/9p/client.c
index 1d48afc7033c..240d7c05b282 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1549,82 +1549,95 @@ EXPORT_SYMBOL(p9_client_unlinkat);
 int
 p9_client_read(struct p9_fid *fid, u64 offset, struct iov_iter *to, int *err)
 {
-	struct p9_client *clnt = fid->clnt;
-	struct p9_req_t *req;
 	int total = 0;
 	*err = 0;
 
+	while (iov_iter_count(to)) {
+		int count;
+
+		count = p9_client_read_once(fid, offset, to, err);
+		if (!count || *err)
+			break;
+		offset += count;
+		total += count;
+	}
+	return total;
+}
+EXPORT_SYMBOL(p9_client_read);
+
+int
+p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
+		    int *err)
+{
+	struct p9_client *clnt = fid->clnt;
+	struct p9_req_t *req;
+	int count = iov_iter_count(to);
+	int rsize, non_zc = 0;
+	char *dataptr;
+
+	*err = 0;
 	p9_debug(P9_DEBUG_9P, ">>> TREAD fid %d offset %llu %d\n",
 		   fid->fid, (unsigned long long) offset, (int)iov_iter_count(to));
 
-	while (iov_iter_count(to)) {
-		int count = iov_iter_count(to);
-		int rsize, non_zc = 0;
-		char *dataptr;
+	rsize = fid->iounit;
+	if (!rsize || rsize > clnt->msize - P9_IOHDRSZ)
+		rsize = clnt->msize - P9_IOHDRSZ;
 
-		rsize = fid->iounit;
-		if (!rsize || rsize > clnt->msize-P9_IOHDRSZ)
-			rsize = clnt->msize - P9_IOHDRSZ;
+	if (count < rsize)
+		rsize = count;
 
-		if (count < rsize)
-			rsize = count;
+	/* Don't bother zerocopy for small IO (< 1024) */
+	if (clnt->trans_mod->zc_request && rsize > 1024) {
+		/* response header len is 11
+		 * PDU Header(7) + IO Size (4)
+		 */
+		req = p9_client_zc_rpc(clnt, P9_TREAD, to, NULL, rsize,
+				       0, 11, "dqd", fid->fid,
+				       offset, rsize);
+	} else {
+		non_zc = 1;
+		req = p9_client_rpc(clnt, P9_TREAD, "dqd", fid->fid, offset,
+				    rsize);
+	}
+	if (IS_ERR(req)) {
+		*err = PTR_ERR(req);
+		return 0;
+	}
 
-		/* Don't bother zerocopy for small IO (< 1024) */
-		if (clnt->trans_mod->zc_request && rsize > 1024) {
-			/*
-			 * response header len is 11
-			 * PDU Header(7) + IO Size (4)
-			 */
-			req = p9_client_zc_rpc(clnt, P9_TREAD, to, NULL, rsize,
-					       0, 11, "dqd", fid->fid,
-					       offset, rsize);
-		} else {
-			non_zc = 1;
-			req = p9_client_rpc(clnt, P9_TREAD, "dqd", fid->fid, offset,
-					    rsize);
-		}
-		if (IS_ERR(req)) {
-			*err = PTR_ERR(req);
-			break;
-		}
+	*err = p9pdu_readf(&req->rc, clnt->proto_version,
+			   "D", &count, &dataptr);
+	if (*err) {
+		trace_9p_protocol_dump(clnt, &req->rc);
+		p9_tag_remove(clnt, req);
+		return 0;
+	}
+	if (rsize < count) {
+		pr_err("bogus RREAD count (%d > %d)\n", count, rsize);
+		count = rsize;
+	}
 
-		*err = p9pdu_readf(&req->rc, clnt->proto_version,
-				   "D", &count, &dataptr);
-		if (*err) {
-			trace_9p_protocol_dump(clnt, &req->rc);
-			p9_tag_remove(clnt, req);
-			break;
-		}
-		if (rsize < count) {
-			pr_err("bogus RREAD count (%d > %d)\n", count, rsize);
-			count = rsize;
-		}
+	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
+	if (!count) {
+		p9_tag_remove(clnt, req);
+		return 0;
+	}
 
-		p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
-		if (!count) {
-			p9_tag_remove(clnt, req);
-			break;
-		}
+	if (non_zc) {
+		int n = copy_to_iter(dataptr, count, to);
 
-		if (non_zc) {
-			int n = copy_to_iter(dataptr, count, to);
-			total += n;
-			offset += n;
-			if (n != count) {
-				*err = -EFAULT;
-				p9_tag_remove(clnt, req);
-				break;
-			}
-		} else {
-			iov_iter_advance(to, count);
-			total += count;
-			offset += count;
+		if (n != count) {
+			*err = -EFAULT;
+			p9_tag_remove(clnt, req);
+			return n;
 		}
-		p9_tag_remove(clnt, req);
+	} else {
+		iov_iter_advance(to, count);
+		count;
 	}
-	return total;
+	p9_tag_remove(clnt, req);
+	return count;
 }
-EXPORT_SYMBOL(p9_client_read);
+EXPORT_SYMBOL(p9_client_read_once);
 
 int
 p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
-- 
2.25.0

