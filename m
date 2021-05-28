Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC7D394070
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 11:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbhE1J6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 05:58:17 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60344 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236229AbhE1J6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 05:58:15 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5C5EF218B3;
        Fri, 28 May 2021 09:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622195799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dhdQKKFKjVq0AOYJ94M8zTULaqoglwzD51M65ba4TkU=;
        b=bcrRKaP1GJLre/Zq5cnkwbRfyp/acLxsQqxEV73LpzpcavYCf/E8uconIrVnhvXWjSrGpA
        IXKbl4+vgZiyCuNaQC4FSOiZUKQOZCq7DX+pYRuwf2bxUKC5fT4SmZZDssutyySovncCL/
        yQ4pPvBsRVbg59hkE7UX+cBN/nBeF00=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622195799;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dhdQKKFKjVq0AOYJ94M8zTULaqoglwzD51M65ba4TkU=;
        b=2zyj6nHCR2O/JVjQiRV+RYfa3ndqrFN05rtEekrLqwYZQJ63TvusgWLRpPDQF4leVK7sU7
        i8w6V+mes0b0otBw==
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id 3542C11A98;
        Fri, 28 May 2021 09:56:39 +0000 (UTC)
Date:   Fri, 28 May 2021 11:56:38 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Mel Gorman' <mgorman@techsingularity.net>,
        'Andrii Nakryiko' <andrii.nakryiko@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Message-ID: <20210528095637.GO8544@kitsune.suse.cz>
References: <20210526080741.GW30378@techsingularity.net>
 <YK9SiLX1E1KAZORb@infradead.org>
 <20210527090422.GA30378@techsingularity.net>
 <YK9j3YeMTZ+0I8NA@infradead.org>
 <CAEf4BzZLy0s+t+Nj9QgUNM66Ma6HN=VkS+ocgT5h9UwanxHaZQ@mail.gmail.com>
 <CAEf4BzbzPK-3cyLFM8QKE5-o_dL7=UCcvRF+rEqyUcHhyY+FJg@mail.gmail.com>
 <8fe547e9e87f40aebce82021d76a2d08@AcuMS.aculab.com>
 <20210528090421.GK30378@techsingularity.net>
 <2755b39d723146168e875f3b4a851a0d@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2755b39d723146168e875f3b4a851a0d@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 09:49:28AM +0000, David Laight wrote:
> From: Mel Gorman
> > Sent: 28 May 2021 10:04
> > 
> > On Fri, May 28, 2021 at 08:09:39AM +0000, David Laight wrote:
> > > From: Andrii Nakryiko
> > > > Sent: 27 May 2021 15:42
> > > ...
> > > > I agree that empty structs are useful, but here we are talking about
> > > > per-CPU variables only, which is the first use case so far, as far as
> > > > I can see. If we had pahole 1.22 released and widely packaged it could
> > > > have been a viable option to force it on everyone.
> > > ...
> > >
> > > Would it be feasible to put the sources for pahole into the
> > > kernel repository and build it at the same time as objtool?
> > 
> > We don't store other build dependencies like compilers, binutils etc in
> > the kernel repository even though minimum versions are mandated.
> > Obviously tools/ exists but for the most part, they are tools that do
> > not exist in other repositories and are kernel-specific. I don't know if
> > pahole would be accepted and it introduces the possibility that upstream
> > pahole and the kernel fork of it would diverge.
> 
> The other side of the coin is that is you want reproducible builds
> the smaller the number of variables that need to match the better.
> 
> I can see there might be similar issues with the version of libelf-devel
> (needed by objtool).
> If I compile anything with gcc 10 (I'm doing build-root builds)
> I get object files that the hosts 2.30 binutils complain about.
> I can easily see that updating gcc and binutils might leave a
> broken objtool unless the required updated libelf-devel package
> can be found.
> Statically linking the required parts of libelf into objtool
> would save any such problems.

Static libraries are not always available. Especially for core toolchain
libraries the developers often have some ideas about which of the static
and dynamic libraris is the 'correct' one that they like to enforce.

Thanks

Michal
