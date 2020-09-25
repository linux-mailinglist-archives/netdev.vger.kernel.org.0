Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD763279043
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgIYS1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:27:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727495AbgIYS1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:27:10 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601058428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=H6+BMGpX9nRwK6ylAAUa5PZB+Njz4oOv2pFi9n8OI38=;
        b=Ly9QdRCm69024p2pFvUzMklwROwy1WTOTFepwGwrZXmuRoIZfgFAp18cxv2u7acWk2AUHR
        pqqgXoGH/P2qiTHeSS/U4Lgm3SoOhkmbiNPg4FAQ4n1uxoUgGTyb8+sxzz3nOu642kd3sE
        R7SGKbGILlx+4w6dTyrwHCZdWF/GYpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-tApSkebgOlmeS07q1mJcMQ-1; Fri, 25 Sep 2020 14:27:06 -0400
X-MC-Unique: tApSkebgOlmeS07q1mJcMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A13962FD09;
        Fri, 25 Sep 2020 18:27:03 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD88478810;
        Fri, 25 Sep 2020 18:26:55 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, nitesh@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: [PATCH v3 0/4] isolation: limit msix vectors to housekeeping CPUs
Date:   Fri, 25 Sep 2020 14:26:50 -0400
Message-Id: <20200925182654.224004-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up posting for "[PATCH v2 0/4] isolation: limit msix vectors
based on housekeeping CPUs".

Issue
=====
With the current implementation device drivers while creating their MSIX        
vectors only take num_online_cpus() into consideration which works quite well  
for a non-RT environment, but in an RT environment that has a large number of   
isolated CPUs and very few housekeeping CPUs this could lead to a problem.    
The problem will be triggered when something like tuned will try to move all    
the IRQs from isolated CPUs to the limited number of housekeeping CPUs to       
prevent interruptions for a latency-sensitive workload that will be running
on the isolated CPUs. This failure is caused because of the per CPU vector         
limitation.                                                                     


Proposed Fix
============
In this patch-set, the following changes are proposed:
- A generic API housekeeping_num_online_cpus() which is meant to return the
  online housekeeping CPUs based on the hk_flag passed by the caller.
- i40e: Specifically for the i40e driver the num_online_cpus() used in 
  i40e_init_msix() to calculate numbers msix vectors is replaced with the
  above defined API that returns the online housekeeping CPUs that are meant
  to handle managed IRQ jobs.
- pci_alloc_irq_vector(): With the help of housekeeping_num_online_cpus() the
  max_vecs passed in pci_alloc_irq_vector() is restricted only to the online
  housekeeping CPUs (designated for managed IRQ jobs) strictly in an RT
  environment. However, if the min_vecs exceeds the online housekeeping CPUs,
  max_vecs is limited based on the min_vecs instead.


Future Work
===========

- In the previous upstream discussion [1], it was decided that it would be
  better if we can have a generic framework that can be consumed by all the
  drivers to fix this kind of issue. However, it will be a long term work,
  and since there are RT workloads that are getting impacted by the reported
  issue. We agreed upon the proposed per-device approach for now.


Testing
=======
Functionality:
- To test that the issue is resolved with i40e change I added a tracepoint
  in i40e_init_msix() to find the number of CPUs derived for vector creation
  with and without tuned's realtime-virtual-host profile. As per expectation
  with the profile applied I was only getting the number of housekeeping CPUs
  and all available CPUs without it. Another way to verify is by checking
  the number of IRQs that get created corresponding to a impacted device.
  Similarly did a few more tests with different modes eg with only nohz_full,
  isolcpus etc.

Performance:
- To analyze the performance impact I have targetted the change introduced in 
  pci_alloc_irq_vectors() and compared the results against a vanilla kernel
  (5.9.0-rc3) results.

  Setup Information:
  + I had a couple of 24-core machines connected back to back via a couple of
    mlx5 NICs and I analyzed the average bitrate for server-client TCP and
    UDP transmission via iperf. 
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
    + Single Stream        - Even on a vanilla kernel the Bitrate observed 
                             for a TCP single stream test seem to vary
                             significantly across different runs (eg. the %
                             variation between the best and the worst case on
                             a vanilla kernel was around 8-10%). A similar
                             variation was observed with the kernel that
                             included my patches. No additional degradation
                             was observed.

If there are any suggestions for more performance evaluation, I would
be happy to discuss/perform them.


Changes from v2[2]:
==================
- Renamed hk_num_online_cpus() with housekeeping_num_online_cpus() to keep
  the naming convention consistent (based on a suggestion from Peter
  Zijlstra and Frederic Weisbecker).
- Added an argument "enum hk_flags" to the housekeeping_num_online_cpus() API
  to make it more usable in different use-cases (based on a suggestion from 
  Frederic Weisbecker).
- Replaced cpumask_weight(cpu_online_mask) with num_online_cpus() (suggestion
  from Bjorn Helgaas).
- Modified patch commit messages and comment based on Bjorn Helgaas's
  suggestion.

Changes from v1[3]:
==================
Patch1:                                                                       
- Replaced num_houskeeeping_cpus() with hk_num_online_cpus() and started
  using the cpumask corresponding to HK_FLAG_MANAGED_IRQ to derive the number
  of online housekeeping CPUs. This is based on Frederic Weisbecker's
  suggestion.           
- Since the hk_num_online_cpus() is self-explanatory, got rid of             
  the comment that was added previously.                                     
Patch2:                                                                       
- Added a new patch that is meant to enable managed IRQ isolation for
  nohz_full CPUs. This is based on Frederic Weisbecker's suggestion.              
Patch4 (PCI):                                                                 
- For cases where the min_vecs exceeds the online housekeeping CPUs, instead
  of skipping modification to max_vecs, started restricting it based on the
  min_vecs. This is based on a suggestion from Marcelo Tosatti.                                                                    


[1] https://lore.kernel.org/lkml/20200922095440.GA5217@lenoir/
[2] https://lore.kernel.org/lkml/20200923181126.223766-1-nitesh@redhat.com/
[3] https://lore.kernel.org/lkml/20200909150818.313699-1-nitesh@redhat.com/


Nitesh Narayan Lal (4):
  sched/isolation: API to get number of housekeeping CPUs
  sched/isolation: Extend nohz_full to isolate managed IRQs
  i40e: Limit msix vectors to housekeeping CPUs
  PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs

 drivers/net/ethernet/intel/i40e/i40e_main.c |  3 ++-
 include/linux/pci.h                         | 17 +++++++++++++++++
 include/linux/sched/isolation.h             |  9 +++++++++
 kernel/sched/isolation.c                    |  2 +-
 4 files changed, 29 insertions(+), 2 deletions(-)

-- 


