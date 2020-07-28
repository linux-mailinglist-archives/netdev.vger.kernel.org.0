Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B5D230AA3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbgG1Mu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:50:59 -0400
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:37816 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1729562AbgG1Mu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 08:50:58 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id EDB48AE800ED;
        Tue, 28 Jul 2020 08:38:56 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     v9fs-developer@lists.sourceforge.net
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH kernel] 9p/trans_fd: Check file mode at opening
Date:   Tue, 28 Jul 2020 22:41:29 +1000
Message-Id: <20200728124129.130856-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "fd" transport layer uses 2 file descriptors passed externally
and calls kernel_write()/kernel_read() on these. If files were opened
without FMODE_WRITE/FMODE_READ, WARN_ON_ONCE() will fire.

This adds file mode checking in p9_fd_open; this returns -EBADF to
preserve the original behavior.

Found by syzkaller.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 net/9p/trans_fd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 13cd683a658a..62cdfbd01f0a 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -797,6 +797,7 @@ static int parse_opts(char *params, struct p9_fd_opts *opts)
 
 static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
 {
+	bool perm;
 	struct p9_trans_fd *ts = kzalloc(sizeof(struct p9_trans_fd),
 					   GFP_KERNEL);
 	if (!ts)
@@ -804,12 +805,16 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
 
 	ts->rd = fget(rfd);
 	ts->wr = fget(wfd);
-	if (!ts->rd || !ts->wr) {
+	perm = ts->rd && (ts->rd->f_mode & FMODE_READ) &&
+	       ts->wr && (ts->wr->f_mode & FMODE_WRITE);
+	if (!ts->rd || !ts->wr || !perm) {
 		if (ts->rd)
 			fput(ts->rd);
 		if (ts->wr)
 			fput(ts->wr);
 		kfree(ts);
+		if (!perm)
+			return -EBADF;
 		return -EIO;
 	}
 
-- 
2.17.1

