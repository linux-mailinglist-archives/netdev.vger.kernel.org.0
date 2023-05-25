Return-Path: <netdev+bounces-5290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED96710999
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4913E281518
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E2FE564;
	Thu, 25 May 2023 10:12:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F423AE560
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:12:15 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FE51B1;
	Thu, 25 May 2023 03:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685009522; x=1716545522;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=N/zwrSVypYR69GoZqPE+SbIhxpOv+B6QByyWYEs768E=;
  b=ilJ1+XzFjHnlOrV0x8DWRKcoNnbkuh3EgV+pLe/6Leqe9Mb+GZkJxaca
   NAnjT3/oLwrVH+hbB0dIfGWBCbUIQJN4x2Ep8BeydXW6eDM2y4I61/uwH
   TbyL3zYTm5WSWDx3y7035arwab5+BTuuhY2yT6as1XEQuNapUeXjoAAsQ
   lExkOKaDi0CXPTqoAjwOgc4qnP3Q6FIiv269YBuaLeQ4lNpH0hYbmnTwg
   pM1nLy2oJWlsXefRiGLj2Xum/6+Ba4JlR/hBcnPTQohNH3MhUg1c8Fd8S
   pPB84aOx3kf3OezJkxHVBZrrk8toFZDdoxVYyVpLmw4hJpwf92q//y25D
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="334194535"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="334194535"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 03:12:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="655164459"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="655164459"
Received: from aghiriba-mobl.ger.corp.intel.com ([10.249.40.17])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 03:11:54 -0700
Date: Thu, 25 May 2023 13:11:51 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Bjorn Helgaas <helgaas@kernel.org>
cc: linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, 
    Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, 
    Rob Herring <robh@kernel.org>, 
    =?ISO-8859-2?Q?Krzysztof_Wilczy=F1ski?= <kw@linux.com>, 
    Emmanuel Grumbach <emmanuel.grumbach@intel.com>, 
    "Rafael J . Wysocki" <rafael@kernel.org>, 
    Heiner Kallweit <hkallweit1@gmail.com>, Lukas Wunner <lukas@wunner.de>, 
    Kalle Valo <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, Michal Kazior <michal.kazior@tieto.com>, 
    Janusz Dziedzic <janusz.dziedzic@tieto.com>, ath10k@lists.infradead.org, 
    linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>, 
    LKML <linux-kernel@vger.kernel.org>, 
    Dean Luick <dean.luick@cornelisnetworks.com>, 
    Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
    stable@vger.kernel.org
Subject: Re: [PATCH v2 9/9] wifi: ath10k: Use RMW accessors for changing
 LNKCTL
In-Reply-To: <ZG4o/pYseBklnrTc@bhelgaas>
Message-ID: <ecdc8e85-786-db97-a7d4-bfd82c08714@linux.intel.com>
References: <ZG4o/pYseBklnrTc@bhelgaas>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1525169391-1685006896=:1738"
Content-ID: <e7b32c4d-e7b9-c81d-670-b54285b6b554@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1525169391-1685006896=:1738
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <5114585-6ccd-c09a-416-a53bb2256299@linux.intel.com>

On Wed, 24 May 2023, Bjorn Helgaas wrote:

> On Wed, May 17, 2023 at 01:52:35PM +0300, Ilpo Järvinen wrote:
> > Don't assume that only the driver would be accessing LNKCTL. ASPM
> > policy changes can trigger write to LNKCTL outside of driver's control.
> > 
> > Use RMW capability accessors which does proper locking to avoid losing
> > concurrent updates to the register value. On restore, clear the ASPMC
> > field properly.
> > 
> > Fixes: 76d870ed09ab ("ath10k: enable ASPM")
> > Suggested-by: Lukas Wunner <lukas@wunner.de>
> > Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/net/wireless/ath/ath10k/pci.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> > index a7f44f6335fb..9275a672f90c 100644
> > --- a/drivers/net/wireless/ath/ath10k/pci.c
> > +++ b/drivers/net/wireless/ath/ath10k/pci.c
> > @@ -1963,8 +1963,9 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
> >  	ath10k_pci_irq_enable(ar);
> >  	ath10k_pci_rx_post(ar);
> >  
> > -	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> > -				   ar_pci->link_ctl);
> > +	pcie_capability_clear_and_set_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> > +					   PCI_EXP_LNKCTL_ASPMC,
> > +					   ar_pci->link_ctl & PCI_EXP_LNKCTL_ASPMC);
> >  
> >  	return 0;
> >  }
> > @@ -2821,8 +2822,8 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar,
> >  
> >  	pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> >  				  &ar_pci->link_ctl);
> > -	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> > -				   ar_pci->link_ctl & ~PCI_EXP_LNKCTL_ASPMC);
> > +	pcie_capability_clear_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> > +				   PCI_EXP_LNKCTL_ASPMC);
> 
> These ath drivers all have the form:
> 
>   1) read LNKCTL
>   2) save LNKCTL value in ->link_ctl
>   3) write LNKCTL with "->link_ctl & ~PCI_EXP_LNKCTL_ASPMC"
>      to disable ASPM
>   4) write LNKCTL with ->link_ctl, presumably to re-enable ASPM
> 
> These patches close the hole between 1) and 3) where other LNKCTL
> updates could interfere, which is definitely a good thing.
> 
> But the hole between 1) and 4) is much bigger and still there.  Any
> update by the PCI core in that interval would be lost.

Any update to PCI_EXP_LNKCTL_ASPMC field in that interval is lost yes, the 
updates to _the other fields_ in LNKCTL are not lost.

I know this might result in drivers/pci/pcie/aspm.c disagreeing what
the state of the ASPM is (as shown under sysfs) compared with LNKCTL 
value but the cause can no longer be due racing RMW. Essentially, 4) is 
seen as an override to what core did if it changed ASPMC in between. 
Technically, something is still "lost" like you say but for a different 
reason than this series is trying to fix.

> Straw-man proposal:
> 
>   - Change pci_disable_link_state() so it ignores aspm_disabled and
>     always disables ASPM even if platform firmware hasn't granted
>     ownership.  Maybe this should warn and taint the kernel.
> 
>   - Change drivers to use pci_disable_link_state() instead of writing
>     LNKCTL directly.

I fully agree that's the direction we should be moving, yes. However, I'm 
a bit hesitant to take that leap in one step. These drivers currently not 
only disable ASPM but also re-enable it (assuming we guessed the intent
right).

If I directly implement that proposal, ASPM is not going to be re-enabled 
when PCI core does not allowing it. Could it cause some power related 
regression?

My plan is to make another patch series after these to realize exactly 
what you're proposing. It would allow better to isolate the problems that 
related to the lack of ASPM.

I hope this two step approach is an acceptable way forward? I can of 
course add those patches on top of these if that would be preferrable.


-- 
 i.
--8323329-1525169391-1685006896=:1738--

