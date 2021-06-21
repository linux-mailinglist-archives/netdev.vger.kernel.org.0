Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739E43AF955
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 01:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhFUXcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 19:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhFUXcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 19:32:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF67361107;
        Mon, 21 Jun 2021 23:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624318190;
        bh=KJ7WjNmYBh491XSyMu7GNf72RVITjezyvu+GpDfxP68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZRXiSwzfgMsXsiyC6PWxyDTyeLja1PzZZTgHJ4+ieqEm9pHgyvX4b0Ukpr5uohPCM
         V95Cs41ac4+X87InUs201y7VO5n67lQ7OKsenZlHOt27nKOg2oc3D70x8+JYGgtKnp
         Um6v60oA+Gkzy33QwxRw4LZ6WAejU+YpWrPlXYQShZMjHIWhZYcyrmNiB0KYgplv07
         jiToLQYF8JmJg10sFhWnuk/XNSO48GFDDBmE17Hceq43zPOp7sLF2hXjX2CpPxDIzC
         kVxLpeQNZwEuzlix6otpNhemDOeFC6JQLtUwszniDv7CuPtW7LnPSO3C/QP9LU2O4s
         rn2A3zIQWfJ9A==
Date:   Mon, 21 Jun 2021 16:29:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <yunshenglin0825@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        olteanv@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, edumazet@google.com, weiwan@google.com,
        cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, hdanton@sina.com, jgross@suse.com,
        JKosina@suse.com, mkubecek@suse.cz, bjorn@kernel.org,
        alobakin@pm.me
Subject: Re: [PATCH net v2] net: sched: add barrier to ensure correct
 ordering for lockless qdisc
Message-ID: <20210621162948.179f0753@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210619103009.GA1530@ip-172-31-30-86.us-east-2.compute.internal>
References: <1623891854-57416-1-git-send-email-linyunsheng@huawei.com>
        <20210618173047.68db0b81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210618173837.0131edc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210619103009.GA1530@ip-172-31-30-86.us-east-2.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Jun 2021 10:30:09 +0000 Yunsheng Lin wrote:
> When debugging pointed to the misordering between STATE_MISSED
> setting/clearing and STATE_MISSED checking, only _after_atomic()
> was added first, and it did not fix the misordering problem,
> when both _before_atomic() and _after_atomic() were added, the
> misordering problem disappeared.
> 
> I suppose _before_atomic() matters because the STATE_MISSED
> setting and the lock rechecking is only done when first check of
> STATE_MISSED returns false. _before_atomic() is used to make sure
> the first check returns correct result, if it does not return the
> correct result, then we may have misordering problem too.
> 
>      cpu0                        cpu1
>                               clear MISSED
>                              _after_atomic()
>                                 dequeue
>     enqueue
>  first trylock() #false
>   MISSED check #*true* ?
> 
> As above, even cpu1 has a _after_atomic() between clearing
> STATE_MISSED and dequeuing, we might stiil need a barrier to
> prevent cpu0 doing speculative MISSED checking before cpu1
> clearing MISSED?
> 
> And the implicit load-acquire barrier contained in the first
> trylock() does not seems to prevent the above case too.
> 
> And there is no load-acquire barrier in pfifo_fast_dequeue()
> too, which possibly make the above case more likely to happen.

Ah, you're right. The test_bit() was not in the patch context, 
I forgot it's there... Both barriers are indeed needed.
