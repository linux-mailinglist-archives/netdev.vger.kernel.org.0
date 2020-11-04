Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA3C2A6E45
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 20:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbgKDTma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 14:42:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgKDTm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 14:42:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6ADF206F9;
        Wed,  4 Nov 2020 19:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604518948;
        bh=hnEIJUynmmgvhXM6LNWJ3AbWQehuvhEF6/0d7tVxPgk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OywGmDa2wkQkk/FhsD+bRB9zR6KglkyRoMbANXBzP4e4dx6FgMPNTyaIhnIarG7zu
         oFglqRYw1+Uwz3W6VMPysiR2T770vJnQAWj26vk5kLUVdEpzNHizPnxCIsJBjXgatC
         pHCqqFYQZ/G2oxBfooxmn412DtuvdrvbNp+CcbM4=
Date:   Wed, 4 Nov 2020 11:42:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask
Message-ID: <20201104114226.250a4e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <79c58e6cf23196b73887b20802daebd59fe89476.camel@redhat.com>
References: <cover.1604055792.git.pabeni@redhat.com>
        <20201102145447.0074f272@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <86c37d881a93d5690faf20de3bccceca1493fd74.camel@redhat.com>
        <20201103085245.3397defa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <79c58e6cf23196b73887b20802daebd59fe89476.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Nov 2020 18:36:08 +0100 Paolo Abeni wrote:
> On Tue, 2020-11-03 at 08:52 -0800, Jakub Kicinski wrote:
> > On Tue, 03 Nov 2020 16:22:07 +0100 Paolo Abeni wrote:  
> > > The relevant use case is an host running containers (with the related
> > > orchestration tools) in a RT environment. Virtual devices (veths, ovs
> > > ports, etc.) are created by the orchestration tools at run-time.
> > > Critical processes are allowed to send packets/generate outgoing
> > > network traffic - but any interrupt is moved away from the related
> > > cores, so that usual incoming network traffic processing does not
> > > happen there.
> > > 
> > > Still an xmit operation on a virtual devices may be transmitted via ovs
> > > or veth, with the relevant forwarding operation happening in a softirq
> > > on the same CPU originating the packet. 
> > > 
> > > RPS is configured (even) on such virtual devices to move away the
> > > forwarding from the relevant CPUs.
> > > 
> > > As Saeed noted, such configuration could be possibly performed via some
> > > user-space daemon monitoring network devices and network namespaces
> > > creation. That will be anyway prone to some race: the orchestation tool
> > > may create and enable the netns and virtual devices before the daemon
> > > has properly set the RPS mask.
> > > 
> > > In the latter scenario some packet forwarding could still slip in the
> > > relevant CPU, causing measurable latency. In all non RT scenarios the
> > > above will be likely irrelevant, but in the RT context that is not
> > > acceptable - e.g. it causes in real environments latency above the
> > > defined limits, while the proposed patches avoid the issue.
> > > 
> > > Do you see any other simple way to avoid the above race?
> > > 
> > > Please let me know if the above answers your doubts,  
> > 
> > Thanks, that makes it clearer now.
> > 
> > Depending on how RT-aware your container management is it may or may not
> > be the right place to configure this, as it creates the veth interface.
> > Presumably it's the container management which does the placement of
> > the tasks to cores, why is it not setting other attributes, like RPS?  
> 
> The container orchestration is quite complex, and I'm unsure isolation
> and networking configuration are performed (or can be performed) by the
> same precess (without an heavy refactor).
> 
> On the flip hand, the global rps mask knob looked quite
> straightforward to me.

I understand, but I can't shake the feeling this is a hack.

Whatever sets the CPU isolation should take care of the RPS settings.

> Possibly I can reduce the amount of new code introduced by this
> patchset removing some code duplication
> between rps_default_mask_sysctl() and flow_limit_cpu_sysctl(). Would
> that make this change more acceptable? Or should I drop this
> altogether?

I'm leaning towards drop altogether, unless you can get some
support/review tags from other netdev developers. So far it
appears we only got a down vote from Saeed.

> > Also I wonder if it would make sense to turn this knob into something
> > more generic. When we arrive at the threaded NAPIs - could it make
> > sense for the threads to inherit your mask as the CPUs they are allowed
> > to run on?  
> 
> I personally *think* this would be fine - and good. But isn't a bit
> premature discussing the integration of 2 missing pieces ? :)
