Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B3A2C1822
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732266AbgKWWFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:05:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbgKWWFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:05:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16C5A2065E;
        Mon, 23 Nov 2020 22:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606169120;
        bh=WdAxvkzx3t0CR8g6BMeEUxhmD6sgdPUz0+QX03a2Fl4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZVr0+wb/mr6gTAKd84U8e3HJXUPbm0tdqka1eTDALkPvs+S2Vpidd/dunKIU9jpAq
         brm+GQgx5K9I1SBNCKACcxieD2Em+yaJZcenE2haam1+zXFIwqwaN7M5bALd8IU4si
         Pr4oEaIOovj7yTAje9r1uYX5z4bqfet3+Z6nov+s=
Date:   Mon, 23 Nov 2020 14:05:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>, <roopa@nvidia.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] bridge: mrp: Implement LC mode for MRP
Message-ID: <20201123140519.3bb3db16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <13cef7c2-cacc-2c24-c0d5-e462b0e3b4df@nvidia.com>
References: <20201123111401.136952-1-horatiu.vultur@microchip.com>
        <5ffa6f9f-d1f3-adc7-ddb8-e8107ea78da5@nvidia.com>
        <20201123123132.uxvec6uwuegioc25@soft-dev3.localdomain>
        <13cef7c2-cacc-2c24-c0d5-e462b0e3b4df@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 16:25:53 +0200 Nikolay Aleksandrov wrote:
> >>> @@ -156,4 +157,10 @@ struct br_mrp_in_link_hdr {
> >>>       __be16 interval;
> >>>  };
> >>>
> >>> +struct br_mrp_in_link_status_hdr {
> >>> +     __u8 sa[ETH_ALEN];
> >>> +     __be16 port_role;
> >>> +     __be16 id;
> >>> +};
> >>> +  
> >>
> >> I didn't see this struct used anywhere, am I missing anything?  
> > 
> > Yes, you are right, the struct is not used any. But I put it there as I
> > put the other frame types for MRP.
> >   
> 
> I see, we don't usually add unused code. The patch is fine as-is and since
> this is already the case for other MRP parts I'm not strictly against it, so:
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> If Jakub decides to adhere to that rule you can keep my acked-by and just remove
> the struct for v2.

Yes, good catch, let's drop it, we don't want to make too much of 
a precedent for using kernel uAPI headers as a place to provide
protocol-related structs if the kernel doesn't need them.

The existing structs are only present in net-next as well, so if you
don't mind Horatiu it'd be good to follow up and remove the unused ones
and move the ones (if any) which are only used by the kernel but not by
the user space <-> kernel API communication out of include/uapi.
