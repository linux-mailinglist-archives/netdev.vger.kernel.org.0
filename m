Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0928BC92C2
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 22:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfJBUI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 16:08:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfJBUI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 16:08:26 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 60CE03D965;
        Wed,  2 Oct 2019 20:08:25 +0000 (UTC)
Received: from krava (ovpn-204-114.brq.redhat.com [10.40.204.114])
        by smtp.corp.redhat.com (Postfix) with SMTP id EDBBB19D70;
        Wed,  2 Oct 2019 20:08:18 +0000 (UTC)
Date:   Wed, 2 Oct 2019 22:08:18 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Julia Kartseva <hex@fb.com>, Yonghong Song <yhs@fb.com>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "md@linux.it" <md@linux.it>, Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        iovisor-dev@lists.iovisor.org
Subject: Re: libbpf-devel rpm uapi headers
Message-ID: <20191002200818.GC13941@krava>
References: <20191002174331.GA13941@krava>
 <20191002184315.zl5xpfhsaspllaix@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002184315.zl5xpfhsaspllaix@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 02 Oct 2019 20:08:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 11:43:17AM -0700, Alexei Starovoitov wrote:
> On Wed, Oct 02, 2019 at 07:43:31PM +0200, Jiri Olsa wrote:
> > hi,
> > we'd like to have bcc linked with libbpf instead of the
> > github submodule, initial change is discussed in here:
> >   https://github.com/iovisor/bcc/pull/2535
> > 
> > In order to do that, we need to have access to uapi headers
> > compatible with libbpf rpm, bcc is attaching and using them
> > during compilation.
> > 
> > I added them in the fedora spec below (not submitted yet),
> > so libbpf would carry those headers.
> > 
> > Thoughts? thanks,
> 
> I think it may break a bunch of people who rely on bcc being a single library.

there's still libbpf.a available so it's still possible

> What is the main motiviation to use libbpf as a shared library in libbcc?

Besides that it's better to share common source of libbpf code,
it also prevents issues when having application that links to
libbpf and libbcc, where you could end up conflicting functions
and segfaults if those 2 libbpf libs are not on the same version.

quote from the github pull request ;-)

bpftrace links to libbcc, which carries libbcc_bpf and if I link
bpftrace with libbpf, the dynamic loader might get consused and
I get crash if those 2 libbpf libs (bcc x bpftrace) are not the
same version

> 
> I think we can have both options. libbpf as git submodule and as shared.
> In practice git submodule is so much simpler to use and a lot less headaches.

that's what the change to bcc suggests.. the build detects libbpf-devel
and if available links with it.. Yonghong suggested we also need uapi
headers so we don't rely on standard kernel headers

jirka
