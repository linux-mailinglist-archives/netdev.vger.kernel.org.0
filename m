Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5935B2B68E4
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 16:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgKQPlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 10:41:07 -0500
Received: from mx.der-flo.net ([193.160.39.236]:54152 "EHLO mx.der-flo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgKQPlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 10:41:07 -0500
Received: by mx.der-flo.net (Postfix, from userid 110)
        id D48354426F; Tue, 17 Nov 2020 16:40:48 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1203:ecb0:3930:1751:4157:4d75:a5e2])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id 8E8E0441DD;
        Tue, 17 Nov 2020 16:39:09 +0100 (CET)
Date:   Tue, 17 Nov 2020 16:39:02 +0100
From:   Florian Lehner <dev@der-flo.net>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     acme@kernel.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [FIX bpf,perf] bpf,perf: return EOPNOTSUPP for bpf handler on
 PERF_COUNT_SW_DUMMY
Message-ID: <20201117153902.GA6933@der-flo.net>
References: <20201116183752.2716-1-dev@der-flo.net>
 <20201116210209.skeolnndx3gk2xav@kafai-mbp.dhcp.thefacebook.com>
 <20201117075334.GJ3121392@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201117075334.GJ3121392@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 08:53:34AM +0100, Peter Zijlstra wrote:
> On Mon, Nov 16, 2020 at 01:02:09PM -0800, Martin KaFai Lau wrote:
> > On Mon, Nov 16, 2020 at 07:37:52PM +0100, Florian Lehner wrote:
> > > bpf handlers for perf events other than tracepoints, kprobes or uprobes
> > > are attached to the overflow_handler of the perf event.
> > > 
> > > Perf events of type software/dummy are placeholder events. So when
> > > attaching a bpf handle to an overflow_handler of such an event, the bpf
> > > handler will not be triggered.
> > > 
> > > This fix returns the error EOPNOTSUPP to indicate that attaching a bpf
> > > handler to a perf event of type software/dummy is not supported.
> > > 
> > > Signed-off-by: Florian Lehner <dev@der-flo.net>
> > It is missing a Fixes tag.
> 
> I don't think it actually fixes anything. worse it could break things.
> 
> Atatching a bpf filter to a dummy event is pointless, but harmless. We
> allow it now, disallowing it will break whatever programs out there are
> doing harmless silly things.
> 
> I really don't see the point of this patch. It grows the kernel code for
> absolutely no distinguishable benefit.

I agree, this fix does not implement the functionality of attaching a
bpf handler to a perf event of type software/dummy. Instead it returns
an error code and let the user know that this kind of action is not
supported (yet).
As a user I would prefer to get an error for something that is pointless
than needing to debug why an attached bpf handler is never execute.

Do you think it would be better to improve documentation to point this
out? And if so, which documentation would be best to update?
