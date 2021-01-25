Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0899302211
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 07:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbhAYGQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 01:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbhAYGPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 01:15:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 810A922C9C;
        Mon, 25 Jan 2021 06:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611555312;
        bh=IB/UXTLldY0VeVK04PPliyb0CI5VZn97BZEC0qXYo0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dCnZiJfOK26Uee1JFXsLbHn2Lx+kDinMavd9/cVloz7FEEZidk2p/GyDL+yOBSWj4
         EIUd+P621/8KiUeGvVwvi5Zx2rAgbXGwS10B0nzOr5sjk3IVu7HEGLqb9YPLCvPKFU
         xAK4iMcvTckYbKt0YqxaqD7BL8Y3WOqrwOM5RzOfmS8zJzvequUBFAoaoRFxOYgGwk
         8FtNPMxMS3zVlDRgquNTXsfdW93oZgHoiHHDyYbe8MtFzBM05qd41Hari/4JMSRiWe
         iBkIgdlFkRDgs92LMgv1UvI5pmx4oI37uL9gMI2W1TAwwPxRs/NiaZQjaWpblEJz/R
         /NxLWgFn9pe8Q==
Date:   Mon, 25 Jan 2021 08:15:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com
Subject: Re: [net-next v2 2/2] tcp: Add receive timestamp support for receive
 zerocopy.
Message-ID: <20210125061508.GC579511@unreal>
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
 <20210121004148.2340206-3-arjunroy.kdev@gmail.com>
 <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a18cbf73-1720-dec0-fbc6-2e357fee6bd8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a18cbf73-1720-dec0-fbc6-2e357fee6bd8@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 10:55:45PM -0700, David Ahern wrote:
> On 1/22/21 9:07 PM, Jakub Kicinski wrote:
> > On Wed, 20 Jan 2021 16:41:48 -0800 Arjun Roy wrote:
> >> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> >> index 768e93bd5b51..b216270105af 100644
> >> --- a/include/uapi/linux/tcp.h
> >> +++ b/include/uapi/linux/tcp.h
> >> @@ -353,5 +353,9 @@ struct tcp_zerocopy_receive {
> >>  	__u64 copybuf_address;	/* in: copybuf address (small reads) */
> >>  	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
> >>  	__u32 flags; /* in: flags */
> >> +	__u64 msg_control; /* ancillary data */
> >> +	__u64 msg_controllen;
> >> +	__u32 msg_flags;
> >> +	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
> >
> > Well, let's hope nobody steps on this landmine.. :)
> >
>
> Past suggestions were made to use anonymous declarations - e.g., __u32
> :32; - as a way of reserving the space for future use. That or declare
> '__u32 resvd', check that it must be 0 and makes it available for later
> (either directly or with a union).

This is the schema (reserved field without union) used by the RDMA UAPIs from
the beginning (>20 years already) and it works like a charm.

Highly recommend :).

Thanks

>
