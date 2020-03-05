Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7434C17A109
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 09:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgCEIQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 03:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgCEIQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 03:16:22 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 523C32073D;
        Thu,  5 Mar 2020 08:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583396181;
        bh=5S7btBui38a4/pFvORCkt8E9I2wN6CwB43TY2KMdVbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QgBRkgPfSNa8ac49RezTfRMt9axB1L+/JxyGnsbJHfttK//AGYEGAYJat48dAyIIT
         47e65ZcspABqZzxW+CAepKHM+M+9gomGZTsJBRw6fH6sHrETj4Z7BvPBMUw7uJCLDc
         TI+cBPG3YIIGVSpEnTtViMZ7ReWeQ3KV/dVK/ZBE=
Date:   Thu, 5 Mar 2020 00:16:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200305001620.204c292e@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200305010706.dk7zedpyj5pb5jcv@ast-mbp>
References: <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
        <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
        <87pndt4268.fsf@toke.dk>
        <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
        <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
        <87k1413whq.fsf@toke.dk>
        <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
        <20200304114000.56888dac@kicinski-fedora-PC1C0HJN>
        <20200304204506.wli3enu5w25b35h7@ast-mbp>
        <20200304132439.6abadbe3@kicinski-fedora-PC1C0HJN>
        <20200305010706.dk7zedpyj5pb5jcv@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Mar 2020 17:07:08 -0800, Alexei Starovoitov wrote:
> > Maybe also the thief should not have CAP_ADMIN in the first place?
> > And ask a daemon to perform its actions..  
> 
> a daemon idea keeps coming back in circles.
> With FD-based kprobe/uprobe/tracepoint/fexit/fentry that problem is gone,
> but xdp, tc, cgroup still don't have the owner concept.
> Some people argued that these three need three separate daemons.
> Especially since cgroups are mainly managed by systemd plus container
> manager it's quite different from networking (xdp, tc) where something
> like 'networkd' might makes sense.
> But if you take this line of thought all the ways systemd should be that
> single daemon to coordinate attaching to xdp, tc, cgroup because
> in many cases cgroup and tc progs have to coordinate the work.

The feature creep could happen, but Toke's proposal has a fairly simple
feature set, which should be easy to cover by a stand alone daemon.

Toke, I saw that in the library discussion there was no mention of 
a daemon, what makes a daemon solution unsuitable?

> At that's where it's getting gloomy... unless the kernel can provide
> a facility so central daemon is not necessary.
> 
> > > current xdp, tc, cgroup apis don't have the concept of the link
> > > and owner of that link.  
> > 
> > Why do the attachment points have to have a concept of an owner and 
> > not the program itself?  
> 
> bpf program is an object. That object has an owner or multiple owners.
> A user process that holds a pointer to that object is a shared owner.
> FD is such pointer. FD == std::shared_ptr<bpf_prog>.
> Holding that pointer guarantees that <bpf_prog> will not disappear,
> but it says nothing that the program will keep running.
> For [ku]probe,tp,fentry,fexit there was always <bpf_link> in the kernel.
> It wasn't that formal in the past until most recent Andrii's patches,
> but the concept existed for long time. FD == std::shared_ptr<bpf_link>
> connects a kernel object with <bpf_prog>. When that kernel objects emits
> an event the <bpf_link> guarantees that <bpf_prog> will be executed.

I see so the link is sort of [owner -> prog -> target].

> For cgroups we don't have such concept. We thought that three attach modes we
> introduced (default, allow-override, allow-multi) will cover all use cases. But
> in practice turned out that it only works when there is a central daemon for
> _all_ cgroup-bpf progs in the system otherwise different processes step on each
> other. More so there has to be a central diff-review human authority otherwise
> teams step on each other. That's sort-of works within one org, but doesn't
> scale.
> 
> To avoid making systemd a central place to coordinate attaching xdp, tc, cgroup
> progs the kernel has to provide a mechanism for an application to connect a
> kernel object with a prog and hold the ownership of that link so that no other
> process in the system can break that connection. 

To me for XDP the promise that nothing breaks the connection cannot be
made without a daemon, because without the daemon the link has to be
available somewhere/pinned to make changes to, and therefore is no
longer safe. (Lock but with a key right next to it, in the previous
analogies.)

And daemon IMHO can just monitor the changes. No different how we would
monitor for applications fiddling with any other networking state,
addresses, routes, device config, you name it. XDP changes already fire
link change notification, that's there probably from day one.

> That kernel object is cgroup,
> qdisc, netdev. Interesting question comes when that object disappears. What to
> do with the link? Two ways to solve it:
> 1. make link hold the object, so it cannot be removed.
> 2. destroy the link when object goes away.
> Both have pros and cons as I mentioned earlier. And that's what's to be decided.
> I think the truth is somewhat in the middle. The link has to hold the object,
> so it doesn't disappear from under it, but get notified on deletion, so the
> link can be self destroyed. From the user point of view the execution guarantee
> is still preserved. The kernel object was removed and the link has one dangling
> side. Note this behavior is vastly different from existing xdp, tc, cgroup
> behavior where both object and bpf prog can be alive, but connection is gone
> and execution guarantee is broken.
