Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA63B5A34F8
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 08:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiH0GL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 02:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiH0GLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 02:11:55 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E05AAB4E5
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 23:11:53 -0700 (PDT)
Received: from fsav111.sakura.ne.jp (fsav111.sakura.ne.jp [27.133.134.238])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 27R6BpP3040685;
        Sat, 27 Aug 2022 15:11:51 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav111.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp);
 Sat, 27 Aug 2022 15:11:51 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 27R6BpTA040676
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 27 Aug 2022 15:11:51 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <4293faaf-8279-77e2-8b1a-aff765416980@I-love.SAKURA.ne.jp>
Date:   Sat, 27 Aug 2022 15:11:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: [PATCH v2] 9p/trans_fd: perform read/write with TIF_SIGPENDING set
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
References: <00000000000039af4d05915a9f56@google.com>
 <000000000000c1d3ca0593128b24@google.com>
 <345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp>
In-Reply-To: <345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting hung task at p9_fd_close() [1], for p9_mux_poll_stop()
 from p9_conn_destroy() from p9_fd_close() is failing to interrupt already
started kernel_read() from p9_fd_read() from p9_read_work() and/or
kernel_write() from p9_fd_write() from p9_write_work() requests.

Since p9_socket_open() sets O_NONBLOCK flag, p9_mux_poll_stop() does not
need to interrupt kernel_{read,write}(). However, since p9_fd_open() does
not set O_NONBLOCK flag, but pipe blocks unless signal is pending,
p9_mux_poll_stop() needs to interrupt kernel_{read,write}() when the file
descriptor refers to a pipe. In other words, pipe file descriptor needs
to be handled as if socket file descriptor. We somehow need to interrupt
kernel_{read,write}() on pipes.

If we can tolerate "possibility of breaking userspace program by setting
O_NONBLOCK flag on userspace-supplied file descriptors" and "possibility
of race window that userspace program clears O_NONBLOCK flag between after
automatically setting O_NONBLOCK flag and before calling
kernel_{read,write}()", we could automatically set O_NONBLOCK flag
immediately before calling kernel_{read,write}().

A different approach, which this patch is doing, is to surround
kernel_{read,write}() with set_thread_flag(TIF_SIGPENDING) and
recalc_sigpending(). This might be ugly and bit costly, but does not
touch userspace-supplied file descriptors.

Link: https://syzkaller.appspot.com/bug?extid=8b41a1365f1106fd0f33 [1]
Reported-by: syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>
---
Although syzbot tested that this patch solves hung task problem, syzbot
cannot verify that this patch will not break functionality of p9 users.
Please test before applying this patch.

 net/9p/trans_fd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index e758978b44be..e2f4e3245a80 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -256,11 +256,13 @@ static int p9_fd_read(struct p9_client *client, void *v, int len)
 	if (!ts)
 		return -EREMOTEIO;
 
-	if (!(ts->rd->f_flags & O_NONBLOCK))
-		p9_debug(P9_DEBUG_ERROR, "blocking read ...\n");
-
 	pos = ts->rd->f_pos;
+	/* Force non-blocking read() even without O_NONBLOCK. */
+	set_thread_flag(TIF_SIGPENDING);
 	ret = kernel_read(ts->rd, v, len, &pos);
+	spin_lock_irq(&current->sighand->siglock);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
 	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
 		client->status = Disconnected;
 	return ret;
@@ -423,10 +425,12 @@ static int p9_fd_write(struct p9_client *client, void *v, int len)
 	if (!ts)
 		return -EREMOTEIO;
 
-	if (!(ts->wr->f_flags & O_NONBLOCK))
-		p9_debug(P9_DEBUG_ERROR, "blocking write ...\n");
-
+	/* Force non-blocking write() even without O_NONBLOCK. */
+	set_thread_flag(TIF_SIGPENDING);
 	ret = kernel_write(ts->wr, v, len, &ts->wr->f_pos);
+	spin_lock_irq(&current->sighand->siglock);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
 	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
 		client->status = Disconnected;
 	return ret;
-- 
2.18.4

