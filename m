Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CB568B0AA
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 16:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjBEPtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 10:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBEPtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 10:49:02 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 556DE9038;
        Sun,  5 Feb 2023 07:49:01 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 106B792009C; Sun,  5 Feb 2023 16:48:55 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 0478292009B;
        Sun,  5 Feb 2023 15:48:54 +0000 (GMT)
Date:   Sun, 5 Feb 2023 15:48:54 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <bhelgaas@google.com>,
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
        Paolo Abeni <pabeni@redhat.com>
cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lukas Wunner <lukas@wunner.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/7] pci: Work around ASMedia ASM2824 PCIe link training
 failures
Message-ID: <alpine.DEB.2.21.2302022022230.45310@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,HDRS_LCASE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

 This is v6 of the change to work around a PCIe link training phenomenon 
where a pair of devices both capable of operating at a link speed above 
2.5GT/s seems unable to negotiate the link speed and continues training 
indefinitely with the Link Training bit switching on and off repeatedly 
and the data link layer never reaching the active state.

 Following Bjorn's suggestion from the previous iteration:
<https://lore.kernel.org/lkml/20221109050418.GA529724@bhelgaas/> I have 
moved the workaround into the PCI core.  I have kept the part specific to 
ASMedia (to lift the speed restriction after a successful retrain) within, 
although I find it a good candidate for a standalone quirk.  It seems to 
me we'd have to add additional classes of fixups however to move this part 
to drivers/pci/quirks.c, which I think would be an overkill.  So I've only 
made it explicitly guarded by CONFIG_PCI_QUIRKS; I can see there's prior 
art with this approach.

 In the course of the update I have realised that commit 6b2f1351af56 
("PCI: Wait for device to become ready after secondary bus reset") makes 
no sense and was about to figure out what to do here about it, but then 
found Lukas's recent patch series addressing this issue (thanks, Lukas, 
you made my life easier!), so I have rebased my patch set on top of 
Lukas's:
<https://lore.kernel.org/all/da77c92796b99ec568bd070cbe4725074a117038.1673769517.git.lukas@wunner.de/>.

 This has resulted in mild ugliness in that `pcie_downstream_link_retrain' 
may be called from `pci_bridge_wait_for_secondary_bus' twice, first time 
via `pcie_wait_for_link_delay' and second time via `pci_dev_wait'.  This 
second call to `pcie_downstream_link_retrain' will do nothing, because for 
`link_active_reporting' devices `pcie_wait_for_link_delay' will have 
ensured the link has gone up or the second call won't have been reached.

 I have also decided to move the initialisation of `link_active_reporting' 
earlier on, so as to have a single way to check for the feature.  This has 
brought an extra patch and its 3 clean-up dependencies into the series.

 This was originally observed in a configuration featuring a downstream 
port of the ASMedia ASM2824 Gen 3 switch wired to the upstream port of the 
Pericom PI7C9X2G304 Gen 2 switch.  However in the course of review I have 
come to the conclusion that similarly to the earlier similar change to 
U-Boot it is indeed expected to be safe to apply this workaround to any 
downstream port that has failed link negotiation provided that:

1. the port is capable of reporting the data link layer link active 
   status (because unlike U-Boot we cannot busy-loop continuously polling 
   the link training bit),

and:

2. we don't attempt to lift the 2.5GT/s speed restriction, imposed as the
   basis of the workaround, for devices not explicitly known to continue 
   working in that case.

It is expected to be safe because the workaround is applied to a failed 
link, that is one that does not (at the time this code is executed) work 
anyway, so trying to bring it up cannot make the situation worse.

 This has been verified with a SiFive HiFive unmatched board, with and 
without CONFIG_PCI_QUIRKS enabled, booting with or without the workaround 
activated in U-Boot, which covered both the link retraining part of the 
quirk and the lifting of speed restriction already imposed by U-Boot.

 I have also issued resets via sysfs to see how this change behaves.  For 
the problematic link this required a hack to remove a `dev->subordinate' 
check from `pci_parent_bus_reset', which in turn triggered the workaround 
as expected and brought the link up (but otherwise clobbered downstream 
devices as one would inevitably expect).

 I have no way to verify these patches with power management or hot-plug 
events, but owing to Lukas's effort they get into the same infrastructure, 
so I expect the workaround to do its job as expected.  I note that there 
is an extra call to `pcie_wait_for_link' from `pciehp_check_link_status', 
but I expect it to work too.  For `link_active_reporting' devices it will 
call `pcie_downstream_link_retrain' and for`!link_active_reporting' ones 
we have no means to do anything anyway.

 The 3 extra clean-ups were only compile-tested (with PowerPC and x86-64 
configurations, as appropriate), because I have no suitable hardware 
available.

 Please see individual change descriptions for further details.

 Let me know if this is going in the right direction.

  Maciej
