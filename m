Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9878E34D629
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhC2Rjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhC2Rj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:39:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545AE61879;
        Mon, 29 Mar 2021 17:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617039568;
        bh=vPyEn/U16uCo1O6mO22oiChJn58ryFuGP88hEbW0UXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SYiJhKlVqki94RoGpMjHgY4QpHVgwsR/uelLwCBSpAXO5X43PcJ9pumz2yGL2aDOB
         wp/w/nn19oJG4u7cixj2bSkLB+4FUdMAdgTtld0/eNGSS40aiUnazSWqwfQcWdrHdP
         XZs0JnM4iSFxi8PbfG0q+JCCjFuWtvaFZFo9hIQd/zrVoJJCDQfVn4L0TuK0nykM8W
         q38qRJPqN5HPHl9HI38LS9S2X1IXn38Tdo1Qe3unT9s9gdFV3a3sVG9HL+ae4aR+Jc
         B7U4RIRQ5IXRldhxPjOqBd7q8OX3oprdqpW+HxJtkXRqQc7D83kjMU1qIsg3FXqudn
         iKkPQDCVHXUOQ==
Date:   Mon, 29 Mar 2021 10:39:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, damian.dybek@intel.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, roopa@nvidia.com
Subject: Re: [PATCH net-next 6/6] ethtool: clarify the ethtool FEC interface
Message-ID: <20210329103925.04db7c9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <435d5a68-95bf-81b6-2d29-75d2888e62cd@gmail.com>
References: <20210325011200.145818-1-kuba@kernel.org>
        <20210325011200.145818-7-kuba@kernel.org>
        <435d5a68-95bf-81b6-2d29-75d2888e62cd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Mar 2021 12:56:30 +0100 Edward Cree wrote:
> On 25/03/2021 01:12, Jakub Kicinski wrote:
> > Drivers should reject mixing %ETHTOOL_FEC_AUTO_BIT with other
> > + * FEC modes, because it's unclear whether in this case other modes constrain
> > + * AUTO or are independent choices.  
> 
> Does this mean you want me to spin a patch to sfc to reject this?
> Currently for us e.g. AUTO|RS means use RS if the cable and link partner
>  both support it, otherwise let firmware choose (presumably between BASER
>  and OFF) based on cable/module & link partner caps and/or parallel detect.
> We took this approach because our requirements writers believed that
>  customers would have a need for this setting; they called it "prefer FEC",
>  and I think the idea was to use FEC if possible (even on cables where the
>  IEEE-recommended default is no FEC, such as CA-25G-N 3m DAC) but allow
>  fallback to no FEC if e.g. link partner doesn't advertise FEC in AN.
> Similarly, AUTO|BASER ("prefer BASE-R FEC") might be desired by a user who
>  wants to use BASE-R if possible to minimise latency, but fall back to RS
>  FEC if the cable or link partner insists on it (eg CA-25G-L 5m DAC).
> Whether we were right and all this is actually useful, I couldn't say.

Interesting combo. Up to you, the API is quite unclear, I think users
shouldn't expect anything beyond single bit set to work across
implementations. IMHO supporting anything beyond that is just code
complexity for little to no gain. But then again, as long as you don't
confuse AUTO with autoneg there's no burning need to change :)
