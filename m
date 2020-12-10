Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33262D5922
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387517AbgLJLXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:23:20 -0500
Received: from exchange.tu-berlin.de ([130.149.7.70]:17687 "EHLO
        exchange.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgLJLXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:23:03 -0500
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2020 06:23:02 EST
Received: from SPMA-03.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 1F26E6E63B_FD20360B;
        Thu, 10 Dec 2020 11:15:44 +0000 (GMT)
Received: from exchange.tu-berlin.de (exchange.tu-berlin.de [130.149.7.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (verified OK))
        by SPMA-03.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id C207133A5A4_FD2035DF;
        Thu, 10 Dec 2020 11:15:41 +0000 (GMT)
Received: from [192.168.1.8] (91.64.84.74) by ex-02.tubit.win.tu-berlin.de
 (172.26.26.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.529.5; Thu, 10 Dec 2020
 12:15:40 +0100
From:   Felicitas Hetzelt <file@sect.tu-berlin.de>
Subject: Unchecked HW/hypervisor input issues in rocker module
To:     <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>,
        "Radev, Martin" <martin.radev@aisec.fraunhofer.de>,
        "Morbitzer, Mathias" <mathias.morbitzer@aisec.fraunhofer.de>,
        Robert Buhren <robert@sect.tu-berlin.de>
Message-ID: <c2062f6d-3bab-c867-e4e3-f062b8edb093@sect.tu-berlin.de>
Date:   Thu, 10 Dec 2020 12:19:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ex-05.tubit.win.tu-berlin.de (172.26.26.166) To
 ex-02.tubit.win.tu-berlin.de (172.26.26.163)
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tu-berlin.de; h=from:subject:to:cc:message-id:date:mime-version:content-type:content-transfer-encoding; s=dkim-tub; bh=yP0Z7wdMNTU63NFxyV+rU4VDfS81GngcxyQ9qqdFuL4=; b=ARr3/NXpTdchwrU2vcIJQcuX7ibX7/sX9YEOWcl9GSJB/7ubfs/oCrNlVHS1G8gfsUDdIIRuHv3w21tru8Wr+9f5NyiSJ2Um2vlEgcQYDocn354o/LxoMm+LMOaR9u0D5gRv5mpCBj6wFY0bSJYyHDpeBpJ1uMIHXGsB7bmSMDQ=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jiri,

we have been analyzing the HW/Hypervisor-OS interface of device drivers
and discovered bugs in the rocker driver that can be triggered from a
malicious Hypervisor or PCI device.

The reason for analyzing these interfaces is that, technologies such as
Intel's Trusted Domain Extensions [1] and AMD's Secure Nested Paging [2]
change the threat model assumed by various Linux kernel subsystems.
These technologies take the presence of a fully malicious hypervisor
into account and aim to provide protection for virtual machines in such
an environment. Executing at a higher privilege level than the guest
kernel, the hypervisor was considered trustworthy in the past. Note that
these issues are of little (or no) relevance in a "normal"
virtualization setup, nevertheless we believe that it is required to fix
them if TDX or SNP is used.

Further, it is known that malicious PCI devices can be attached to the
USB-C port in order to attack this interface [3] (if thunderbolt is not
locked down).

Therefore, all input received from the hypervisor or an external device
should be carefully validated.

We are aware that these threat-models are relatively new and many parts
of the Linux kernel do not yet incorporate them.

We are happy to provide more information if needed!

[1]
https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html

[2] https://www.amd.com/en/processors/amd-secure-encrypted-virtualization

[3]
https://www.ndss-symposium.org/wp-content/uploads/2019/02/ndss2019_05A-1_Markettos_paper.pdf

###################################################################
Bug1:
Description:

Oob array access on rocker->msix_entries, due to an integer overflow
when evaluating ROCKER_MSIX_VEC_COUNT.

The allocation size of the rocker->msix_entries array determined by the
hardware
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L2684
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L2691

A different hardware controlled variable port_count determines the
maximum index for this array via
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_hw.h#L33
For a sufficiently large value of port count this calculation will cause
an integer overflow, i.e. port_count == 0xffffffff will result in
ROCKER_MSIX_VEC_COUNT(rocker->port_count) == 2, which is lower than e.g.
ROCKER_MSIX_VEC_RESERVED0.

Therefore, even though the number of reported msix_entries is checked
against port count
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L2688
We found that for a value of port_count == -1/0xffffffff and
msix_entries == 2 that check will not trigger.
This leads to oob access on each invocation of rocker_msix_vector
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L96
Whenever the passed vector parameter is >= 2, e.g.
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L280

Patch:
Cast to long in ROCKER_MSIX_VEC_COUNT
Or check if port_count has a valid range in
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L2944

###################################################################
Bug2:
Description:

PTR read from dma controlled mem (desc_info)
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L572
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L358

rocker->cmd_ring->desc is allocated as coherent dma memory
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L610
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L444

And rocker->cmd_ring->desc_info[*].desc is set to point to desc
structures in dma memory
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L453

When the device is removed the following functions are called
Rocker_remove -> rocker_dma_rings_finie ->
rocker_dma_cmd_ring_waits_free -> rocker_dma_cmd_wait_free

Rocker_dma_cmd_wait_free invokes rocker_desc_cookie_ptr_get to
initialize the pointer variable ‘wait’ with a device controlled value
(as it is located in dma coherent memory). And passes that value to kfree.
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L572
https://github.com/torvalds/linux/blob/eccc876724927ff3b9ff91f36f7b6b159e948f0c/drivers/net/ethernet/rocker/rocker_main.c#L358

Similar issues arise in other locations of the driver.
