Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558F72BB7E8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgKTUum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729587AbgKTUul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 15:50:41 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D9642223F;
        Fri, 20 Nov 2020 20:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605905441;
        bh=CD6J9aBN3wd+dkrZ6D4o7RWa0H5Idy0AtRGQgdfH1H0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J1bOxW/cK/+sjBE+Pofli22i2mKXW3WbeCRRHVTEKiKoknf4WK7oSrUYsCwWbeQ0d
         BDPi9AKjTED0cwrPhpD0Hbj0ZABDGx2u+bh+JU6ppDs2b0bPtiaSOuWUaWatHxoVmh
         6saxDs3hB4YmUZk4LkhofkGWuo8a5EmkHmPWFjVM=
Date:   Fri, 20 Nov 2020 12:50:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcel Apfelbaum <mapfelba@redhat.com>
Cc:     marcel@redhat.com, Saeed Mahameed <saeed@kernel.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [kuba@kernel.org: Re: [PATCH net-next v2 0/3] net: introduce
 rps_default_mask]
Message-ID: <20201120125039.6a88b0b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+aaKfD_6qdNVRgr2TdDeuOau1UCFzRqWRB8iM-_GHV7mMrcsg@mail.gmail.com>
References: <20201119162527.GB9877@fuller.cnet>
        <CA+aaKfCMa1sOa6bMXFAaP6Wb=5ZgoAcnZAaP9aBmWwOzaAtcHw@mail.gmail.com>
        <CA+aaKfD_6qdNVRgr2TdDeuOau1UCFzRqWRB8iM-_GHV7mMrcsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 19:39:24 +0200 Marcel Apfelbaum wrote:
> > The CPU isolation is done statically at system boot by setting
> > Linux kernel parameters, So the container management component, in
> > this case the Machine Configuration Operator (for Openshift) or the
> > K8s counterpart can't really help. (actually they would help if a
> > global RPS mask would exist)
> >
> > I tried to tweak the rps_cpus mask using the container management
> > stack, but there is no sane way to do it, please let me get a
> > little into the details.
> >
> > The k8s orchestration component that deals with injecting the
> > network device(s) into the container is CNI, which is interface
> > based and implemented by a lot of plugins, making it hardly
> > feasible to go over all the existing plugins and change them. Also
> > what about the 3rd party ones?

I'm not particularly amenable to the "changing user space is hard"
argument. Especially that you don't appear to have given it an honest
try.

> > Writing a new CNI plugin and chain it into the existing one is also
> > not an option AFAIK, they work at the network level and do not have
> > access to sysfs (they handle the network namespaces). Even if it
> > would be possible (I don't have a deep CNI understanding), it will
> > require a cluster global configuration that is actually needed only
> > for some of the cluster nodes.
> >
> > Another approach is to set the RPS configuration from the inside(of
> > the container), but the /sys mount is read only for unprivileged
> > containers, so we lose again.
> >
> > That leaves us with a host daemon hack:
> > Since the virtual network devices are created in the host namespace
> > and then "moved" into the container, we can listen to some udev
> > event and write to the rps_cpus file after the virtual netdev is
> > created and before it is moved (as stated above, the work is done
> > by a CNI plugin implementation). That is of course extremely racy
> > and not a valid solution.
> >
> >> > Possibly I can reduce the amount of new code introduced by this
> >> > patchset removing some code duplication
> >> > between rps_default_mask_sysctl() and flow_limit_cpu_sysctl().
> >> > Would that make this change more acceptable? Or should I drop
> >> > this altogether?  
> >>
> >> I'm leaning towards drop altogether, unless you can get some
> >> support/review tags from other netdev developers. So far it
> >> appears we only got a down vote from Saeed.

As I said here, try to convince some other senior networking developers
this is the right solution and I'll apply it.

This is giving me flashbacks of trying bend the kernel for OpenStack
because there was no developer on my team who could change OpenStack.

> > Any solution that will allow the user space to avoid the
> > network soft IRQs on specific CPUs would be welcome.
> >
> > The proposed global mask is a solution, maybe there other ways?
