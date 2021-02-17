Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144DC31DEC4
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhBQSD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:03:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233065AbhBQSDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 13:03:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A35B64E58;
        Wed, 17 Feb 2021 18:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613584987;
        bh=mk2ayuiham+xkGX3mCdpxhHDxa72J1kkP7EWe6+BkQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WBZj/nmA24PHGS6CBg5AbR08SoRieeoZoRqjzetG8Diwmez98HSvluVyJKl0PA7se
         +O9tW7I4hYw+PcSky2vgFS/z0ARKlKzoV9gah3V01KJrbDH1fQ6U2T76t59lVGa4gZ
         Sfb2fPvZiZISUM2a0OHm5MQE2M9pr+TDBKPZOmT7I15Gm9xbrFr4NtIjhIlLqg6Mmq
         /HK4pDOQnFQolRiGmrM/1LnyMl4b7ZvPLCsNUolt8NHjKpPYw2IWDLZJi1UIp3jRa0
         /FC+p+oOeAoo65mIjCg2Odqh5OMP50oULHhAOsZhaXu9oTFSahdN9dnqOhRZr3KIqR
         BlBOM6rovystw==
Date:   Wed, 17 Feb 2021 10:03:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Cheng <vincent.cheng.xh@renesas.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/3] ptp: ptp_clockmatrix: Add
 wait_for_sys_apll_dpll_lock.
Message-ID: <20210217100306.4948cc73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210216181226.GA5450@renesas.com>
References: <1613192766-14010-1-git-send-email-vincent.cheng.xh@renesas.com>
        <1613192766-14010-2-git-send-email-vincent.cheng.xh@renesas.com>
        <20210215114822.4f698920@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210216181226.GA5450@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Feb 2021 13:12:29 -0500 Vincent Cheng wrote:
> >> +}
> >> +
> >> +static int wait_for_sys_apll_dpll_lock(struct idtcm *idtcm)
> >> +{
> >> +	const char *fmt = "%d ms SYS lock timeout: APLL Loss Lock %d  DPLL state %d";
> >> +	u8 i = LOCK_TIMEOUT_MS / LOCK_POLL_INTERVAL_MS;  
> >
> >Using msleep() and loops is quite inaccurate. I'd recommend you switch
> >to:
> >
> >	unsigned long timeout = jiffies + msecs_to_jiffies(LOCK_TIMEOUT_MS);
> >
> >And then use:
> >
> >	while (time_is_after_jiffies(timeout))
> >  
> 
> To clarify, the suggestion is to use jiffies for accuracy, but
> the msleep(LOCK_POLL_INTERVAL_MS) remains to prevent the do-while
> loop from becoming a busy-wait loop.
> 
> #define LOCK_TIMEOUT_MS			(2000)
> #define LOCK_POLL_INTERVAL_MS		(10)
> 
> unsigned long timeout = jiffies + msecs_to_jiffies(LOCK_TIMEOUT_MS);
> 
> do {
> 	...
>         /*refresh 'locked' variable */
> 	if (locked)
> 		return 0;
> 	
> 	msleep(LOCK_POLL_INTERVAL_MS);
> 
> } while (time_is_after_jiffies(timeout));

Yes, exactly, sorry for lack of clarity.

> >> +			dev_warn(&idtcm->client->dev,
> >> +				"No wait state: DPLL_SYS_STATE %d", dpll);  
> >
> >It looks like other prints in this function use \n at the end of the
> >lines, should we keep it consistent?  
> 
> Looks like the \n is not needed for dev_warn.  Will remove \n 
> of existing messages for consistency.
>
> >> +	dev_warn(&idtcm->client->dev, fmt, LOCK_TIMEOUT_MS, apll, dpll);  
> >
> >I'd recommend leaving the format in place, that way static code
> >checkers can validate the arguments.  
> 
> Good point.  The fmt was used to keep 80 column rule.
> But now that 100 column rule is in place, the fmt
> workaround is not needed anymore.  Will fix in v3 patch.

Log strings / formats are a well known / long standing exception 
to the line length limit. No need to worry about that.

> >> +static void wait_for_chip_ready(struct idtcm *idtcm)
> >> +{
> >> +	if (wait_for_boot_status_ready(idtcm))
> >> +		dev_warn(&idtcm->client->dev, "BOOT_STATUS != 0xA0");  
> >
> >no new line?  
> 
> Nope.  Tried an experiment and \n is not neeeded.
> 
> 	dev_warn(&idtcm->client->dev, "debug: has \\n at end\n");
> 	dev_warn(&idtcm->client->dev, "debug: does not have \\n at end");
> 	dev_warn(&idtcm->client->dev, "debug: has \\n\\n at end\n\n");
> 	dev_warn(&idtcm->client->dev, "debug: hello");
> 	dev_warn(&idtcm->client->dev, "debug: world");
> 
> [   99.069100] idtcm 15-005b: debug: has \n at end
> [   99.073623] idtcm 15-005b: debug: does not have \n at end
> [   99.079017] idtcm 15-005b: debug: has \n\n at end
> [   99.079017]
> [   99.085194] idtcm 15-005b: debug: hello
> [   99.089025] idtcm 15-005b: debug: world
> 
> >> +
> >> +	if (wait_for_sys_apll_dpll_lock(idtcm))
> >> +		dev_warn(&idtcm->client->dev,
> >> +			 "Continuing while SYS APLL/DPLL is not locked");  
> >
> >And here.  
> 
> \n not needed.

Right, it's not needed I was just commenting that the new cases are not
consistent with existing code in the file, but removing \n everywhere
sounds fine as well.
