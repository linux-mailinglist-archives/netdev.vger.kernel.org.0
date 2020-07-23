Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3306822A813
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGWGJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgGWGJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31CEC0619E3;
        Wed, 22 Jul 2020 23:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jnNftkdWuHutn0l5/V2Gz6Qvt1s8tXbdDMQLxkwuHBo=; b=AHWMVgl+gZI3ppeRUJG22CnuN2
        mXsqGUtHr7hHIshIeM0BR3FDFu7P8hUJdDKWEDjaeFBPFzHAKS1/J2NqqrgVWAiWy0PDBIJV6MaAk
        gPot77jPYt8McodlLqHe4rYj1xwXIh3dwL7d5dP2a47D69tnzjzBjxRqbyL4qtqPcLy6LsSPLTz8/
        YOabKmimQamGM4cxDNfekHWNUuwVnDebo84hbzn4arDbH1CmgtyNxmN2OFQxyAhRHpoT37cldfrc6
        Ax/DteamlOzerpb/bK5cMQkwL7vWGfqduGUdI9Ez5lzvt3eBZC1+o7Ayqr6UYOa2Jd5AGGDGAZ45S
        4D3R2EfQ==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUPo-0003jj-5f; Thu, 23 Jul 2020 06:09:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 02/26] net/bpfilter: split __bpfilter_process_sockopt
Date:   Thu, 23 Jul 2020 08:08:44 +0200
Message-Id: <20200723060908.50081-3-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split __bpfilter_process_sockopt into a low-level send request routine and
the actual setsockopt hook to split the init time ping from the actual
setsockopt processing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/bpfilter/bpfilter_kern.c | 51 +++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 3bac5820062af1..78d561f2c54da7 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -31,48 +31,51 @@ static void __stop_umh(void)
 		shutdown_umh();
 }
 
-static int __bpfilter_process_sockopt(struct sock *sk, int optname,
-				      char __user *optval,
-				      unsigned int optlen, bool is_set)
+static int bpfilter_send_req(struct mbox_request *req)
 {
-	struct mbox_request req;
 	struct mbox_reply reply;
 	loff_t pos;
 	ssize_t n;
-	int ret = -EFAULT;
 
-	req.is_set = is_set;
-	req.pid = current->pid;
-	req.cmd = optname;
-	req.addr = (uintptr_t)optval;
-	req.len = optlen;
 	if (!bpfilter_ops.info.tgid)
-		goto out;
+		return -EFAULT;
 	pos = 0;
-	n = kernel_write(bpfilter_ops.info.pipe_to_umh, &req, sizeof(req),
+	n = kernel_write(bpfilter_ops.info.pipe_to_umh, req, sizeof(*req),
 			   &pos);
-	if (n != sizeof(req)) {
+	if (n != sizeof(*req)) {
 		pr_err("write fail %zd\n", n);
-		__stop_umh();
-		ret = -EFAULT;
-		goto out;
+		goto stop;
 	}
 	pos = 0;
 	n = kernel_read(bpfilter_ops.info.pipe_from_umh, &reply, sizeof(reply),
 			&pos);
 	if (n != sizeof(reply)) {
 		pr_err("read fail %zd\n", n);
-		__stop_umh();
-		ret = -EFAULT;
-		goto out;
+		goto stop;
 	}
-	ret = reply.status;
-out:
-	return ret;
+	return reply.status;
+stop:
+	__stop_umh();
+	return -EFAULT;
+}
+
+static int bpfilter_process_sockopt(struct sock *sk, int optname,
+				    char __user *optval, unsigned int optlen,
+				    bool is_set)
+{
+	struct mbox_request req = {
+		.is_set		= is_set,
+		.pid		= current->pid,
+		.cmd		= optname,
+		.addr		= (uintptr_t)optval,
+		.len		= optlen,
+	};
+	return bpfilter_send_req(&req);
 }
 
 static int start_umh(void)
 {
+	struct mbox_request req = { .pid = current->pid };
 	int err;
 
 	/* fork usermode process */
@@ -82,7 +85,7 @@ static int start_umh(void)
 	pr_info("Loaded bpfilter_umh pid %d\n", pid_nr(bpfilter_ops.info.tgid));
 
 	/* health check that usermode process started correctly */
-	if (__bpfilter_process_sockopt(NULL, 0, NULL, 0, 0) != 0) {
+	if (bpfilter_send_req(&req) != 0) {
 		shutdown_umh();
 		return -EFAULT;
 	}
@@ -103,7 +106,7 @@ static int __init load_umh(void)
 	mutex_lock(&bpfilter_ops.lock);
 	err = start_umh();
 	if (!err && IS_ENABLED(CONFIG_INET)) {
-		bpfilter_ops.sockopt = &__bpfilter_process_sockopt;
+		bpfilter_ops.sockopt = &bpfilter_process_sockopt;
 		bpfilter_ops.start = &start_umh;
 	}
 	mutex_unlock(&bpfilter_ops.lock);
-- 
2.27.0

