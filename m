Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638A9320E93
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 00:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhBUXpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 18:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbhBUXpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 18:45:10 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1352C061786
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 15:44:30 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o7so9142339pgl.1
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 15:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=4y5ahYpWQ+mJo0lx9mXLeA6gZ8fH/D4QLJvMkUa/Y/U=;
        b=Jng4yS5SLPtMPxYkGO3H3Qi0/QoxlTc5hPuPJ3Ew0xeOzWqZJb0WSGn46U/HGbvy2+
         vu1gmekIK24Nz2o8UMfVQi1MgCS3MDSBbAoShmRKOhbwHws2XiIMdA0SZZO2AtYaHxFk
         BoQqXUs4irjgFFPToVdTL3pX/bG4w2UV4+cDiW6beDdztBcXC4cuyOp9xroakC/GHEUx
         Pk+YD4/p4/EMJhqjP/3zjsqQ7GLQaPQBpCfp7AO8zR/5xLuVTKssk6qZ57VOXpJ8K/1P
         /nHlI7zmy0pIuELnc7VVUaki+YIcfNEOTkwv76wt0NkCfAB0ztduSu4rfNblVg2cTrfC
         LJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4y5ahYpWQ+mJo0lx9mXLeA6gZ8fH/D4QLJvMkUa/Y/U=;
        b=q40LxXYa+U1Junw6T2V/DpveCwX3lh+qC9tAPMCS/dCD605iGxvPqKjKbQIIEzWU4Y
         AqmjJu85N/jB6knsAKOZfOzA51HiYEuKWST5gejplqwhyKuZVh+heJNXMLSj7/AZ0uEw
         Bw+W5Lpgoq3kDJHRqb8va8L56tPuGZU8MUl2pwVbDI/+Ixf8u5QO4TbOy8potlHmFtJx
         fi39c9C5t9UEm4BLd3uLmVInjHDLmya5ILIbc5o0QVqMVWsTDtc3fr0c6KRbVSvaXqJb
         3vOjvcluGtSYuf22AatsWxcQiGuGXG/cf+ZdBvnDvApD6B+YGXBfaS7WmfWPd1w2NQbS
         GpIQ==
X-Gm-Message-State: AOAM533SzH3sTcj0ogy86BKgkr6sVc++88mXmyrw123fDWYRMI0LcUMN
        9xcbT+HctI4xS5o6efMAWg==
X-Google-Smtp-Source: ABdhPJxAo4vfZV5GNbQ3ZOfBf7+YdjTEAFNvFUnz/SaPbfs3bc31068F1V8q2OvUVa8lrHhU52Farg==
X-Received: by 2002:a63:1c1d:: with SMTP id c29mr18153145pgc.94.1613951070430;
        Sun, 21 Feb 2021 15:44:30 -0800 (PST)
Received: from DESKTOP (softbank126011114100.bbtec.net. [126.11.114.100])
        by smtp.gmail.com with ESMTPSA id x13sm16255931pfq.34.2021.02.21.15.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 15:44:30 -0800 (PST)
Date:   Mon, 22 Feb 2021 08:44:27 +0900
From:   Takeshi Misawa <jeliantsurux@gmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org
Subject: [PATCH net] net: qrtr: Fix memory leak in qrtr_tun_open
Message-ID: <20210221234427.GA2140@DESKTOP>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If qrtr_endpoint_register() failed, tun is leaked.
Fix this, by freeing tun in error path.

syzbot report:
BUG: memory leak
unreferenced object 0xffff88811848d680 (size 64):
  comm "syz-executor684", pid 10171, jiffies 4294951561 (age 26.070s)
  hex dump (first 32 bytes):
    80 dd 0a 84 ff ff ff ff 00 00 00 00 00 00 00 00  ................
    90 d6 48 18 81 88 ff ff 90 d6 48 18 81 88 ff ff  ..H.......H.....
  backtrace:
    [<0000000018992a50>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000018992a50>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000018992a50>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<0000000003a453ef>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000dec38ac8>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<0000000079094996>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<000000004096d290>] do_open fs/namei.c:3252 [inline]
    [<000000004096d290>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8e64241>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<00000000a3299422>] do_sys_openat2+0xed/0x230 fs/open.c:1172
    [<000000002c1bdcef>] do_sys_open fs/open.c:1188 [inline]
    [<000000002c1bdcef>] __do_sys_openat fs/open.c:1204 [inline]
    [<000000002c1bdcef>] __se_sys_openat fs/open.c:1199 [inline]
    [<000000002c1bdcef>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1199
    [<00000000f3a5728f>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000004b38b7ec>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 28fb4e59a47d ("net: qrtr: Expose tunneling endpoint to user space")
Reported-by: syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
---
Dear David Howells

syzbot reported memory leak in qrtr_tun_open.

I send a patch that passed syzbot reproducer test.
Please consider this memory leak and patch.

syzbot link:
https://syzkaller.appspot.com/bug?id=e2f0676dd0bb3d0e83184bfcaa2bcba46b1410b5

Regards.
---
 net/qrtr/tun.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
index 15ce9b642b25..20d60a78590a 100644
--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -31,6 +31,7 @@ static int qrtr_tun_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 static int qrtr_tun_open(struct inode *inode, struct file *filp)
 {
 	struct qrtr_tun *tun;
+	int ret;
 
 	tun = kzalloc(sizeof(*tun), GFP_KERNEL);
 	if (!tun)
@@ -43,7 +44,17 @@ static int qrtr_tun_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = tun;
 
-	return qrtr_endpoint_register(&tun->ep, QRTR_EP_NID_AUTO);
+	ret = qrtr_endpoint_register(&tun->ep, QRTR_EP_NID_AUTO);
+	if (ret) {
+		goto out;
+	}
+
+	return ret;
+
+out:
+	filp->private_data = NULL;
+	kfree(tun);
+	return ret;
 }
 
 static ssize_t qrtr_tun_read_iter(struct kiocb *iocb, struct iov_iter *to)
-- 
2.25.1

