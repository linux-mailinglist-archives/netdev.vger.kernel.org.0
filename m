Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF96179923
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbgCDTmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgCDTmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 14:42:01 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F1302166E;
        Wed,  4 Mar 2020 19:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583350920;
        bh=crJbpv3mo3HaJyfPkCN0Aozw3ZmljzaOcyE/nD9zy1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FGK8NnELq9CZvDZ3Jij/96NKuYxgH8Zj64UtX5YYRXFJmj4V8suppGiOp+bPBL+jF
         fq3V4PNpAuDvL/MKGf7lXZMdnq3w0BJbhg6tXxLLK7vDoD9dmgp3Bgt1CY2Dg0mEHC
         UPIKpworPeqDFz9wZNIKvmNQ4/K/Ni3Fl6K3fmog=
Date:   Wed, 4 Mar 2020 11:41:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200304114000.56888dac@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
References: <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
        <87imjms8cm.fsf@toke.dk>
        <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
        <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
        <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
        <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
        <87pndt4268.fsf@toke.dk>
        <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
        <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
        <87k1413whq.fsf@toke.dk>
        <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 20:36:45 -0800 Alexei Starovoitov wrote:
> > > libxdp can choose to pin it in some libxdp specific location, so other
> > > libxdp-enabled applications can find it in the same location, detach,
> > > replace, modify, but random app that wants to hack an xdp prog won't
> > > be able to mess with it.  
> > 
> > What if that "random app" comes first, and keeps holding on to the link
> > fd? Then the admin essentially has to start killing processes until they
> > find the one that has the device locked, no?  
> 
> Of course not. We have to provide an api to make it easy to discover
> what process holds that link and where it's pinned.

That API to discover ownership would be useful but it's on the BPF side.

We have netlink notifications in networking world. The application
which doesn't want its program replaced should simply listen to the
netlink notifications and act if something goes wrong. And we already
have XDP_FLAGS_UPDATE_IF_NOEXIST.

> But if we go with notifier approach none of it is an issue.

Sorry, what's the notifier approach? You mean netdev notifier chain 
or something new?

> Whether target obj is held or notifier is used everything I said before still
> stands. "random app" that uses netlink after libdispatcher got its link FD will
> not be able to mess with carefully orchestrated setup done by libdispatcher.
> 
> Also either approach will guarantee that infamous message:
> "unregister_netdevice: waiting for %s to become free. Usage count"
> users will never see.
>
> > And what about the case where the link fd is pinned on a bpffs that is
> > no longer available? I.e., if a netdevice with an XDP program moves
> > namespaces and no longer has access to the original bpffs, that XDP
> > program would essentially become immutable?  
> 
> 'immutable' will not be possible.
> I'm not clear to me how bpffs is going to disappear. What do you mean
> exactly?
> 
> > > We didn't come up with these design choices overnight. It came from
> > > hard lessons learned while deploying xdp, tc and cgroup in production.
> > > Legacy apis will not be deprecated, of course.  

This sounds like a version of devm_* helpers for configuration.
Why are current user space APIs insufficient? Surely all of this can 
be done from user space. And we will need a centralized daemon for XDP
dispatch, so why is it not a part of a daemon?
