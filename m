Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22DC2A6475
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 13:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgKDMhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 07:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729583AbgKDMhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 07:37:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E988DC0613D3;
        Wed,  4 Nov 2020 04:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=69FU7ghO8WjsOmkJBEaPXkg/5I7NmXJk48zGhGZfh5c=; b=DdiM6pmP17iaTQZK78CwSqwIdk
        ftBOvVdB7bDIbJ+/LFWc0maCiKEb6La4jbRQ+hM0NuiZbuxbhdUfJAu3PCNVw5N5ACpN2nkfVT3pP
        Q0o0ElPhsQ5maVjWWZsn1qYX62TrhRHI8n5cv9cqrCeX5ianDOn9piz6dhjNF9ajB8An0+QKFGQ9t
        /fnk4EznR60SFOCWUTfhbgUsR85pvt9wHSfhSyRcJUIczRqAwj/b0xGy4VONVBqf2zpaNoSGlHwke
        its7Dq1AFdh7JA3Qb64jfDFPJ4EshK67PoVZulrhb/P7lSrlx/Q9RmJMPRY5Be9iAnQYX+JkluPy/
        5StLcHog==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kaI27-0005YU-Ea; Wed, 04 Nov 2020 12:36:59 +0000
Date:   Wed, 4 Nov 2020 12:36:59 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        venkat.x.venkatsubra@oracle.com, manjunath.b.patil@oracle.com,
        joe.jin@oracle.com, srinivas.eeda@oracle.com
Subject: Re: [PATCH 1/1] mm: avoid re-using pfmemalloc page in
 page_frag_alloc()
Message-ID: <20201104123659.GA17076@casper.infradead.org>
References: <20201103193239.1807-1-dongli.zhang@oracle.com>
 <20201103203500.GG27442@casper.infradead.org>
 <7141038d-af06-70b2-9f50-bf9fdf252e22@oracle.com>
 <20201103211541.GH27442@casper.infradead.org>
 <20201104011640.GE2445@rnichana-ThinkPad-T480>
 <2bce996a-0a62-9d14-4310-a4c5cb1ddeae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2bce996a-0a62-9d14-4310-a4c5cb1ddeae@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 09:50:30AM +0100, Eric Dumazet wrote:
> On 11/4/20 2:16 AM, Rama Nichanamatlu wrote:
> >> Thanks for providing the numbers.  Do you think that dropping (up to)
> >> 7 packets is acceptable?
> > 
> > net.ipv4.tcp_syn_retries = 6
> > 
> > tcp clients wouldn't even get that far leading to connect establish issues.
> 
> This does not really matter. If host was under memory pressure,
> dropping a few packets is really not an issue.
> 
> Please do not add expensive checks in fast path, just to "not drop a packet"
> even if the world is collapsing.

Right, that was my first patch -- to only recheck if we're about to
reuse the page.  Do you think that's acceptable, or is that still too
close to the fast path?

> Also consider that NIC typically have thousands of pre-allocated page/frags
> for their RX ring buffers, they might all have pfmemalloc set, so we are speaking
> of thousands of packet drops before the RX-ring can be refilled with normal (non pfmemalloc) page/frags.
> 
> If we want to solve this issue more generically, we would have to try
> to copy data into a non pfmemalloc frag instead of dropping skb that
> had frags allocated minutes ago under memory pressure.

I don't think we need to copy anything.  We need to figure out if the
system is still under memory pressure, and if not, we can clear the
pfmemalloc bit on the frag, as in my second patch.  The 'least change'
way of doing that is to try to allocate a page, but the VM could export
a symbol that says "we're not under memory pressure any more".

Did you want to move checking that into the networking layer, or do you
want to keep it in the pagefrag allocator?
