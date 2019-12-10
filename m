Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 482CF118D1E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 16:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLJP6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 10:58:01 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35880 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfLJP6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 10:58:00 -0500
Received: by mail-io1-f65.google.com with SMTP id a22so4349522ios.3
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 07:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nvur1Bj3nl4CLr5ek2z8ES9n5dJyB/sJxmpMaueCmiY=;
        b=e3aSf/KXcc+AR+5F42eoJ4K1Y2VE+DmXZfc8211Yl+ii6+BkV2EHRLFgezbj+bslIo
         K5gCrJamxlce19s/mXb6qeDZVnKPk4dpEHLV6o7tx+dyofzWfxf2b7kQRwpLVqIvnxdF
         gGNGyCuFsOeTXpHF27AraAsjOmWZ9OwdBft9IDLqNoviNAsd8exGQxadRomEYCWm1Abp
         j1Q++Ul5RaS+opJNko4bRKWkqrXFS5U2nHt4m2FPtqYIFanI7Lu6Yx/1cBVRWOs+/vd7
         TF57Wmz2SPy73NxVNQhJDXpAEDNbzPbNroa1oJHmmjay1m+37RrX9PaMGIV8QfgGdR2o
         XaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nvur1Bj3nl4CLr5ek2z8ES9n5dJyB/sJxmpMaueCmiY=;
        b=CdwPguvw8xFu4vc/8z6KTXL1jTe6BReDqPunK75Y6afCpHfJ1bfWZmXBdmJBvzn8f2
         yhf0LDy9edOymD1Eh17nk6TzzD8P5usmKfVqZlfPI9jlZp6OvUvUOPXPgZpT86uca5YS
         xWJ64bOo2LLORjD/eVcxEpK2pPpV+JhQdcIDBpwqeumPo3MzwNOePKGPCjzefDmHck+w
         NFwgUXOHylWpYxsQhmrE94VrCa1ByxRP4lUuWTNuzeItXY5I+ABWO5rpD1Eoa3PcOvn0
         FBLwAPAt2ofpGQaaOAHL0R+qAfU+2xIFKspPs/v6F3aLjgWvcPCi3ijaPozpKUNGY/4D
         ZFuw==
X-Gm-Message-State: APjAAAWox5ykNvjIgOgFdc419P9iVT0G5hLP/3SSHuKzlV7i+hjJaEWX
        tcsiLxbA8bf5skEiYgnnRbPkojUNV8Q4Lw==
X-Google-Smtp-Source: APXvYqxKQvNZgQMaZ1zbKTgPZjIlZzKeGlZBWxsFUmJz/xTnPkB1O/4ZUq6YhzBH9YTtTw7n9ygIoQ==
X-Received: by 2002:a02:cd3b:: with SMTP id h27mr15035171jaq.18.1575993479974;
        Tue, 10 Dec 2019 07:57:59 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w6sm770953ioa.16.2019.12.10.07.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 07:57:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 10/11] net: make socket read/write_iter() honor IOCB_NOWAIT
Date:   Tue, 10 Dec 2019 08:57:41 -0700
Message-Id: <20191210155742.5844-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210155742.5844-1-axboe@kernel.dk>
References: <20191210155742.5844-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The socket read/write helpers only look at the file O_NONBLOCK. not
the iocb IOCB_NOWAIT flag. This breaks users like preadv2/pwritev2
and io_uring that rely on not having the file itself marked nonblocking,
but rather the iocb itself.

Cc: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 net/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index b343db1489bd..b116e58d6438 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -957,7 +957,7 @@ static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			     .msg_iocb = iocb};
 	ssize_t res;
 
-	if (file->f_flags & O_NONBLOCK)
+	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
 		msg.msg_flags = MSG_DONTWAIT;
 
 	if (iocb->ki_pos != 0)
@@ -982,7 +982,7 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos != 0)
 		return -ESPIPE;
 
-	if (file->f_flags & O_NONBLOCK)
+	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
 		msg.msg_flags = MSG_DONTWAIT;
 
 	if (sock->type == SOCK_SEQPACKET)
-- 
2.24.0

