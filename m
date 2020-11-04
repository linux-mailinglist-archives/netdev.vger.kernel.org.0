Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0FE2A6BD7
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 18:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbgKDRgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 12:36:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730254AbgKDRgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 12:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604511378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Egp5/piH9cLQbhOxqBiQ6oUXBo8D99rZQxLNpy2SM8g=;
        b=JgTVihE2urYmSTbc+eD5bMkiY/6E3tSxzc+hiVAebZPri/g+SqINY6xb0vjsIdVsM3Ou6h
        amw78FihQbHWrF3NvaZIqwFcx+xGps1l6wsECzVYs3v+q6oy+bZtJgGTlv8lZXHvrAXzwE
        YR4fiS4X2SOUfNodaJoYh5uKWMPPVb0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-Bbwo2LBhNzG7tSnCvjq0hw-1; Wed, 04 Nov 2020 12:36:14 -0500
X-MC-Unique: Bbwo2LBhNzG7tSnCvjq0hw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E287F804745;
        Wed,  4 Nov 2020 17:36:12 +0000 (UTC)
Received: from ovpn-114-21.ams2.redhat.com (ovpn-114-21.ams2.redhat.com [10.36.114.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7D781084273;
        Wed,  4 Nov 2020 17:36:09 +0000 (UTC)
Message-ID: <79c58e6cf23196b73887b20802daebd59fe89476.camel@redhat.com>
Subject: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Date:   Wed, 04 Nov 2020 18:36:08 +0100
In-Reply-To: <20201103085245.3397defa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <cover.1604055792.git.pabeni@redhat.com>
         <20201102145447.0074f272@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <86c37d881a93d5690faf20de3bccceca1493fd74.camel@redhat.com>
         <20201103085245.3397defa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-03 at 08:52 -0800, Jakub Kicinski wrote:
> On Tue, 03 Nov 2020 16:22:07 +0100 Paolo Abeni wrote:
> > The relevant use case is an host running containers (with the related
> > orchestration tools) in a RT environment. Virtual devices (veths, ovs
> > ports, etc.) are created by the orchestration tools at run-time.
> > Critical processes are allowed to send packets/generate outgoing
> > network traffic - but any interrupt is moved away from the related
> > cores, so that usual incoming network traffic processing does not
> > happen there.
> > 
> > Still an xmit operation on a virtual devices may be transmitted via ovs
> > or veth, with the relevant forwarding operation happening in a softirq
> > on the same CPU originating the packet. 
> > 
> > RPS is configured (even) on such virtual devices to move away the
> > forwarding from the relevant CPUs.
> > 
> > As Saeed noted, such configuration could be possibly performed via some
> > user-space daemon monitoring network devices and network namespaces
> > creation. That will be anyway prone to some race: the orchestation tool
> > may create and enable the netns and virtual devices before the daemon
> > has properly set the RPS mask.
> > 
> > In the latter scenario some packet forwarding could still slip in the
> > relevant CPU, causing measurable latency. In all non RT scenarios the
> > above will be likely irrelevant, but in the RT context that is not
> > acceptable - e.g. it causes in real environments latency above the
> > defined limits, while the proposed patches avoid the issue.
> > 
> > Do you see any other simple way to avoid the above race?
> > 
> > Please let me know if the above answers your doubts,
> 
> Thanks, that makes it clearer now.
> 
> Depending on how RT-aware your container management is it may or may not
> be the right place to configure this, as it creates the veth interface.
> Presumably it's the container management which does the placement of
> the tasks to cores, why is it not setting other attributes, like RPS?

The container orchestration is quite complex, and I'm unsure isolation
and networking configuration are performed (or can be performed) by the
same precess (without an heavy refactor).

On the flip hand, the global rps mask knob looked quite
straightforward to me.

Possibly I can reduce the amount of new code introduced by this
patchset removing some code duplication
between rps_default_mask_sysctl() and flow_limit_cpu_sysctl(). Would
that make this change more acceptable? Or should I drop this
altogether?

> Also I wonder if it would make sense to turn this knob into something
> more generic. When we arrive at the threaded NAPIs - could it make
> sense for the threads to inherit your mask as the CPUs they are allowed
> to run on?

I personally *think* this would be fine - and good. But isn't a bit
premature discussing the integration of 2 missing pieces ? :)

Thanks,

Paolo

