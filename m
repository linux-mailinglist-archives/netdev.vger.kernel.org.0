Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAE32CD6F1
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436793AbgLCNa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:30:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436780AbgLCNaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:55 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/23] tun: honor IOCB_NOWAIT flag
Date:   Thu,  3 Dec 2020 08:29:23 -0500
Message-Id: <20201203132935.931362-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132935.931362-1-sashal@kernel.org>
References: <20201203132935.931362-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5aac0390a63b8718237a61dd0d24a29201d1c94a ]

tun only checks the file O_NONBLOCK flag, but it should also be checking
the iocb IOCB_NOWAIT flag. Any fops using ->read/write_iter() should check
both, otherwise it breaks users that correctly expect O_NONBLOCK semantics
if IOCB_NOWAIT is set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/e9451860-96cc-c7c7-47b8-fe42cadd5f4c@kernel.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 46bdd0df2eb8b..e72d273999834 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2028,12 +2028,15 @@ static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = tun_get(tfile);
 	ssize_t result;
+	int noblock = 0;
 
 	if (!tun)
 		return -EBADFD;
 
-	result = tun_get_user(tun, tfile, NULL, from,
-			      file->f_flags & O_NONBLOCK, false);
+	if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
+		noblock = 1;
+
+	result = tun_get_user(tun, tfile, NULL, from, noblock, false);
 
 	tun_put(tun);
 	return result;
@@ -2254,10 +2257,15 @@ static ssize_t tun_chr_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = tun_get(tfile);
 	ssize_t len = iov_iter_count(to), ret;
+	int noblock = 0;
 
 	if (!tun)
 		return -EBADFD;
-	ret = tun_do_read(tun, tfile, to, file->f_flags & O_NONBLOCK, NULL);
+
+	if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
+		noblock = 1;
+
+	ret = tun_do_read(tun, tfile, to, noblock, NULL);
 	ret = min_t(ssize_t, ret, len);
 	if (ret > 0)
 		iocb->ki_pos = ret;
-- 
2.27.0

