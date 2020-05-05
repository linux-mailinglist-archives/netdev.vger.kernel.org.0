Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6583D1C5FC0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbgEESLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:11:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22569 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730595AbgEESLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588702276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FUXa2CXmLuQRCLi3xJlNiY+EjIDk0Fg9RVQ/zxz/azE=;
        b=Ew+OdeAIVYU6nOSsvswepMvT/TlKYPq2wCU3jM7XJR4nYiTzXU8a+2/nJXsQFEISd+JxdV
        uD/hXPb/EE9EkkGJH6EPgfqZCKLWSsNLh1bMYMy3pCtYY8F8pclqBhq8tlxVsI8bgyRIKL
        cpvVYZ8N9LguhGrbanwuVOemWb0iPP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-KnVlNyLUPpCFfSK0Az0--w-1; Tue, 05 May 2020 14:11:14 -0400
X-MC-Unique: KnVlNyLUPpCFfSK0Az0--w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78AEE8014D5;
        Tue,  5 May 2020 18:11:12 +0000 (UTC)
Received: from treble (ovpn-119-47.rdu2.redhat.com [10.10.119.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E79635C1B2;
        Tue,  5 May 2020 18:11:10 +0000 (UTC)
Date:   Tue, 5 May 2020 13:11:08 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200505181108.hwcqanvw3qf5qyxk@treble>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
 <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble>
 <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 10:43:00AM -0700, Alexei Starovoitov wrote:
> > Or, if you want to minimize the patch's impact on other arches, and keep
> > the current patch the way it is (with bug fixed and changed patch
> > description), that's fine too.  I can change the patch description
> > accordingly.
> > 
> > Or if you want me to measure the performance impact of the +40% code
> > growth, and *then* decide what to do, that's also fine.  But you'd need
> > to tell me what tests to run.
> 
> I'd like to minimize the risk and avoid code churn,
> so how about we step back and debug it first?
> Which version of gcc are you using and what .config?
> I've tried:
> Linux version 5.7.0-rc2 (gcc version 10.0.1 20200505 (prerelease) (GCC)
> CONFIG_UNWINDER_ORC=y
> # CONFIG_RETPOLINE is not set
> 
> and objtool didn't complain.
> I would like to reproduce it first before making any changes.

Revert

  3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")

and compile with retpolines off (and either ORC or FP, doesn't matter).

I'm using GCC 9.3.1:

  kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x8dc: sibling call from callable instruction with modified stack frame

That's the original issue described in that commit.

> Also since objtool cannot follow the optimizations compiler is doing
> how about admit the design failure and teach objtool to build ORC
> (and whatever else it needs to build) based on dwarf for the functions where
> it cannot understand the assembly code ?
> Otherwise objtool will forever be playing whackamole with compilers.

I agree it's not a good long term approach.  But DWARF has its own
issues and we can't rely on it for live patching.

As I mentioned we have a plan to use a compiler plugin to annotate jump
tables (including GCC switch tables).  But the approach taken by this
patch should be good enough for now.

-- 
Josh

