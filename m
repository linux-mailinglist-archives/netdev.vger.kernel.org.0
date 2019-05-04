Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581F213B49
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 19:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfEDRKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 13:10:03 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62365 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfEDRKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 13:10:02 -0400
Received: from fsav302.sakura.ne.jp (fsav302.sakura.ne.jp [153.120.85.133])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x44HA0uA033874;
        Sun, 5 May 2019 02:10:00 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav302.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav302.sakura.ne.jp);
 Sun, 05 May 2019 02:10:00 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav302.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x44H9xub033633
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Sun, 5 May 2019 02:10:00 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] ipv4: Delete uncached routes upon unregistration of
 loopback device.
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mahesh Bandewar <maheshb@google.com>
References: <0000000000007d22100573d66078@google.com>
 <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <4684eef5-ea50-2965-86a0-492b8b1e4f52@I-love.SAKURA.ne.jp>
 <9d430543-33c3-0d9b-dc77-3a179a8e3919@I-love.SAKURA.ne.jp>
 <920ebaf1-ee87-0dbb-6805-660c1cbce3d0@I-love.SAKURA.ne.jp>
 <cc054b5c-4e95-8d30-d4bf-9c85f7e20092@gmail.com>
 <15b353e9-49a2-f08b-dc45-2e9bad3abfe2@i-love.sakura.ne.jp>
 <057735f0-4475-7a7b-815f-034b1095fa6c@gmail.com>
 <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp>
 <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
 <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com>
 <117fcc49-d389-c389-918f-86ccaef82e51@i-love.sakura.ne.jp>
 <70be7d61-a6fe-e703-978a-d17f544efb44@gmail.com>
 <40199494-8eb7-d861-2e3b-6e20fcebc0dc@i-love.sakura.ne.jp>
 <519ea12b-4c24-9e8e-c5eb-ca02c9c7d264@i-love.sakura.ne.jp>
 <f6f770a7-17af-d51f-3ffb-4edba9b28101@gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <ab80de53-25b8-618b-4dcb-b732059f6f9c@i-love.sakura.ne.jp>
Date:   Sun, 5 May 2019 02:09:59 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f6f770a7-17af-d51f-3ffb-4edba9b28101@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/05/05 0:56, Eric Dumazet wrote:> 
> Well, you have not fixed a bug, you simply made sure that whatever cpu is using the
> routes you forcibly deleted is going to crash the host very soon (use-after-frees have
> undefined behavior, but KASAN should crash most of the times)

I confirmed that this patch survives "#syz test:" before submitting.
But you know that this patch is deleting the route entry too early. OK.

> 
> Please do not send patches like that with a huge CC list, keep networking patches
> to netdev mailing list.

If netdev people started working on this "minutely crashing bug" earlier,
I would not have written a patch...

> 
> Mahesh has an alternative patch, adding a fake device that can not be dismantled
> to make sure we fully intercept skbs sent through a dead route, instead of relying
> on loopback dropping them later at some point.

So, the reason to temporarily move the refcount is to give enough period
so that the route entry is no longer used. But moving the refcount to a
loopback device in a namespace was wrong. Is this understanding correct?

Compared to moving the refcount to the loopback device in the init namespace,
the fake device can somehow drop the refcount moved via rt_flush_dev(), can't it?

Anyway, I'll wait for Mahesh.

