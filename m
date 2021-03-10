Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA0C333C14
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhCJMDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbhCJMDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:03:06 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 775AFC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:03:06 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 18E9A92009D; Wed, 10 Mar 2021 13:03:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 12E2692009B;
        Wed, 10 Mar 2021 13:03:04 +0100 (CET)
Date:   Wed, 10 Mar 2021 13:03:03 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     netdev@vger.kernel.org
cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] FDDI: defxx: CSR access fixes and improvements
Message-ID: <alpine.DEB.2.21.2103091713260.33195@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

 As a lab upgrade I have recently replaced a dated 32-bit x86 server with 
a new POWER9 system.  One of the purposes of the system has been providing 
network based resources to clients over my FDDI network.  As such the new 
server has also received a new DEFPA FDDI network adapter.

 As it turned out the interface did not work with the driver as shipped by 
the most recent stable Debian release (Linux version 5.9.15) for ppc64el.  
Symptoms were inconclusive, and the DEFPA adapter turned out to have a 
manufacturing defect as well, however eventually I have figured out the 
PCIe host bridge used with the system, Power Systems Host Bridge 4 (PHB4), 
does not (anymore) implement PCI I/O transactions, while the binary defxx 
driver as shipped by Debian comes configured for port I/O, and then a bug 
in resource handling causes the driver to try and use an unassigned port 
I/O range for adapter's PDQ main ASIC's CSR access.

 Fortunately the PFI PCI interface ASIC used with the DEFPA adapter has 
been designed such as to provide for both PCI I/O and PCI memory accesses 
to be used for PDQ CSR access, via a pair of BARs to be alternatively 
used.

 Originally the defxx driver only supported port I/O access, but in the 
course of interfacing it to the TURBOchannel bus I had to implement MMIO 
access too, and while at it I have added a kernel configuration option to 
globally switch between port I/O and MMIO at compilation time, however 
conservatively defaulting to port I/O for EISA bus support where the use 
of MMIO currently requires the adapter to have been suitably configured 
via ECU (EISA Configuration Utility), supplied externally.

 With the kernel configuration option set to MMIO the DEFPA interface 
works correctly with my POWER9 system.  Therefore I have prepared this 
small patch series consisting of a pair of conservative bug fixes, to be 
backported to stable branches, and then a pair of improvements for the 
robustness of the driver.

 So changes 1/4 and 2/4 apply both to net and net-next, and then changes 
3/4 and 4/4 apply on top of them to net-next only.  In particular there 
are diff context dependencies going like this: 1/4 -> 3/4 -> 4/4.  Let me 
know if this submission needs to be sorted differently.

 See individual change descriptions for further details as to the actual 
changes made.

 NB the ESIC interface chip used for slave address decoding with the DEFEA 
EISA adapter has decoding implemented for address bits 31:10 and therefore 
supports full 32-bit range for the allocation of the CSR decoding window.  
For DOS compatibility reasons ECU however only allows allocations between 
0x000c0000 and 0x000effff.

 Given that for other compatibility reasons EISA is subtractively decoded 
on mixed PCI/EISA systems we could allocate an MMIO region from arbitrary 
unoccupied memory space and program the ESIC suitably without regard for 
that compatibility limitation.  In fact I have a proof-of-concept change 
and it seems to work reliably.

 However with these patches applied the driver continues supporting port 
I/O as fallback and the EISA product ID register is located in the EISA 
slot-specific port I/O address space, so any EISA system however modern 
(sounds like a joke, eh?) also has to support port I/O access somehow.

 So while I think such a dynamic MMIO allocation would be an example of 
good engineering, but it would require changes to our EISA core and 
therefore it may have had sense 25 years ago when EISA was still 
mainstream, but not nowadays when EISA systems are I suppose more of a 
curiosity rather than the usual equipment.

 This patch series has been thoroughly verified with Linux 5.11.0 as 
released and then a Raptor Talos II POWER9 system and a Malta 5Kc MIPS64 
system for PCI DEFPA adapter support, an Advanced Integrated Research 
486EI x86 system for EISA DEFEA adapter support, and a Digital Equipment 
DECstation 5000 model 260 MIPS III system for TURBOchannel DEFTA adapter 
support, covering both port I/O and MMIO operation where applicable.

 Please apply.

  Maciej
