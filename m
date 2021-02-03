Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2581530E294
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhBCSde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhBCSdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 13:33:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B68C64DE1;
        Wed,  3 Feb 2021 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612377163;
        bh=nrnoJq4oxf/9OcwkqRDmZyznVXAdwNJp4vEfxmlzWSc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hqNUNgFP4sttZcI+RC1TauBOb1oF6JVmOpKfyRk4ZLpDDOIkv15LiAxn+Y4UbfVSM
         8fq2FHo4ZDmwj24XSjn873w+sOit5/CwXm2k6v9m89o8S/mI3VvhYo1xblbbuNzUgi
         VSRCriLVKtKLW4IS9veR+hA3yYVFT08xPczZ1rv0iedUPC2JyQowO5DMtj/Ny1Bs43
         EJtimxE9Z+EJSYASIF9nPGiMuUqTu0KgFX+vOEM5MXc0Yes5s6B6Y7PDlKEbyapG1e
         eHbERKsEZw/rf26DWPNmusQz1AX5deh9GFDDGfWdKMifX84lNg5hQefjAFJXqNTraw
         JRxwdCTuMG4tw==
Date:   Wed, 3 Feb 2021 10:32:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
Subject: Re: [PATCH net-next 5/6] i40e: Add info trace at loading XDP
 program
Message-ID: <20210203103241.7e86ca2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM6PR11MB4657968657193183F2082BC79BB49@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
        <20210202022420.1328397-6-anthony.l.nguyen@intel.com>
        <DM6PR11MB4657968657193183F2082BC79BB49@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 10:00:07 +0000 Kubalewski, Arkadiusz wrote:
> >> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> >> index 521ea9df38d5..f35bd9164106 100644
> >> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> >> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> >> @@ -12489,11 +12489,14 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
> >>  	/* Kick start the NAPI context if there is an AF_XDP socket open
> >>  	 * on that queue id. This so that receiving will start.
> >>  	 */
> >> -	if (need_reset && prog)
> >> +	if (need_reset && prog) {
> >> +		dev_info(&pf->pdev->dev,
> >> +			 "Loading XDP program, please note: XDP_REDIRECT action requires the same number of queues on both interfaces\n");  
> >
> >We try to avoid spamming logs. This message will be helpful to users
> >only the first time, if at all.  
> 
> You are probably right, it would look like a spam to the one who is
> continuously loading and unloading the XDP programs.
> But still, want to remain as much user friendly as possible.
> Will use dev_info_once(...) instead.

Not exactly what I meant, I meant that it's only marginally useful the
first time the user sees it. Not first time since boot.

The two options that I think could be better are:
 - work on improving the interfaces in terms of IRQ/queue config and
   capabilities so the user is not confused in the first place;
 - detect that the configuration is in fact problematic 
   (IOW #Qs < #CPUs) and setting extack. If you set the extact and
   return 0 / success the extact will show as "Warning: " in iproute2
   output.
