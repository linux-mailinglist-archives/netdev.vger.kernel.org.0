Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0F1144DE8
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAVItS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:49:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47042 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVItS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 03:49:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YCaO7HkGDxrq9uLeSsmssHBPXstORVfrji7Ya82A6ow=; b=PBZryFkN7FC0BHIdjcadjnluY
        3F/Z7Lu1TSTlHaw3CydYtJIXZVTAJyy7f3/Apj2YOlxDOozUOnmwwekxLBYgirt9ETkOhAA7qKfgA
        X3UGUF3In4IqthKVlMA509WVRTdL0+VSMSj7+CP6XBjIk87bMjt1i3qyJnndgFB0DaOMzoB8UdItI
        9SWKyYlnUSQbPcnnfzgGXmEShdDfGoKuXJHKbqQLXuhTtjE1g7hiV0KJYkb+rcal9IhELt3OvAhfO
        6B3EO1ZF2+QKlFM1VExdc+vtGUFpzzjPHRpTYj9tvPKPJZww6EBw4jqA7v4zQBPxXyzkFDBFR+3xf
        tmIJFVoVQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iuBhB-0000IC-2I; Wed, 22 Jan 2020 08:49:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D7315304121;
        Wed, 22 Jan 2020 09:47:22 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 262E82B703E5E; Wed, 22 Jan 2020 09:49:02 +0100 (CET)
Date:   Wed, 22 Jan 2020 09:49:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, jinyuqi@huawei.com,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        guoyang2@huawei.com, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
Message-ID: <20200122084902.GQ14914@hirez.programming.kicks-ass.net>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
 <5fd55696-e46c-4269-c106-79782efb0dd8@hisilicon.com>
 <CANn89iJ02iFxGibdqO+YWVYX4q4J=W9vv7HOpMVqNK-qZvHcQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJ02iFxGibdqO+YWVYX4q4J=W9vv7HOpMVqNK-qZvHcQw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 18, 2020 at 08:12:48PM -0800, Eric Dumazet wrote:
> Instead the changelog should be explaining why the revert is now safe.

FWIW, it was always safe, UBSAN was just buggy.
