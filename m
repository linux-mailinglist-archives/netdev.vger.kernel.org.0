Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FEA33E10E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhCPWCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:02:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:30805 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhCPWCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:02:13 -0400
IronPort-SDR: HbnErv9BgFkP0FWhpHeLqTId+ofZrsgrjR91Gog72z3BGGHhHzCLSWONMh4zWhYwsHJkT1IUkQ
 FUzfqqkbsv2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="168612690"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="168612690"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 15:02:13 -0700
IronPort-SDR: H5Hp5Ovw/lWsX+qmQ2QAHc18aEgxbnXR7LybT2VWkNtoOS0SmbC020Mkd4DcXcI4VnZH0aNDP8
 dntYeElcZ7hw==
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="449865416"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.254.107.179])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 15:02:10 -0700
Date:   Tue, 16 Mar 2021 15:02:10 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stefan Assmann <sassmann@kpanic.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, lihong.yang@intel.com,
        slawomirx.laba@intel.com, nicholas.d.nunley@intel.com
Subject: Re: [PATCH] iavf: fix locking of critical sections
Message-ID: <20210316150210.00007249@intel.com>
In-Reply-To: <20210316132905.5d0f90dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210316100141.53551-1-sassmann@kpanic.de>
        <20210316101443.56b87cf6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <44b3f5f0-93f8-29e2-ab21-5fd7cc14c755@kpanic.de>
        <20210316132905.5d0f90dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> > > I personally think that the overuse of flags in Intel drivers brings
> > > nothing but trouble. At which point does it make sense to just add a
> > > lock / semaphore here rather than open code all this with no clear
> > > semantics? No code seems to just test the __IAVF_IN_CRITICAL_TASK flag,
> > > all the uses look like poor man's locking at a quick grep. What am I
> > > missing?
> > 
> > I agree with you that the locking could be done with other locking
> > mechanisms just as good. I didn't invent the current method so I'll let
> > Intel comment on that part, but I'd like to point out that what I'm
> > making use of is fixing what is currently in the driver.
> 
> Right, I should have made it clear that I don't blame you for the
> current state of things. Would you mind sending a patch on top of 
> this one to do a conversion to a semaphore? 
> 
> Intel folks any opinions?

I know Slawomir has been working closely with Stefan on figuring out
the right ways to fix this code.  Hopefully he can speak for himself,
but I know he's on Europe time.

As for conversion to mutexes I'm a big fan, and as long as we don't
have too many collisions with the RTNL lock I think it's a reasonable
improvement to do, and if Stefan doesn't want to work on it, we can
look into whether Slawomir or his team can.

