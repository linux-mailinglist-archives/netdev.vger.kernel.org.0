Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C242A4964
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgKCPWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:22:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728109AbgKCPWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604416934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lChGiPw5PKK8M2mjuLILlsWFMRIa+6Y0yf5fTgLfNzg=;
        b=IEbXRt0DKyTLA1sGhlgMUitHFFbp6I7QmOZE3/8ahNWOQ032++L61KQcQ4S0rGw9iqvTqA
        WDsfKGe4oefY9SbGiZjO9k/3OD5bgV1ZIBkUoBY/UdU90CM0Gsh2WMYY3fkMv6KdCzV0z2
        jexpYcWoraAdXWh4ckykeSXpu0pU3SE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-1LuhBAQYPcKtH7EjtH9oPA-1; Tue, 03 Nov 2020 10:22:13 -0500
X-MC-Unique: 1LuhBAQYPcKtH7EjtH9oPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A38E5F9C5;
        Tue,  3 Nov 2020 15:22:11 +0000 (UTC)
Received: from ovpn-114-173.ams2.redhat.com (ovpn-114-173.ams2.redhat.com [10.36.114.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A0795B4BB;
        Tue,  3 Nov 2020 15:22:08 +0000 (UTC)
Message-ID: <86c37d881a93d5690faf20de3bccceca1493fd74.camel@redhat.com>
Subject: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Date:   Tue, 03 Nov 2020 16:22:07 +0100
In-Reply-To: <20201102145447.0074f272@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <cover.1604055792.git.pabeni@redhat.com>
         <20201102145447.0074f272@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-02 at 14:54 -0800, Jakub Kicinski wrote:
> On Fri, 30 Oct 2020 12:16:00 +0100 Paolo Abeni wrote:
> > Real-time setups try hard to ensure proper isolation between time
> > critical applications and e.g. network processing performed by the
> > network stack in softirq and RPS is used to move the softirq 
> > activity away from the isolated core.
> > 
> > If the network configuration is dynamic, with netns and devices
> > routinely created at run-time, enforcing the correct RPS setting
> > on each newly created device allowing to transient bad configuration
> > became complex.
> > 
> > These series try to address the above, introducing a new
> > sysctl knob: rps_default_mask. The new sysctl entry allows
> > configuring a systemwide RPS mask, to be enforced since receive 
> > queue creation time without any fourther per device configuration
> > required.
> > 
> > Additionally, a simple self-test is introduced to check the 
> > rps_default_mask behavior.
> 
> RPS is disabled by default, the processing is going to happen wherever
> the IRQ is mapped, and one would hope that the IRQ is not mapped to the
> core where the critical processing runs.
> 
> Would you mind elaborating further on the use case?

On Mon, 2020-11-02 at 15:27 -0800, Saeed Mahameed wrote:
> The whole thing can be replaced with a user daemon scripts that
> monitors all newly created devices and assign to them whatever rps mask
> (call it default).
> 
> So why do we need this special logic in kernel ? 
> 
> I am not sure about this, but if rps queues sysfs are available before
> the netdev is up, then you can also use udevd to assign the rps masks
> before such devices are even brought up, so you would avoid the race
> conditions that you described, which are not really clear to me to be
> honest.

Thank you for the feedback.

Please allow me to answer you both here, as your questions are related.

The relevant use case is an host running containers (with the related
orchestration tools) in a RT environment. Virtual devices (veths, ovs
ports, etc.) are created by the orchestration tools at run-time.
Critical processes are allowed to send packets/generate outgoing
network traffic - but any interrupt is moved away from the related
cores, so that usual incoming network traffic processing does not
happen there.

Still an xmit operation on a virtual devices may be transmitted via ovs
or veth, with the relevant forwarding operation happening in a softirq
on the same CPU originating the packet. 

RPS is configured (even) on such virtual devices to move away the
forwarding from the relevant CPUs.

As Saeed noted, such configuration could be possibly performed via some
user-space daemon monitoring network devices and network namespaces
creation. That will be anyway prone to some race: the orchestation tool
may create and enable the netns and virtual devices before the daemon
has properly set the RPS mask.

In the latter scenario some packet forwarding could still slip in the
relevant CPU, causing measurable latency. In all non RT scenarios the
above will be likely irrelevant, but in the RT context that is not
acceptable - e.g. it causes in real environments latency above the
defined limits, while the proposed patches avoid the issue.

Do you see any other simple way to avoid the above race?

Please let me know if the above answers your doubts,

Paolo

