Return-Path: <netdev+bounces-11434-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A94473312C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:28:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB7C61C20FB0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD951992F;
	Fri, 16 Jun 2023 12:27:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE67419BAA
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:27:59 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A4EF30DE;
	Fri, 16 Jun 2023 05:27:56 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 1B84492009C; Fri, 16 Jun 2023 14:27:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 13F8F92009B;
	Fri, 16 Jun 2023 13:27:53 +0100 (BST)
Date: Fri, 16 Jun 2023 13:27:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Bjorn Helgaas <helgaas@kernel.org>
cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
    Eric Dumazet <edumazet@google.com>, Oliver O'Halloran <oohall@gmail.com>, 
    Stefan Roese <sr@denx.de>, Leon Romanovsky <leon@kernel.org>, 
    linux-rdma@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, Jim Wilson <wilson@tuliptree.org>, 
    Nicholas Piggin <npiggin@gmail.com>, 
    Alex Williamson <alex.williamson@redhat.com>, 
    Bjorn Helgaas <bhelgaas@google.com>, 
    Mika Westerberg <mika.westerberg@linux.intel.com>, 
    David Abdurachmanov <david.abdurachmanov@gmail.com>, 
    linuxppc-dev@lists.ozlabs.org, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, 
    "David S. Miller" <davem@davemloft.net>, Lukas Wunner <lukas@wunner.de>, 
    netdev@vger.kernel.org, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
    Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v9 00/14] pci: Work around ASMedia ASM2824 PCIe link
 training failures
In-Reply-To: <20230615183754.GA1483387@bhelgaas>
Message-ID: <alpine.DEB.2.21.2306160431470.64925@angie.orcam.me.uk>
References: <20230615183754.GA1483387@bhelgaas>
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

On Thu, 15 Jun 2023, Bjorn Helgaas wrote:

> >  If doing it this way, which I actually like, I think it would be a little 
> > bit better performance- and style-wise if this was written as:
> > 
> > 	if (pci_is_pcie(dev)) {
> > 		bridge = pci_upstream_bridge(dev);
> > 		retrain = !!bridge;
> > 	}
> > 
> > (or "retrain = bridge != NULL" if you prefer this style), and then we 
> > don't have to repeatedly check two variables iff (pcie && !bridge) in the 
> > loop below:
> 
> Done, thanks, I do like that better.  I did:
> 
>   bridge = pci_upstream_bridge(dev);
>   if (bridge)
>     retrain = true;
> 
> because it seems like it flows more naturally when reading.

 Perfect, and good timing too, as I have just started checking your tree 
as your message arrived.  I ran my usual tests with and w/o PCI_QUIRKS 
enabled and results were as expected.  As before I didn't check hot plug 
and reset paths as these features are awkward with the HiFive Unmatched 
system involved.

 I have skimmed over the changes as committed to pci/enumeration and found 
nothing suspicious.  I have verified that the tree builds as at each of 
them with my configuration.

 As per my earlier remark:

> I think making a system halfway-fixed would make little sense, but with
> the actual fix actually made last as you suggested I think this can be
> split off, because it'll make no functional change by itself.

I am not perfectly happy with your rearrangement to fold the !PCI_QUIRKS 
stub into the change carrying the actual workaround and then have the 
reset path update with a follow-up change only, but I won't fight over it.  
It's only one tree revision that will be in this halfway-fixed state and 
I'll trust your judgement here.

 Let me know if anything pops up related to these changes anytime and I'll 
be happy to look into it.  The system involved is nearing two years since 
its deployment already, but hopefully it has many years to go yet and will 
continue being ready to verify things.  It's not that there's lots of real 
RISC-V hardware available, let alone with PCI/e connectivity.

 Thank you for staying with me and reviewing this patch series through all 
the iterations.

  Maciej

