Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCC22A4BFE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgKCQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbgKCQws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 11:52:48 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 961E920870;
        Tue,  3 Nov 2020 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604422367;
        bh=ATUgDepSx8znfuwBCpbqINr4q8BPefrp2EOWlxQiwf0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U7qwLuRDXQeVl45mOrGV5DelyKEA5ux4Uyj0Dyjj5HcYPgjIyGK95KTG1rc303hgo
         79NR5ue3xm2GfDt5nuig5H2iyhJxzPE4H/DH/Jw7sHeGs/dEZKsvUMBeVPJx47a3KM
         4Q/JqmNC6gb2CIefRPEi7lwCSNzUvfwYjo18S0qs=
Date:   Tue, 3 Nov 2020 08:52:45 -0800
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
Message-ID: <20201103085245.3397defa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <86c37d881a93d5690faf20de3bccceca1493fd74.camel@redhat.com>
References: <cover.1604055792.git.pabeni@redhat.com>
        <20201102145447.0074f272@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <86c37d881a93d5690faf20de3bccceca1493fd74.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Nov 2020 16:22:07 +0100 Paolo Abeni wrote:
> On Mon, 2020-11-02 at 14:54 -0800, Jakub Kicinski wrote:
> > On Fri, 30 Oct 2020 12:16:00 +0100 Paolo Abeni wrote:  
> > > Real-time setups try hard to ensure proper isolation between time
> > > critical applications and e.g. network processing performed by the
> > > network stack in softirq and RPS is used to move the softirq 
> > > activity away from the isolated core.
> > > 
> > > If the network configuration is dynamic, with netns and devices
> > > routinely created at run-time, enforcing the correct RPS setting
> > > on each newly created device allowing to transient bad configuration
> > > became complex.
> > > 
> > > These series try to address the above, introducing a new
> > > sysctl knob: rps_default_mask. The new sysctl entry allows
> > > configuring a systemwide RPS mask, to be enforced since receive 
> > > queue creation time without any fourther per device configuration
> > > required.
> > > 
> > > Additionally, a simple self-test is introduced to check the 
> > > rps_default_mask behavior.  
> > 
> > RPS is disabled by default, the processing is going to happen wherever
> > the IRQ is mapped, and one would hope that the IRQ is not mapped to the
> > core where the critical processing runs.
> > 
> > Would you mind elaborating further on the use case?  
> 
> On Mon, 2020-11-02 at 15:27 -0800, Saeed Mahameed wrote:
> > The whole thing can be replaced with a user daemon scripts that
> > monitors all newly created devices and assign to them whatever rps mask
> > (call it default).
> > 
> > So why do we need this special logic in kernel ? 
> > 
> > I am not sure about this, but if rps queues sysfs are available before
> > the netdev is up, then you can also use udevd to assign the rps masks
> > before such devices are even brought up, so you would avoid the race
> > conditions that you described, which are not really clear to me to be
> > honest.  
> 
> Thank you for the feedback.
> 
> Please allow me to answer you both here, as your questions are related.
> 
> The relevant use case is an host running containers (with the related
> orchestration tools) in a RT environment. Virtual devices (veths, ovs
> ports, etc.) are created by the orchestration tools at run-time.
> Critical processes are allowed to send packets/generate outgoing
> network traffic - but any interrupt is moved away from the related
> cores, so that usual incoming network traffic processing does not
> happen there.
> 
> Still an xmit operation on a virtual devices may be transmitted via ovs
> or veth, with the relevant forwarding operation happening in a softirq
> on the same CPU originating the packet. 
> 
> RPS is configured (even) on such virtual devices to move away the
> forwarding from the relevant CPUs.
> 
> As Saeed noted, such configuration could be possibly performed via some
> user-space daemon monitoring network devices and network namespaces
> creation. That will be anyway prone to some race: the orchestation tool
> may create and enable the netns and virtual devices before the daemon
> has properly set the RPS mask.
> 
> In the latter scenario some packet forwarding could still slip in the
> relevant CPU, causing measurable latency. In all non RT scenarios the
> above will be likely irrelevant, but in the RT context that is not
> acceptable - e.g. it causes in real environments latency above the
> defined limits, while the proposed patches avoid the issue.
> 
> Do you see any other simple way to avoid the above race?
> 
> Please let me know if the above answers your doubts,

Thanks, that makes it clearer now.

Depending on how RT-aware your container management is it may or may not
be the right place to configure this, as it creates the veth interface.
Presumably it's the container management which does the placement of
the tasks to cores, why is it not setting other attributes, like RPS?

Also I wonder if it would make sense to turn this knob into something
more generic. When we arrive at the threaded NAPIs - could it make
sense for the threads to inherit your mask as the CPUs they are allowed
to run on?
