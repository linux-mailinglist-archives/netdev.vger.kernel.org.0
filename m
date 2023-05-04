Return-Path: <netdev+bounces-474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E98986F78F3
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 00:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0B1B280E65
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67196C155;
	Thu,  4 May 2023 22:20:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB377C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 22:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8DEC433EF;
	Thu,  4 May 2023 22:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683238850;
	bh=rwx7iUdSi9ZJ936Oee+tnrMgzVQXpxJNfSPrASIpy3Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=YKsUVpu0ptYjRBovoU/uOo2fA0BLiAZ1A+MBoqqjLC4c5AS7LeMY8bwZEN8loP+Gs
	 32n4NOnIJBMoV5gKsEAkVHH0nJiXS1gPKnCxotZljfqR1V4u4dNPWyAWtx8U0yfbCT
	 SXACPyg87+6r2MlTf67MfYt+OvW2G2HHVFp3SnMXecSyCAEHHBTsJrSqfGym4NDomP
	 DMk3EPIfkqNi9tsmpRaccspQfjuesw8vkZMyprA6GPQvMtpC8eQpyHfbZysO7RoPlU
	 xIdDEW6wAuoObJ8PfmRChxOfCuTrKWbAgYzUDSL4n2lAZB9iu7OBv8SWzhKNMd8m7j
	 3LCQ1rhIJRL5w==
Date: Thu, 4 May 2023 17:20:48 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Oliver O'Halloran <oohall@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>,
	David Abdurachmanov <david.abdurachmanov@gmail.com>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
	linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 7/7] PCI: Work around PCIe link training failures
Message-ID: <20230504222048.GA887151@bhelgaas>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2304060116380.13659@angie.orcam.me.uk>

On Thu, Apr 06, 2023 at 01:21:31AM +0100, Maciej W. Rozycki wrote:
> Attempt to handle cases such as with a downstream port of the ASMedia 
> ASM2824 PCIe switch where link training never completes and the link 
> continues switching between speeds indefinitely with the data link layer 
> never reaching the active state.

We're going to land this series this cycle, come hell or high water.

We talked about reusing pcie_retrain_link() earlier.  IIRC that didn't
work: ASPM needs to use PCI_EXP_LNKSTA_LT because not all devices
support PCI_EXP_LNKSTA_DLLLA, and you need PCI_EXP_LNKSTA_DLLLA
because the erratum makes PCI_EXP_LNKSTA_LT flap.

What if we made pcie_retrain_link() reusable by making it:

  bool pcie_retrain_link(struct pci_dev *pdev, u16 link_status_bit)

so ASPM could use pcie_retrain_link(link->pdev, PCI_EXP_LNKSTA_LT) and
you could use pcie_retrain_link(dev, PCI_EXP_LNKSTA_DLLLA)?

Maybe do it two steps?

  1) Move pcie_retrain_link() just after pcie_wait_for_link() and make
  it take link->pdev instead of link.

  2) Add the bit parameter.

I'm OK with having pcie_retrain_link() in pci.c, but the surrounding
logic about restricting to 2.5GT/s, retraining, removing the
restriction, retraining again is stuff I'd rather have in quirks.c so
it doesn't clutter pci.c.

