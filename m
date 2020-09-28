Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F4F27B18A
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 18:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgI1QNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 12:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgI1QNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 12:13:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B71C061755;
        Mon, 28 Sep 2020 09:13:44 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601309622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fgursmpxb2O5tZTENK3QKNcBPtJOFO4D16e2e18XLWI=;
        b=PXCpzIO2y+d7baDTO2lerLR1Zg5n8DxenaTvnh3W+iij2F3wPnCcmIfnNnCG44pXW4YJ1t
        Hc+zBZ6W3bv4XgZ5QZjVa7SYP4Fo82SkQHl9UYU0aglc3Lw7cEBNS+K1qvkF5lv8k7PjNm
        o+bXKxBWIfxA85bDmcbeHzNX0645TaH0dc+Blxoy0WOwCba+TjpjezgU+qCZRBoo8Oc01M
        AGMtmBI2QH/PXHT5ewze9sTEe4/+T5ULwWKjEiIPyTnryGOOQeSp0F23hzfNYPwy7Dg1zm
        1Vs+lk/xTxgL1PDJCcB0okhUr/6/70TR8zE8Mo7dwwUtM0hQkRK1rS7hG6/Xyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601309622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fgursmpxb2O5tZTENK3QKNcBPtJOFO4D16e2e18XLWI=;
        b=i1MLe1ztX4w4kIdRrY03/b5cyV5KiZ/2UZ+FERHut/eIc7Bq/k+HmqyxnNGkMDH4/s1WWr
        aRV6Ehox/Vqvl2Cw==
To:     syzbot <syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com>,
        davem@davemloft.net, hchunhui@mail.ustc.edu.cn, hdanton@sina.com,
        ja@ssi.bg, jmorris@namei.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: WARNING in hrtimer_forward
In-Reply-To: <0000000000007d5ec805b04c5fc8@google.com>
References: <0000000000007d5ec805b04c5fc8@google.com>
Date:   Mon, 28 Sep 2020 18:13:42 +0200
Message-ID: <87pn65khft.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27 2020 at 07:29, syzbot wrote:
> syzbot has bisected this issue to:
>
> commit 0e7bbcc104baaade4f64205e9706b7d43c46db7d
> Author: Julian Anastasov <ja@ssi.bg>
> Date:   Wed Jul 27 06:56:50 2016 +0000
>
>     neigh: allow admin to set NUD_STALE
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1661d187900000
> start commit:   ba5f4cfe bpf: Add comment to document BTF type PTR_TO_BTF_..
> git tree:       bpf-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1561d187900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1161d187900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d44e1360b76d34dc
> dashboard link: https://syzkaller.appspot.com/bug?extid=ca740b95a16399ceb9a5
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1148fe4b900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f5218d900000
>
> Reported-by: syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com
> Fixes: 0e7bbcc104ba ("neigh: allow admin to set NUD_STALE")

That bisect does not make any sense and reverting the commit on top of
next does not help either.

What happens is:

            fail-16132   [029] ....   933.714866: sys_enter: NR 16 (3, 8b28, 20000000, 0, 0, 0)
          <idle>-0       [001] d.s2   933.715768: hrtimer_cancel: hrtimer=00000000fe9fe1b9
          <idle>-0       [001] ..s1   933.715771: hrtimer_expire_entry: hrtimer=00000000fe9fe1b9 function=mac80211_hwsim_beacon now=933716506319
            fail-16132   [029] d..1   933.715794: hrtimer_start: hrtimer=00000000fe9fe1b9 function=mac80211_hwsim_beacon expires=933818720770 softexpires=933818720770 mode=REL|SOFT
          <idle>-0       [001] ..s1   933.715812: hrtimer_forward: hrtimer=00000000fe9fe1b9

So the timer was armed at some point and then the expiry which does the
forward races with the ioctl which starts the timer. Lack of
serialization or such ...

Thanks,

        tglx

