Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1C22B81D8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgKRQ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgKRQ1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:27:01 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9752724818;
        Wed, 18 Nov 2020 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605716820;
        bh=d6fcYi77BXc0FDTlYdszbLc7LzeiPITJH4/OZIoT2Sg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dAHGsinRGFxYeHu9dwjrFUIo14FWc38Mv6mosYACM0CItOIG6P+Rylwmr8ZMzCW2v
         E+bR4pkNQ6SKYXvZAkFpHP+C+n65mHUjTlpEI35S5nbPWyz/eIgfV+kxSxpyrvw0Av
         L3lZOKAv8jyozkH11r5jtDatMK/yDwyIc4EFNIyQ=
Date:   Wed, 18 Nov 2020 08:26:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        linmiaohe@huawei.com, martin.varghese@nokia.com, pabeni@redhat.com,
        pshelar@ovn.org, fw@strlen.de, gnault@redhat.com,
        steffen.klassert@secunet.com, kyk.segfault@gmail.com,
        viro@zeniv.linux.org.uk, vladimir.oltean@nxp.com,
        edumazet@google.com, saeed@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: add in_softirq() debug checking in
 napi_consume_skb()
Message-ID: <20201118082658.2aa41190@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118155757.GY3121392@hirez.programming.kicks-ass.net>
References: <1603971288-4786-1-git-send-email-linyunsheng@huawei.com>
        <20201031153824.7ae83b90@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <5b04ad33-1611-8d7b-8fec-4269c01ecab3@huawei.com>
        <20201102114110.4a20d461@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <5bd6de52-b8e0-db6f-3362-862ae7b2c728@huawei.com>
        <20201118074348.3bbd1468@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201118155757.GY3121392@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 16:57:57 +0100 Peter Zijlstra wrote:
> On Wed, Nov 18, 2020 at 07:43:48AM -0800, Jakub Kicinski wrote:
> 
> > TBH the last sentence I wrote isn't clear even to me at this point ;D
> > 
> > Maybe using just the macros from preempt.h - like this?
> > 
> > #define lockdep_assert_in_softirq()                                    \
> > do {                                                                   \
> >        WARN_ON_ONCE(__lockdep_enabled                  &&              \
> >                     (!in_softirq() || in_irq() || in_nmi())	\
> > } while (0)
> > 
> > We know what we're doing so in_softirq() should be fine (famous last
> > words).  
> 
> So that's not actually using any lockdep state. But if that's what you
> need, I don't have any real complaints.

Great, thanks! 

The motivation was to piggy back on lockdep rather than adding a
one-off Kconfig knob for a check in the fast path in networking.
