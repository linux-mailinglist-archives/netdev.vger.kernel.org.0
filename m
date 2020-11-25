Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1882C3531
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgKYAFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgKYAFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 19:05:03 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D2402145D;
        Wed, 25 Nov 2020 00:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606262702;
        bh=GDphglMR0qfjZO1dfIE2YnPKz9gS3qOrfYOsru8FUhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YrBNIFMqnNBwu4pCNCxJskuZGTA2odbT39OkTCerJV83vy0+/MIM+DqcQV0oh9n4y
         V6mgh4ORxROaMur1RLeCeBGgHC0Ufq32DatIaGiBOUXoNdWq05dnG6jM1Euh5zpNEn
         tmlV0Z6ucR+4L+4p/J6M3TC0DLb4C1PxUCFlvCn8=
Date:   Tue, 24 Nov 2020 16:05:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Po Liu <po.liu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH net] enetc: Advance the taprio base time in the future
Message-ID: <20201124160501.514f3be5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124210003.kyzqkaudfjl7q3dw@skbuf>
References: <20201124012005.2442293-1-vladimir.oltean@nxp.com>
        <VE1PR04MB64967D95BBDB594A286C139A92FB0@VE1PR04MB6496.eurprd04.prod.outlook.com>
        <20201124095812.539b9d1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201124210003.kyzqkaudfjl7q3dw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 21:00:04 +0000 Vladimir Oltean wrote:
> On Tue, Nov 24, 2020 at 09:58:12AM -0800, Jakub Kicinski wrote:
> > > This is the right way for calculation. For the ENETC,  hardware also
> > > do the same calculation before send to Operation State Machine.
> > > For some TSN IP, like Felix and DesignWare TSN in RT1170 and IMX8MP
> > > require the basetime limite the range not less than the current time
> > > 8 cycles, software may do calculation before setting to the
> > > hardware.
> > > Actually, I do suggest this calculation to sch_taprio.c, but I found
> > > same calculation only for the TXTIME by taprio_get_start_time().
> > > Which means:
> > > If (currenttime < basetime)
> > >        Admin_basetime = basetime;
> > > Else
> > >        Admin_basetime =  basetime + (n+1)* cycletime;
> > > N is the minimal value which make Admin_basetime is larger than the
> > > currenttime.
> > >
> > > User space never to get the current time. Just set a value as offset
> > > OR future time user want.
> > > For example: set basetime = 1000000ns, means he want time align to
> > > 1000000ns, and on the other device, also set the basetime =
> > > 1000000ns, then the two devices are aligned cycle.
> > > If user want all the devices start at 11.24.2020 11:00 then set
> > > basetime = 1606273200.0 s.
> > >  
> > > > - the sja1105 offload does it via future_base_time()
> > > > - the ocelot/felix offload does it via vsc9959_new_base_time()
> > > >
> > > > As for the obvious question: doesn't the hardware just "do the right thing"
> > > > if passed a time in the past? I've tested and it doesn't look like it. I cannot  
> > >
> > > So hardware already do calculation same way.  
> >
> > So the patch is unnecessary? Or correct? Not sure what you're saying..  
> 
> He's not saying the patch is unnecessary. What the enetc driver
> currently does for the case where the base_time is zero is bogus anyway.
> 
> What Po is saying is that calling future_base_time() should not be
> needed. Instead, he is suggesting we could program directly the
> admin_conf->base_time into the hardware, which will do the right thing
> as long as the driver doesn't mangle it in various ways, such as replace
> the base_time with the current time.
> 
> And what I said in the commit message is that I've been there before and
> there were some still apparent issues with the schedule's phase. I had
> some issues at the application layer as well. In the meantime I sorted
> those out, and after re-applying the simple kernel change and giving the
> system some thorough testing, it looks like Po is right.

Thanks for explaining!
