Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4946911B94B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 17:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbfLKQ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 11:56:16 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34491 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726444AbfLKQ4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 11:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576083374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KPNvaGpq3HBFsvPBMbtFzNSf8jY+m1mkWfo8bwQYb1M=;
        b=fa8iH4fx/eBTIxK1t50omahAapkCGbKWouGEIXIPA4SCTYXPCMvV5Oqx7c7a0u6pfTC/jk
        cff6++Q1TEU1u6nZ8+gmHyg1jRsKnLU1uvsIM3NI1Me/YIZqZalbiDvv4uVDf191tXxXG+
        sKahBhb1RAqnAPJ16rT4zkFhTHBN3Mc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-BWJS7TFYMbKlq0NdBdIvLw-1; Wed, 11 Dec 2019 11:56:10 -0500
X-MC-Unique: BWJS7TFYMbKlq0NdBdIvLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F353F911EF;
        Wed, 11 Dec 2019 16:56:08 +0000 (UTC)
Received: from krava (unknown [10.43.17.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68AEC66074;
        Wed, 11 Dec 2019 16:56:03 +0000 (UTC)
Date:   Wed, 11 Dec 2019 17:56:00 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCHv3] bpf: Emit audit messages upon successful prog load and
 unload
Message-ID: <20191211165600.GG25474@krava>
References: <20191206214934.11319-1-jolsa@kernel.org>
 <20191209121537.GA14170@linux.fritz.box>
 <CAHC9VhQdOGTj1HT1cwvAdE1sRpzk5mC+oHQLHgJFa3vXEij+og@mail.gmail.com>
 <d387184e-9c5f-d5b2-0acb-57b794235cbd@iogearbox.net>
 <CAHC9VhRDsEDGripZRrVNcjEBEEULPk+0dRp-uJ3nmmBK7B=sYQ@mail.gmail.com>
 <20191210153652.GA14123@krava>
 <CAHC9VhSa_B-VJOa_r8OcNrm0Yd_t1j3otWhKHgganSDx5Ni=Tg@mail.gmail.com>
 <20191211131955.GC23383@linux.fritz.box>
 <CAHC9VhQqiD7BBGwLYuQVySG84iwR9MJh8GZuTU3xCBm7GLn8hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQqiD7BBGwLYuQVySG84iwR9MJh8GZuTU3xCBm7GLn8hw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 11:21:33AM -0500, Paul Moore wrote:
> On Wed, Dec 11, 2019 at 8:20 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > On Tue, Dec 10, 2019 at 05:45:59PM -0500, Paul Moore wrote:
> > > On Tue, Dec 10, 2019 at 10:37 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > On Mon, Dec 09, 2019 at 06:53:23PM -0500, Paul Moore wrote:
> > > > > On Mon, Dec 9, 2019 at 6:19 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > > On 12/9/19 3:56 PM, Paul Moore wrote:
> > > > > > > On Mon, Dec 9, 2019 at 7:15 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > > >> On Fri, Dec 06, 2019 at 10:49:34PM +0100, Jiri Olsa wrote:
> > > > > > >>> From: Daniel Borkmann <daniel@iogearbox.net>
> > > > > > >>>
> > > > > > >>> Allow for audit messages to be emitted upon BPF program load and
> > > > > > >>> unload for having a timeline of events. The load itself is in
> > > > > > >>> syscall context, so additional info about the process initiating
> > > > > > >>> the BPF prog creation can be logged and later directly correlated
> > > > > > >>> to the unload event.
> > > > > > >>>
> > > > > > >>> The only info really needed from BPF side is the globally unique
> > > > > > >>> prog ID where then audit user space tooling can query / dump all
> > > > > > >>> info needed about the specific BPF program right upon load event
> > > > > > >>> and enrich the record, thus these changes needed here can be kept
> > > > > > >>> small and non-intrusive to the core.
> > > > > > >>>
> > > > > > >>> Raw example output:
> > > > > > >>>
> > > > > > >>>    # auditctl -D
> > > > > > >>>    # auditctl -a always,exit -F arch=x86_64 -S bpf
> > > > > > >>>    # ausearch --start recent -m 1334
> > > > > > >>>    ...
> > > > > > >>>    ----
> > > > > > >>>    time->Wed Nov 27 16:04:13 2019
> > > > > > >>>    type=PROCTITLE msg=audit(1574867053.120:84664): proctitle="./bpf"
> > > > > > >>>    type=SYSCALL msg=audit(1574867053.120:84664): arch=c000003e syscall=321   \
> > > > > > >>>      success=yes exit=3 a0=5 a1=7ffea484fbe0 a2=70 a3=0 items=0 ppid=7477    \
> > > > > > >>>      pid=12698 auid=1001 uid=1001 gid=1001 euid=1001 suid=1001 fsuid=1001    \
> > > > > > >>>      egid=1001 sgid=1001 fsgid=1001 tty=pts2 ses=4 comm="bpf"                \
> > > > > > >>>      exe="/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"                  \
> > > > > > >>>      subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
> > > > > > >>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84664): prog-id=76 op=LOAD
> > > > > > >>>    ----
> > > > > > >>>    time->Wed Nov 27 16:04:13 2019
> > > > > > >>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84665): prog-id=76 op=UNLOAD
> > > > > > >>>    ...
> > > > > > >>>
> > > > > > >>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > > > > >>> Co-developed-by: Jiri Olsa <jolsa@kernel.org>
> > > > > > >>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > > >>
> > > > > > >> Paul, Steve, given the merge window is closed by now, does this version look
> > > > > > >> okay to you for proceeding to merge into bpf-next?
> > > > > > >
> > > > > > > Given the change to audit UAPI I was hoping to merge this via the
> > > > > > > audit/next tree, is that okay with you?
> > > > > >
> > > > > > Hm, my main concern is that given all the main changes are in BPF core and
> > > > > > usually the BPF subsystem has plenty of changes per release coming in that we'd
> > > > > > end up generating unnecessary merge conflicts. Given the include/uapi/linux/audit.h
> > > > > > UAPI diff is a one-line change, my preference would be to merge via bpf-next with
> > > > > > your ACK or SOB added. Does that work for you as well as?
> > > > >
> > > > > I regularly (a few times a week) run the audit and SELinux tests
> > > > > against Linus+audit/next+selinux/next to make sure things are working
> > > > > as expected and that some other subsystem has introduced a change
> > > > > which has broken something.  If you are willing to ensure the tests
> > > > > get run, including your new BPF audit tests I would be okay with that;
> > > > > is that acceptable?
> > > >
> > > > would you please let me know which tree this landed at the end?
> > >
> > > I think that's what we are trying to figure out - Daniel?
> >
> > Yeah, sounds reasonable wrt running tests to make sure nothing breaks. In that
> > case I'd wait for your ACK or SOB to proceed with merging into bpf-next. Thanks
> > Paul!
> 
> As long as you're going to keep testing this, here ya go :)
> 
> Acked-by: Paul Moore <paul@paul-moore.com>
> 
> (also, go ahead and submit that PR for audit-testsuite - thanks!)

https://github.com/linux-audit/audit-testsuite/pull/90

thanks,
jirka

