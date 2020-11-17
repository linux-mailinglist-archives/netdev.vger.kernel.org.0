Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942352B5A8B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 08:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgKQHyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 02:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgKQHyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 02:54:01 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFA0C0613CF;
        Mon, 16 Nov 2020 23:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YobMuSYlNrh+KHmGSO1/4i3Jnd8oZDx2P712IaeZeYE=; b=1bFmE6PPQrI2gsq08QMUVAKwkx
        cqKKVUqQ+YnUb/qVkv0JbTnZM1fhKxH+0ABnxNKunEef7drwHISJ1LdsqHseGEaMyhdcc5qwWvyA4
        f39GQOuDz4bD9e0cgHSlTIAcPRoJ7Iu06u49p76aMPp6RCe68/i/hIBj3aV/Q1VAnYarlNbYr5Zmn
        81dyL4P+kvrGc2zJki/6QzjF3sUyNECZ5sqVoM4xfoaNEtxOLgVXJdxEq2fEdzoC/mi+/10+tqiTj
        3+SGj/ztWusR5A0mG/FUorR7GSxM2yR5c6nLSDZE9rFqLfxwPnq8Or1gj9B2/lfl11R1HovpIv6if
        yt9g/X3A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kevo4-00051K-CH; Tue, 17 Nov 2020 07:53:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A3CF03012DC;
        Tue, 17 Nov 2020 08:53:34 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 862292018BF97; Tue, 17 Nov 2020 08:53:34 +0100 (CET)
Date:   Tue, 17 Nov 2020 08:53:34 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Florian Lehner <dev@der-flo.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        john.fastabend@gmail.com, mingo@redhat.com, acme@kernel.org
Subject: Re: [FIX bpf,perf] bpf,perf: return EOPNOTSUPP for bpf handler on
 PERF_COUNT_SW_DUMMY
Message-ID: <20201117075334.GJ3121392@hirez.programming.kicks-ass.net>
References: <20201116183752.2716-1-dev@der-flo.net>
 <20201116210209.skeolnndx3gk2xav@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116210209.skeolnndx3gk2xav@kafai-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 01:02:09PM -0800, Martin KaFai Lau wrote:
> On Mon, Nov 16, 2020 at 07:37:52PM +0100, Florian Lehner wrote:
> > bpf handlers for perf events other than tracepoints, kprobes or uprobes
> > are attached to the overflow_handler of the perf event.
> > 
> > Perf events of type software/dummy are placeholder events. So when
> > attaching a bpf handle to an overflow_handler of such an event, the bpf
> > handler will not be triggered.
> > 
> > This fix returns the error EOPNOTSUPP to indicate that attaching a bpf
> > handler to a perf event of type software/dummy is not supported.
> > 
> > Signed-off-by: Florian Lehner <dev@der-flo.net>
> It is missing a Fixes tag.

I don't think it actually fixes anything. worse it could break things.

Atatching a bpf filter to a dummy event is pointless, but harmless. We
allow it now, disallowing it will break whatever programs out there are
doing harmless silly things.

I really don't see the point of this patch. It grows the kernel code for
absolutely no distinguishable benefit.