I think it'd be good if the pci_device_add() path made clear that this
is a workaround for a problem, e.g.,

  void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
  {
    ...
    if (pcie_link_failed(dev))
      pcie_fix_link_train(dev);

where pcie_fix_link_train() could live in quirks.c (with a stub when
CONFIG_PCI_QUIRKS isn't enabled).  It *might* even be worth adding it
and the stub first because that's a trivial patch and wouldn't clutter
the probe.c git history with all the grotty details about ASM2824 and
this topology.

> +int pcie_downstream_link_retrain(struct pci_dev *dev)
> +{
> +	static const struct pci_device_id ids[] = {
> +		{ PCI_VDEVICE(ASMEDIA, 0x2824) }, /* ASMedia ASM2824 */
> +		{}
> +	};
> +	u16 lnksta, lnkctl2;
> +
> +	if (!pci_is_pcie(dev) || !pcie_downstream_port(dev) ||
> +	    !pcie_cap_has_lnkctl2(dev) || !dev->link_active_reporting)
> +		return -1;
> +
> +	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
> +	pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
> +	if ((lnksta & (PCI_EXP_LNKSTA_LBMS | PCI_EXP_LNKSTA_DLLLA)) ==
> +	    PCI_EXP_LNKSTA_LBMS) {

You go to some trouble to make sure PCI_EXP_LNKSTA_LBMS is set, and I
can't remember what the reason is.  If you make a preparatory patch
like this, it would give a place for that background, e.g.,

  +bool pcie_link_failed(struct pci_dev *dev)
  +{
  +       u16 lnksta;
  +
  +       if (!pci_is_pcie(dev) || !pcie_downstream_port(dev) ||
  +           !pcie_cap_has_lnkctl2(dev) || !dev->link_active_reporting)
  +               return false;
  +
  +       pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
  +       if ((lnksta & (PCI_EXP_LNKSTA_LBMS | PCI_EXP_LNKSTA_DLLLA)) ==
  +                       PCI_EXP_LNKSTA_LBMS)
  +               return true;
  +
  +       return false;
  +}

If this is a generic thing and checking PCI_EXP_LNKSTA_LBMS makes
sense for everybody, it could go in pci.c; otherwise it could go in
quirks.c as well.  I guess it's not *truly* generic anyway because it
only detects link training failures for devices that have LNKCTL2 and
link_active_reporting.

> +		unsigned long timeout;
> +		u16 lnkctl;
> +
> +		pci_info(dev, "broken device, retraining non-functional downstream link at 2.5GT/s\n");
> +
> +		pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &lnkctl);
> +		lnkctl |= PCI_EXP_LNKCTL_RL;
> +		lnkctl2 &= ~PCI_EXP_LNKCTL2_TLS;
> +		lnkctl2 |= PCI_EXP_LNKCTL2_TLS_2_5GT;
> +		pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
> +		pcie_capability_write_word(dev, PCI_EXP_LNKCTL, lnkctl);
> +		/*
> +		 * Due to an erratum in some devices the Retrain Link bit
> +		 * needs to be cleared again manually to allow the link
> +		 * training to succeed.
> +		 */
> +		lnkctl &= ~PCI_EXP_LNKCTL_RL;
> +		if (dev->clear_retrain_link)
> +			pcie_capability_write_word(dev, PCI_EXP_LNKCTL,
> +						   lnkctl);
> +
> +		timeout = jiffies + PCIE_LINK_RETRAIN_TIMEOUT;
> +		do {
> +			pcie_capability_read_word(dev, PCI_EXP_LNKSTA,
> +					     &lnksta);
> +			if (lnksta & PCI_EXP_LNKSTA_DLLLA)
> +				break;
> +			usleep_range(10000, 20000);
> +		} while (time_before(jiffies, timeout));
> +
> +		if (!(lnksta & PCI_EXP_LNKSTA_DLLLA)) {
> +			pci_info(dev, "retraining failed\n");
> +			return -1;
> +		}
> +	}

> +	if (IS_ENABLED(CONFIG_PCI_QUIRKS) && (lnksta & PCI_EXP_LNKSTA_DLLLA) &&
> +	    (lnkctl2 & PCI_EXP_LNKCTL2_TLS) == PCI_EXP_LNKCTL2_TLS_2_5GT &&
> +	    pci_match_id(ids, dev)) {
> +		u32 lnkcap;
> +		u16 lnkctl;
> +
> +		pci_info(dev, "removing 2.5GT/s downstream link speed restriction\n");
> +		pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnkcap);
> +		pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &lnkctl);
> +		lnkctl |= PCI_EXP_LNKCTL_RL;
> +		lnkctl2 &= ~PCI_EXP_LNKCTL2_TLS;
> +		lnkctl2 |= lnkcap & PCI_EXP_LNKCAP_SLS;
> +		pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
> +		pcie_capability_write_word(dev, PCI_EXP_LNKCTL, lnkctl);

This starts a retrain; should we wait for training to complete?

> +	}

