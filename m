Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9DD1424E2
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 09:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgATITW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 03:19:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41770 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgATITW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 03:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lv6mWV+LyBEpHARixm1MrWLqdXwoOkowEDIcmQHZnc0=; b=K242n6o0jAV2chrAfUWM2qOEKD
        pFQAkqMOBGF2gB/c3h630UEUAffnHDCcvHqDGASyUzUxxwxVonblqWWaxvJLxo1i9mWVjyV6EXhPA
        uuJ0WhRJF9qk1mpJr29Wc4Hc7MCk/5Uxiz1/8/RLWNPGOLGa84F+8ITD4QwvLQHFht++tuq1qgIfr
        yOEGRW5/dfMp3nr6gLe+9Tv9boTVIcYaMzjQnaqslvThV91NI7g2SBBLCgUJAjDk/fM5+GL75tcq6
        Q8yJi9r7l33dJnKA0zy1gFENHyr2RK4WUdiRw0qik1sGeWRnA24SD9DAWA1GuBMR1jEg+V/hi3mFc
        kUDCsnVQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1itSH2-0007Y6-TP; Mon, 20 Jan 2020 08:19:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 634EC3035D4;
        Mon, 20 Jan 2020 09:17:20 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 936C820983E34; Mon, 20 Jan 2020 09:18:58 +0100 (CET)
Date:   Mon, 20 Jan 2020 09:18:58 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinyuqi@huawei.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        guoyang2@huawei.com, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
Message-ID: <20200120081858.GI14879@hirez.programming.kicks-ass.net>
References: <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
 <7e6c6202-24bb-a532-adde-d53dd6fb14c3@gmail.com>
 <20200117180324.GA2623847@rani.riverdale.lan>
 <94573cea-a833-9b48-6581-8cc5cdd19b89@gmail.com>
 <20200117183800.GA2649345@rani.riverdale.lan>
 <45224c36-9941-aae5-aca4-e2c8e3723355@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45224c36-9941-aae5-aca4-e2c8e3723355@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 10:48:19AM -0800, Eric Dumazet wrote:
> 
> 
> On 1/17/20 10:38 AM, Arvind Sankar wrote:
> > On Fri, Jan 17, 2020 at 10:16:45AM -0800, Eric Dumazet wrote:
> >> Wasńt it the case back in 2016 already for linux-4.8 ?
> >>
> >> What will prevent someone to send another report to netdev/lkml ?
> >>
> >>  -fno-strict-overflow support is not a prereq for CONFIG_UBSAN.
> >>
> >> Fact that we kept in lib/ubsan.c and lib/test_ubsan.c code for 
> >> test_ubsan_add_overflow() and test_ubsan_sub_overflow() is disturbing.
> >>
> > 
> > No, it was bumped in 2018 in commit cafa0010cd51 ("Raise the minimum
> > required gcc version to 4.6"). That raised it from 3.2 -> 4.6.
> > 
> 
> This seems good to me, for gcc at least.
> 
> Maybe it is time to enfore -fno-strict-overflow in KBUILD_CFLAGS 
> instead of making it conditional.

IIRC there was a bug in UBSAN vs -fwrapv/-fno-strict-overflow that was
only fixed in gcc-8 or 9 or so.

So while the -fwrapv/-fno-strict-overflow flag has been correctly
supported since like forever, UBSAN was buggy until quite recent when
used in conjustion with that flag.
