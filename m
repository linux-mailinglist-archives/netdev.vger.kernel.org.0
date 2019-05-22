Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B2226137
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 12:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfEVKBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 06:01:45 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41565 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729156AbfEVKBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 06:01:45 -0400
Received: by mail-lf1-f68.google.com with SMTP id d8so1215412lfb.8
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 03:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JnVnevi+IXvwZDlS9zws2BfOVOYLG9/iHTFIsiQn0cs=;
        b=IPxGan8SJsmWqaTkj/PHVIchRnweLfuylpXjADLt/vWxdye6aP1BWX8c8dwzd3z+vo
         1A8869wttjcflRrpVRbQ8scQyxt6r8rMrvKfwG7RM3mS9UpwWVmUVBlVBGq8FZmA5QyS
         Hc5GraUJVIOO+fOvguS3iQmKShMLrotp3t+m4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JnVnevi+IXvwZDlS9zws2BfOVOYLG9/iHTFIsiQn0cs=;
        b=ICRsYXNmf+OUDONBpwtZ0T6Tin/ITO4ODMLSVTQmmDM/gtCgRIHPJnizA9M6WGogMP
         phTQbXaz02VGn8EV+mdVK4agYhFnm0IJwyv9yeXtwIcFzh8RZcp0IEJSuQDkO2FeIyfp
         YMkCRUblXEoOtNc8jccvLZ3aPG6cH4jiplnxHkix4aWYGDBeUjtxFzKJFSkQ+Da9DnJj
         QNNDfHCmqTPUqr6wmI5VfFNHaHb1ArBM+PT/BTvQoN5gFovj10z2E7ems375H/bevArg
         kIcCAjz6RSJFdXz7tKNIdmo/1JlsB65puXj/C8FZ4KTNqogLtKKUfkj+htrB8Wh6vhK8
         gEbw==
X-Gm-Message-State: APjAAAVkoXxbZ7Qp/bFlc/D72aBBxSXKMf2ZDyLRjXKT+PO896VwiXV6
        FUwN3hNRNA8PJidtPDNo/J0fUuxmI4DOeA==
X-Google-Smtp-Source: APXvYqxZEtCyQ3p6EHar8xNAw0eXao5afPJv4+gOM9qGtEwOydra7v6g0RKwZA1QiW2F4uvHFlwaiw==
X-Received: by 2002:a19:2d1a:: with SMTP id k26mr961507lfj.104.1558519303632;
        Wed, 22 May 2019 03:01:43 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id h22sm332804ljk.86.2019.05.22.03.01.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 03:01:42 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: [bpf PATCH] bpf: sockmap, restore sk_write_space when psock gets dropped
Date:   Wed, 22 May 2019 12:01:42 +0200
Message-Id: <20190522100142.28925-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once psock gets unlinked from its sock (sk_psock_drop), user-space can
still trigger a call to sk->sk_write_space by setting TCP_NOTSENT_LOWAT
socket option. This causes a null-ptr-deref because we try to read
psock->saved_write_space from sk_psock_write_space:

==================================================================
BUG: KASAN: null-ptr-deref in sk_psock_write_space+0x69/0x80
Read of size 8 at addr 00000000000001a0 by task sockmap-echo/131

CPU: 0 PID: 131 Comm: sockmap-echo Not tainted 5.2.0-rc1-00094-gf49aa1de9836 #81
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
?-20180724_192412-buildhw-07.phx2.fedoraproject.org-1.fc29 04/01/2014
Call Trace:
 ? sk_psock_write_space+0x69/0x80
 __kasan_report.cold.2+0x5/0x3f
 ? sk_psock_write_space+0x69/0x80
 kasan_report+0xe/0x20
 sk_psock_write_space+0x69/0x80
 tcp_setsockopt+0x69a/0xfc0
 ? tcp_shutdown+0x70/0x70
 ? fsnotify+0x5b0/0x5f0
 ? remove_wait_queue+0x90/0x90
 ? __fget_light+0xa5/0xf0
 __sys_setsockopt+0xe6/0x180
 ? sockfd_lookup_light+0xb0/0xb0
 ? vfs_write+0x195/0x210
 ? ksys_write+0xc9/0x150
 ? __x64_sys_read+0x50/0x50
 ? __bpf_trace_x86_fpu+0x10/0x10
 __x64_sys_setsockopt+0x61/0x70
 do_syscall_64+0xc5/0x520
 ? vmacache_find+0xc0/0x110
 ? syscall_return_slowpath+0x110/0x110
 ? handle_mm_fault+0xb4/0x110
 ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
 ? trace_hardirqs_off_caller+0x4b/0x120
 ? trace_hardirqs_off_thunk+0x1a/0x3a
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f2e5e7cdcce
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b1 66 2e 0f 1f 84 00 00 00 00 00
0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff
ff 73 01 c3 48 8b 0d 8a 11 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffed011b778 EFLAGS: 00000206 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2e5e7cdcce
RDX: 0000000000000019 RSI: 0000000000000006 RDI: 0000000000000007
RBP: 00007ffed011b790 R08: 0000000000000004 R09: 00007f2e5e84ee80
R10: 00007ffed011b788 R11: 0000000000000206 R12: 00007ffed011b78c
R13: 00007ffed011b788 R14: 0000000000000007 R15: 0000000000000068
==================================================================

Restore the saved sk_write_space callback when psock is being dropped to
fix the crash.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/skmsg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 178a3933a71b..50ced8aba9db 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -351,6 +351,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
+	sk->sk_write_space = psock->saved_write_space;
+
 	if (psock->sk_proto) {
 		sk->sk_prot = psock->sk_proto;
 		psock->sk_proto = NULL;
-- 
2.20.1

