Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628E31748D8
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 20:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgB2TSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 14:18:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgB2TSv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Feb 2020 14:18:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395B724677;
        Sat, 29 Feb 2020 19:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583003930;
        bh=wVLk4lPUUHi8PjEQT5vDEkR+iWJpI77VnR4JsulXb2M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ul9PtBMODCGVKU6qXm9HANNcAtaczF+Ypu7nmZOWhDbncJOsiQQmsrzfRqqI3aDem
         HRhiuRpoLugQGP0LJ44e+OE/A0tikHzRTUbFRKZM4BlhtSCBa8E3ulNO/tum4JdDn9
         dGKC3aG9K1XoS1iNXROgtkKJtTqLau/dJ5jmDhoA=
Date:   Sat, 29 Feb 2020 11:18:48 -0800
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
Message-ID: <20200229111848.53450ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200229074004.GL26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-4-jiri@resnulli.us>
        <20200228114056.5bc06ad2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200229074004.GL26061@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Feb 2020 08:40:04 +0100 Jiri Pirko wrote:
> Fri, Feb 28, 2020 at 08:40:56PM CET, kuba@kernel.org wrote:
> >On Fri, 28 Feb 2020 18:24:56 +0100 Jiri Pirko wrote:  
> >> @@ -299,6 +300,9 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
> >>  		return -EINVAL;
> >>  	}
> >>  
> >> +	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
> >> +		return -EOPNOTSUPP;  
> >
> >Could we have this helper take one stat type? To let drivers pass the
> >stat type they support?   
> 
> That would be always "any" as "any" is supported by all drivers.
> And that is exactly what the helper checks..

I'd think most drivers implement some form of DELAYED today, 'cause for
the number of flows things like OvS need that's the only practical one.
I was thinking to let drivers pass DELAYED here.

I agree that your patch would most likely pass ANY in almost all cases
as you shouldn't be expected to know all the drivers, but at least the
maintainers can easily just tweak the parameter.

Does that make sense? Maybe I'm missing something.
