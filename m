Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05221945C6
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 18:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCZRr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 13:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgCZRr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 13:47:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 790462070A;
        Thu, 26 Mar 2020 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585244878;
        bh=NaZQt404XwZx2V7iFbgzg4sZjdQZx3A9dQh/StbeMGI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AYhVNfk8y29mzr7qON4HkZPdo19K0G9oGpCi8R7KruhkiQLhc9slTl8KcKCkZX85E
         JkkM7MJ0z10nJx5raHfD8LFsCMYEG/Xd0aOzGlOJi+qrhMQFm6UJtb2dihgXozCw0J
         /DrNNCi6rtX8TsEUCuTI2Gn6RITKBFy69pNnY7RY=
Date:   Thu, 26 Mar 2020 10:47:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200326104755.1ea5ac43@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
        <158462359315.164779.13931660750493121404.stgit@toke.dk>
        <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
        <875zez76ph.fsf@toke.dk>
        <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
        <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
        <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
        <87tv2f48lp.fsf@toke.dk>
        <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
        <87h7ye3mf3.fsf@toke.dk>
        <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
        <87tv2e10ly.fsf@toke.dk>
        <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
        <87369wrcyv.fsf@toke.dk>
        <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
        <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 10:04:53 +0000 Lorenz Bauer wrote:
> On Thu, 26 Mar 2020 at 00:16, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > Those same folks have similar concern with XDP. In the world where
> > container management installs "root" XDP program which other user
> > applications can plug into (libxdp use case, right?), it's crucial to
> > ensure that this root XDP program is not accidentally overwritten by
> > some well-meaning, but not overly cautious developer experimenting in
> > his own container with XDP programs. This is where bpf_link ownership
> > plays a huge role. Tupperware agent (FB's container management agent)
> > would install root XDP program and will hold onto this bpf_link
> > without sharing it with other applications. That will guarantee that
> > the system will be stable and can't be compromised.  
> 
> Thanks for the extensive explanation Andrii.
> 
> This is what I imagine you're referring to: Tupperware creates a new network
> namespace ns1 and a veth0<>veth1 pair, moves one of the veth devices
> (let's says veth1) into ns1 and runs an application in ns1. On which veth
> would the XDP program go?
> 
> The way I understand it, veth1 would have XDP, and the application in ns1 would
> be prevented from attaching a new program? Maybe you can elaborate on this
> a little.

Nope, there is no veths involved. Tupperware mediates the requests 
from containers to install programs on the physical interface for
heavy-duty network processing like DDoS protection for the entire
machine.
