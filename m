Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED72D308FB2
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbhA2V5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:57:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231335AbhA2V5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:57:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 280F564E0C;
        Fri, 29 Jan 2021 21:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611957423;
        bh=JFXcp5hcRzeOdQmARynw+e5iZvxPrVy9IZ5Fz2O2o1Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UbcrEIAjID8butS8l1CXsVi68aW2+EnT/corLsU3SEhN5fYHWWB98OLBVyWkVJjIv
         sdD6D5KnoSxV1zOTx4LGfZt+6UijYId5QYHrjzVvG3nPW+xylFiYEJfXxQgqUtfxdX
         s1t1mra8GM3NVV8tCL0PlmCAoKvy6FzdhYkqtN92J8H5NoJEuSHobqUIzQc340gEBH
         CxtaXZW6ZdrW1rXfA2ZgAF/VpbHCbiJpIa+97G5AHMuFeLrkazvIgJo2vOPamUwjAM
         GOdVhH9uSKFtJfuAb/cgwkaDiINWlgrFKsv7ET467GbO2ggqmW3b9BBdIYqZzZgHvK
         Og/FsDcRQBTBw==
Date:   Fri, 29 Jan 2021 13:57:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 2/8] taprio: Add support for frame
 preemption offload
Message-ID: <20210129135702.0f8cf702@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87wnvvsayz.fsf@vcostago-mobl2.amr.corp.intel.com>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
        <20210122224453.4161729-3-vinicius.gomes@intel.com>
        <20210126000924.jjkjruzmh5lgrkry@skbuf>
        <87wnvvsayz.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 13:13:24 -0800 Vinicius Costa Gomes wrote:
> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
> 
> > On Fri, Jan 22, 2021 at 02:44:47PM -0800, Vinicius Costa Gomes wrote:  
> >> +	/* It's valid to enable frame preemption without any kind of
> >> +	 * offloading being enabled, so keep it separated.
> >> +	 */
> >> +	if (tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]) {
> >> +		u32 preempt = nla_get_u32(tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]);
> >> +		struct tc_preempt_qopt_offload qopt = { };
> >> +
> >> +		if (preempt == U32_MAX) {
> >> +			NL_SET_ERR_MSG(extack, "At least one queue must be not be preemptible");
> >> +			err = -EINVAL;
> >> +			goto free_sched;
> >> +		}
> >> +
> >> +		qopt.preemptible_queues = tc_map_to_queue_mask(dev, preempt);
> >> +
> >> +		err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
> >> +						    &qopt);
> >> +		if (err)
> >> +			goto free_sched;
> >> +
> >> +		q->preemptible_tcs = preempt;
> >> +	}
> >> +  
> >
> > First I'm interested in the means: why check for preempt == U32_MAX when
> > you determine that all traffic classes are preemptible? What if less
> > than 32 traffic classes are used by the netdev? The check will be
> > bypassed, won't it?  
> 
> Good catch :-)
> 
> I wanted to have this (at least one express queue) handled in a
> centralized way, but perhaps this should be handled best per driver.

Centralized is good. Much easier than reviewing N drivers to make sure
they all behave the same, and right.
