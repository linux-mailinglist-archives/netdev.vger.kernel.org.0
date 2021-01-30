Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1450430977F
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 19:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhA3SNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 13:13:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhA3SN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 13:13:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B57CF64E05;
        Sat, 30 Jan 2021 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612030369;
        bh=3tXJXuztwk1NC+mEWJBkzVI5F6y6vuF5kdnSsisrCNk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D+rJZfwShyobR5ey11lskRcQ/KQXgPcAJGQVt8n/mwcpTtrqX/6xW7NZ8ChtxceOw
         t/KNKX7zNYee2bamyaf25n8QN+/9+ojkzU4egi+2B1dXGMGFKbe91dt4IxjPpv89Jm
         BrRA4VsniSIKXImtKK6jfDurPK2TcKMgJCsY47Jc50mT2tSuwtvYtI1X9rEbK7ZWpl
         2aKsacg2lEAerls2ct1M15ynPA6yANcYC+c38wUTZu9oGixQ9zjPPb26WAluMJ3A9E
         L7kIyQ1HLQSfUPXEHcPLAdJItdHQF9Ux9RM3kQ+0NHFLR6zJ++x97sYrc/RtnS5LRD
         FNJmonAWQLXlw==
Date:   Sat, 30 Jan 2021 10:12:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
Subject: Re: [PATCH net 1/4] igc: Report speed and duplex as unknown when
 device is runtime suspended
Message-ID: <20210130101247.41592be3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <107f90ab-0466-67e8-8cc5-7ac79513f939@intel.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
        <20210128213851.2499012-2-anthony.l.nguyen@intel.com>
        <20210129222255.5e7115bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <107f90ab-0466-67e8-8cc5-7ac79513f939@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jan 2021 16:00:06 +0200 Neftin, Sasha wrote:
> On 1/30/2021 08:22, Jakub Kicinski wrote:
> > On Thu, 28 Jan 2021 13:38:48 -0800 Tony Nguyen wrote:  
> >> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> >>
> >> Similar to commit 165ae7a8feb5 ("igb: Report speed and duplex as unknown
> >> when device is runtime suspended"), if we try to read speed and duplex
> >> sysfs while the device is runtime suspended, igc will complain and
> >> stops working:  
> >   
> >> The more generic approach will be wrap get_link_ksettings() with begin()
> >> and complete() callbacks, and calls runtime resume and runtime suspend
> >> routine respectively. However, igc is like igb, runtime resume routine
> >> uses rtnl_lock() which upper ethtool layer also uses.
> >>
> >> So to prevent a deadlock on rtnl, take a different approach, use
> >> pm_runtime_suspended() to avoid reading register while device is runtime
> >> suspended.  
> > 
> > Is someone working on the full fix to how PM operates?
> > 
> > There is another rd32(IGC_STATUS) in this file which I don't think
> > is protected either.  
>
> What is another rd32(IGC_STATUS) you meant? in  igc_ethtool_get_regs? 

Yes.

> While the device in D3 state there is no configuration space registers 
> access.

That's to say similar stack trace will be generated to the one fixed
here, if someone runs ethtool -d, correct? I don't see anything
checking runtime there either.

To be clear I'm not asking for this to be addressed in this series.
Rather for a strong commitment that PM handling will be restructured.
It seems to me you should depend on refcounting / locking that the PM
subsystem does more rather than involving rtnl_lock.
