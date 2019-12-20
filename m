Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2530B127D4A
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 15:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfLTOau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 09:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfLTOat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D41124684;
        Fri, 20 Dec 2019 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852248;
        bh=5fQWw3Pf9jDvzny+heHuY3ldUi2oJPZL7MGzXD+p5rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lgQ1rOyi74lvu6O2Kh2AaIEcIvKHLG2zCLz024PmyLoKtZN4EViGQKZMOrSqIhuTc
         zN/g9TZD0Gpch+ViABW0ZpU3MaadvJW6P6fjOSUnPbmxIpGtBetgiuFq3eGNYf6+wc
         KGk1Zlqfc2lNdbkCHrRwHzut7tswr7gnWo5gQKcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 40/52] net: make socket read/write_iter() honor IOCB_NOWAIT
Date:   Fri, 20 Dec 2019 09:29:42 -0500
Message-Id: <20191220142954.9500-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit ebfcd8955c0b52eb793bcbc9e71140e3d0cdb228 ]

The socket read/write helpers only look at the file O_NONBLOCK. not
the iocb IOCB_NOWAIT flag. This breaks users like preadv2/pwritev2
and io_uring that rely on not having the file itself marked nonblocking,
but rather the iocb itself.

Cc: netdev@vger.kernel.org
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index d7a106028f0e0..ca8de9e1582d9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -955,7 +955,7 @@ static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			     .msg_iocb = iocb};
 	ssize_t res;
 
-	if (file->f_flags & O_NONBLOCK)
+	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
 		msg.msg_flags = MSG_DONTWAIT;
 
 	if (iocb->ki_pos != 0)
@@ -980,7 +980,7 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos != 0)
 		return -ESPIPE;
 
-	if (file->f_flags & O_NONBLOCK)
+	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
 		msg.msg_flags = MSG_DONTWAIT;
 
 	if (sock->type == SOCK_SEQPACKET)
-- 
2.20.1

