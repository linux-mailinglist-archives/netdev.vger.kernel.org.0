Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC2DC1134F2
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbfLDS1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 13:27:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:40604 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbfLDS1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 13:27:40 -0500
Received: from [194.230.159.159] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1icZN2-0004rF-GG; Wed, 04 Dec 2019 19:27:28 +0100
Date:   Wed, 4 Dec 2019 19:27:27 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
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
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191204182727.GA29780@localhost.localdomain>
References: <20191202131847.30837-1-jolsa@kernel.org>
 <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
 <87wobepgy0.fsf@toke.dk>
 <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
 <877e3cpdc9.fsf@toke.dk>
 <CAADnVQJeC9FQDXhv34KTiFSRq-=x4cBaspj-bTXdQ1=7prphcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJeC9FQDXhv34KTiFSRq-=x4cBaspj-bTXdQ1=7prphcA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25653/Wed Dec  4 10:46:42 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 09:39:59AM -0800, Alexei Starovoitov wrote:
> On Wed, Dec 4, 2019 at 2:58 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > On Mon, Dec 2, 2019 at 1:15 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > >>
> > >> Ah, that is my mistake: I was getting dynamic libbpf symbols with this
> > >> approach, but that was because I had the version of libbpf.so in my
> > >> $LIBDIR that had the patch to expose the netlink APIs as versioned
> > >> symbols; so it was just pulling in everything from the shared library.
> > >>
> > >> So what I was going for was exactly what you described above; but it
> > >> seems that doesn't actually work. Too bad, and sorry for wasting your
> > >> time on this :/
> > >
> > > bpftool is currently tightly coupled with libbpf and very likely
> > > in the future the dependency will be even tighter.
> > > In that sense bpftool is an extension of libbpf and libbpf is an extension
> > > of bpftool.
> > > Andrii is working on set of patches to generate user space .c code
> > > from bpf program.
> > > bpftool will be generating the code that is specific for the version
> > > bpftool and for
> > > the version of libbpf. There will be compatibility layers as usual.
> > > But in general the situation where a bug in libbpf is so criticial
> > > that bpftool needs to repackaged is imo less likely than a bug in
> > > bpftool that will require re-packaging of libbpf.
> > > bpftool is quite special. It's not a typical user of libbpf.
> > > The other way around is more correct. libbpf is a user of the code
> > > that bpftool generates and both depend on each other.
> > > perf on the other side is what typical user space app that uses
> > > libbpf will look like.
> > > I think keeping bpftool in the kernel while packaging libbpf
> > > out of github was an oversight.
> > > I think we need to mirror bpftool into github/libbpf as well
> > > and make sure they stay together. The version of libbpf == version of bpftool.
> > > Both should come from the same package and so on.
> > > May be they can be two different packages but
> > > upgrading one should trigger upgrade of another and vice versa.
> > > I think one package would be easier though.
> > > Thoughts?
> >
> > Yup, making bpftool explicitly the "libbpf command line interface" makes
> > sense and would help clarify the relationship between the two. As Jiri
> > said, we are already moving in that direction packaging-wise...
> 
> Awesome. Let's figure out the logistics.
> Should we do:
> git mv tools/bpf/bpftool/ tools/lib/bpf/
> and appropriate adjustment to Makefiles ?
> or keep it where it is and only add to
> https://github.com/libbpf/libbpf/blob/master/scripts/sync-kernel.sh ?

I'd be in preference of the latter aka keeping where it is.

Thanks,
Daniel
