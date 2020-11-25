Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2EB2C4928
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgKYUiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:38:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730181AbgKYUiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 15:38:05 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94A41207BB;
        Wed, 25 Nov 2020 20:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606336684;
        bh=elEwWPhSnABfUSwIsJehdG48/a2CeEJSdCp80Tz8dks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d+PVKQ2amyfFG94j7OMAcbH2lj0XOtH1DXtqpI9Vp0nTy5c53NhH8PfoECaTaHeac
         kZxhgTtHBFsc+NBKaMQ3xeT7yk0uACZVkggdCgXRWmXifnwTdlV8umtt/jb67qxU9b
         OeJDtQYPaGvJIA0rDjQshkXI6dxZ7mFFLqQAtUhk=
Date:   Wed, 25 Nov 2020 12:38:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH v3 net] enetc: Let the hardware auto-advance the taprio
 base-time of 0
Message-ID: <20201125123803.02c1f508@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VE1PR04MB6496784CA12CA642867F372A92FA0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20201124220259.3027991-1-vladimir.oltean@nxp.com>
        <VE1PR04MB6496784CA12CA642867F372A92FA0@VE1PR04MB6496.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 02:28:27 +0000 Po Liu wrote:
> > The tc-taprio base time indicates the beginning of the tc-taprio schedule,
> > which is cyclic by definition (where the length of the cycle in nanoseconds
> > is called the cycle time). The base time is a 64-bit PTP time in the TAI
> > domain.
> > 
> > Logically, the base-time should be a future time. But that imposes some
> > restrictions to user space, which has to retrieve the current PTP time from
> > the NIC first, then calculate a base time that will still be larger than the
> > base time by the time the kernel driver programs this value into the
> > hardware. Actually ensuring that the programmed base time is in the
> > future is still a problem even if the kernel alone deals with this.
> > 
> > Luckily, the enetc hardware already advances a base-time that is in the
> > past into a congruent time in the immediate future, according to the same
> > formula that can be found in the software implementation of taprio (in
> > taprio_get_start_time):
> > 
> > 	/* Schedule the start time for the beginning of the next
> > 	 * cycle.
> > 	 */
> > 	n = div64_s64(ktime_sub_ns(now, base), cycle);
> > 	*start = ktime_add_ns(base, (n + 1) * cycle);
> > 
> > There's only one problem: the driver doesn't let the hardware do that.
> > It interferes with the base-time passed from user space, by special-casing
> > the situation when the base-time is zero, and replaces that with the
> > current PTP time. This changes the intended effective base-time of the
> > schedule, which will in the end have a different phase offset than if the
> > base-time of 0.000000000 was to be advanced by an integer multiple of
> > the cycle-time.
> > 
> > Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-
> > taprio offload")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> It makes sense to me for this patch. Thanks!

Applied, thanks!
