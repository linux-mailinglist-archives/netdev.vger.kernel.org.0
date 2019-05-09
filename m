Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0F618A39
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 15:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfEINDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 09:03:08 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:51671 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfEINDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 09:03:07 -0400
Received: by mail-it1-f195.google.com with SMTP id s3so3392136itk.1
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 06:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lrOhAw0sRCAQ3y5JzhUO9qwjE87PxvqK2URtKLv0dZI=;
        b=hFsjYOCxC0gr593JRxNG9FrZD5WWeyw4qCbzAmirygOb1W0pVnpIRSc0BHFIeF84Rr
         Zup0wjcUbalqNiVJcfhmnrrfqNfx9shU03Bcj/oiv0JkM22q/OARveD68F1VNK9cTjU+
         K6g4IjsA0IxEvoxG5ULyyfj3W7nNNvK2NN75sHZdMvtmuryOMn/qUbdGPzD+GhxIt24m
         yPeSAITo/1mMTA4DgBDiHoKLJFnYrO959ROHkscm2ABiiPqTq03KQbyx6fMkDV9mipgO
         bD6xbnkemW9y46LsFKOxo/sHesR40r/GPmATacq2fe3Y7r5eC0ODGhMOfla3cEwquwjW
         bmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lrOhAw0sRCAQ3y5JzhUO9qwjE87PxvqK2URtKLv0dZI=;
        b=DleG6GFCBf2CjgT4H2KSfkpy9L5GqSKmf7U+GVua2eZI64R/d9qnyAlEzoXLi1BEms
         F7IuCo98Nt+NDDwmh1Fuzdbog0o7B5foS77RqOya4ewtLHG0mg3o9v3I11KfYXtmXQQM
         MHTJdiIE88QbJnVrWoDzJUhi6HetNdhfdQrsfGnPXHWhiwmCaKXH+lshPDVu7b60Nvks
         AYOwHsAVxDOMiWZEYxXee/tt9z96UexvqQ9HCpT4LpNOYA0EYjddI+4SdIJ+kwlU8rzU
         yo0iXyHv09gikpEGh/hh0NRER5uEtkKVs56E5zi2EOu3zH9bG7/cmEDudliGu1mpaj6N
         7wNg==
X-Gm-Message-State: APjAAAW8ttcbS78MW6rWyE3RzgqG9g8PNMgyjjCaQyHgCT6a4feUE83M
        /HJotSHE5ZeeQRLHftskMcgRCg1kPJWicyLdKR54ow==
X-Google-Smtp-Source: APXvYqypM/J9GkSNpoEgS1CV7kAoZkYHIvwJjkkGE0RD174ldbjZZlzCy7sGykk2JaOw0C9fRBa5vKmZE5QYCEOfHOQ=
X-Received: by 2002:a05:660c:38a:: with SMTP id x10mr2828361itj.12.1557406986628;
 Thu, 09 May 2019 06:03:06 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000afcf18058364e99e@google.com> <0000000000008497eb0583d26f55@google.com>
In-Reply-To: <0000000000008497eb0583d26f55@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 9 May 2019 15:02:55 +0200
Message-ID: <CACT4Y+ax0TjkaFLoYZL0jZCdRELA7ajnBaAeSANw-hUP--CqJQ@mail.gmail.com>
Subject: Re: WARNING: locking bug in __icmp_send
To:     syzbot <syzbot+173d67242daa7ce45f85@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: syzbot <syzbot+173d67242daa7ce45f85@syzkaller.appspotmail.com>
Date: Mon, Mar 11, 2019 at 3:32 PM
To: <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
<syzkaller-bugs@googlegroups.com>, <yoshfuji@linux-ipv6.org>

> syzbot has bisected this bug to:
>
> commit 8bafb83eeee2efb8b9b4e9dfd9fb90debe4a2417
> Author: David S. Miller <davem@davemloft.net>
> Date:   Fri Mar 30 16:32:00 2018 +0000
>
>      Merge branch 'stmmac-DWMAC5'
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13354d9d200000
> start commit:   8bafb83e Merge branch 'stmmac-DWMAC5'
> git tree:       net
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=10b54d9d200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17354d9d200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=73d88a42238825ad
> dashboard link: https://syzkaller.appspot.com/bug?extid=173d67242daa7ce45f85
> userspace arch: amd64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153d6923200000
>
> Reported-by: syzbot+173d67242daa7ce45f85@syzkaller.appspotmail.com
> Fixes: 8bafb83e ("Merge branch 'stmmac-DWMAC5'")

#syz dup: WARNING: locking bug in icmp_send

https://syzkaller.appspot.com/bug?id=4b9e5e6290e3fdee367ea37949f3bda8d4ec87bd
