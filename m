Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0B62466F2
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgHQNGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:06:21 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56738 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgHQNGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 09:06:19 -0400
Received: from fsav404.sakura.ne.jp (fsav404.sakura.ne.jp [133.242.250.103])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 07HD6GQK065030;
        Mon, 17 Aug 2020 22:06:16 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav404.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav404.sakura.ne.jp);
 Mon, 17 Aug 2020 22:06:16 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav404.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 07HD6A2e065007
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 17 Aug 2020 22:06:16 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] mwifiex: don't call del_timer_sync() on uninitialized
 timer
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        amit karwar <amitkarwar@gmail.com>, andreyknvl@google.com,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, Nishant Sarmukadam <nishants@marvell.com>,
        syzbot+dc4127f950da51639216@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>
References: <MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <1595900652-3842-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <CA+ASDXMHt2gq9Hy+iP_BYkWXsSreWdp3_bAfMkNcuqJ3K+-jbQ@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <45dd8b7c-584d-40dc-342a-6d894e0e68c8@i-love.sakura.ne.jp>
Date:   Mon, 17 Aug 2020 22:06:07 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+ASDXMHt2gq9Hy+iP_BYkWXsSreWdp3_bAfMkNcuqJ3K+-jbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ganapathi, how do you want to fix this bug?

On 2020/07/29 3:45, Brian Norris wrote:
>> syzbot is reporting that del_timer_sync() is called from
>> mwifiex_usb_cleanup_tx_aggr() from mwifiex_unregister_dev() without
>> checking timer_setup() from mwifiex_usb_tx_init() was called [1].
>> Since mwifiex_usb_prepare_tx_aggr_skb() is calling del_timer() if
>> is_hold_timer_set == true, use the same condition for del_timer_sync().
>>
>> [1] https://syzkaller.appspot.com/bug?id=fdeef9cf7348be8b8ab5b847f2ed993aba8ea7b6
>>
>> Reported-by: syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>
>> Cc: Ganapathi Bhat <gbhat@marvell.com>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> ---
>> A patch from Ganapathi Bhat ( https://patchwork.kernel.org/patch/10990275/ ) is stalling
>> at https://lore.kernel.org/linux-usb/MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com/ .
>> syzbot by now got this report for 10000 times. Do we want to go with this simple patch?
> 
> Sorry, that stall is partly my fault, and partly Ganapathi's. It
> doesn't help that it took him 4 months to reply to my questions, so I
> completely lost even the tiny bit of context I had managed to build up
> in my head at initial review time... and so it's still buried in the
> dark corners of my inbox. (I think I'll go archive that now, because
> it really deserves a better sell than it had initially, if Ganapathi
> really wants to land it.)
