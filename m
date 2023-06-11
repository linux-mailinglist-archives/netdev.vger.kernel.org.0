Return-Path: <netdev+bounces-9922-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C69872B2F4
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D8941C209C4
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF451C8F9;
	Sun, 11 Jun 2023 17:14:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD7EC2E4
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:14:21 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A13CE9;
	Sun, 11 Jun 2023 10:14:18 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 2EE2992009C; Sun, 11 Jun 2023 19:14:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 202D892009B;
	Sun, 11 Jun 2023 18:14:16 +0100 (BST)
Date: Sun, 11 Jun 2023 18:14:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Bjorn Helgaas <helgaas@kernel.org>
cc: Bjorn Helgaas <bhelgaas@google.com>, 
    Mahesh J Salgaonkar <mahesh@linux.ibm.com>, 
    Oliver O'Halloran <oohall@gmail.com>, 
    Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
    Christophe Leroy <christophe.leroy@csgroup.eu>, 
    Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
    "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, 
    Alex Williamson <alex.williamson@redhat.com>, 
    Lukas Wunner <lukas@wunner.de>, 
    Mika Westerberg <mika.westerberg@linux.intel.com>, 
    Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>, 
    David Abdurachmanov <david.abdurachmanov@gmail.com>, 
    =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, linux-pci@vger.kernel.org, 
    linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 7/7] PCI: Work around PCIe link training failures
In-Reply-To: <20230504222048.GA887151@bhelgaas>
Message-ID: <alpine.DEB.2.21.2306080224280.36323@angie.orcam.me.uk>
References: <20230504222048.GA887151@bhelgaas>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 4 May 2023, Bjorn Helgaas wrote:

> We talked about reusing pcie_retrain_link() earlier.  IIRC that didn't
> work: ASPM needs to use PCI_EXP_LNKSTA_LT because not all devices
> support PCI_EXP_LNKSTA_DLLLA, and you need PCI_EXP_LNKSTA_DLLLA
> because the erratum makes PCI_EXP_LNKSTA_LT flap.
> 
> What if we made pcie_retrain_link() reusable by making it:
> 
>   bool pcie_retrain_link(struct pci_dev *pdev, u16 link_status_bit)
> 
> so ASPM could use pcie_retrain_link(link->pdev, PCI_EXP_LNKSTA_LT) and
> you could use pcie_retrain_link(dev, PCI_EXP_LNKSTA_DLLLA)?

 This is somewhat more complicated, because of the inverted logic between 
the two status bits.  Therefore I think a boolean flag is more adequate 
with preparatory logic within the function itself.  This will tighten the 
call interface as well.

> Maybe do it two steps?
> 
>   1) Move pcie_retrain_link() just after pcie_wait_for_link() and make
>   it take link->pdev instead of link.
> 
>   2) Add the bit parameter.

 Having compared the two pieces side by side now I think it makes sense.  
While there are minor differences, most prominently the original code is 
more aggressive than mine in polling the status bit, I think these details 
are not significant enough to argue over them here.  And we can consider 
switching to more modern `usleep_range' interface separately.

 A minor pessimisation resulting is that LNKSTA has to be reread in the 
caller after return from `pcie_retrain_link'; previously the last value 
read in the poll loop could have been reused.

> I'm OK with having pcie_retrain_link() in pci.c, but the surrounding
> logic about restricting to 2.5GT/s, retraining, removing the
> restriction, retraining again is stuff I'd rather have in quirks.c so
> it doesn't clutter pci.c.

 Well, it was there in quirks.c originally and I only moved this piece 
following your earlier suggestion:

> If we think the first part (attempting the retrain) is safe to do
> whenever the link is down, maybe we should do that more directly as
> part of the PCI core instead of as a quirk?

as in here: <https://lore.kernel.org/r/20221109050418.GA529724@bhelgaas/>, 
though if you did change your mind after all, I can move it back, sure.  
It's not always that the first thought is the best, or sometimes good at 
all.

