Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A1415241A
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 01:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgBEAfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 19:35:50 -0500
Received: from mx1.cock.li ([185.10.68.5]:37377 "EHLO cock.li"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727714AbgBEAfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 19:35:48 -0500
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on cock.li
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NO_RECEIVED,NO_RELAYS shortcircuit=_SCTYPE_
        autolearn=disabled version=3.4.2
From:   Sergey Alirzaev <l29ah@cock.li>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cock.li; s=mail;
        t=1580862943; bh=nAV3l3sUTQpml1uNYZHfn/7ytdaY9Tyf+4SAhK9kxa4=;
        h=From:To:Cc:Subject:Date:From;
        b=FBI/CC4625dbP+d0Eo79S69mfRAfHxDp75pBmTbWpy5tOBE9MZ2ioSgE8cMqE3T+0
         nfgeRlAxaRMzXspuWGP1r/SUVqUb/v6fj5xNxE3kbMg7XPyk38ekpt1OvJ0ffaTvg8
         iDKzSIpqrGCJFQgnk+zuiEAuRUOXlUKGHQ9x+rtd/+q6m8Rin4h8EXPq9Q8lbLuwqJ
         fqpFsa03Q/Q/zKrS5T/5aRg51w7XaP0wuJ1h7hoEoxhoAihhHDNz1BeUMNgj0VtIFR
         YsCn8k1AjVAzHD77EpAq4JvsYZfYEnTAr07IetkIn8c+q7np4ZfrZfseKrwHuvh2lS
         5CwPmtciFXD5A==
To:     v9fs-developer@lists.sourceforge.net
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sergey Alirzaev <l29ah@cock.li>
Subject: [PATCH 1/2] 9pnet: allow making incomplete read requests
Date:   Wed,  5 Feb 2020 03:34:56 +0300
Message-Id: <20200205003457.24340-1-l29ah@cock.li>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user doesn't necessarily want to wait for all the requested data to
be available, since the waiting time is unbounded.

Signed-off-by: Sergey Alirzaev <l29ah@cock.li>
---
 include/net/9p/client.h |   2 +
 net/9p/client.c         | 133 ++++++++++++++++++++++------------------
 2 files changed, 76 insertions(+), 59 deletions(-)

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
index 1d48afc7033c..186f5b44aa01 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1548,83 +1548,98 @@ EXPORT_SYMBOL(p9_client_unlinkat);
 
 int
 p9_client_read(struct p9_fid *fid, u64 offset, struct iov_iter *to, int *err)
+{
+	int total = 0;
+	*err = 0;
+
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
 {
 	struct p9_client *clnt = fid->clnt;
 	struct p9_req_t *req;
 	int total = 0;
-	*err = 0;
+	int count = iov_iter_count(to);
+	int rsize, non_zc = 0;
+	char *dataptr;
 
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
+		return total;
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
+		return total;
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
+		return total;
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
+		total += n;
+		if (n != count) {
+			*err = -EFAULT;
+			p9_tag_remove(clnt, req);
+			return total;
 		}
-		p9_tag_remove(clnt, req);
+	} else {
+		iov_iter_advance(to, count);
+		total += count;
 	}
+	p9_tag_remove(clnt, req);
 	return total;
 }
-EXPORT_SYMBOL(p9_client_read);
+EXPORT_SYMBOL(p9_client_read_once);
 
 int
 p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
-- 
2.25.0

