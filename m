Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF6E112644
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 10:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfLDJBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 04:01:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58811 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727136AbfLDJBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 04:01:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575450104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RN/l+ytAzaNhoJcK3/jpshrBdeMaQLMrqTK8LFIbtHY=;
        b=eXjNzFA5swYkW2iXOK74t3sAObY5Ht6t9VToNEw/gs+zq0PHwa/bhkUUf3ZCgxNdOP8pK6
        1lCs7dY9oHOceXbBt27NDQSKbwphf8E0pet8Zs1DzdzVDH/xMl4BxeW292juTcIVWoO8SA
        6/XuGOFCRtI3RvOe5VCbTH5T/DDqqWQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-T7xi4hn_Nv2nC2A-iPYaew-1; Wed, 04 Dec 2019 04:01:43 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4774107ACC7;
        Wed,  4 Dec 2019 09:01:39 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A81031D1;
        Wed,  4 Dec 2019 09:01:30 +0000 (UTC)
Date:   Wed, 4 Dec 2019 10:01:28 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191204090128.GA20746@krava>
References: <20191202131847.30837-1-jolsa@kernel.org>
 <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
 <87wobepgy0.fsf@toke.dk>
 <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: T7xi4hn_Nv2nC2A-iPYaew-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 09:52:11PM -0800, Alexei Starovoitov wrote:
> On Mon, Dec 2, 2019 at 1:15 PM Toke H=F8iland-J=F8rgensen <toke@redhat.co=
m> wrote:
> >
> > Ah, that is my mistake: I was getting dynamic libbpf symbols with this
> > approach, but that was because I had the version of libbpf.so in my
> > $LIBDIR that had the patch to expose the netlink APIs as versioned
> > symbols; so it was just pulling in everything from the shared library.
> >
> > So what I was going for was exactly what you described above; but it
> > seems that doesn't actually work. Too bad, and sorry for wasting your
> > time on this :/
>=20
> bpftool is currently tightly coupled with libbpf and very likely
> in the future the dependency will be even tighter.
> In that sense bpftool is an extension of libbpf and libbpf is an extensio=
n
> of bpftool.
> Andrii is working on set of patches to generate user space .c code
> from bpf program.
> bpftool will be generating the code that is specific for the version
> bpftool and for
> the version of libbpf. There will be compatibility layers as usual.
> But in general the situation where a bug in libbpf is so criticial
> that bpftool needs to repackaged is imo less likely than a bug in
> bpftool that will require re-packaging of libbpf.
> bpftool is quite special. It's not a typical user of libbpf.
> The other way around is more correct. libbpf is a user of the code
> that bpftool generates and both depend on each other.
> perf on the other side is what typical user space app that uses
> libbpf will look like.
> I think keeping bpftool in the kernel while packaging libbpf
> out of github was an oversight.
> I think we need to mirror bpftool into github/libbpf as well
> and make sure they stay together. The version of libbpf =3D=3D version of=
 bpftool.
> Both should come from the same package and so on.
> May be they can be two different packages but
> upgrading one should trigger upgrade of another and vice versa.
> I think one package would be easier though.
> Thoughts?

great, makes sense.. Toke already mentioned we might need to move
bpftool to libbpf package to solve our issues, now when you guys
have already plans for that, it works for us ;-)

thanks for sharing the plan,
jirka

