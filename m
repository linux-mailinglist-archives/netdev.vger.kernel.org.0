Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EA52C0F71
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389691AbgKWPzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389680AbgKWPzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:55:03 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE22EC0613CF;
        Mon, 23 Nov 2020 07:55:03 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 05D891F44CF8
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Jann Horn <jannh@google.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        YiFei Zhu <yifeifz2@illinois.edu>
Subject: [PATCH] entry: Fix boot for !CONFIG_GENERIC_ENTRY
Organization: Collabora
References: <CA+G9fYs9sg69JgmQNZhutQnbijb4GzcO03XF66EjkQ6CTpXXxA@mail.gmail.com>
        <CAK8P3a1Lx1MMQ3s1uWjevsi2wqFo2r=k1hhrxf1spUxEQX_Rag@mail.gmail.com>
        <CAG48ez17CKBMO4193wxuWLRQWQ+q6EV=Qr5oTWiKivMxEi0zQw@mail.gmail.com>
        <87h7pgqhdf.fsf@collabora.com>
Date:   Mon, 23 Nov 2020 10:54:58 -0500
In-Reply-To: <87h7pgqhdf.fsf@collabora.com> (Gabriel Krisman Bertazi's message
        of "Mon, 23 Nov 2020 09:26:20 -0500")
Message-ID: <87a6v8qd9p.fsf_-_@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gabriel Krisman Bertazi <krisman@collabora.com> writes:

> Jann Horn <jannh@google.com> writes:
>> As part of fixing this, it might be a good idea to put "enum
>> syscall_work_bit" behind a "#ifdef CONFIG_GENERIC_ENTRY" to avoid
>> future accidents like this?
>
> Hi Jan, Arnd,
>
> That is correct.  This is a copy pasta mistake.  My apologies.  I didn't
> have a !GENERIC_ENTRY device to test, but just the ifdef would have
> caught it.

I have patched it as suggested.  Tested on qemu for arm32 and on bare
metal for x86-64.

Once again, my apologies for the mistake.

-- >8 --
Subject: [PATCH] entry: Fix boot for !CONFIG_GENERIC_ENTRY

A copy-pasta mistake tries to set SYSCALL_WORK flags instead of TIF
flags for !CONFIG_GENERIC_ENTRY.  Also, add safeguards to catch this at
compilation time.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 include/linux/thread_info.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 6a597fd5d351..45ad3176e2fa 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -35,6 +35,7 @@ enum {
 	GOOD_STACK,
 };
 
+#ifdef CONFIG_GENERIC_ENTRY
 enum syscall_work_bit {
 	SYSCALL_WORK_BIT_SECCOMP,
 	SYSCALL_WORK_BIT_SYSCALL_TRACEPOINT,
@@ -48,6 +49,7 @@ enum syscall_work_bit {
 #define SYSCALL_WORK_SYSCALL_TRACE	BIT(SYSCALL_WORK_BIT_SYSCALL_TRACE)
 #define SYSCALL_WORK_SYSCALL_EMU	BIT(SYSCALL_WORK_BIT_SYSCALL_EMU)
 #define SYSCALL_WORK_SYSCALL_AUDIT	BIT(SYSCALL_WORK_BIT_SYSCALL_AUDIT)
+#endif
 
 #include <asm/thread_info.h>
 
@@ -127,11 +129,11 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 	clear_bit(SYSCALL_WORK_BIT_##fl, &task_thread_info(t)->syscall_work)
 #else
 #define set_syscall_work(fl) \
-	set_ti_thread_flag(current_thread_info(), SYSCALL_WORK_##fl)
+	set_ti_thread_flag(current_thread_info(), TIF_##fl)
 #define test_syscall_work(fl) \
-	test_ti_thread_flag(current_thread_info(), SYSCALL_WORK_##fl)
+	test_ti_thread_flag(current_thread_info(), TIF_##fl)
 #define clear_syscall_work(fl) \
-	clear_ti_thread_flag(current_thread_info(), SYSCALL_WORK_##fl)
+	clear_ti_thread_flag(current_thread_info(), TIF_##fl)
 
 #define set_task_syscall_work(t, fl) \
 	set_ti_thread_flag(task_thread_info(t), TIF_##fl)
-- 
2.29.2