> I think it'd be good if the pci_device_add() path made clear that this
> is a workaround for a problem, e.g.,
> 
>   void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>   {
>     ...
>     if (pcie_link_failed(dev))
>       pcie_fix_link_train(dev);
> 
> where pcie_fix_link_train() could live in quirks.c (with a stub when
> CONFIG_PCI_QUIRKS isn't enabled).  It *might* even be worth adding it
> and the stub first because that's a trivial patch and wouldn't clutter
> the probe.c git history with all the grotty details about ASM2824 and
> this topology.

 I have added a stub now, both as an intermediate step and ultimately for 
!PCI_QUIRKS, but I disagree about having the check in pci.c and the fix in 
quirks.c, because from the code structure's point of view it makes no 
sense IMHO to have the check enabled and the fix disabled both at a time 
for !PCI_QUIRKS, even if the compiler would actually optimise the check 
away in that case.

 Please let me know if you maintain your suggestion and if so, then why 
you find it so important.  I think with the use of `pcie_retrain_link' 
this code has become straightforward enough not to need to be split or 
factored out any further (and while factoring out the conditionals only 
would make some sense to me, it would require duplicating configuration 
register accesses even further).

> > +int pcie_downstream_link_retrain(struct pci_dev *dev)
> > +{
> > +	static const struct pci_device_id ids[] = {
> > +		{ PCI_VDEVICE(ASMEDIA, 0x2824) }, /* ASMedia ASM2824 */
> > +		{}
> > +	};
> > +	u16 lnksta, lnkctl2;
> > +
> > +	if (!pci_is_pcie(dev) || !pcie_downstream_port(dev) ||
> > +	    !pcie_cap_has_lnkctl2(dev) || !dev->link_active_reporting)
> > +		return -1;
> > +
> > +	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
> > +	pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
> > +	if ((lnksta & (PCI_EXP_LNKSTA_LBMS | PCI_EXP_LNKSTA_DLLLA)) ==
> > +	    PCI_EXP_LNKSTA_LBMS) {
> 
> You go to some trouble to make sure PCI_EXP_LNKSTA_LBMS is set, and I
> can't remember what the reason is.  If you make a preparatory patch
> like this, it would give a place for that background, e.g.,

 It has been already documented along with the code in question:

 * With the ASM2824 we can rely on the otherwise optional Data Link Layer
 * Link Active status bit and in the failed link training scenario it will
 * be off along with the Link Bandwidth Management Status indicating that
 * hardware has changed the link speed or width in an attempt to correct
 * unreliable link operation.  For a port that has been left unconnected
 * both bits will be clear.  [...]

>   +bool pcie_link_failed(struct pci_dev *dev)
>   +{
>   +       u16 lnksta;
>   +
>   +       if (!pci_is_pcie(dev) || !pcie_downstream_port(dev) ||
>   +           !pcie_cap_has_lnkctl2(dev) || !dev->link_active_reporting)
>   +               return false;
>   +
>   +       pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
>   +       if ((lnksta & (PCI_EXP_LNKSTA_LBMS | PCI_EXP_LNKSTA_DLLLA)) ==
>   +                       PCI_EXP_LNKSTA_LBMS)
>   +               return true;
>   +
>   +       return false;
>   +}
> 
> If this is a generic thing and checking PCI_EXP_LNKSTA_LBMS makes
> sense for everybody, it could go in pci.c; otherwise it could go in
> quirks.c as well.  I guess it's not *truly* generic anyway because it
> only detects link training failures for devices that have LNKCTL2 and
> link_active_reporting.

 I do not have enough information to tell whether this is generic or not.  

 Checking for PCI_EXP_LNKSTA_LBMS is important, because otherwise this 
code would attempt to retrain every empty slot or otherwise unconnected 
PCIe link, which we do not want to do and which would surely take a lot of 
time with some of the larger systems, to say nothing of the log clutter 
showing that there is something wrong with the system while indeed there 
is nothing.

 Out of all the ports whose data link layer is not in the DL_Active state 
the LBMS bit is only set for the failed link in my system and I suspect it 
is related to the link speed negotiation erratum causing unsuccessful link 
training to repeat indefinitely.

 By definition LBMS cannot be set for an unconnected link, because the bit 
is only allowed to be set for an event observed that has happened with a 
port reporting no DL_Down status at any time throughout the event, which 
can only happen with the physical layer up, which of course cannot happen 
for an unconnected link (of course I can imagine another erratum affecting 
the LBMS bit, but that has not been reported yet).

 While making sure I got all the details in the previous paragraph right I 
have gone through a reference to the DL_Feature data link layer state (and 
a potential need to disable it for interacting with a non-compliant legacy 
downstream device), but neither device involved supports it, so it can't 
possibly be the cause for the phenomenon observed.

 IOW the LBMS bit serves the purpose of indicating that there is actually 
a device down an inactive link (the state of the physical layer's LinkUp 
bit is not directly accessible via software).  And one might argue that 
the state where LBMS is set but DLLLA is clear (where actually supported) 
after a device reset is indeed a generic sign of an odd link training 
issue.

 If you think it would make sense to include any piece of the text above 
with the existing documentation, then I'll be happy to improve it.

> > +	if (IS_ENABLED(CONFIG_PCI_QUIRKS) && (lnksta & PCI_EXP_LNKSTA_DLLLA) &&
> > +	    (lnkctl2 & PCI_EXP_LNKCTL2_TLS) == PCI_EXP_LNKCTL2_TLS_2_5GT &&
> > +	    pci_match_id(ids, dev)) {
> > +		u32 lnkcap;
> > +		u16 lnkctl;
> > +
> > +		pci_info(dev, "removing 2.5GT/s downstream link speed restriction\n");
> > +		pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnkcap);
> > +		pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &lnkctl);
> > +		lnkctl |= PCI_EXP_LNKCTL_RL;
> > +		lnkctl2 &= ~PCI_EXP_LNKCTL2_TLS;
> > +		lnkctl2 |= lnkcap & PCI_EXP_LNKCAP_SLS;
> > +		pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
> > +		pcie_capability_write_word(dev, PCI_EXP_LNKCTL, lnkctl);
> 
> This starts a retrain; should we wait for training to complete?

 Yep, why not, with `pcie_retrain_link' now updated it's trivial, and we 
can then also verify the result (and do nothing about it except for 
reporting, as it's supposed to never happen, so let's just wait and see).

> If we put most of this into a pcie_fix_link_train() (separated from
> detecting the *need* to fix something), could it be made to look
> sort of like this?  (I suppose you'd want to return bool and rename
> it that reads naturally, e.g., "pcie_link_forcibly_retrained()",
> "pcie_link_retrained()", etc)

 Ah, I concluded to make it return `bool' independently, having not seen 
this suggestion of yours yet, so it seems like we're getting in sync, and 
likewise I renamed the function to `pcie_failed_link_retrain' already.

>   +void pcie_fix_link_train(struct pci_dev *dev)
>   +{
>   +       u16 lnkctl2;
>   +       u32 lnkcap;
>   +       bool linkup;
>   +
>   +       pci_info(dev, "attempting link retrain at 2.5GT/s\n");
>   +       pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
>   +       lnkctl2 &= ~PCI_EXP_LNKCTL2_TLS;
>   +       lnkctl2 |= PCI_EXP_LNKCTL2_TLS_2_5GT;
>   +       pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
>   +
>   +       linkup = pcie_retrain_link(dev, PCI_EXP_LNKSTA_DLLLA);
>   +       if (!linkup) {
>   +               pci_info(dev, "retraining failed\n");
>   +               return;
>   +       }
>   +
>   +       if (LNKCAP supports only 2.5GT/s)
>   +               return;
>   +
>   +       if (!pci_match_id(ids, dev))
>   +               return;
> 
> Your comment said "if we know this is *safe*"; I can't remember if
> pci_match_id() is there to avoid a known problem?

 It's the other way round, the intent is to lift the speed restriction and 
retrain for devices known to succeed and survive only.

 It cannot be universally guaranteed that such a retrain will succeed even 
if 2.5GT/s works, and moreover this piece is independent from the attempt 
to recover made immediately above and will also run where the firmware has 
clamped the speed of the link somehow, whether for this erratum or for 
another reason (remember that the speed clamp is sticky, so it will have 
survived our bus/interconnect hierarchy reset).

 In particular Pali has reported (in an earlier discussion concerning this 
erratum on the U-Boot mailing list) the existence of downstream devices 
that lock up when a link retrain is attempted, so we don't want to request 
one for an otherwise known-working link (retraining a dead link won't hurt 
of course regardless, because at worst it'll just stay in its non-working 
state, and we don't have a way to figure out what might be there anyway).  
Cf. <https://lists.denx.de/pipermail/u-boot/2021-November/467201.html>.

> > +/* Same as above, but called for a downstream device.  */
> > +static int pcie_upstream_link_retrain(struct pci_dev *dev)
> > +{
> > +	struct pci_dev *bridge;
> > +
> > +	bridge = pci_upstream_bridge(dev);
> > +	if (bridge)
> > +		return pcie_downstream_link_retrain(bridge);
> > +	else
> > +		return -1;
> > +}
> > +
> >  static int pci_acs_enable;
> >  
> >  /**
> > @@ -1148,8 +1274,8 @@ void pci_resume_bus(struct pci_bus *bus)
> >  
> >  static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
> >  {
> > +	int retrain = 0;
> >  	int delay = 1;
> > -	u32 id;
> >  
> >  	/*
> >  	 * After reset, the device should not silently discard config
> > @@ -1163,21 +1289,37 @@ static int pci_dev_wait(struct pci_dev *
> >  	 * Command register instead of Vendor ID so we don't have to
> >  	 * contend with the CRS SV value.
> >  	 */
> > -	pci_read_config_dword(dev, PCI_COMMAND, &id);
> > -	while (PCI_POSSIBLE_ERROR(id)) {
> > +	for (;;) {
> > +		u32 id;
> > +
> > +		pci_read_config_dword(dev, PCI_COMMAND, &id);
> > +		if (!PCI_POSSIBLE_ERROR(id)) {
> > +			if (delay > PCI_RESET_WAIT)
> > +				pci_info(dev, "ready %dms after %s\n",
> > +					 delay - 1, reset_type);
> > +			break;
> > +		}
> > +
> >  		if (delay > timeout) {
> >  			pci_warn(dev, "not ready %dms after %s; giving up\n",
> >  				 delay - 1, reset_type);
> >  			return -ENOTTY;
> >  		}
> >  
> > -		if (delay > PCI_RESET_WAIT)
> > +		if (delay > PCI_RESET_WAIT) {
> > +			if (!retrain) {
> > +				retrain = 1;
> > +				if (pcie_upstream_link_retrain(dev) == 0) {
> > +					delay = 1;
> > +					continue;
> > +				}
> > +			}
> >  			pci_info(dev, "not ready %dms after %s; waiting\n",
> >  				 delay - 1, reset_type);
> > +		}
> 
> Thanks for fixing this in the reset path, too.  Can we move this part
> to a separate patch?  It's related to the rest of the patch, but it
> looks so much different that I think it would be easier to understand
> by itself.

 I think making a system halfway-fixed would make little sense, but with 
the actual fix actually made last as you suggested I think this can be 
split off, because it'll make no functional change by itself.

 While at it I have verified that the initial value of `retrain' does not 
have to be changed for the compiler to optimise away any code related to 
it in the !PCI_QUIRKS case where `pcie_parent_link_retrain' gets optimised 
away too, so we're good here.

 I changed `retrain' to `bool' though and inverted the logic as I find it 
more natural this way.

> I think I might try to fold the pcie_upstream_link_retrain() directly
> in here because the "upstream link retrain" in the function name
> doesn't really make sense in PCIe terms.

 Well, it does, as you can indeed request a retrain for an upstream port 
device.  This is not however what this function does, so I agree it's 
confusing.  I have replaced "upstream" with "parent" in the function name 
then to avoid this ambiguity.

 Otherwise I think factoring this piece out makes code more readable, as 
it's already quite deeply nested in blocks, and the compiler will inline 
it anyway, so I'd rather keep it as a separate function.

 With the observations made I'll be posting a rewritten patch series now.  
I realise there might still be issues outstanding, but this rewrite was 
already humongous enough and I think it deserves a second pair of eyeballs 
before massaging it any further.

 And last but not least, thank you for waiting, it was quite a stretch for 
me to fit this effort in among all the stuff currently on my table and all 
the unforeseen events.

  Maciej

