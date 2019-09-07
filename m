Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837A7AC4F2
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 08:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406480AbfIGGyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 02:54:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729409AbfIGGyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 02:54:19 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 845F33B72D;
        Sat,  7 Sep 2019 06:54:18 +0000 (UTC)
Received: from krava (ovpn-204-49.brq.redhat.com [10.40.204.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A16385C1B2;
        Sat,  7 Sep 2019 06:54:15 +0000 (UTC)
Date:   Sat, 7 Sep 2019 08:54:13 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH 0/7] libbpf: Fix cast away const qualifiers in btf.h
Message-ID: <20190907065413.GA31822@krava>
References: <20190906073144.31068-1-jolsa@kernel.org>
 <62e760de-e746-c512-350a-c2188a2bb3ed@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62e760de-e746-c512-350a-c2188a2bb3ed@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Sat, 07 Sep 2019 06:54:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 09:09:17AM +0000, Andrii Nakryiko wrote:
> On 9/6/19 8:31 AM, Jiri Olsa wrote:
> > hi,
> > when including btf.h in bpftrace, I'm getting -Wcast-qual warnings like:
> > 
> >    bpf/btf.h: In function ‘btf_var_secinfo* btf_var_secinfos(const btf_type*)’:
> >    bpf/btf.h:302:41: warning: cast from type ‘const btf_type*’ to type
> >    ‘btf_var_secinfo*’ casts away qualifiers [-Wcast-qual]
> >      302 |  return (struct btf_var_secinfo *)(t + 1);
> >          |                                         ^
> > 
> > I changed the btf.h header to comply with -Wcast-qual checks
> > and used const cast away casting in libbpf objects, where it's
> 
> Hey Jiri,
> 
> We made all those helper funcs return non-const structs intentionally to 
> improve their usability and avoid all those casts that you added back.
> 
> Also, those helpers are now part of public API, so we can't just change 
> them to const, as it can break existing users easily.
> 
> If there is a need to run with -Wcast-qual, we should probably disable 
> those checks where appropriate in libbpf code.
> 
> So this will be a NACK from me, sorry.

ok, I'll disable disable it in bpftrace code then

thanks,
jirka

> 
> > all related to deduplication code, so I believe loosing const
> > is fine there.
> > 
> > thanks,
> > jirka
> > 
> > 
> > ---
> > Jiri Olsa (7):
> >        libbpf: Use const cast for btf_int_* functions
> >        libbpf: Return const btf_array from btf_array inline function
> >        libbpf: Return const btf_enum from btf_enum inline function
> >        libbpf: Return const btf_member from btf_members inline function
> >        libbpf: Return const btf_param from btf_params inline function
> >        libbpf: Return const btf_var from btf_var inline function
> >        libbpf: Return const struct btf_var_secinfo from btf_var_secinfos inline function
> > 
> >   tools/lib/bpf/btf.c    | 21 +++++++++++----------
> >   tools/lib/bpf/btf.h    | 30 +++++++++++++++---------------
> >   tools/lib/bpf/libbpf.c |  2 +-
> >   3 files changed, 27 insertions(+), 26 deletions(-)
> > 
> 
