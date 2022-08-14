Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C339F59266C
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 22:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiHNUxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 16:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHNUxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 16:53:20 -0400
Received: from forward100j.mail.yandex.net (forward100j.mail.yandex.net [5.45.198.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45A918396
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 13:53:18 -0700 (PDT)
Received: from myt6-870ea81e6a0f.qloud-c.yandex.net (myt6-870ea81e6a0f.qloud-c.yandex.net [IPv6:2a02:6b8:c12:2229:0:640:870e:a81e])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id EF27F64F38ED;
        Sun, 14 Aug 2022 23:53:16 +0300 (MSK)
Received: by myt6-870ea81e6a0f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id VQcJEwGU7o-rFheVOWX;
        Sun, 14 Aug 2022 23:53:16 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1660510396;
        bh=6DfvZKkoYrBZQY9QKmpT6aw2IaRKeGGolubxlTMgOyY=;
        h=Date:Message-ID:Cc:To:Subject:From;
        b=RwIaPVndT5bhASf2CAFRjUXcgZuAsVFk8Vwql3sWZ1DImdaS5bYGj+mekMf7HHkfi
         JOACj+xa5cM6l+Iya4RcLFpEj90G0swdJwjtPCI3CQi6Z2rgua4qOWZ1MR8nfsw3tl
         TzhOO57If8L7icC4u2zVuiuBCTdCrN5WHG5uuieg=
Authentication-Results: myt6-870ea81e6a0f.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
From:   Kirill Tkhai <tkhai@ya.ru>
Subject: [PATCH] af_unix: Add ioctl(SIOCUNIXGRABFDS) to grab files of receive
 queue skbs
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Kirill Tkhai <tkhai@ya.ru>
Message-ID: <9293c7ee-6fb7-7142-66fe-051548ffb65c@ya.ru>
Date:   Sun, 14 Aug 2022 23:53:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a fd owning a counter of some critical resource, say, of a mount,
it's impossible to umount that mount and disconnect related block device.
That fd may be contained in some unix socket receive queue skb.

Despite we have an interface for detecting such the sockets queues
(/proc/[PID]/fdinfo/[fd] shows non-zero scm_fds count if so) and
it's possible to kill that process to release the counter, the problem is
that there may be several processes, and it's not a good thing to kill
each of them.

This patch adds a simple interface to grab files from receive queue,
so the caller may analyze them, and even do that recursively, if grabbed
file is unix socket itself. So, the described above problem may be solved
by this ioctl() in pair with pidfd_getfd().

Note, that the existing recvmsg(,,MSG_PEEK) is not suitable for that
purpose, since it modifies peek offset inside socket, and this results
in a problem in case of examined process uses peek offset itself.
Additional ptrace freezing of that task plus ioctl(SO_PEEK_OFF) won't help
too, since that socket may relate to several tasks, and there is no
reliable and non-racy way to detect that. Also, if the caller of such
trick will die, the examined task will remain frozen forever. The new
suggested ioctl(SIOCUNIXGRABFDS) does not have such problems.

The realization of ioctl(SIOCUNIXGRABFDS) is pretty simple. The only
interesting thing is protocol with userspace. Firstly, we let userspace
to know the number of all files in receive queue skbs. Then we receive
fds one by one starting from requested offset. We return number of
received fds if there is a successfully received fd, and this number
may be less in case of error or desired fds number lack. Userspace
may detect that situations by comparison of returned value and
out.nr_all minus in.nr_skip. Looking over different variant this one
looks the best for me (I considered returning error in case of error
and there is a received fd. Also I considered returning number of
received files as one more member in struct unix_ioc_grab_fds).

Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
---
 include/uapi/linux/un.h |   12 ++++++++
 net/unix/af_unix.c      |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/include/uapi/linux/un.h b/include/uapi/linux/un.h
index 0ad59dc8b686..995b358263dd 100644
--- a/include/uapi/linux/un.h
+++ b/include/uapi/linux/un.h
@@ -11,6 +11,18 @@ struct sockaddr_un {
 	char sun_path[UNIX_PATH_MAX];	/* pathname */
 };
 
+struct unix_ioc_grab_fds {
+	struct {
+		int nr_grab;
+		int nr_skip;
+		int *fds;
+	} in;
+	struct {
+		int nr_all;
+	} out;
+};
+
 #define SIOCUNIXFILE (SIOCPROTOPRIVATE + 0) /* open a socket file with O_PATH */
+#define SIOCUNIXGRABFDS (SIOCPROTOPRIVATE + 1) /* grab files from recv queue */
 
 #endif /* _LINUX_UN_H */
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index bf338b782fc4..3c7e8049eba1 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3079,6 +3079,73 @@ static int unix_open_file(struct sock *sk)
 	return fd;
 }
 
+static int unix_ioc_grab_fds(struct sock *sk, struct unix_ioc_grab_fds __user *uarg)
+{
+	int i, todo, skip, count, all, err, done = 0;
+	struct unix_sock *u = unix_sk(sk);
+	struct unix_ioc_grab_fds arg;
+	struct sk_buff *skb = NULL;
+	struct scm_fp_list *fp;
+
+	if (copy_from_user(&arg, uarg, sizeof(arg)))
+		return -EFAULT;
+
+	skip = arg.in.nr_skip;
+	todo = arg.in.nr_grab;
+
+	if (skip < 0 || todo <= 0)
+		return -EINVAL;
+	if (mutex_lock_interruptible(&u->iolock))
+		return -EINTR;
+
+	all = atomic_read(&u->scm_stat.nr_fds);
+	err = -EFAULT;
+	/* Set uarg->out.nr_all before the first file is received. */
+	if (put_user(all, &uarg->out.nr_all))
+		goto unlock;
+	err = 0;
+	if (all <= skip)
+		goto unlock;
+	if (all - skip < todo)
+		todo = all - skip;
+	while (todo) {
+		spin_lock(&sk->sk_receive_queue.lock);
+		if (!skb)
+			skb = skb_peek(&sk->sk_receive_queue);
+		else
+			skb = skb_peek_next(skb, &sk->sk_receive_queue);
+		spin_unlock(&sk->sk_receive_queue.lock);
+
+		if (!skb)
+			goto unlock;
+
+		fp = UNIXCB(skb).fp;
+		count = fp->count;
+		if (skip >= count) {
+			skip -= count;
+			continue;
+		}
+
+		for (i = skip; i < count && todo; i++) {
+			err = receive_fd_user(fp->fp[i], &arg.in.fds[done], 0);
+			if (err < 0)
+				goto unlock;
+			done++;
+			todo--;
+		}
+		skip = 0;
+	}
+unlock:
+	mutex_unlock(&u->iolock);
+
+	/* Return number of fds (non-error) if there is a received file. */
+	if (done)
+		return done;
+	if (err < 0)
+		return err;
+	return 0;
+}
+
 static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
 	struct sock *sk = sock->sk;
@@ -3113,6 +3180,9 @@ static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		}
 		break;
 #endif
+	case SIOCUNIXGRABFDS:
+		err = unix_ioc_grab_fds(sk, (struct unix_ioc_grab_fds __user *)arg);
+		break;
 	default:
 		err = -ENOIOCTLCMD;
 		break;