If we put most of this into a pcie_fix_link_train() (separated from
detecting the *need* to fix something), could it be made to look
sort of like this?  (I suppose you'd want to return bool and rename
it that reads naturally, e.g., "pcie_link_forcibly_retrained()",
"pcie_link_retrained()", etc)

  +void pcie_fix_link_train(struct pci_dev *dev)
  +{
  +       u16 lnkctl2;
  +       u32 lnkcap;
  +       bool linkup;
  +
  +       pci_info(dev, "attempting link retrain at 2.5GT/s\n");
  +       pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
  +       lnkctl2 &= ~PCI_EXP_LNKCTL2_TLS;
  +       lnkctl2 |= PCI_EXP_LNKCTL2_TLS_2_5GT;
  +       pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
  +
  +       linkup = pcie_retrain_link(dev, PCI_EXP_LNKSTA_DLLLA);
  +       if (!linkup) {
  +               pci_info(dev, "retraining failed\n");
  +               return;
  +       }
  +
  +       if (LNKCAP supports only 2.5GT/s)
  +               return;
  +
  +       if (!pci_match_id(ids, dev))
  +               return;

Your comment said "if we know this is *safe*"; I can't remember if
pci_match_id() is there to avoid a known problem?

  +
  +       pci_info(dev, "attempting link retrain at max supported rate\n");
  +       pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnkcap);
  +       lnkctl2 &= ~PCI_EXP_LNKCTL2_TLS;
  +       lnkctl2 |= lnkcap & PCI_EXP_LNKCAP_SLS;
  +       pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
  +
  +       linkup = pcie_retrain_link(dev, PCI_EXP_LNKSTA_DLLLA);
  +       if (!linkup)
  +               pci_info(dev, "retraining failed\n");
  +}

> +
> +	return 0;
> +}
> +
> +/* Same as above, but called for a downstream device.  */
> +static int pcie_upstream_link_retrain(struct pci_dev *dev)
> +{
> +	struct pci_dev *bridge;
> +
> +	bridge = pci_upstream_bridge(dev);
> +	if (bridge)
> +		return pcie_downstream_link_retrain(bridge);
> +	else
> +		return -1;
> +}
> +
>  static int pci_acs_enable;
>  
>  /**
> @@ -1148,8 +1274,8 @@ void pci_resume_bus(struct pci_bus *bus)
>  
>  static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
>  {
> +	int retrain = 0;
>  	int delay = 1;
> -	u32 id;
>  
>  	/*
>  	 * After reset, the device should not silently discard config
> @@ -1163,21 +1289,37 @@ static int pci_dev_wait(struct pci_dev *
>  	 * Command register instead of Vendor ID so we don't have to
>  	 * contend with the CRS SV value.
>  	 */
> -	pci_read_config_dword(dev, PCI_COMMAND, &id);
> -	while (PCI_POSSIBLE_ERROR(id)) {
> +	for (;;) {
> +		u32 id;
> +
> +		pci_read_config_dword(dev, PCI_COMMAND, &id);
> +		if (!PCI_POSSIBLE_ERROR(id)) {
> +			if (delay > PCI_RESET_WAIT)
> +				pci_info(dev, "ready %dms after %s\n",
> +					 delay - 1, reset_type);
> +			break;
> +		}
> +
>  		if (delay > timeout) {
>  			pci_warn(dev, "not ready %dms after %s; giving up\n",
>  				 delay - 1, reset_type);
>  			return -ENOTTY;
>  		}
>  
> -		if (delay > PCI_RESET_WAIT)
> +		if (delay > PCI_RESET_WAIT) {
> +			if (!retrain) {
> +				retrain = 1;
> +				if (pcie_upstream_link_retrain(dev) == 0) {
> +					delay = 1;
> +					continue;
> +				}
> +			}
>  			pci_info(dev, "not ready %dms after %s; waiting\n",
>  				 delay - 1, reset_type);
> +		}

Thanks for fixing this in the reset path, too.  Can we move this part
to a separate patch?  It's related to the rest of the patch, but it
looks so much different that I think it would be easier to understand
by itself.

I think I might try to fold the pcie_upstream_link_retrain() directly
in here because the "upstream link retrain" in the function name
doesn't really make sense in PCIe terms.

Bjorn

