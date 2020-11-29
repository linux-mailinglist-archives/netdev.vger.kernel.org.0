Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518612C7842
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 07:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgK2GXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 01:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgK2GXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 01:23:38 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E610B20771;
        Sun, 29 Nov 2020 06:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606630977;
        bh=4TiLHs/bksEPXJGUnD5rSjMpIpEXqIvIktifDppwC8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xYXezo0M/56ifstbh7CRHf4NSpI89kBk44cf0reK/Yk8LZtsoPWzr2+rhIH3dB7Re
         xV79EfQA1QBBghK2cbmT7BIK6MevYb/pnzNzyvuz9Nz6vgl9tvapmWIen/ClNjNsGQ
         8qXupQvJz6RXVSd3zGGkkAPGOo7oyHxPu8oAmOTI=
Date:   Sun, 29 Nov 2020 07:22:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <X8M+PuwwZZwr+pdP@kroah.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201128221635.63fdcf69@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128221635.63fdcf69@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 10:16:35PM -0800, Stephen Hemminger wrote:
> On Fri, 23 Oct 2020 11:38:50 +0800
> Hangbin Liu <haliu@redhat.com> wrote:
> 
> > This series converts iproute2 to use libbpf for loading and attaching
> > BPF programs when it is available. This means that iproute2 will
> > correctly process BTF information and support the new-style BTF-defined
> > maps, while keeping compatibility with the old internal map definition
> > syntax.
> > 
> > This is achieved by checking for libbpf at './configure' time, and using
> > it if available. By default the system libbpf will be used, but static
> > linking against a custom libbpf version can be achieved by passing
> > LIBBPF_DIR to configure. FORCE_LIBBPF can be set to force configure to
> > abort if no suitable libbpf is found (useful for automatic packaging
> > that wants to enforce the dependency).
> > 
> > The old iproute2 bpf code is kept and will be used if no suitable libbpf
> > is available. When using libbpf, wrapper code ensures that iproute2 will
> > still understand the old map definition format, including populating
> > map-in-map and tail call maps before load.
> > 
> > The examples in bpf/examples are kept, and a separate set of examples
> > are added with BTF-based map definitions for those examples where this
> > is possible (libbpf doesn't currently support declaratively populating
> > tail call maps).
> 
> 
> Luca wants to put this in Debian 11 (good idea), but that means:
> 
> 1. It has to work with 5.10 release and kernel.
> 2. Someone has to test it.
> 3. The 5.10 is a LTS kernel release which means BPF developers have
>    to agree to supporting LTS releases.

Why would the bpf developers have to support any old releases?  That's
not their responsibility, that's the developers who want to create
stable/lts releases.

> If someone steps up to doing this then I would be happy to merge it now
> for 5.10. Otherwise it won't show up until 5.11.

Don't ever "rush" anything for a LTS/stable release, otherwise I am
going to have to go back to the old way of not announcing them until
_after_ they are released as people throw stuff that is not ready for
a normal merge.

This looks like a new feature, and shouldn't go in right now in the
development cycle anyway, all features for 5.10 had to be in linux-next
before 5.9 was released.

thanks,

greg k-h
