Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC8269477C
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjBMNxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBMNxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:53:35 -0500
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A269ED4;
        Mon, 13 Feb 2023 05:53:31 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 019173000794D;
        Mon, 13 Feb 2023 14:53:28 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id D8E261E172; Mon, 13 Feb 2023 14:53:27 +0100 (CET)
Date:   Mon, 13 Feb 2023 14:53:27 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 6/7] PCI: pciehp: Rely on `link_active_reporting'
Message-ID: <20230213135327.GA29595@wunner.de>
References: <alpine.DEB.2.21.2302022022230.45310@angie.orcam.me.uk>
 <alpine.DEB.2.21.2302051459210.33812@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2302051459210.33812@angie.orcam.me.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 03:49:21PM +0000, Maciej W. Rozycki wrote:
> Use `link_active_reporting' to determine whether Data Link Layer Link 
> Active Reporting is available rather than re-retrieving the capability.
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>

Reviewed-by: Lukas Wunner <lukas@wunner.de>

I believe this should work without the preceding patches in the series,
hence can be applied independently.

Thanks,

Lukas

>  drivers/pci/hotplug/pciehp_hpc.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> linux-pcie-link-active-reporting-hpc.diff
> Index: linux-macro/drivers/pci/hotplug/pciehp_hpc.c
> ===================================================================
> --- linux-macro.orig/drivers/pci/hotplug/pciehp_hpc.c
> +++ linux-macro/drivers/pci/hotplug/pciehp_hpc.c
> @@ -984,7 +984,7 @@ static inline int pcie_hotplug_depth(str
>  struct controller *pcie_init(struct pcie_device *dev)
>  {
>  	struct controller *ctrl;
> -	u32 slot_cap, slot_cap2, link_cap;
> +	u32 slot_cap, slot_cap2;
>  	u8 poweron;
>  	struct pci_dev *pdev = dev->port;
>  	struct pci_bus *subordinate = pdev->subordinate;
> @@ -1030,9 +1030,6 @@ struct controller *pcie_init(struct pcie
>  	if (dmi_first_match(inband_presence_disabled_dmi_table))
>  		ctrl->inband_presence_disabled = 1;
>  
> -	/* Check if Data Link Layer Link Active Reporting is implemented */
> -	pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &link_cap);
> -
>  	/* Clear all remaining event bits in Slot Status register. */
>  	pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
>  		PCI_EXP_SLTSTA_ABP | PCI_EXP_SLTSTA_PFD |
> @@ -1051,7 +1048,7 @@ struct controller *pcie_init(struct pcie
>  		FLAG(slot_cap, PCI_EXP_SLTCAP_EIP),
>  		FLAG(slot_cap, PCI_EXP_SLTCAP_NCCS),
>  		FLAG(slot_cap2, PCI_EXP_SLTCAP2_IBPD),
> -		FLAG(link_cap, PCI_EXP_LNKCAP_DLLLARC),
> +		FLAG(pdev->link_active_reporting, true),
>  		pdev->broken_cmd_compl ? " (with Cmd Compl erratum)" : "");
>  
>  	/*
