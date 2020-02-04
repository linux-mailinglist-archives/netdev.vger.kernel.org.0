Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B1F151AE9
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 14:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgBDND2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 08:03:28 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35666 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgBDND2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 08:03:28 -0500
Received: by mail-ot1-f68.google.com with SMTP id r16so17034072otd.2
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 05:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5kwMY+yOcoe9hemHRL4Y06hBc7IAz8tTHyF8xqYySrw=;
        b=vAIRMq8SoUHEI2zcLg6Qytv91Rusr976z0RRPo/o6VAnOW13HGwWguRH8xGdq0cw0z
         yvrRohCP2MtVydNTLQRSJIgM6ZZZflHTwOvTpGxMuuL2P0Ar2EtF+qihMQap9pRMt6GU
         kPwlHKIiiJ6VXG2phr8zGOi3qpafsIDAXK+o0mEudVv6ov9W3E63Czn5EHAdrzj9OWWN
         UpOB51VKBYLb1vCdR5hM/mJe4XlV0puUyQaaJlccAC+4d+XLe8z9gADbuDAelzFEuoNF
         5XroVNWj/G2Ck28XDSJQBD01EJhMLUFWzMSGIbJBipnPW3/bwWyhqjWoyhMIZPuOa9uu
         2qYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5kwMY+yOcoe9hemHRL4Y06hBc7IAz8tTHyF8xqYySrw=;
        b=lEl/sjtcct94v8iq3UBUFetp/8L5WswgcRHhwt+MweIfESgCmKd08sg4aOfUUC+9sq
         1L5qw002d3qhaje8/REfOGog/D9lnqwZUU4JUG1GMq8Xvty/mUYqNSC04CRKRCCw7uXr
         qhivRITvqhOdX4xRMiJDIsWejzQM/y5/2UWQ8ZazmPcg7vcQMK7NqXwtjo9KZHMSTnQD
         MJK9gixKSZvVw0wx2ea30c8i6HTliSg6v8V8q2puRWlDKGN5WNNW2jna+cSoKGJJJqae
         yuS9bPprdMyg3uzEwe9dUB/2VfPSq12bTAlg9OMcpNPtS4FJtHRAfr7KgTV0BOT48ned
         OwoQ==
X-Gm-Message-State: APjAAAU3My2tGxkq/qQlBNn3O3l8YHRPgOGYUyv9svnnOLQnYuzIcu8w
        ZSADMfyEebkuHYtQ8CqFGxZ78dava3jd7Y+hkZaYrg==
X-Google-Smtp-Source: APXvYqyUDEChjDRXpZSB7Ici17ut0o0FeHEcZPweNHQh7TrPef5JWZJJ3GGksPBLGT6NChvfjIm+gcL4NY1dAnPk0kQ=
X-Received: by 2002:a05:6830:22cc:: with SMTP id q12mr22662566otc.110.1580821405204;
 Tue, 04 Feb 2020 05:03:25 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005cad20059db8adba@google.com>
In-Reply-To: <0000000000005cad20059db8adba@google.com>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 4 Feb 2020 14:02:58 +0100
Message-ID: <CAG48ez3tsUWA8tXL7rVMJ+CEpuNmxZrX=RjFhvMcu1SkvXkHDw@mail.gmail.com>
Subject: unbounded recursion through bond_netdev_event notifier? [was: BUG:
 stack guard page was hit in update_stack_state]
To:     syzbot <syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Cc:     Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 4, 2020 at 5:43 AM syzbot
<syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    b3a60822 Merge branch 'for-v5.6' of git://git.kernel.org:/..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=147ae5f1e00000

In the console output, you can see that this seems to be an unbounded
recursion bug. The stack trace is unreliable, but it looks like the
actual recursion might be something like the following, where a netdev
change triggers the bond_netdev_event notifier, which in turn causes
another netdev change, and so on:

[  734.548523][T28658]  ? netdev_lower_get_next_private+0x85/0xb0
[  734.554632][T28658]  ? bond_compute_features.isra.0+0x56a/0xa80
[inlined bond_slave_netdev_event ?]
[  734.572769][T28658]  ? bond_netdev_event+0x71a/0x950
[  734.577901][T28658]  ? notifier_call_chain+0xc2/0x230
[  734.583113][T28658]  ? raw_notifier_call_chain+0x2e/0x40
[  734.588589][T28658]  ? call_netdevice_notifiers_info+0xba/0x130
[  734.594765][T28658]  ? netdev_update_features+0xc7/0xd0
[  734.600142][T28658]  ? __netdev_update_features+0x13e0/0x13e0
[...]
[  734.617522][T28658]  ? netdev_upper_get_next_dev_rcu+0xac/0x110
[  734.623605][T28658]  ? __netdev_update_features+0x8af/0x13e0
[...]
[  734.649988][T28658]  ? netdev_change_features+0x64/0xb0
[...]


> kernel config:  https://syzkaller.appspot.com/x/.config?x=614e56d86457f3a7

says CONFIG_UNWINDER_FRAME_POINTER=y. Unfortunately, the x86 frame
pointer unwinder apparently can't unwind out of a double fault...
maybe it'd be better to use ORC for syzkaller?

> dashboard link: https://syzkaller.appspot.com/bug?extid=c2fb6f9ddcea95ba49b5
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
