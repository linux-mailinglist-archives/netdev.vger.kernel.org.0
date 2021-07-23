Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DAA3D33D0
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 06:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhGWEBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 00:01:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229447AbhGWEBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 00:01:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627015314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ixRb8AtMzzXaO7RwzeqtAhwd7Uqd89rcjRupU8sxETE=;
        b=YP0zgZvg0lz9QKHshKmSq5bw6ipth/xdLrWc3uGa4gbXyRpkfway9crmaS1n+S9Iq62mOd
        NtnRii6y47mgbJwOhRe5C/fO7XUNRZEAGILnhggz3ZoJbEWsHt2mK91kXH5xwqPBqRvkmp
        +PMXmS4aEp7GjjtYmUMWEqLJ0E6EPMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-3Pu2k2o6N2u9S283n6MTcQ-1; Fri, 23 Jul 2021 00:41:50 -0400
X-MC-Unique: 3Pu2k2o6N2u9S283n6MTcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DED878799EB;
        Fri, 23 Jul 2021 04:41:48 +0000 (UTC)
Received: from Laptop-X1 (ovpn-13-95.pek2.redhat.com [10.72.13.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 522B610016F7;
        Fri, 23 Jul 2021 04:41:44 +0000 (UTC)
Date:   Fri, 23 Jul 2021 12:41:30 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Martynas Pumputis <m@lambda.lt>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple
 sections
Message-ID: <YPpIeppWpqFCSaqZ@Laptop-X1>
References: <20210705124307.201303-1-m@lambda.lt>
 <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 04:47:14PM +0200, Martynas Pumputis wrote:
> > > diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> > > index d05737a4..f76b90d2 100644
> > > --- a/lib/bpf_libbpf.c
> > > +++ b/lib/bpf_libbpf.c
> > > @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
> > >          }
> > > 
> > >          bpf_object__for_each_program(p, obj) {
> > > +               bool prog_to_attach = !prog && cfg->section &&
> > > +                       !strcmp(get_bpf_program__section_name(p), cfg->section);
> > 
> > This is still problematic, because one section can have multiple BPF
> > programs. I.e., it's possible two define two or more XDP BPF programs
> > all with SEC("xdp") and libbpf works just fine with that. I suggest
> > moving users to specify the program name (i.e., C function name
> > representing the BPF program). All the xdp_mycustom_suffix namings are
> > a hack and will be rejected by libbpf 1.0, so it would be great to get
> > a head start on fixing this early on.
> 
> Thanks for bringing this up. Currently, there is no way to specify a
> function name with "tc exec bpf" (only a section name via the "sec" arg). So
> probably, we should just add another arg to specify the function name.

How about add a "prog" arg to load specified program name and mark
"sec" as not recommended? To keep backwards compatibility we just load the
first program in the section.

Thanks
Hangbin

