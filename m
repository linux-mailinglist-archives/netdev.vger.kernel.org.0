Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2487E176400
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgCBTdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgCBTdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 14:33:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C779621D56;
        Mon,  2 Mar 2020 19:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583177602;
        bh=8Z7VJonbUajpWFyhevM9l7sxdap1t3rDzCpXaKQOhvQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lc75PEv96Izsso3iMj78DXToSEK7bBdDE627tdaA+m974OZSsOIxbs3nrzKLky7WI
         vT2eq6tOMpG1GgU9JDztpZGT19QA8HwSXdggtkHbM13X5uKoq+k6S1H2uhABxatHsC
         5prKMfbQDMhOXLVdlEKC8rQyWjCF1SIAEMRIi3Eg=
Date:   Mon, 2 Mar 2020 11:33:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 03/12] flow_offload: check for basic action
 hw stats type
Message-ID: <20200302113319.22fb0cb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200301090009.GT26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-4-jiri@resnulli.us>
        <20200228114056.5bc06ad2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200229074004.GL26061@nanopsycho>
        <20200229111848.53450ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200301090009.GT26061@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Mar 2020 10:00:09 +0100 Jiri Pirko wrote:
> Sat, Feb 29, 2020 at 08:18:48PM CET, kuba@kernel.org wrote:
> >On Sat, 29 Feb 2020 08:40:04 +0100 Jiri Pirko wrote:  
> >> Fri, Feb 28, 2020 at 08:40:56PM CET, kuba@kernel.org wrote:  
> >> >On Fri, 28 Feb 2020 18:24:56 +0100 Jiri Pirko wrote:    
> >> >> @@ -299,6 +300,9 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
> >> >>  		return -EINVAL;
> >> >>  	}
> >> >>  
> >> >> +	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
> >> >> +		return -EOPNOTSUPP;    
> >> >
> >> >Could we have this helper take one stat type? To let drivers pass the
> >> >stat type they support?     
> >> 
> >> That would be always "any" as "any" is supported by all drivers.
> >> And that is exactly what the helper checks..  
> >
> >I'd think most drivers implement some form of DELAYED today, 'cause for
> >the number of flows things like OvS need that's the only practical one.
> >I was thinking to let drivers pass DELAYED here.
> >
> >I agree that your patch would most likely pass ANY in almost all cases
> >as you shouldn't be expected to know all the drivers, but at least the
> >maintainers can easily just tweak the parameter.
> >
> >Does that make sense? Maybe I'm missing something.  
> 
> Well, I guess. mlx5 only supports "delayed". It would work for it.
> How about having flow_action_basic_hw_stats_types_check() as is and
> add flow_action_basic_hw_stats_types_check_ext() that would accept extra
> arg with enum?

SGTM, perhaps with a more concise name? 
Just flow_basic_hw_stats_check()?
