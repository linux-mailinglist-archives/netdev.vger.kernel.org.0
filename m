Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1C91409CE
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 13:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgAQMdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 07:33:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48440 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgAQMdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 07:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3jYS1ZEmTmMSRX8PguHajTLWnTrFdecI+q7fihgLtLs=; b=gHWhwlO7GYuoIeZlewk6yJEEU
        YDiZwouIIHdPzZzA3bX7ZtX51CVaTXq+lQeQuEhAN5SA4DUQEiMEE1O8jFZDq19fykG0yDy9LOf5W
        oFp8HS4lyL45Kg7JizBBeXj5V5wMbdd9eCtuBc3scT71bFvpH7nNHM38gmDYvL0fdM04LmUziWpbW
        G/wvsm9ZjyYg9p0/+yAOwOLwmTdOQJOpxkkC5xMGg3aO+Pmf4mNP/P2g78QSQ51isBiC7faIroSbn
        fO19ro09kPsl42eofzATrmKhEah0fkc2DzD4nDoa/p+Mvq5r2n2XBZz3u+LScaCfyafkP1yCvco7j
        ujMVu7jhA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isQo5-0006x3-He; Fri, 17 Jan 2020 12:32:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5A522305EEC;
        Fri, 17 Jan 2020 13:31:16 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 61FEB202CF680; Fri, 17 Jan 2020 13:32:53 +0100 (CET)
Date:   Fri, 17 Jan 2020 13:32:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinyuqi@huawei.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        guoyang2@huawei.com, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
Message-ID: <20200117123253.GC14879@hirez.programming.kicks-ass.net>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 02:54:03PM +0800, Shaokun Zhang wrote:
> So how about this? ;-)
> 
>                 delta = prandom_u32_max(now - old);
> 
> +#ifdef CONFIG_UBSAN
>         /* Do not use atomic_add_return() as it makes UBSAN unhappy */
> +       old = (u32)atomic_read(p_id);
>         do {
> -               old = (u32)atomic_read(p_id);
>                 new = old + delta + segs;
> -       } while (atomic_cmpxchg(p_id, old, new) != old);
> +       } while (!atomic_try_cmpxchg(p_id, &old, new));
> +#else
> +       new = atomic_add_return(segs + delta, p_id);
> +#endif

That's crazy, just accept that UBSAN is taking bonghits and ignore it.
Use atomic_add_return() unconditionally.
