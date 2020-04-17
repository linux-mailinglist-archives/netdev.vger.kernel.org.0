Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482361AD559
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 06:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgDQEiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 00:38:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56637 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgDQEiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 00:38:11 -0400
Received: from fsav110.sakura.ne.jp (fsav110.sakura.ne.jp [27.133.134.237])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 03H4bbSN080607;
        Fri, 17 Apr 2020 13:37:37 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav110.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav110.sakura.ne.jp);
 Fri, 17 Apr 2020 13:37:37 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav110.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 03H4bUS2080400
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Fri, 17 Apr 2020 13:37:37 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: WARNING: locking bug in tomoyo_supervisor
To:     syzbot <syzbot+1c36440b364ea3774701@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Network Development <netdev@vger.kernel.org>,
        James Chapman <jchapman@katalix.com>
References: <000000000000a475ac05a36fa01e@google.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Message-ID: <5b71a079-54bb-57a0-360d-33fce141504f@i-love.sakura.ne.jp>
Date:   Fri, 17 Apr 2020 13:37:31 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <000000000000a475ac05a36fa01e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/04/17 7:05, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    4f8a3cc1 Merge tag 'x86-urgent-2020-04-12' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1599027de00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3bfbde87e8e65624
> dashboard link: https://syzkaller.appspot.com/bug?extid=1c36440b364ea3774701
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150733cde00000

This seems to be a misattributed report explained at https://lkml.kernel.org/r/20190924140241.be77u2jne3melzte@pathway.suse.cz .
Petr and Sergey, how is the progress of making printk() asynchronous? When can we expect that work to be merged?
If it is delaying, can we implement storing these metadata into the per-CPU buffers?

Anyway,

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10aacf5de00000

bisection log says this will be a duplicate of

#syz dup: WARNING: locking bug in inet_autobind

. This misattribution by chance served as a reminder for "locking bug in inet_autobind" bug. ;-)

According to https://syzkaller.appspot.com/bug?id=a7d678fba80c34b5770cc1b5638b8a2709ae9f3f ,
this bug is happening on "2020/04/01 19:28", "2020/04/09 06:24" and "2020/04/10 20:48"
which are after the opening of the merge window for 5.7-rc1. Reproducer suggests that
pppl2tp and inet6_udp are relevant.

