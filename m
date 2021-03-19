Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AC93423BF
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 18:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhCSRxw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Mar 2021 13:53:52 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:43648 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229990AbhCSRxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 13:53:22 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-9jLXWH1zMCqvOsEQSVWmXw-1; Fri, 19 Mar 2021 13:53:13 -0400
X-MC-Unique: 9jLXWH1zMCqvOsEQSVWmXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFC6E800493;
        Fri, 19 Mar 2021 17:53:10 +0000 (UTC)
Received: from hog (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 851C810013D6;
        Fri, 19 Mar 2021 17:53:08 +0000 (UTC)
Date:   Fri, 19 Mar 2021 18:53:06 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Guy Shapiro <guysh@mellanox.com>, netdev@vger.kernel.org,
        antony@phenome.org
Subject: Re: [PATCH] xfrm: return error when esp offload is requested and not
 supported
Message-ID: <YFTlAoPPWOTG0AAf@hog>
References: <20210310093611.GA5406@moon.secunet.de>
 <20210315104350.GY62598@gauss3.secunet.de>
 <YE99dz85HaajKX4w@hog>
 <20210317084243.GB1282@moon.secunet.de>
MIME-Version: 1.0
In-Reply-To: <20210317084243.GB1282@moon.secunet.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-03-17, 09:42:43 +0100, Antony Antony wrote:
> Hi,
> 
> On Mon, Mar 15, 2021 at 16:29:59 +0100, Sabrina Dubroca wrote:
> > 2021-03-15, 11:43:50 +0100, Steffen Klassert wrote:
> > > On Wed, Mar 10, 2021 at 10:36:11AM +0100, Antony Antony wrote:
> > > > When ESP offload is not supported by the device return an error,
> > > > -EINVAL, instead of silently ignoring it, creating a SA without offload,
> > > > and returning success.
> > > > 
> > > > with this fix ip x s a would return
> > > > RTNETLINK answers: Invalid argument
> > > > 
> > > > Also, return an error, -EINVAL, when CONFIG_XFRM_OFFLOAD is
> > > > not defined and the user is trying to create an SA with the offload.
> > > > 
> > > > Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
> > > > Signed-off-by: Antony Antony <antony.antony@secunet.com>
> > > 
> > > I feal a bit unease about this one. When we designed the offloading
> > > API, we decided to fallback to software if HW offload is not available.
> 
> Right! Now, I recollect the silent fallback feature, which was mentioned
> when the offload was introduced. However, while using I found it
> confusing. And I thought it was an unintended side effect and came up
> with a fix. Looking closer at the proposed patch and commit 4a132095dd6 I
> wonder what would be a consistent behavior.
> 
> 
> > Right, but it's a little bit inconsistent. If HW offload is not
> > available, we get silent fallback. This is great for compatibility
> > (old kernels will completely ignore the XFRMA_OFFLOAD_DEV attribute,
> > new kernels try to emulate this), and because routes can change and
> > suddenly the packets that should have been going through some device
> > go through another, which may have different capabilities.
> > 
> > On the other hand, if HW offload is available but doesn't support the
> > exact features we're trying to enable (UDP encap, wrong algorithm, etc
> > (*)), then we can fail in a visible way.
> 
> Yes.
> 
> > (*) I know there's an "if (err != -EOPNOTSUPP)" on the result of
> > ->xdo_dev_state_add(), but for example mlx5 seems to return EINVAL
> > instead of EOPNOTSUPP.
> 
> That is interesting. I think !CONFIG_XFRM_OFFLOAD should be
> EOPNOTSUPP?

That would be inconsistent behavior between !CONFIG_XFRM_OFFLOAD and
CONFIG_XFRM_OFFLOAD, besides changing the existing behavior.

> > Antony, what prompted you to write this patch? Do you have a use case
> > for requiring offloading instead of falling back to software?
> 
> I was using strongSWAN. Due to NIC changes and route changes the SA,
> with offload, failed to create.
> Actually, strongSWAN didn't even try to create a SA. It reported an
> error when it checked offload support on the device, after IKE
> negotiation just before installing the SA.
> 
> [KNL] 192.168.1.1 is on interface eth2
> [KNL] HW offload is not supported by device
> 
> To debug I tried "ip x s a eth2" and a the SA got created, which
> confused me. After a closer showed offload was silently ignored.
> 
> Next I tried to create an offload to loopback device.
> "ip x s a ... offload dev lo dir in" and there was an SA without
> offload, Device lo will never have offload:)
> This led me to look at the kernel code. There I found the offload
> request can be silently ignored. So I created a fix.
> 
> One important point to note: IKE daemons check for offload support,
> using ETHTOOL_GFEATURES or ETH_SS_FEATURES, before requesting kernel
> to add a SA with offload. I see strongSWAN and libreswan trying to
> detect it before requesting offload. This why I got the error.

That kind of check is somewhere between "kind of unreliable" and
"completely bogus", considering that between the check and SA
insertion, the IP address could move to a different device, the route
could change, IPsec offload could be disabled or enabled on the
device, or the device could entirely disappear from the system. Most
of the time it's probably going to turn out ok, but as you noticed, it
can fail pretty spectacularly.

> I had a closeer look and I noticed that deciding when to fail and when
> to fallback is complex. e.g no NAT support with offload is failure,
> -EINVAL and not a fallback.
> 
> I think the current kernel, when it has code to support a feature,
> should fail explictly when the feature requested can't be
> enabled. While, an older kernel which is not aware of the feature may
> silently ignore an unsupported feature. Atleast that is how I feel
> now!

I'd lean toward keeping the current behavior as is (because changing
behavior isn't that great, and because it seems a bit less likely to
trip people up), and possibly introduce a "force offload" option.

Thanks for explaining.

-- 
Sabrina

