Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6164F2C0D6E
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbgKWO03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:26:29 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34654 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730282AbgKWO03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:26:29 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 7711D1F44CB9
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
Subject: Re: [arm64] kernel BUG at kernel/seccomp.c:1309!
Organization: Collabora
References: <CA+G9fYs9sg69JgmQNZhutQnbijb4GzcO03XF66EjkQ6CTpXXxA@mail.gmail.com>
        <CAK8P3a1Lx1MMQ3s1uWjevsi2wqFo2r=k1hhrxf1spUxEQX_Rag@mail.gmail.com>
        <CAG48ez17CKBMO4193wxuWLRQWQ+q6EV=Qr5oTWiKivMxEi0zQw@mail.gmail.com>
Date:   Mon, 23 Nov 2020 09:26:20 -0500
In-Reply-To: <CAG48ez17CKBMO4193wxuWLRQWQ+q6EV=Qr5oTWiKivMxEi0zQw@mail.gmail.com>
        (Jann Horn's message of "Mon, 23 Nov 2020 15:02:10 +0100")
Message-ID: <87h7pgqhdf.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> On Mon, Nov 23, 2020 at 2:45 PM Arnd Bergmann <arnd@kernel.org> wrote:
>> On Mon, Nov 23, 2020 at 12:15 PM Naresh Kamboju
>> <naresh.kamboju@linaro.org> wrote:
>> >
>> > While booting arm64 kernel the following kernel BUG noticed on several arm64
>> > devices running linux next 20201123 tag kernel.
>> >
>> >
>> > $ git log --oneline next-20201120..next-20201123 -- kernel/seccomp.c
>> > 5c5c5fa055ea Merge remote-tracking branch 'seccomp/for-next/seccomp'
>> > bce6a8cba7bf Merge branch 'linus'
>> > 7ef95e3dbcee Merge branch 'for-linus/seccomp' into for-next/seccomp
>> > fab686eb0307 seccomp: Remove bogus __user annotations
>> > 0d8315dddd28 seccomp/cache: Report cache data through /proc/pid/seccomp_cache
>> > 8e01b51a31a1 seccomp/cache: Add "emulator" to check if filter is constant allow
>> > f9d480b6ffbe seccomp/cache: Lookup syscall allowlist bitmap for fast path
>> > 23d67a54857a seccomp: Migrate to use SYSCALL_WORK flag
>> >
>> >
>> > Please find these easy steps to reproduce the kernel build and boot.
>>
>> Adding Gabriel Krisman Bertazi to Cc, as the last patch (23d67a54857a) here
>> seems suspicious: it changes
>>
>> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
>> index 02aef2844c38..47763f3999f7 100644
>> --- a/include/linux/seccomp.h
>> +++ b/include/linux/seccomp.h
>> @@ -42,7 +42,7 @@ struct seccomp {
>>  extern int __secure_computing(const struct seccomp_data *sd);
>>  static inline int secure_computing(void)
>>  {
>> -       if (unlikely(test_thread_flag(TIF_SECCOMP)))
>> +       if (unlikely(test_syscall_work(SECCOMP)))
>>                 return  __secure_computing(NULL);
>>         return 0;
>>  }
>>
>> which is in the call chain directly before
>>
>> int __secure_computing(const struct seccomp_data *sd)
>> {
>>        int mode = current->seccomp.mode;
>>
>> ...
>>         switch (mode) {
>>         case SECCOMP_MODE_STRICT:
>>                 __secure_computing_strict(this_syscall);  /* may call do_exit */
>>                 return 0;
>>         case SECCOMP_MODE_FILTER:
>>                 return __seccomp_filter(this_syscall, sd, false);
>>         default:
>>                 BUG();
>>         }
>> }
>>
>> Clearly, current->seccomp.mode is set to something other
>> than SECCOMP_MODE_STRICT or SECCOMP_MODE_FILTER
>> while the test_syscall_work(SECCOMP) returns true, and this
>> must have not been the case earlier.
>
> Ah, I think the problem is actually in
> 3136b93c3fb2b7c19e853e049203ff8f2b9dd2cd ("entry: Expose helpers to
> migrate TIF to SYSCALL_WORK flag"). In the !GENERIC_ENTRY case, it
> adds this code:
>
> +#define set_syscall_work(fl)                                           \
> +       set_ti_thread_flag(current_thread_info(), SYSCALL_WORK_##fl)
> +#define test_syscall_work(fl) \
> +       test_ti_thread_flag(current_thread_info(), SYSCALL_WORK_##fl)
> +#define clear_syscall_work(fl) \
> +       clear_ti_thread_flag(current_thread_info(), SYSCALL_WORK_##fl)
> +
> +#define set_task_syscall_work(t, fl) \
> +       set_ti_thread_flag(task_thread_info(t), TIF_##fl)
> +#define test_task_syscall_work(t, fl) \
> +       test_ti_thread_flag(task_thread_info(t), TIF_##fl)
> +#define clear_task_syscall_work(t, fl) \
> +       clear_ti_thread_flag(task_thread_info(t), TIF_##fl)
>
> but the SYSCALL_WORK_FLAGS are not valid on !GENERIC_ENTRY, we'll mix
> up (on arm64) SYSCALL_WORK_BIT_SECCOMP (==0) and TIF_SIGPENDING (==0).
>
> As part of fixing this, it might be a good idea to put "enum
> syscall_work_bit" behind a "#ifdef CONFIG_GENERIC_ENTRY" to avoid
> future accidents like this?

Hi Jan, Arnd,

That is correct.  This is a copy pasta mistake.  My apologies.  I didn't
have a !GENERIC_ENTRY device to test, but just the ifdef would have
caught it.

-- 
Gabriel Krisman Bertazi
