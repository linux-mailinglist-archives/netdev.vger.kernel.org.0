Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E86721BBB7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGJRAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 13:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbgGJRAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 13:00:13 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E2D62078B;
        Fri, 10 Jul 2020 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594400412;
        bh=pTyURjANtPqmaLJUbxYqI4qaMGNCNSURnp1G+dRkB1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HnVJiYlzf+9XFUcJO/ZGQdAlmlTzC3Tkxf6ranJEAFmIbPfLys7jyc358mBNCgeDH
         kSlcbtn0oWqnbYCzfDB7wXNOBo1XczhLcRRWiu4zOVOKOd2sPLZeItKhosD6xK/I1o
         vtHkuhEhhqlfkhTYVpWxorxK0HNq6FFcg2nQBtXI=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 7FF79405FF; Fri, 10 Jul 2020 14:00:10 -0300 (-03)
Date:   Fri, 10 Jul 2020 14:00:10 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v5 bpf-next 2/5] bpf: Introduce sleepable BPF programs
Message-ID: <20200710170010.GC7487@kernel.org>
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-3-alexei.starovoitov@gmail.com>
 <d0c6b6a6-7b82-e620-8ced-8a1acfaf6f6d@iogearbox.net>
 <20200630234117.arqmjpbivy5fhhmk@ast-mbp.dhcp.thefacebook.com>
 <CACYkzJ5kGxxA1E70EKah_hWbsb7hoUy8s_Y__uCeSyYxVezaBA@mail.gmail.com>
 <5596445c-7474-9913-6765-5d699c6c5c4e@iogearbox.net>
 <CAADnVQLoVfPWNBR-_56ofgaUFv8k3NT2aiGjV9jj_gOt0aoJ5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLoVfPWNBR-_56ofgaUFv8k3NT2aiGjV9jj_gOt0aoJ5g@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Jul 01, 2020 at 08:21:13AM -0700, Alexei Starovoitov escreveu:
> On Wed, Jul 1, 2020 at 2:34 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > +1, I think augmenting mid-term would be the best given check_sleepable_blacklist()
> > is rather a very fragile workaround^hack and it's also a generic lsm/sec hooks issue
> 
> I tried to make that crystal clear back in march during bpf virtual conference.
> imo whitelist is just as fragile as blacklist. Underlying
> implementation can change.
> 
> > (at least for BPF_PROG_TYPE_LSM type & for the sake of documenting it for other LSMs).
> > Perhaps there are function attributes that could be used and later retrieved via BTF?
> 
> Even if we convince gcc folks to add another function attribute it
> won't appear in dwarf.

Warning, hack ahead!

Perhaps we could do that with some sort of convention, i.e. define some
type and make a function returning that type to have the desired
attribute?

I.e.

typedef __attribute__foo__int int;

__attribute__foo__int function_bla(...)
{
}

?

> So we won't be able to convert it to BTF in pahole.
> Looking at how we failed to extend address_space() attribute to
> support existing __rcu
> and __user annotations I don't have high hopes of achieving annotations
> via compiler (either gcc or clang). So plan B is to engage with sparse folks and
> make it emit BTF with __rcu, __user and other annotations.

-- 

- Arnaldo
