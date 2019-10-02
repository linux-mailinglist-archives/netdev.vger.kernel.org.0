Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3CCC93B9
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfJBVvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:51:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:58952 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfJBVvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:51:02 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFmWJ-0005sg-V3; Wed, 02 Oct 2019 23:50:52 +0200
Date:   Wed, 2 Oct 2019 23:50:51 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: test_progs: don't leak server_fd
 in test_sockopt_inherit
Message-ID: <20191002215051.GB9196@pc-66.home>
References: <20191001173728.149786-1-brianvv@google.com>
 <20191001173728.149786-3-brianvv@google.com>
 <CAEf4BzYxs6Ace8s64ML3pA9H4y0vgdWv_vDF57oy3i-O_G7c-g@mail.gmail.com>
 <CABCgpaWbPN+2vSNdynHtmDxrgGbyzHa_D-y4-X8hLrQYbhTx=A@mail.gmail.com>
 <20191002085553.GA6226@pc-66.home>
 <CAEf4BzZAywR2g4bRu8Bs-YJxzf64GTrR7NvgOaXG2fqaKiJpSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZAywR2g4bRu8Bs-YJxzf64GTrR7NvgOaXG2fqaKiJpSQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25590/Wed Oct  2 10:31:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 01:30:14PM -0700, Andrii Nakryiko wrote:
> On Wed, Oct 2, 2019 at 1:56 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > On Tue, Oct 01, 2019 at 08:42:30PM -0700, Brian Vazquez wrote:
> > > Thanks for reviewing the patches Andrii!
> > >
> > > Although Daniel fixed them and applied them correctly.
> >
> > After last kernel/maintainer summit at LPC, I reworked all my patchwork scripts [0]
> > which I use for bpf trees in order to further reduce manual work and add more sanity
> > checks at the same time. Therefore, the broken Fixes: tag was a good test-case. ;-)
> 
> Do you scripts also capitalize first word after libbpf: prefix? Is
> that intentional? Is that a recommended subject casing:
> 
> "libbpf: Do awesome stuff" vs "libbpf: do awesome stuff"?

Right now we have a bit of a mix on that regard, and basically what the
pw-apply script from [0] is doing, is the following to provide some more
context:

- Pulls the series mbox specified by series id from patchwork, dumps all
  necessary information about the series, e.g. whether it's complete and
  all patches are present, etc.
- Pushes the mbox through mb2q which is a script that x86 maintainers and
  few others use for their patch management and spills out a new mbox.
  This is effectively 'normalizing' the patches from the mbox to bring in
  some more consistency, meaning it adds Link: tags to every patch based
  on the message id and checks whether the necessary mailing list aka
  bpf was in Cc, so we always have lore BPF archive links, sorts tags so
  they all have a consistent order, it allows to propagate Acked-by,
  Reviewed-by, Tested-by tags from cover letter into the individual
  patches, it also capitalizes the first word after the subsystem prefix.
- It applies and merges the resulting mbox, and performs additional checks
  for the newly added commit range, that is, it checks whether Fixes tags
  are correctly formatted, whether the commit exists at all in the tree or
  whether subject / sha is wrong, and throws warnings to me so I can fix
  them up if needed or toss out the series again worst case, as well as
  checks whether SOB from the patch authors is present and matches their
  name.
- It allows to set the patches from the series into accepted state in
  patchwork.

So overall less manual work / checks than what used to be before while
improving / ensuring more consistency in the commits at the same time.
If you have further suggestions / improvements / patches to pw.git,
happy to hear. :)

Thanks,
Daniel

> >   [0] https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/pw.git/
> >
> > > On Tue, Oct 1, 2019 at 8:20 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Tue, Oct 1, 2019 at 10:40 AM Brian Vazquez <brianvv@google.com> wrote:
> > > > >
> > > >
> > > > I don't think there is a need to add "test_progs:" to subject, "
> > > > test_sockopt_inherit" is specific enough ;)
> > > >
> > > > > server_fd needs to be close if pthread can't be created.
> > > >
> > > > typo: closed
> > > >
> > > > > Fixes: e3e02e1d9c24 ("selftests/bpf: test_progs: convert test_sockopt_inherit")
> > > > > Cc: Stanislav Fomichev <sdf@google.com>
> > > > > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > > > > ---
> > > >
> > > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > > >
> > > > >  tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
