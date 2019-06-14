Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A350B45704
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFNILa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:11:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60474 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfFNILa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=USG8NWPdVBgY5Ej2X/EDSC1YVY6FY+uYmg/tOOLTTFo=; b=F751dU49JkcOCni8fL2Qt0e2R
        526jP56gRAGvqGQopmBVt6ByAtqWtTPuVRjmAQFCMc85IhMtr9ojAqwZyKTL7iA6waWtkxWITHOoM
        f8/MVsucKiaQz/8neYKfB6i7z78g64oPDzJNOqZdb+gRvysCzZrs1dOBUgy7lsVSaw/8ncAORS4d+
        QEZXCl6TlW53imd7FYTVEMyF7lHl9bQpZ+JYkIV3vFtbfPRLeStaAM7JLFjp/WHsQi6EAi0QhsBDO
        ZUbBHyY2kvgnsxG+2DA5/RgYbH6JyY1UakyxxTxhjgFqtFxyjSQulKXZdt1OWF3B39o7xiu96x6kK
        LosCUCu+Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbhIs-0003ta-Ag; Fri, 14 Jun 2019 08:11:18 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C40FB20A15636; Fri, 14 Jun 2019 10:11:16 +0200 (CEST)
Date:   Fri, 14 Jun 2019 10:11:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 2/9] objtool: Fix ORC unwinding in non-JIT BPF generated
 code
Message-ID: <20190614081116.GU3436@hirez.programming.kicks-ass.net>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
 <20190613205710.et5fywop4gfalsa6@ast-mbp.dhcp.thefacebook.com>
 <20190614012030.b6eujm7b4psu62kj@treble>
 <20190614070852.GQ3436@hirez.programming.kicks-ass.net>
 <20190614073536.d3xkhwhq3fuivwt5@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614073536.d3xkhwhq3fuivwt5@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:35:38AM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 09:08:52AM +0200, Peter Zijlstra wrote:
> > On Thu, Jun 13, 2019 at 08:20:30PM -0500, Josh Poimboeuf wrote:
> > > On Thu, Jun 13, 2019 at 01:57:11PM -0700, Alexei Starovoitov wrote:
> > 
> > > > and to patches 8 and 9.
> > > 
> > > Well, it's your code, but ... can I ask why?  AT&T syntax is the
> > > standard for Linux, which is in fact the OS we are developing for.
> > 
> > I agree, all assembly in Linux is AT&T, adding Intel notation only
> > serves to cause confusion.
> 
> It's not assembly. It's C code that generates binary and here
> we're talking about comments.

And comments are useless if they don't clarify. Intel syntax confuses.

> I'm sure you're not proposing to do:
> /* mov src, dst */
> #define EMIT_mov(DST, SRC)                                                               \
> right?

Which is why Josh reversed both of them. The current Intel order is just
terribly confusing. And I don't see any of the other JITs having
confusing comments like this.

> bpf_jit_comp.c stays as-is. Enough of it.

I think you're forgetting this is also arch/x86 code, and no, it needs
changes because its broken wrt unwinding.
