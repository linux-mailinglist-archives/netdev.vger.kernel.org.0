Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4834A2AF5CF
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgKKQJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgKKQJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 11:09:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DBA6206A1;
        Wed, 11 Nov 2020 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605110976;
        bh=TqyJZMDwFQcpQlK342xsrOlFwbXnEbcCT0Uw9BJw+3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LY2akF8O7rqwwg2H99heKGcaZ/gbJpYribw9iLFq8I4RoyLlNWFFnExt72goirXaQ
         hTw1DHwAzR5Jg+5sOLvSjlKmtLxZWIwZafIho+0VMZY+DHoQ7x4gPtkW1rf0/wyMQV
         GwMl+BlZ2GsYvUiWbxfFNL1SXBUHRQfgfBoYKWos=
Date:   Wed, 11 Nov 2020 08:09:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net V2] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is
 disabled
Message-ID: <20201111080935.27989dc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <83a73a18-d03b-c763-2b4f-b0c7e6cd14fc@gmail.com>
References: <20201108144309.31699-1-tariqt@nvidia.com>
        <20201110154428.06094336@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <83a73a18-d03b-c763-2b4f-b0c7e6cd14fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 14:25:53 +0200 Tariq Toukan wrote:
> On 11/11/2020 1:44 AM, Jakub Kicinski wrote:
> > On Sun,  8 Nov 2020 16:43:09 +0200 Tariq Toukan wrote:  
> >> @@ -528,3 +528,7 @@ Drivers should ignore the changes to TLS the device feature flags.
> >>   These flags will be acted upon accordingly by the core ``ktls`` code.
> >>   TLS device feature flags only control adding of new TLS connection
> >>   offloads, old connections will remain active after flags are cleared.
> >> +
> >> +The TLS encryption cannot be offloaded to device if checksum calculation
> >> +is not, hence the TLS TX device feature flag is cleared when HW_CSUM is
> >> +disabled.  
> > 
> > This makes it sound like the driver will fall back to software crypto
> > if L4 csum offload gets disabled, is this your intention?
> > 
> > Seems at odds with the paragraph above it.
> >   
> 
> Actually, TLS feature bit acts on new connections, while CSUM feature 
> bit acts immediately, so for old connections we still have a gap.

Well, for your implementation. I'm pretty sure NFP will always recompute
the TCP csum on TLS segments :)

> I think of adding logic in netif_skb_features or tls_validate_xmit_skb, 
> but it's not trivial.
> 
> I'll resubmit when i figure out a clean way that covers all cases and is 
> consistent with TLS feature bit behavior.

Sounds like the way forward you're thinking of is changing the way both
feature flags work, and not just stopping new connections? Fine by me,
TLS fallback is quite a bit less efficient than the normal SW
implementation (can't use AES-NI), my concern was that users will be
surprised they don't get the performance they are expecting from SW.
