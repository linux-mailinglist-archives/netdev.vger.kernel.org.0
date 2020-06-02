Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80B11EC1D1
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgFBSbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgFBSbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 14:31:50 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF189206E2;
        Tue,  2 Jun 2020 18:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591122710;
        bh=w+bGG+hfRHUIaJ7ejsUApeTMVI0Dr/mZj/Q8ag19DAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fNweCS5Y4ksVMKM5G/6+qk425YWDpNnPCILNtwlyGj5fSKfpnkcnukXnMCLcLWwhj
         7QrfbolzPJiAUUaYjobjQtu0FUQlwIa9nlRLz+HifeFssUYyV1PTKRWzlPc/bmfOHr
         mz7NYdty3U9tKu+U4hFyV7DWG7Q+c1SRCet1fSV4=
Date:   Tue, 2 Jun 2020 11:31:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Message-ID: <20200602113148.47c2daea@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <4f07f3e0-8179-e70a-71a5-9f0407b709d6@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
        <20200529194641.243989-11-saeedm@mellanox.com>
        <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
        <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
        <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <4f07f3e0-8179-e70a-71a5-9f0407b709d6@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jun 2020 14:32:44 +0300 Tariq Toukan wrote:
> On 6/2/2020 1:12 AM, Jakub Kicinski wrote:
> >>>> This is a rare corner case anyway, where more than 1k tcp
> >>>> connections sharing the same RX ring will request resync at the
> >>>> same exact moment.  
> >>>
> >>> IDK about that. Certain applications are architected for max
> >>> capacity, not efficiency under steady load. So it matters a lot how
> >>> the system behaves under stress. What if this is the chain of
> >>> events:
> >>>
> >>> overload -> drops -> TLS steams go out of sync -> all try to resync
> >>>     
> >>
> >> I agree that this is not that rare, and it may be improved both in
> >> future patches and hardware. Do you think it is critical to improve
> >> it now, and not in a follow-up series?  
> > 
> > It's not a blocker for me, although if this makes it into 5.8 there
> > will not be a chance to improve before net-next closes, so depends if
> > you want to risk it and support the code as is...
> >   
> 
> Hi Jakub,
> Thanks for your comments.
> 
> This is just the beginning of this driver's offload support. I will 
> continue working on enhancements and improvements in next kernels.
> We have several enhancements in plans.
> 
> For now, if no real blockers, I think it's in a good shape to start with 
> and make it to the kernel.
> 
> IMHO, this specific issue of better handling the resync failure in 
> driver can be addressed in stages:
> 
> 1. As a fix: stop asking the stack for resync re-calls. If a resync 
> attempt fails, terminate any resync attempts for the specific connection.
> If there's room for a re-spin I can provide today. Otherwise it is a 
> simple fix that can be addressed in the early rc's in -net.
> What do you think?
> 
> 2. Recover: this is an enhancement to be done in future kernels, where 
> the driver internally and independently recovers from failed attempts 
> and makes sure the are processed when there's enough room on the SQ 
> again. Without the stack being engaged.

IIUC the HW asks for a resync at the first record after a specific seq
(the record header is in the frame that carried the OOO marking, right?)

Can we make the core understand those semantics and avoid trying to
resync at the wrong record?
