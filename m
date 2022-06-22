Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C49B554E38
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357949AbiFVPC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357713AbiFVPCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:02:25 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCBA3D1FA
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:02:22 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3178a95ec78so115146727b3.4
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=R50zHUKRUl0fT3rPUwcIHcVLrKor4p94wdFD4E+TgrU=;
        b=Si/03bv8QUDOFJDGnH2gEdIhlvcUV50nrS8o5sVs2Nc/aM7tngtxB2q+BM1/gYa+r/
         NTtpW3jAf+zpUn1q2Dxwr2E6B8EjSxjvV/Eegf6rh98nvkJe4f0BXitakRoBK1MI/KQ0
         qNuvOd4cmWJHIE6nKmBjT7Ip/cF/N6OS4MlneZ8Zzaq++84L337SoQdQHePlFoFuDu4w
         bARfeRAyXx6+9lnpnYxvHz3fvfViM8OW29OeKuxHw884f6Kqc2FlVBhhTSBSZcCj30Nc
         maLiR0ycusfXOm7jKgWYqzTx+stGzV8uK+rucLlQd6yACvVzvau79BRIkx1dRzMJREvW
         ceMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=R50zHUKRUl0fT3rPUwcIHcVLrKor4p94wdFD4E+TgrU=;
        b=hqhLNU7YNHcE9VWDkR18s7CkfYeVm6AS0/ZmyqATGfi68IJNi+IyvrJ9OXP2Q/lQk1
         IaTgmzOo0mwczsHIQCGxet0fbtsM6/P+SDphGBhCiMMIcdJGSP/q8L++iagZ75eAH6xU
         43nUyuG8RT6qXU/yqy9oGrPzVk2lTqHtDEDkFVH/Sk1+zF/DrC15S4fiTZqbZov7K/Eo
         QoQTH5Ad/2BCT+0mMA6WGXvnOP0C48DgWK7yl6u0vTwfughttRbwXcaNdggN7BxpR5P1
         SedFTvGWrsxmu9En7GMeVO6EtXRD0zfTenrXycCZS08FCADWgneN86evhZdV450Id2MG
         FL9w==
X-Gm-Message-State: AJIora+ja8cJ5b9eHQ7HiZ8Q0yQRQ91ft1oit7zxT2jCyssMfqSVGWp5
        lhaS5URub6o2Pm5bWh2RahOQycXgH3uXKA==
X-Google-Smtp-Source: AGRyM1v9m8JG+wRgfhjlFAM8mAUO0chZSSrr89bStoqH02Qu6cD+T77BFaNnkZ9FF3GWiJVewIyKsRFD0WLTAw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:dcc4:0:b0:317:7ed8:6b44 with SMTP id
 f187-20020a0ddcc4000000b003177ed86b44mr4707906ywe.468.1655910141864; Wed, 22
 Jun 2022 08:02:21 -0700 (PDT)
Date:   Wed, 22 Jun 2022 15:02:20 +0000
Message-Id: <20220622150220.1091182-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net] net: clear msg_get_inq in __sys_recvfrom() and __copy_msghdr_from_user()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported uninit-value in tcp_recvmsg() [1]

Issue here is that msg->msg_get_inq should have been cleared,
otherwise tcp_recvmsg() might read garbage and perform
more work than needed, or have undefined behavior.

Given CONFIG_INIT_STACK_ALL_ZERO=y is probably going to be
the default soon, I chose to change __sys_recvfrom() to clear
all fields but msghdr.addr which might be not NULL.

For __copy_msghdr_from_user(), I added an explicit clear
of kmsg->msg_get_inq.

[1]
BUG: KMSAN: uninit-value in tcp_recvmsg+0x6cf/0xb60 net/ipv4/tcp.c:2557
tcp_recvmsg+0x6cf/0xb60 net/ipv4/tcp.c:2557
inet_recvmsg+0x13a/0x5a0 net/ipv4/af_inet.c:850
sock_recvmsg_nosec net/socket.c:995 [inline]
sock_recvmsg net/socket.c:1013 [inline]
__sys_recvfrom+0x696/0x900 net/socket.c:2176
__do_sys_recvfrom net/socket.c:2194 [inline]
__se_sys_recvfrom net/socket.c:2190 [inline]
__x64_sys_recvfrom+0x122/0x1c0 net/socket.c:2190
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Local variable msg created at:
__sys_recvfrom+0x81/0x900 net/socket.c:2154
__do_sys_recvfrom net/socket.c:2194 [inline]
__se_sys_recvfrom net/socket.c:2190 [inline]
__x64_sys_recvfrom+0x122/0x1c0 net/socket.c:2190

CPU: 0 PID: 3493 Comm: syz-executor170 Not tainted 5.19.0-rc3-syzkaller-30868-g4b28366af7d9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: f94fd25cb0aa ("tcp: pass back data left in socket after receive")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 net/socket.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 2bc8773d9dc5e60595b14c2289e48d4ff0241da0..96300cdc06251fd654bce6277c54677f686079f8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2149,10 +2149,13 @@ SYSCALL_DEFINE4(send, int, fd, void __user *, buff, size_t, len,
 int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 		   struct sockaddr __user *addr, int __user *addr_len)
 {
+	struct sockaddr_storage address;
+	struct msghdr msg = {
+		/* Save some cycles and don't copy the address if not needed */
+		.msg_name = addr ? (struct sockaddr *)&address : NULL,
+	};
 	struct socket *sock;
 	struct iovec iov;
-	struct msghdr msg;
-	struct sockaddr_storage address;
 	int err, err2;
 	int fput_needed;
 
@@ -2163,14 +2166,6 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	if (!sock)
 		goto out;
 
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	/* Save some cycles and don't copy the address if not needed */
-	msg.msg_name = addr ? (struct sockaddr *)&address : NULL;
-	/* We assume all kernel code knows the size of sockaddr_storage */
-	msg.msg_namelen = 0;
-	msg.msg_iocb = NULL;
-	msg.msg_flags = 0;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	err = sock_recvmsg(sock, &msg, flags);
@@ -2375,6 +2370,7 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 		return -EFAULT;
 
 	kmsg->msg_control_is_user = true;
+	kmsg->msg_get_inq = 0;
 	kmsg->msg_control_user = msg.msg_control;
 	kmsg->msg_controllen = msg.msg_controllen;
 	kmsg->msg_flags = msg.msg_flags;
-- 
2.37.0.rc0.104.g0611611a94-goog

