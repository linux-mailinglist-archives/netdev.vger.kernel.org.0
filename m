Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EA7389726
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhEST71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbhEST70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 15:59:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6334C06175F;
        Wed, 19 May 2021 12:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=pa6BrMj2NYTUx+FQfaM5GghsBa5Z3C6LhlWK7oeSwIQ=; b=CZmwYV3jYiu3u0QlcRAzcgEYp6
        N70ofExUBfFF1kwX1ipFzqpMyNGFnVPdiIvNBX2RaByyNGtsyQLk5GMGgB9+JWslTH6SmFTM3yHty
        3zvHdENLmlK1Mb9rPy4qYAuKRRMX63GFMGjnGlN28JXX7oTwMpK92hkCp8O8RBaMMs6+wz0Njge8m
        A6B/mGSWKhyjhnrQ1SvZT14sQWAJoP5aJ+hasMUL07tBlbP8vUWujWFQ1Gwghl2HhebyRezgKhiMW
        6Nbz+I/HWUOeReYO64FxZZGh3DQReLpnehy6prRR+2T22B4xPr7pMyATUFTU1qb8PfN/lrxnLhNqt
        DH+NzPPQ==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljSKO-00Fklp-OW; Wed, 19 May 2021 19:58:00 +0000
Subject: Re: [syzbot] BUG: MAX_LOCKDEP_KEYS too low! (2)
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
References: <0000000000003687bd05c2b2401d@google.com>
 <CACT4Y+YJDGFN4q-aTPritnjjHEXiFovOm9eO6Ay4xC1YOa5z3w@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c545268c-fe62-883c-4c46-974b3bb3cea1@infradead.org>
Date:   Wed, 19 May 2021 12:57:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+YJDGFN4q-aTPritnjjHEXiFovOm9eO6Ay4xC1YOa5z3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/21 12:48 PM, Dmitry Vyukov wrote:
> On Wed, May 19, 2021 at 7:35 PM syzbot
> <syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    b81ac784 net: cdc_eem: fix URL to CDC EEM 1.0 spec
>> git tree:       net
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15a257c3d00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5b86a12e0d1933b5
>> dashboard link: https://syzkaller.appspot.com/bug?extid=a70a6358abd2c3f9550f
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com
>>
>> BUG: MAX_LOCKDEP_KEYS too low!
> 

include/linux/lockdep.h

#define MAX_LOCKDEP_KEYS_BITS		13
#define MAX_LOCKDEP_KEYS		(1UL << MAX_LOCKDEP_KEYS_BITS)

Documentation/locking/lockdep-design.rst:

Troubleshooting:
----------------

The validator tracks a maximum of MAX_LOCKDEP_KEYS number of lock classes.
Exceeding this number will trigger the following lockdep warning::

	(DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))

By default, MAX_LOCKDEP_KEYS is currently set to 8191, and typical
desktop systems have less than 1,000 lock classes, so this warning
normally results from lock-class leakage or failure to properly
initialize locks.  These two problems are illustrated below:

> 
> What config controls this? I don't see "MAX_LOCKDEP_KEYS too low" in
> any of the config descriptions...
> Here is what syzbot used:
> 
> CONFIG_LOCKDEP=y
> CONFIG_LOCKDEP_BITS=16
> CONFIG_LOCKDEP_CHAINS_BITS=17
> CONFIG_LOCKDEP_STACK_TRACE_BITS=20
> CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
> CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
> 
> We already bumped most of these.
> The log contains dump of the lockdep debug files, is there any offender?
> 
> Also looking at the log I noticed a memory safety bug in lockdep implementation:

...

-- 
~Randy

