Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB8044E3A9
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 10:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhKLJQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 04:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbhKLJQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 04:16:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DF9C061767
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 01:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bmOJRqUnHuXWxtVarDDqZw2i4uch4i3uWSZPKYi2voI=; b=CCPhcu8oSu9emQzJ/RPY8E5H/V
        tfImNrTTXAGVdYOTsJLq2QqHeyNFThCmcNeStR/OvHGxJpF3OyMGqmsbshXx14yUqqQMGu2H/hLs6
        FmB2ltHKK4oQYew24pnPiWfn3mkydFEeUFU587fYfFmmUE446K4Bs/8LdTNVWI7BvPWZzd92PiSn5
        OnOl1WTqtbYOS1r0wZIWiR3U88Uk+REN2eaoA0y2Tt0tRGLkJGGEYPZhDEXHb2NNZe2D4M93+wJw8
        875+PIM+9UAPwM2tGorHO930r5Kqp2+e1X88RoXz3wntj+1HQNvDHxKcuakfK3rQZ4ErDCx+HeeCc
        RU6hfMRw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlScp-003Oh3-O7; Fri, 12 Nov 2021 09:13:36 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E966230001B;
        Fri, 12 Nov 2021 10:13:34 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5497E2019EC36; Fri, 12 Nov 2021 10:13:34 +0100 (CET)
Date:   Fri, 12 Nov 2021 10:13:34 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v1] x86/csum: rewrite csum_partial()
Message-ID: <YY4wPgyt65Q6WOdK@hirez.programming.kicks-ass.net>
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
 <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
 <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 02:30:50PM -0800, Eric Dumazet wrote:
> > For values 7 through 1 I wonder if you wouldn't be better served by
> > just doing a single QWORD read and a pair of shifts. Something along
> > the lines of:
> >     if (len) {
> >         shift = (8 - len) * 8;
> >         temp64 = (*(unsigned long)buff << shift) >> shift;
> >         result += temp64;
> >         result += result < temp64;
> >     }
> 
> Again, KASAN will not be happy.

If you do it in asm, kasan will not know, so who cares :-) as long as
the load is aligned, loading beyond @len shouldn't be a problem,
otherwise there's load_unaligned_zeropad().
