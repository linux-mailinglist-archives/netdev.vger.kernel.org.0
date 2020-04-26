Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE721B93B5
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 21:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgDZTnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 15:43:20 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55279 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgDZTnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 15:43:20 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e76007a9;
        Sun, 26 Apr 2020 19:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Q95WupxJotcACUWONTVu7EW65Ro=; b=bYO8K8
        UeSNbeGbha+u6Z+X4OWjAckkt578muPBYfljxTemQveUyZ4Y4KqM3k5XP3wLRZN3
        3mYbpBfLS7i0PpncwzhsYoncBN8ReR5a/OkMjlGMooXNhMaeWFyl3aNqIi+dVcW5
        XrVcNxNrpXIIa/A+YYSAurfsFS7n25G0dWk+n5zm0J3HEeTWS6Hdyhd4Zjk3oKgS
        qha1334mjnFs+Z7o8hcpMwI+D1TUO1jYj++hJNUACygOipLiP2fRE42PDXMcXzTA
        Y+QNHPHPi3Uxr0XHqfQ2KNxqhX4lR1zeaTfSN33UxQOu1cyFzO8lQwRfVgdy23uG
        5kPRxtnoVNbQkuyA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a45018e5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 26 Apr 2020 19:31:46 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id u189so14740028ilc.4;
        Sun, 26 Apr 2020 12:43:11 -0700 (PDT)
X-Gm-Message-State: AGi0PuZQXvRTigFAKCzD2TWIRZvSoUg3vp2NAHEMQqTqxxE5VOtNh79Z
        +ttimxxB8QjU2QwSPSjkWAgyaP/sAGKcWREV1t4=
X-Google-Smtp-Source: APiQypJhdrWBdGhX+odG4xvM1xd9YLFfY6dps9KqG4u5HpuETWThfLmwYZGpIfmkBCsKnMx1fb9tGxaDOvBguexuC5A=
X-Received: by 2002:a92:5c82:: with SMTP id d2mr18807878ilg.231.1587930190268;
 Sun, 26 Apr 2020 12:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005fd19505a4355311@google.com> <e40c443e-74aa-bad4-7be8-4cdddfdf3eaf@gmail.com>
In-Reply-To: <e40c443e-74aa-bad4-7be8-4cdddfdf3eaf@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 26 Apr 2020 13:42:58 -0600
X-Gmail-Original-Message-ID: <CAHmME9ov2ae08UTzwKL7enquChzDNxpg4c=ppnJqS2QF6ZAn_Q@mail.gmail.com>
Message-ID: <CAHmME9ov2ae08UTzwKL7enquChzDNxpg4c=ppnJqS2QF6ZAn_Q@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in wg_packet_tx_worker
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jhs@mojatatu.com,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        Krzysztof Kozlowski <krzk@kernel.org>, kuba@kernel.org,
        kvalo@codeaurora.org, leon@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>, vivien.didelot@gmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 1:40 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 4/26/20 10:57 AM, syzbot wrote:
> > syzbot has bisected this bug to:
> >
> > commit e7096c131e5161fa3b8e52a650d7719d2857adfd
> > Author: Jason A. Donenfeld <Jason@zx2c4.com>
> > Date:   Sun Dec 8 23:27:34 2019 +0000
> >
> >     net: WireGuard secure network tunnel
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15258fcfe00000
> > start commit:   b2768df2 Merge branch 'for-linus' of git://git.kernel.org/..
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=17258fcfe00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13258fcfe00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
> > dashboard link: https://syzkaller.appspot.com/bug?extid=0251e883fe39e7a0cb0a
> > userspace arch: i386
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f5f47fe00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e8efb4100000
> >
> > Reported-by: syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com
> > Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> >
>
> I have not looked at the repro closely, but WireGuard has some workers
> that might loop forever, cond_resched() might help a bit.

I'm working on this right now. Having a bit difficult of a time
getting it to reproduce locally...

The reports show the stall happening always at:

static struct sk_buff *
sfq_dequeue(struct Qdisc *sch)
{
       struct sfq_sched_data *q = qdisc_priv(sch);
       struct sk_buff *skb;
       sfq_index a, next_a;
       struct sfq_slot *slot;

       /* No active slots */
       if (q->tail == NULL)
               return NULL;

next_slot:
       a = q->tail->next;
       slot = &q->slots[a];

Which is kind of interesting, because it's not like that should block
or anything, unless there's some kasan faulting happening.
