Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA8D261576
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731962AbgIHQuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731990AbgIHQuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:50:06 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55609C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 09:50:06 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z13so23835iom.8
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 09:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=knw0Phyf4lcxPfcI+W+2G/ZQ7pW6xZfsdOiqIM6ktqw=;
        b=gbVS6FD2jUIirMZ0VSiBlkGctJK8YHe/D8r+K9iY2h+A9JQ9vPz6K1tZrTJuzLXJGc
         wi0+81UIoyLpFFeCDdRpdHs/+gv6KbTw8R5ez+2HciXibKXG1DEcpeWNKlLZZN+7eKmf
         RZd1oh+AKzab39/uY286Owbbv+xiYPnkusIqSlnLLqHDRGzdMiX9IRqLVzTWWoahUpCo
         HayJ2AekQvXOIyANrIMFKkGidp+8DZSdBLvQjVV1Cm9Eb1JYBYmFj6GLZvZOv0D+bnGA
         6P26x73X5oslpxs2NlOrdpbeAOH1XCVtA0N00DCUzlZ+Jr6h7zU/tH9inCeS1tpqcgSS
         YwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=knw0Phyf4lcxPfcI+W+2G/ZQ7pW6xZfsdOiqIM6ktqw=;
        b=llHe9u6qj6dZrScWYeQqLBho60vFLgwZ1mUPo0pTqqaml/VWmVmRQPPFbSmyiVw4U9
         xQFEaekP6Wt1mGmAMblXPBfatK23N9KNzWHT7cIhPHCHdKDJXVOCEz/bU2+gKjnhjRb/
         UwXhLpRS82QSPoEP30aeZTLRMYAxSRWrA5afxPuh+dPEl2Dmv1xGrACnEFHfwHZHCoQH
         N3dLpQwXcTlZ5BS5I0bGfUHsW7h2IhKscWmG3BZvDV8fy4sz+mQ6vtysT29VYaoWZ/bV
         S6tvFYh/G+ByHAUCMftYhuvt7VsgGFrcm7zr5638Qrc3xJHGYnhBuZkOQo/UOpBbnpsU
         X1kQ==
X-Gm-Message-State: AOAM5313kCw5ZjizjIbzhAEFjYrga1NBwxVYcjL61uQkmvteNvb4coQQ
        E3AD7aUu8W0FD9mSG51U1b0=
X-Google-Smtp-Source: ABdhPJw498jKHpRYHw6YA9+jmWpGnowOUF6/uVy8G4HXSJ5ORVxXsXpkR5oCD3jdLA9HMR27W9ckIw==
X-Received: by 2002:a6b:37d5:: with SMTP id e204mr21133351ioa.104.1599583805553;
        Tue, 08 Sep 2020 09:50:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id q23sm3656982iob.19.2020.09.08.09.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 09:50:04 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: avoid lockdep issue in fib6_del()
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200908082023.3690438-1-edumazet@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7f56f2d0-e741-bc24-c671-14e53607be2b@gmail.com>
Date:   Tue, 8 Sep 2020 10:50:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908082023.3690438-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 2:20 AM, Eric Dumazet wrote:
> syzbot reported twice a lockdep issue in fib6_del() [1]
> which I think is caused by net->ipv6.fib6_null_entry
> having a NULL fib6_table pointer.
> 
> fib6_del() already checks for fib6_null_entry special
> case, we only need to return earlier.
> 
> Bug seems to occur very rarely, I have thus chosen
> a 'bug origin' that makes backports not too complex.
> 
> [1]
> WARNING: suspicious RCU usage
> 5.9.0-rc4-syzkaller #0 Not tainted
> -----------------------------
> net/ipv6/ip6_fib.c:1996 suspicious rcu_dereference_protected() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 4 locks held by syz-executor.5/8095:
>  #0: ffffffff8a7ea708 (rtnl_mutex){+.+.}-{3:3}, at: ppp_release+0x178/0x240 drivers/net/ppp/ppp_generic.c:401
>  #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: spin_trylock_bh include/linux/spinlock.h:414 [inline]
>  #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: fib6_run_gc+0x21b/0x2d0 net/ipv6/ip6_fib.c:2312
>  #2: ffffffff89bd6a40 (rcu_read_lock){....}-{1:2}, at: __fib6_clean_all+0x0/0x290 net/ipv6/ip6_fib.c:2613
>  #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
>  #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: __fib6_clean_all+0x107/0x290 net/ipv6/ip6_fib.c:2245
> 
> stack backtrace:
> CPU: 1 PID: 8095 Comm: syz-executor.5 Not tainted 5.9.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x198/0x1fd lib/dump_stack.c:118
>  fib6_del+0x12b4/0x1630 net/ipv6/ip6_fib.c:1996
>  fib6_clean_node+0x39b/0x570 net/ipv6/ip6_fib.c:2180
>  fib6_walk_continue+0x4aa/0x8e0 net/ipv6/ip6_fib.c:2102
>  fib6_walk+0x182/0x370 net/ipv6/ip6_fib.c:2150
>  fib6_clean_tree+0xdb/0x120 net/ipv6/ip6_fib.c:2230
>  __fib6_clean_all+0x120/0x290 net/ipv6/ip6_fib.c:2246

This is walking a table and __fib6_clean_all takes the lock for the
table (and you can see that above), so puzzling how fib6_del can be
called for an entry with NULL fib6_table.
