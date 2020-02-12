Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26D315B406
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgBLWkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:40:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51340 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728603AbgBLWkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:40:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581547252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eL3bOf0Ue8KnmLIX3IiACzfPQmTnby6aitjM8xRfWC8=;
        b=Psw37HH1JYXgYGxwc4RKFtJ1IjM2A90mDdpAh5PK2JopPBAawaxfIO9wAyI/0ujAyXB6yc
        l9d1f4+ZMBzxrsLWjanXDknxgijEgmfbdr3CYylBFLyogurEaQ8kngmaOw/mDnh9Xj6+Hp
        fYVap9SHH4UMRyzyrbggypvAOhr0ob8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-evQGAiydPT-i6Mai_gLHRQ-1; Wed, 12 Feb 2020 17:40:48 -0500
X-MC-Unique: evQGAiydPT-i6Mai_gLHRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 437DFDB61;
        Wed, 12 Feb 2020 22:40:46 +0000 (UTC)
Received: from krava (ovpn-204-72.brq.redhat.com [10.40.204.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FF395C1D6;
        Wed, 12 Feb 2020 22:40:42 +0000 (UTC)
Date:   Wed, 12 Feb 2020 23:40:39 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 00/14] bpf: Add trampoline and dispatcher to
 /proc/kallsyms
Message-ID: <20200212224039.GA233036@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <CAJ+HfNhBDU9c4-0D5RiHFZBq_LN7E=k8=rhL+VbmxJU7rdDBxQ@mail.gmail.com>
 <20200210161751.GC28110@krava>
 <20200211193223.GI3416@kernel.org>
 <20200212111346.GF183981@krava>
 <20200212133125.GA22501@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212133125.GA22501@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 10:31:25AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Feb 12, 2020 at 12:13:46PM +0100, Jiri Olsa escreveu:
> > On Tue, Feb 11, 2020 at 04:32:23PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Historically vmlinux was preferred because it contains function sizes,
> > > but with all these out of the blue symbols, we need to prefer starting
> > > with /proc/kallsyms and, as we do now, continue getting updates via
> > > PERF_RECORD_KSYMBOL.
> 
> > > Humm, but then trampolines don't generate that, right? Or does it? If it
> > > doesn't, then we will know about just the trampolines in place when the
> > > record/top session starts, reparsing /proc/kallsyms periodically seems
> > > excessive?
> 
> > I plan to extend the KSYMBOL interface to contain trampolines/dispatcher
> > data,
> 
> That seems like the sensible, without looking too much at all the
> details, to do, yes.
> 
> > plus we could do some inteligent fallback to /proc/kallsyms in case
> > vmlinux won't have anything
> 
> At this point what would be the good reason to prefer vmlinux instead of
> going straight to using /proc/kallsyms?

symbol (with sizes) and code for dwarf unwind, processor trace

jirka

> 
> We have support for taking a snapshot of it at 'perf top' start, i.e.
> right at the point we need to resolve a kernel symbol, then we get
> PERF_RECORD_KSYMBOL for things that gets in place after that.
> 
> And as well we save it to the build-id cache so that later, at 'perf
> report/script' time we can resolve kernel symbols, etc.
> 
> vmlinux is just what is in there right before boot, after that, for
> quite some time, _lots_ of stuff happens :-)
> 
> - Arnaldo
> 

