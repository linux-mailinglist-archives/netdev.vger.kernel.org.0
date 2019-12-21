Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC4E1287F5
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 08:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfLUHll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 02:41:41 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43879 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfLUHll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 02:41:41 -0500
Received: by mail-qk1-f196.google.com with SMTP id t129so9566465qke.10
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 23:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hV9c82FEXr+bwm8wynV8PMYGRUL8xxEUxPtTqZgVLgs=;
        b=OtuMlB8Azi75+9o5XNpB+PPI3QV9Ff4ifuhU4JsGuT7MGQLQzVwgVNOsy7hi8vW/yL
         28xOFr3IHTL0eWDpqR3/ge+UzNej/4Mrg4GwfyQpG6t4DlFpxLKETYm9fqoftPJ6ODUL
         i/xOo8h28IDG62qTE2kAJBKW4Kx6nFHTzCrlZEewRNoeKFXsibTkESeHBSrtOIVPaw6n
         T7wPE/NjdbMBV1YMmtcpW9cIkFEUK7BbYD1IGLkzYYeeWGz83pcfrC80uGOU1aL7h5WS
         mh9Waudmpd++BKLieVNZ1oq7NeB+ZZu0NGQmQDa2o2+h+sUJzRt+I8x4SMOLk2t41FdS
         Zdkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hV9c82FEXr+bwm8wynV8PMYGRUL8xxEUxPtTqZgVLgs=;
        b=H3cUFj8LwcOYXrTb4452VsfKYrSJk7X0EzCi7/Ge4vLNeT6nHqxNhKoVkthJEQ4uQL
         OS6Wiuk8d8bVGxXsm3c/4tGBHVWUvXJnz+oXS1DhqOtOU8S5W5JwstCipA7iF79dkHiu
         4SmIAzmxJ+ixuwZXMH+W3qnzVnF638kS8iSp6SHd+L+BssvNUm6hs3gybcGc1eY4rkCS
         ebky7FVfatLAHJs0YB76MlihNN1+8CmB5UzQJ/pdw17Y12jslRkFG9mBICrRgZJ6JL1y
         GtaUfADd6SWRS5pLgkUqRzjRO8kHIvkAiTdxaK58CzPf95u7OVvXhoR5Yje8rk3c+Caa
         mSyw==
X-Gm-Message-State: APjAAAVuYZn0/WArH/esRZc28WVQ9dJxknnenhjLFReYm36EcZhPyHgy
        Wn928W5yNIEtJqTKv08o9zvsSDXs2zBdv5dxUVRQsDwO
X-Google-Smtp-Source: APXvYqxBOiPXBGWc+Z8WKrn19kZ05vDHIecF4YRnN9bZPd9a4rDkXr8iIRyiQqm0LU4/2yON6TJq4F3Ix4F61X49C7A=
X-Received: by 2002:a37:e312:: with SMTP id y18mr17393541qki.250.1576914097165;
 Fri, 20 Dec 2019 23:41:37 -0800 (PST)
MIME-Version: 1.0
References: <001a1143e62e6f71d20565bf329f@google.com> <000000000000a3c3ef059a1e4260@google.com>
 <20191220203847.08267447@rorschach.local.home>
In-Reply-To: <20191220203847.08267447@rorschach.local.home>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 21 Dec 2019 08:41:21 +0100
Message-ID: <CACT4Y+ZrU_+CFbiUMSMRU4sxtu=o4RVPDNfYbhcegoOB5f0VKA@mail.gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Read in update_stack_state
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     syzbot <syzbot+2990ca6e76c080858a9c@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>, mbenes@suse.cz,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        netdev <netdev@vger.kernel.org>, rppt@linux.ibm.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 21, 2019 at 2:38 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> What's the actual bug? "stack-out-of-bounds" is rather useless without
> any actual output dump. But that's besides the point, this commit is
> *extremely* unlikely to be the culprit.

There is a hundred of reports accumulated on dashboard for this bug
report for past 2 years ;)

> On Fri, 20 Dec 2019 00:14:01 -0800
> syzbot <syzbot+2990ca6e76c080858a9c@syzkaller.appspotmail.com> wrote:
>
> > syzbot suspects this bug was fixed by commit:
> >
> > commit 4ee7c60de83ac01fa4c33c55937357601631e8ad
> > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Date:   Fri Mar 23 14:18:03 2018 +0000
> >
> >      init, tracing: Add initcall trace events
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11ebd0aee00000
> > start commit:   0b6b8a3d Merge branch 'bpf-misc-selftest-improvements'
> > git tree:       bpf-next
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=82a189bf69e089b5
> > dashboard link: https://syzkaller.appspot.com/bug?extid=2990ca6e76c080858a9c
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11dde5b3800000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1347b65d800000
> >
> > If the result looks correct, please mark the bug fixed by replying with:
> >
> > #syz fix: init, tracing: Add initcall trace events
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20191220203847.08267447%40rorschach.local.home.
