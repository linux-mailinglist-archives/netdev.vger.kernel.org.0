Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999A9601F40
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 02:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiJRARW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 20:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiJRAP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 20:15:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21B287F8A;
        Mon, 17 Oct 2022 17:12:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E274E61353;
        Tue, 18 Oct 2022 00:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD022C433C1;
        Tue, 18 Oct 2022 00:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051935;
        bh=Eql+yWMZQH0M/qqw+PqyFRlpY2UZXVOTf+3EGVc8Lt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pa7Gp/071oT+1dE/KdePmDETwEZ2Y4ab+/Twe8Vfnkl0dAu1mAOQz6CaU2QSnDYoo
         +si1ht7DkDZB8RNHnGRwsDTqRjToQduA2xlpTpa89hTvmvmi1CTFvlStm2uzWPKsHJ
         WQhzWH/ByJTNfe3AUjz/IE/k3srUSGHZyztF8Va3yOUxPd51IAzgMnkma5ByEfer2n
         Ib1C2LeeZX5flfeRxOR340Vp6J6H2eD+c2L2CBCANVLjg2k5OgY3CvPGsUUElX8wNp
         VmZ9+g0ajdqzMRwp3nMZwSzMIN4d/3WKjTVFSWnxUSd8c1YF1ps2U5pMbEYi05SV35
         6zwwVrcg75Kfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 7/8] 9p/trans_fd: always use O_NONBLOCK read/write
Date:   Mon, 17 Oct 2022 20:12:01 -0400
Message-Id: <20221018001202.2732458-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001202.2732458-1-sashal@kernel.org>
References: <20221018001202.2732458-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit ef575281b21e9a34dfae544a187c6aac2ae424a9 ]

syzbot is reporting hung task at p9_fd_close() [1], for p9_mux_poll_stop()
 from p9_conn_destroy() from p9_fd_close() is failing to interrupt already
started kernel_read() from p9_fd_read() from p9_read_work() and/or
kernel_write() from p9_fd_write() from p9_write_work() requests.

Since p9_socket_open() sets O_NONBLOCK flag, p9_mux_poll_stop() does not
need to interrupt kernel_read()/kernel_write(). However, since p9_fd_open()
does not set O_NONBLOCK flag, but pipe blocks unless signal is pending,
p9_mux_poll_stop() needs to interrupt kernel_read()/kernel_write() when
the file descriptor refers to a pipe. In other words, pipe file descriptor
needs to be handled as if socket file descriptor.

We somehow need to interrupt kernel_read()/kernel_write() on pipes.

A minimal change, which this patch is doing, is to set O_NONBLOCK flag
 from p9_fd_open(), for O_NONBLOCK flag does not affect reading/writing
of regular files. But this approach changes O_NONBLOCK flag on userspace-
supplied file descriptors (which might break userspace programs), and
O_NONBLOCK flag could be changed by userspace. It would be possible to set
O_NONBLOCK flag every time p9_fd_read()/p9_fd_write() is invoked, but still
remains small race window for clearing O_NONBLOCK flag.

If we don't want to manipulate O_NONBLOCK flag, we might be able to
surround kernel_read()/kernel_write() with set_thread_flag(TIF_SIGPENDING)
and recalc_sigpending(). Since p9_read_work()/p9_write_work() works are
processed by kernel threads which process global system_wq workqueue,
signals could not be delivered from remote threads when p9_mux_poll_stop()
 from p9_conn_destroy() from p9_fd_close() is called. Therefore, calling
set_thread_flag(TIF_SIGPENDING)/recalc_sigpending() every time would be
needed if we count on signals for making kernel_read()/kernel_write()
non-blocking.

Link: https://lkml.kernel.org/r/345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp
Link: https://syzkaller.appspot.com/bug?extid=8b41a1365f1106fd0f33 [1]
Reported-by: syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
[Dominique: add comment at Christian's suggestion]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 83cdb13c6322..a7973bd56a40 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -820,11 +820,14 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
 		goto out_free_ts;
 	if (!(ts->rd->f_mode & FMODE_READ))
 		goto out_put_rd;
+	/* prevent workers from hanging on IO when fd is a pipe */
+	ts->rd->f_flags |= O_NONBLOCK;
 	ts->wr = fget(wfd);
 	if (!ts->wr)
 		goto out_put_rd;
 	if (!(ts->wr->f_mode & FMODE_WRITE))
 		goto out_put_wr;
+	ts->wr->f_flags |= O_NONBLOCK;
 
 	client->trans = ts;
 	client->status = Connected;
-- 
2.35.1

