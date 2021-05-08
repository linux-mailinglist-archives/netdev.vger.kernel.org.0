Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9680376F0E
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 05:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhEHDGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 23:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230399AbhEHDGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 23:06:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF4646112F;
        Sat,  8 May 2021 03:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620443117;
        bh=UCWz0d1P680+8OLROOU7w4JlmYYVS6cncSAWi1+HSM4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VdR3exQSHYmPJOJ9LOTeCOOKI6FLRVGU6O/onZW5RqvCHiAZHqIvcnIT8NOv0nYJA
         GUlWOpc83MHytIbWhBIJ+C97V6uv2sWWSldCJl3Kmrd+yCWwaoBGON3QCe71QYsh1R
         sbQRPVwgdv1a+QBfJ78zQnPEUdU+VhmoiW/B6XX0RDwY2aL+sZXyCk2YuAhHcCUHDr
         4/LSS647o+3VlFBcgvRtkRXBjomRp/T3DTGll4l9Ml28Dux7KWjlgUdbVK1vAhkOyL
         j6xnlYDC7eS8OZLb0usW/YJ2GyrCYhTvk94kBMNFU8IWwAyq+FUon1nYHACKY0rVXw
         hb9pgAznglEzw==
Date:   Fri, 7 May 2021 20:05:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>
Subject: Re: [PATCH net v5 1/3] net: sched: fix packet stuck problem for
 lockless qdisc
Message-ID: <20210507200514.0567ef27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <83ff1619-5ca3-1e60-3a41-0faff1566569@huawei.com>
References: <1620266264-48109-1-git-send-email-linyunsheng@huawei.com>
        <1620266264-48109-2-git-send-email-linyunsheng@huawei.com>
        <20210507165703.70771c55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <83ff1619-5ca3-1e60-3a41-0faff1566569@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 May 2021 10:55:19 +0800 Yunsheng Lin wrote:
> >> +		 * the flag set after releasing lock and reschedule the
> >> +		 * net_tx_action() to do the dequeuing.  
> > 
> > I don't understand why MISSED is checked before the trylock.
> > Could you explain why it can't be tested directly here?  
> The initial thinking was:
> Just like the set_bit() before the second trylock, If MISSED is set
> before first trylock, it means other thread has set the MISSED flag
> for this thread before doing the first trylock, so that this thread
> does not need to do the set_bit().
> 
> But the initial thinking seems over thinking, as thread 3' setting the
> MISSED before the second trylock has ensure either thread 3' second
> trylock returns ture or thread 2 holding the lock will see the MISSED
> flag, so thread 1 can do the test_bit() before or after the first
> trylock, as below:
> 
>     thread 1                thread 2                    thread 3
>                          holding q->seqlock
> first trylock failed                              first trylock failed
>                          unlock q->seqlock
>                                                test_bit(MISSED) return false
>                    test_bit(MISSED) return false
>                           and not reschedule
>                                                       set_bit(MISSED)
> 						      trylock success
> test_bit(MISSED) retun ture
> and not retry second trylock
> 
> If the above is correct, it seems we could:
> 1. do test_bit(MISSED) before the first trylock to avoid doing the
>    first trylock for contended case.
> or
> 2. do test_bit(MISSED) after the first trylock to avoid doing the
>    test_bit() for un-contended case.
> 
> Which one do you prefer?

No strong preference but testing after the trylock seems more obvious
as it saves the temporary variable.

For the contended case could we potentially move or add a MISSED test
before even the first try_lock()? I'm not good at optimizing things, 
but it could save us the atomic op, right? (at least on x86)
