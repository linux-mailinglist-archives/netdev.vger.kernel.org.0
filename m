Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560B233EBC1
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhCQInO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:43:14 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:55276 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhCQIms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 04:42:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 81E3F205B4;
        Wed, 17 Mar 2021 09:42:47 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GBEHnAwBPjIx; Wed, 17 Mar 2021 09:42:46 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D1597204A4;
        Wed, 17 Mar 2021 09:42:46 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 17 Mar 2021 09:42:46 +0100
Received: from moon.secunet.de (172.18.26.121) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 17 Mar
 2021 09:42:46 +0100
Date:   Wed, 17 Mar 2021 09:42:43 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Antony Antony <antony.antony@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Yossi Kuperman" <yossiku@mellanox.com>,
        Guy Shapiro <guysh@mellanox.com>, <netdev@vger.kernel.org>,
        <antony@phenome.org>
Subject: Re: [PATCH] xfrm: return error when esp offload is requested and not
 supported
Message-ID: <20210317084243.GB1282@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20210310093611.GA5406@moon.secunet.de>
 <20210315104350.GY62598@gauss3.secunet.de>
 <YE99dz85HaajKX4w@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YE99dz85HaajKX4w@hog>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Mar 15, 2021 at 16:29:59 +0100, Sabrina Dubroca wrote:
> 2021-03-15, 11:43:50 +0100, Steffen Klassert wrote:
> > On Wed, Mar 10, 2021 at 10:36:11AM +0100, Antony Antony wrote:
> > > When ESP offload is not supported by the device return an error,
> > > -EINVAL, instead of silently ignoring it, creating a SA without offload,
> > > and returning success.
> > > 
> > > with this fix ip x s a would return
> > > RTNETLINK answers: Invalid argument
> > > 
> > > Also, return an error, -EINVAL, when CONFIG_XFRM_OFFLOAD is
> > > not defined and the user is trying to create an SA with the offload.
> > > 
> > > Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
> > > Signed-off-by: Antony Antony <antony.antony@secunet.com>
> > 
> > I feal a bit unease about this one. When we designed the offloading
> > API, we decided to fallback to software if HW offload is not available.

Right! Now, I recollect the silent fallback feature, which was mentioned
when the offload was introduced. However, while using I found it
confusing. And I thought it was an unintended side effect and came up
with a fix. Looking closer at the proposed patch and commit 4a132095dd6 I
wonder what would be a consistent behavior.


> Right, but it's a little bit inconsistent. If HW offload is not
> available, we get silent fallback. This is great for compatibility
> (old kernels will completely ignore the XFRMA_OFFLOAD_DEV attribute,
> new kernels try to emulate this), and because routes can change and
> suddenly the packets that should have been going through some device
> go through another, which may have different capabilities.
> 
> On the other hand, if HW offload is available but doesn't support the
> exact features we're trying to enable (UDP encap, wrong algorithm, etc
> (*)), then we can fail in a visible way.

Yes.

> (*) I know there's an "if (err != -EOPNOTSUPP)" on the result of
> ->xdo_dev_state_add(), but for example mlx5 seems to return EINVAL
> instead of EOPNOTSUPP.

That is interesting. I think !CONFIG_XFRM_OFFLOAD should be
EOPNOTSUPP?

> 
> > Not sure if that was a good idea, but changing this would also change
> > the userspace ABI. So if we change this, we should at least not
> > consider it as a fix because it would be backported to -stable

agreed. It could be a new feature?

> > in that case. Thoughts?
> 
> Agree, but I don't think we could even change this at all.
> 
> At best we could introduce a flag to force offloading, and fail if we
> can't offload. But then what should we do if the traffic for that
> state is rerouted through a different interface, or if offloading is
> temporarily disabled with ethtool? Also, should a kernel with
> !CONFIG_XFRM_OFFLOAD ignore that flag or not?
> 
> Antony, what prompted you to write this patch? Do you have a use case
> for requiring offloading instead of falling back to software?

I was using strongSWAN. Due to NIC changes and route changes the SA,
with offload, failed to create.
Actually, strongSWAN didn't even try to create a SA. It reported an error when it checked offload support on the device, after IKE negotiation just before installing the SA.

[KNL] 192.168.1.1 is on interface eth2
[KNL] HW offload is not supported by device

To debug I tried "ip x s a eth2" and a the SA got created, which confused me. After a closer showed offload was silently ignored.

Next I tried to create an offload to loopback device.
"ip x s a ... offload dev lo dir in" and there was an SA without offload, Device lo will never have offload:)
This led me to look at the kernel code. There I found the offload request can be silently ignored. So I created a fix.

One important point to note: IKE daemons check for offload support, using ETHTOOL_GFEATURES or ETH_SS_FEATURES, before requesting kernel to add a SA with offload. I see strongSWAN and libreswan trying to detect it before requesting offload. This why I got the error.

I had a closeer look and I noticed that deciding when to fail and when to fallback is complex. e.g no NAT support with offload is failure, -EINVAL and not a fallback.

I think the current kernel, when it has code to support a feature, should fail explictly when the feature requested can't be enabled. While, an older kernel which is not aware of the feature may silently ignore an unsupported feature. Atleast that is how I feel now!


thanks for the feedback.

-antony
