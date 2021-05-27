Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60D8393189
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbhE0O4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:56:18 -0400
Received: from outbound-smtp37.blacknight.com ([46.22.139.220]:40209 "EHLO
        outbound-smtp37.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234847AbhE0O4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:56:16 -0400
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp37.blacknight.com (Postfix) with ESMTPS id F08F51EF9
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 15:54:42 +0100 (IST)
Received: (qmail 21500 invoked from network); 27 May 2021 14:54:42 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.23.168])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 27 May 2021 14:54:42 -0000
Date:   Thu, 27 May 2021 15:54:41 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>,
        Linux-BPF <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v2] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Message-ID: <20210527145441.GE30378@techsingularity.net>
References: <20210527120251.GC30378@techsingularity.net>
 <CAEf4BzartMG36AGs-7LkQdpgrB6TYyTJ8PQhjkQWiTN=7sO1Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAEf4BzartMG36AGs-7LkQdpgrB6TYyTJ8PQhjkQWiTN=7sO1Bw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 07:37:05AM -0700, Andrii Nakryiko wrote:
> > This patch checks for older versions of pahole and only allows
> > DEBUG_INFO_BTF_MODULES if pahole supports zero-sized per-cpu structures.
> > DEBUG_INFO_BTF is still allowed as a KVM boot test passed with pahole
> 
> Unfortunately this won't work. The problem is that vmlinux BTF is
> corrupted, which results in module BTFs to be rejected as well, as
> they depend on it.
> 
> But vmlinux BTF corruption makes BPF subsystem completely unusable. So
> even though kernel boots, nothing BPF-related works. So we'd need to
> add dependency for DEBUG_INFO_BTF on pahole 1.22+.
> 

While bpf usage would be broken, the kernel will boot and the effect
should be transparent to any kernel build based on "make oldconfig".
CONFIG_DEBUG_INFO_BTF defaults N so if that is forced out, it will be
easily missed by a distribution kernel maintainer.

Yes, users of BPF will be affected and it may generate bug reports but
the fix will be to build with a working pahole. Breaking boot on the other
hand is a lot more visible and hacking around this with a non-zero struct
size has been shot down.

-- 
Mel Gorman
SUSE Labs
