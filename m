Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F16176425
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCBTjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:39:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBTjh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 14:39:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA73F24695;
        Mon,  2 Mar 2020 19:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583177976;
        bh=p837LGQ4Z7jtgjkOxZ8CcvR4b4uce2IevOhbpqNjCww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ahwfZXU67IRudBlAqiIlPl0YBjiTZo4pXlWICAyHe0k1Q94geb+lk2n2V6bnHSTZY
         UgDkOcIJrC92uXmcTMZmdCq7KJ4oKDWJP8S2qg5jMFW+iyii8funqFXaxr4Dp+T6Er
         z9lnDmYSIbSv3BJGwmNw60TcBxMIRSPWnl7cU+D8=
Date:   Mon, 2 Mar 2020 11:39:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 12/12] sched: act: allow user to specify
 type of HW stats for a filter
Message-ID: <20200302113933.34fa6348@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200301085756.GS26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-13-jiri@resnulli.us>
        <20200228115923.0e4c7baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200229075209.GM26061@nanopsycho>
        <20200229121452.5dd4963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200301085756.GS26061@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Mar 2020 09:57:56 +0100 Jiri Pirko wrote:
> >> >On request:
> >> > - no attr -> any stats allowed but some stats must be provided *
> >> > - 0       -> no stats requested / disabled
> >> > - 0x1     -> must be stat type0
> >> > - 0x6     -> stat type1 or stat type2 are both fine    
> >> 
> >> I was thinking about this of course. On the write side, this is ok
> >> however, this is very tricky on read side. See below.
> >>   
> >> >* no attr kinda doesn't work 'cause u32 offload has no stats and this
> >> >  is action-level now, not flower-level :S What about u32 and matchall?    
> >> 
> >> The fact that cls does not implement stats offloading is a lack of
> >> feature of the particular cls.  
> >
> >Yeah, I wonder how that squares with strict netlink parsing.
> >  
> >> >We can add a separate attribute with "active" stat types:
> >> > - no attr -> old kernel
> >> > - 0       -> no stats are provided / stats disabled
> >> > - 0x1     -> only stat type0 is used by drivers
> >> > - 0x6     -> at least one driver is using type1 and one type2    
> >> 
> >> There are 2 problems:
> >> 1) There is a mismatch between write and read. User might pass different
> >> value than it eventually gets from kernel. I guess this might be fine.  
> >
> >Separate attribute would work.
> >  
> >> 2) Much bigger problem is, that since the same action may be offloaded
> >> by multiple drivers, the read would have to provide an array of
> >> bitfields, each array item would represent one offloaded driver. That is
> >> why I decided for simple value instead of bitfield which is the same on
> >> write and read.  
> >
> >Why an array? The counter itself is added up from all the drivers.
> >If the value is a bitfield all drivers can just OR-in their type.  
> 
> Yeah, for uapi. Internally the array would be still needed. Also the
> driver would need to somehow "write-back" the value to the offload
> caller and someone (caller/tc) would have to use the array to track
> these bitfields for individual callbacks (probably idr of some sort).
> I don't know, is this excercise worth it?

I was thinking of just doing this on HW stats dump. Drivers which don't
report stats by definition don't need to set any bit :)

> Seems to me like we are overengineering this one a bit.

That's possible, the reporting could be added later... I mostly wanted
to have the discussion.

> Also there would be no "any" it would be type0|type1|type2 the user
> would have to pass. If new type appears, the userspace would have to be
> updated to do "any" again :/ This is inconvenient.

In my proposal above I was suggesting no attr to mean any. I think in
your current code ANY already doesn't include disabled so old user
space should not see any change.
