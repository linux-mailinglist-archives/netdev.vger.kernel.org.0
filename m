Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D12930B80F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhBBGxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhBBGxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:53:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08B8E64EDF;
        Tue,  2 Feb 2021 06:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248745;
        bh=M9h+Sf6s4y4nrlOy7Khp1BodHMub+78frC6raSv/AEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qzAVyjOARC//Y73h3S5T3iy/aHUHbPzuqpWUk+8JFC5103rdrwMGo750NoAJcUY7Z
         q/nLfIm72c3DxbhKW1vNrHle9ivdtKAasGWQpx7uqAYtNQVvfM2g85BFncw/OdsJ6A
         R6vNY/p6cfXt2n32kUnDbHb01ouQ6hqeT50VrHh8Fr4ISxmZ/c5I+IISsSLkM39gcz
         KpCMO3YQiWO4wW2bqn9JotgF/hxpfZg1KzV3b70xaB2X94YNchRkHQyWJm3/ZxP9yV
         ghF2G5lYuHR16rK2jppfiZ4dsG7FhjsIm1smN9Yj9vBJ6yTs0J86skFEs2/a4jBaYf
         h80t2Cno8xiHQ==
Date:   Tue, 2 Feb 2021 08:52:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Arjun Roy <arjunroy@google.com>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [net-next v2 2/2] tcp: Add receive timestamp support for receive
 zerocopy.
Message-ID: <20210202065221.GB1945456@unreal>
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
 <20210121004148.2340206-3-arjunroy.kdev@gmail.com>
 <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a18cbf73-1720-dec0-fbc6-2e357fee6bd8@gmail.com>
 <20210125061508.GC579511@unreal>
 <ad3d4a29-b6c1-c6d2-3c0f-fff212f23311@gmail.com>
 <CAOFY-A2y20N9mUDgknbqM=tR0SA6aS6aTjyybggWNa8uY2=U_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFY-A2y20N9mUDgknbqM=tR0SA6aS6aTjyybggWNa8uY2=U_Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 06:20:23PM -0800, Arjun Roy wrote:
> On Mon, Feb 1, 2021 at 6:06 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 1/24/21 11:15 PM, Leon Romanovsky wrote:
> > > On Fri, Jan 22, 2021 at 10:55:45PM -0700, David Ahern wrote:
> > >> On 1/22/21 9:07 PM, Jakub Kicinski wrote:
> > >>> On Wed, 20 Jan 2021 16:41:48 -0800 Arjun Roy wrote:
> > >>>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > >>>> index 768e93bd5b51..b216270105af 100644
> > >>>> --- a/include/uapi/linux/tcp.h
> > >>>> +++ b/include/uapi/linux/tcp.h
> > >>>> @@ -353,5 +353,9 @@ struct tcp_zerocopy_receive {
> > >>>>    __u64 copybuf_address;  /* in: copybuf address (small reads) */
> > >>>>    __s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
> > >>>>    __u32 flags; /* in: flags */
> > >>>> +  __u64 msg_control; /* ancillary data */
> > >>>> +  __u64 msg_controllen;
> > >>>> +  __u32 msg_flags;
> > >>>> +  /* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
> > >>>
> > >>> Well, let's hope nobody steps on this landmine.. :)
> > >>>
> > >>
> > >> Past suggestions were made to use anonymous declarations - e.g., __u32
> > >> :32; - as a way of reserving the space for future use. That or declare
> > >> '__u32 resvd', check that it must be 0 and makes it available for later
> > >> (either directly or with a union).
> > >
> > > This is the schema (reserved field without union) used by the RDMA UAPIs from
> > > the beginning (>20 years already) and it works like a charm.
> > >
> > > Highly recommend :).
> > >
> >
> > agreed.
> >
> > Arjun: would you mind following up with a patch to make this hole
> > explicit and usable for the next extension? Thanks,
>
> Will do.

Please pay attention that all "in" and "out" fields that marked as reserved
should be zeroed and kernel must check "in" field to ensure future compatibility.

Thanks

>
> -Arjun
