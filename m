Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCC22AE41A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbgKJXcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:32:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgKJXcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:32:13 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC5CF207E8;
        Tue, 10 Nov 2020 23:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605051133;
        bh=oYYP8PoMQDx34d6jvaYwRonJviJjFXmRlAKQM8IXFjc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kOTAMi6yYqIuoMtHDFQc9uFRRvlgpb33Sx31kNNSgPQYajs7GdxLv+8lXFzKyOrR8
         11D5J8Zu+I0Jm/RzIstHINcIit2ggvJRiaMRSE/L40iRoCuXqZr8ZXCAn7Lw1J0CND
         MO8MWQMS7+CNglDwZtFpJDqzmvM5AJUrr0ivqwYg=
Message-ID: <6af7754d5bcba7a7f7d92dc43e1f4206ce470c79.camel@kernel.org>
Subject: Re: Hardware time stamping support for AF_XDP applications
From:   Saeed Mahameed <saeed@kernel.org>
To:     "Patel, Vedang" <vedang.patel@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
Date:   Tue, 10 Nov 2020 15:32:11 -0800
In-Reply-To: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
References: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-10 at 22:44 +0000, Patel, Vedang wrote:
> [Sorry if you got the email twice. Resending because it was rejected
> by netdev for containing HTML]
> 
> Hi Saeed/Jesper, 
>  
> I am working in the Time Sensitive Networking team at Intel. We work
> on implementing and upstreaming support for TSN related features for
> intel based NICs. Recently we have been adding support for XDP in
> i225. One of the features which we want to add support for is passing
> the hardware timestamp information to the userspace application
> running AF_XDP sockets (for both Tx and Rx). I came across the XDP
> Workshop[1] conducted in July 2020 and there you stated that you are
> already working on adding support for BTF based metadata to pass
> hardware hints for XDP Programs. My understanding (along with a few
> questions) of the current state is: 

Hi Patel,

> * This feature is currently being maintained out of tree. I found
> that an RFC Series[2] was posted in June 2018. Are you planning to
> post an updated version to be merged in the mainline anytime soon? 

Yes hopefully in the coming couple of weeks.

> * I am guessing hardware timestamp is one of the metadata fields
> which will be eventually supported? [3]

With BTF formatted metadata it is up to the driver to advertise
whatever it can/want :)
so yes.

> * The Metadata support will be extended to pass on the hardware hints
> to AF_XDP sockets. Are there any rough plans on what metadata will be
> transferred?

AF_XDP is not part of my series, but supporting AF_XDP with metadata
offlaod is up to the driver to implement, should be straight forward
and identical to XDP.

what meta data to pass is up to the driver.


> * The current plan for Tx side only includes passing data from the
> application to the driver. Are there any plans to support passing
> information (like HW TX timestamp) from driver to the Application?
>  

you mean for AF_XDP ? i actually haven't thought about this, 
but we could use TX umem packet buffer headroom to pass TX completion
metadata to AF_XDP app, or extend the completion queue entries to host
metadata, i am sure that the 1st approach is preferred, but i am not
planing to support this in my initial series. 

> Finally, is there any way I can help in expediting the development
> and upstreaming of this feature? I have been working on studying how
> XDP works and can work on implementing some part of this feature if
> you would like.
>  

Sure,
Please feel free to clone and test the following branch if you add
support to  your driver and implement offloads for AF_XDP that would be
awesome, and i will append your patches to my series before submission.

it is always great to send new features with multiple use cases and
multi vendor support, this will differently expedite submission and
acceptance

My Latest work can be found at:

https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/log/?h=topic/xdp_metadata3

Please feel free to send me any questions about the code in private or
public.

Thanks,
Saeed.

> Thanks,
> Vedang Patel
> Software Engineer
> Intel Corporation
>  
> [1] - https://netdevconf.info/0x14/session.html?workshop-XDP
> [2] - 
> https://patchwork.ozlabs.org/project/netdev/cover/20180627024615.17856-1-saeedm@mellanox.com/
> [3] - 
> https://xdp-project.net/#outline-container-Important-medium-term-tasks
> 
> 

