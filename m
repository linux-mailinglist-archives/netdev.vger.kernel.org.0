Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CF231CDBE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 17:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhBPQNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 11:13:54 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11547 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhBPQNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 11:13:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602beef20003>; Tue, 16 Feb 2021 08:12:34 -0800
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Feb 2021 16:12:32 +0000
References: <0000000000005243f805b05abc7c@google.com>
 <00000000000008f12905bb0923e0@google.com>
 <CAM_iQpVEZiOca0po6N5Hcp67LV98k_PhbEXogCJFjpOR0AbGwg@mail.gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     syzbot <syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com>,
        "David Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Jiri Pirko" <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: null-ptr-deref Read in tcf_idrinfo_destroy
In-Reply-To: <CAM_iQpVEZiOca0po6N5Hcp67LV98k_PhbEXogCJFjpOR0AbGwg@mail.gmail.com>
Date:   Tue, 16 Feb 2021 18:12:29 +0200
Message-ID: <ygnh35xwrnyq.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613491954; bh=iueBWvrzQvXvpiyEkIDejuii6oURkDiMVH2u8gFcUWU=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=pvdrQCW9Wc+7YIOJh3I5O29T7sl5MkIlhfukUO6oEmY2OdvLjHcxm2tkKIqv2tFwW
         2ZxveW6VNA7uSJ3/YQ3NAvRMwgkvKDE/ELEbz9EqdVfY6NbA5IT/YLIki1f67Tna0D
         WJnmveJGreRcDlxSMPWgXCmRdefpkdhCib3xooXSjihrZCOjQubjJZrHhaCbH+z5Rn
         ScyvK7OHUccGYCsjY/kfN/VJAY4oG3e3H5qXS+9cd8JgUbVKlT0TNZOCQpFBYfrkvA
         MCQZ037Xrmo9xg782X4+LjKi3qs8+X/x/ba+Ovdd00xAnAeGKpTDgh4LDEuOndNSUs
         NuoQviAE/bx1w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 16 Feb 2021 at 01:22, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Feb 10, 2021 at 9:53 PM syzbot
> <syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com> wrote:
>>
>> syzbot has found a reproducer for the following issue on:
>>
>> HEAD commit:    291009f6 Merge tag 'pm-5.11-rc8' of git://git.kernel.org/p..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14470d18d00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=a53fd47f16f22f8c
>> dashboard link: https://syzkaller.appspot.com/bug?extid=151e3e714d34ae4ce7e8
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f45814d00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f4aff8d00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:71 [inline]
>> BUG: KASAN: null-ptr-deref in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
>> BUG: KASAN: null-ptr-deref in __tcf_idr_release net/sched/act_api.c:178 [inline]
>> BUG: KASAN: null-ptr-deref in tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
>> Read of size 4 at addr 0000000000000010 by task kworker/u4:5/204
>>
>> CPU: 0 PID: 204 Comm: kworker/u4:5 Not tainted 5.11.0-rc7-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Workqueue: netns cleanup_net
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:79 [inline]
>>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>>  __kasan_report mm/kasan/report.c:400 [inline]
>>  kasan_report.cold+0x5f/0xd5 mm/kasan/report.c:413
>>  check_memory_region_inline mm/kasan/generic.c:179 [inline]
>>  check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
>>  instrument_atomic_read include/linux/instrumented.h:71 [inline]
>>  atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
>>  __tcf_idr_release net/sched/act_api.c:178 [inline]
>>  tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
>>  tc_action_net_exit include/net/act_api.h:151 [inline]
>>  police_exit_net+0x168/0x360 net/sched/act_police.c:390
>
> This is really strange. It seems we still left some -EBUSY placeholders
> in the idr, however, we actually call tcf_action_destroy() to clean up
> everything including -EBUSY ones on error path.
>
> What do you think, Vlad?
>
> Thanks.

Hi Cong,

I couldn't reproduce the issue with syzbot repro.c, but it looks like we
are missing tcf_idr_insert_many() in exts->police handling code inside
tcf_exts_validate() which calls tcf_action_init_1(). After recent
changes action is no longer inserted in idr by init_1 and requires
manual call to tcf_idr_insert_many(). I'll send a fix.

Regards,
Vlad
