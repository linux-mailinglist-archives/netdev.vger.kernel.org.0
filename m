Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0C7263448
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgIIRR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:17:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34962 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730108AbgIIP2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:28:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599665239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gAOxADskf6N6kLtooyF1uApbBx1RmVCuz5XULPdPjeA=;
        b=PYtIlYC3XJYn0R2rA9+IISZfB5Y4kHVf+suT1xN7QgfDtPJJfWNF60gkx3LK8iXl1aywbH
        4Q4Lol1eZ54P0addlA8omtenvdG7MraBIto0tzlLA/VHFTT4xpFfvJprp5+LngQlnPbP5+
        AxKbYwX2yu/bHBO2Q9gMqZGQO6oZng4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-18YBVbHtMxS_2Zr8MQBqVA-1; Wed, 09 Sep 2020 11:09:05 -0400
X-MC-Unique: 18YBVbHtMxS_2Zr8MQBqVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 080818030A2;
        Wed,  9 Sep 2020 15:09:03 +0000 (UTC)
Received: from wsfd-advnetlab06.anl.lab.eng.bos.redhat.com (wsfd-advnetlab06.anl.lab.eng.bos.redhat.com [10.19.107.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CCE019C4F;
        Wed,  9 Sep 2020 15:09:01 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com
Subject: [RFC] [PATCH v1 0/3] isolation: limit msix vectors based on housekeeping CPUs
Date:   Wed,  9 Sep 2020 11:08:15 -0400
Message-Id: <20200909150818.313699-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up posting for "[v1] i40e: limit the msix vectors based on
housekeeping CPUs" [1] (It took longer than expected for me to get back to
this).


Issue
=====
With the current implementation device drivers while creating their MSIX
vectors only takes num_online_cpus() into consideration which works quite well
for a non-RT environment, but in an RT environment that has a large number of
isolated CPUs and a very few housekeeping CPUs this could lead to a problem.
The problem will be triggered when something like tuned will try to move all
the IRQs from isolated CPUs to the limited number of housekeeping CPUs to
prevent interruptions for a latency sensitive workload that will be runing on
the isolated CPUs. This failure is caused because of the per CPU vector
limitation.


Proposed Fix
============
In this patch-set, the following changes are proposed:
- A generic API num_housekeeping_cpus() which is meant to return the available
  housekeeping CPUs in an environment with isolated CPUs and all online CPUs
  otherwise.
- i40e: Specifically for the i40e driver the num_online_cpus() used in 
  i40e_init_msix() to calculate numbers msix vectors is replaced with the above
  defined API. This is done to restrict the number of msix vectors for i40e in
  RT environments.
- pci_alloc_irq_vector(): With the help of num_housekeeping_cpus() the max_vecs
  passed in pci_alloc_irq_vector() is restricted only to the available
  housekeeping CPUs only in an environment that has isolated CPUs. However, if
  the min_vecs exceeds the num_housekeeping_cpus(), no change is made to make
  sure that a device initialization is not prevented due to lack of
  housekeeping CPUs.



Reproducing the Issue
=====================
I have triggered this issue on a setup that had a total of 72 cores among which
68 were isolated and only 4 were left for housekeeping tasks. I was using
tuned's realtime-virtual-host profile to configure the system. In this
scenario, Tuned reported the error message 'Failed to set SMP affinity of IRQ
xxx to '00000040,00000010,00000005': [Errno 28] No space left on the device'
for several IRQs in tuned.log due to the per CPU vector limit.


Testing
=======
Functionality:
- To test that the issue is resolved with i40e change I added a tracepoint
  in i40e_init_msix() to find the number of CPUs derived for vector creation
  with and without tuned's realtime-virtual-host profile. As per expectation
  with the profile applied I was only getting the number of housekeeping CPUs
  and all available CPUs without it.

Performance:
- To analyze the performance impact I have targetted the change introduced in 
  pci_alloc_irq_vectors() and compared the results against a vanilla kernel
  (5.9.0-rc3) results.

  Setup Information:
  + I had a couple of 24-core machines connected back to back via a couple of
    mlx5 NICs and I analyzed the average bitrate for server-client TCP and UDP
    transmission via iperf. 
  + To minimize the Bitrate variation of iperf TCP and UDP stream test I have
    applied the tuned's network-throughput profile and disabled HT.
 Test Information:
  + For the environment that had no isolated CPUs:
    I have tested with single stream and 24 streams (same as that of online
    CPUs).
  + For the environment that had 20 isolated CPUs:
    I have tested with single stream, 4 streams (same as that the number of
    housekeeping) and 24 streams (same as that of online CPUs).

 Results:
  # UDP Stream Test:
    + There was no degradation observed in UDP stream tests in both
      environments. (With isolated CPUs and without isolated CPUs after the
      introduction of the patches).
  # TCP Stream Test - No isolated CPUs:
    + No noticeable degradation was observed.
  # TCP Stream Test - With isolated CPUs:
    + Multiple Stream (4)  - Average degradation of around 5-6%
    + Multiple Stream (24) - Average degradation of around 2-3%
    + Single Stream        - Even on a vanilla kernel the Bitrate observed for
                             a TCP single stream test seem to vary
                             significantly across different runs (eg. the %
                             variation between the best and the worst case on
                             a vanilla kernel was around 8-10%). A similar
                             variation was observed with the kernel that
                             included my patches. No additional degradation
                             was observed.

Since the change specifically for pci_alloc_irq_vectors is going to impact
several drivers I have posted this patch-set as RFC. I would be happy to
perform more testing based on any suggestions or incorporate any comments to
ensure that the change is not breaking anything.

[1] https://lore.kernel.org/patchwork/patch/1256308/ 

Nitesh Narayan Lal (3):
  sched/isolation: API to get num of hosekeeping CPUs
  i40e: limit msix vectors based on housekeeping CPUs
  PCI: Limit pci_alloc_irq_vectors as per housekeeping CPUs

 drivers/net/ethernet/intel/i40e/i40e_main.c |  3 ++-
 include/linux/pci.h                         | 16 ++++++++++++++
 include/linux/sched/isolation.h             |  7 +++++++
 kernel/sched/isolation.c                    | 23 +++++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)

-- 
2.27.0



