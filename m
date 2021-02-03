Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D7530E42F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhBCUmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhBCUlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 15:41:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47DCC64F58;
        Wed,  3 Feb 2021 20:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612384874;
        bh=Pp/Dsui41S4wztlxsyQaknm4HrYNoFUyHkzlHBNU0i8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nBdZfTN2H85ynzcRdccShtUzxTV8f2DjWjEkOk12pykR2TM3FCyUUzDVxvmx3GTFD
         z78gTs2bJl8/JMsoqPTZ696dZ9+LmPA8AIkzJLXOfJPkREEI94hznIfiUj7s18cjRO
         RxeeLzy9Z1B0n/UDmAU9Qd0l4nN/pdcPbGJiaoPL04DbwH1enMVuLB86f37wNz4gGx
         vIEl0tYSZmuwx9+Sp8n2qbh4soMl2K7KU+hGRYTmjswMaPdz7VFrNJ0tMnUO/rwCdS
         p0EWocVPB2OSL32pmaCE4xt8mjQaEdYueb1SvdEz7GVCrQtFQtOL4g1TO4ugQ1ghiu
         g/v/rQ4Yc60QA==
Date:   Wed, 3 Feb 2021 12:41:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 04/15] ice: add devlink parameters to read and
 write minimum security revision
Message-ID: <20210203124112.67a1e1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129004332.3004826-5-anthony.l.nguyen@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
        <20210129004332.3004826-5-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 16:43:21 -0800 Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The ice NVM flash has a security revision field for the main NVM bank
> and the Option ROM bank. In addition to the revision within the module,
> the device also has a minimum security revision TLV area. This minimum
> security revision field indicates the minimum value that will be
> accepted for the associated security revision when loading the NVM bank.
> 
> Add functions to read and update the minimum security revisions. Use
> these functions to implement devlink parameters, "fw.undi.minsrev" and
> "fw.mgmt.minsrev".
> 
> These parameters are permanent (i.e. stored in flash), and are used to
> indicate the minimum security revision of the associated NVM bank. If
> the image in the bank has a lower security revision, then the flash
> loader will not continue loading that flash bank.
> 
> The new parameters allow for opting in to update the minimum security
> revision to ensure that a flash image with a known security flaw cannot
> be loaded.
> 
> Note that the minimum security revision cannot be reduced, only
> increased. The driver also refuses to allow an update if the currently
> active image revision is lower than the requested value. This is done to
> avoid potentially updating the value such that the device can no longer
> start.

Hi Jake, I had a couple of conversations with people from operations
and I'm struggling to find interest in writing this parameter. 

It seems like the expectation is that the min sec revision will go up
automatically after a new firmware with a higher number is flashed.

Do you have a user scenario where the manual bumping is needed?
