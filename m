Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596394683FA
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 11:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348999AbhLDKXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 05:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345852AbhLDKXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 05:23:01 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5679BC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 02:19:36 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id t9-20020a4a8589000000b002c5c4d19723so2832704ooh.11
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 02:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MUBxI6UjSH7mOTHyHCii08lOt35WlhuPwpHtCxGOpIM=;
        b=JcFz0uAn6z1BVaVAU+OkeYsIDQPsQqJqoJoFKp3g6uAVA/A84+FkF9SetrQkp4mJYM
         B1Hy54zZGMuCX6D6Z17g+EuUIzbeBsvdLOACzNtyEkIIXRGJYZ527kBWHdjBqZx5o4+g
         fMbe+xNpft4zrX6/5uMreZ0JiMg50omlcPQqDoLKusegh/7Z+inEo33l4LYT482FWdNb
         /j5ZA4xkYy1FPhVKRoBMrMN5gSclBnmtmtDkL5VMI9YmcOol/maEJN39ZonFYQ/EJD2x
         KawFs8/p6gzVTndoXsak5CfyU96l6d3RvaUqlFO4Cj2yDF+Yvqrs0hMWYCH6RWe52dJq
         Botw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MUBxI6UjSH7mOTHyHCii08lOt35WlhuPwpHtCxGOpIM=;
        b=BPymKUIMI406RkTcWGhQCHvGded/CDakHHfv6ELNifAAxxiRkYEqQqXlM0q87WF4sC
         HuciwKdH8AOxiYRiOEjIKk6Dtyt9NHl9QUC3M28kiLMnUOBpA8zKwymwk5k2htgCcc7l
         vzy1Kp+cg1TN7xroAw5eSvoWRbx3J9WPUBlIEK6p2FP6Ff46YTCCEIyV57wu3GeoVsNZ
         pfp/RpE/iE/kf9ElKxL6YiGfEjDPp/OsaH8TOMSPpcJXr4raqNAt5IxSq6fBDWClsFft
         G9p3p6JjDbHWk8/tAlF6WivaD0XOCRiATIMMXHd3d+CUi32HyUbz1QvNPjMpfc11zYuY
         Sm0A==
X-Gm-Message-State: AOAM532oRlVyVwuZjE3gWRaG9KKTv4Yxh4TKw1JIIo6sSgv6ZP3sUhTn
        GvK+CWyVJMEY5gp5WGq2rAdMSiftBJKMmGKxi7Es1A==
X-Google-Smtp-Source: ABdhPJybkWfJfZCDkFBH5uXogkxvqt3rVv+MgfzBTH16slbKtn5ifaxol5h7rXJ+pKqtqLGkaKeFUZQJZW0KPHV7pSU=
X-Received: by 2002:a4a:d319:: with SMTP id g25mr16246239oos.21.1638613175445;
 Sat, 04 Dec 2021 02:19:35 -0800 (PST)
MIME-Version: 1.0
References: <000000000000bd9ee505b01f60e2@google.com> <00000000000002e72b05cfdeee4d@google.com>
In-Reply-To: <00000000000002e72b05cfdeee4d@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 4 Dec 2021 11:19:24 +0100
Message-ID: <CACT4Y+YbOGFpwtMXSifaiCUroB8ZGsyVJecRTB1OSjLH682+Ag@mail.gmail.com>
Subject: Re: [syzbot] WARNING in hrtimer_forward
To:     syzbot <syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, hchunhui@mail.ustc.edu.cn, hdanton@sina.com,
        ja@ssi.bg, jmorris@namei.org, johannes.berg@intel.com,
        johannes@sipsolutions.net, kaber@trash.net, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Nov 2021 at 10:21, syzbot
<syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 313bbd1990b6ddfdaa7da098d0c56b098a833572
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Sep 15 09:29:37 2021 +0000
>
>     mac80211-hwsim: fix late beacon hrtimer handling
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=108b5712b00000
> start commit:   ba5f4cfeac77 bpf: Add comment to document BTF type PTR_TO_..
> git tree:       bpf-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d44e1360b76d34dc
> dashboard link: https://syzkaller.appspot.com/bug?extid=ca740b95a16399ceb9a5
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1148fe4b900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f5218d900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: mac80211-hwsim: fix late beacon hrtimer handling
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks legit:

#syz fix: mac80211-hwsim: fix late beacon hrtimer handling
