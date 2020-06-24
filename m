Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66063207A16
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405441AbgFXRS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405414AbgFXRS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:18:57 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655E5C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:18:57 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b16so1416709pfi.13
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+H7Vkh++0CahLHWqSa6P+u8Ir+6U1D24gclnYq9hT+8=;
        b=shHqF/hPybRugz+pDy3a4t/IwdAPg/zJUbkhME6011V8UXoSeAsAjiZ/XB/dtxj+Qv
         K+ULo9AthKTsM9oMkHriU1HdH2tp/TpfNRogYLLcGZEsP1DygBJ6s7+WUbK15k45REwg
         lIT+sEJZaIJqQWAVQpb6Z6ZfpGpm9LbW21CmXjiPwxoWy3z4leCGGonbw1wS2j/GqAjE
         IVFTj+oYvc2AxuXKJTF/+PYCCgSp5RcDsXSZOzHMYmzImlfZMYouoiT/cro/v6bxcx/a
         xyMzw17bpySdthlU9Pon0ykox1964W3mQ2nnOkkeWRwK3+HS1khiUNb6MxQSrO/qgP71
         KoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+H7Vkh++0CahLHWqSa6P+u8Ir+6U1D24gclnYq9hT+8=;
        b=WRwDRNFzFioMIaLG1x7fx4aY6EkT9PfrjM+Rbo4wTs6ROBo4P0yp+DitrgeBh2Rzm7
         gHVkTPynNCD966LUDjK0CUIpYEoF1gBACjSZ6QRUpbINoH9qnpYkpUNgopdu+hRfUr31
         VeELTYWJqv7coFm5ZfVWMCfJcQXAN74vTkCScuQ5xB0oddNEUNjldFTCjXN8ZK3z47yw
         zwM/Yyf03IdBpRRZSBZvMLs1Y8jiK/0G+xiG/tF1HRdyj2kzk2kQcEP/o0ePOD4QGl5Q
         BMOTUHznIf0I0uTXAP199DKtupgao11PdJdOavnQo6+JCkIKJcUQDdvb+ZZnLsCPIkHu
         ay8A==
X-Gm-Message-State: AOAM533/3oF0oJwl2WYfy7jZZlLzO/Q2w/uEF7ElQFuBLsibebldX7Q3
        dMqNGzPTPMQc89vGsO75w3Erwl2SeV4=
X-Google-Smtp-Source: ABdhPJxjVXYnGM+X0C5A1VakD6Tbab83b/tSJKjbJLn53hklfRenrBYu4xBw1Myy9L8FKte/qF7jNw==
X-Received: by 2002:a63:1549:: with SMTP id 9mr22495742pgv.408.1593019136201;
        Wed, 24 Jun 2020 10:18:56 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:18:55 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 00/11] ptq: Per Thread Queues
Date:   Wed, 24 Jun 2020 10:17:39 -0700
Message-Id: <20200624171749.11927-1-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per Thread Queues allows application threads to be assigned dedicated
hardware network queues for both transmit and receive. This facility
provides a high degree of traffic isolation between applications and
can also help facilitate high performance due to fine grained packet
steering. An overview and design considerations of Per Thread Queues
has been add to Documentation/networking/scaling.rst.

This patch set provides a basic implementation of Per Thread Queues.
The patch set includes:

	- Minor Infrastructure changes to cgroups (just export a
	  couple of functions)
	- netqueue.h to hold generic definitions for network queues
	- Minor infrastructure in aRFS and net-sysfs to accommodate
	  PTQ
	- Introduce the concept of "global queues". These are used
	  in cgroup configuration of PTQ. Global queues can be
	  mapped to real device queues. A per device queue sysfs
	  parameter is added to configure the mapping of device
	  queue to a global queue
	- Creation of a new cgroup controller, "net_queues", that
	  is used to configure Per Thread Queues
	- Hook up the transmit path. This has two parts: 1) In
	  send socket operations record the transmit queue
	  associated with a task in the sock structure, 2) In
	  netdev_pick_tx, check if the sock structure of the skb
	  has a valid transmit global queue set. If so, convert the
	  queue identifier to a device queue identifier based on the per
	  device mapping table. This selection precedes XPS
	- Hook up the receive path. This has two parts: 1) In
	  rps_record_sock_flow check if a receive global queue is
	  assigned to the running task, if so then set it in the
	  sock_flow_table entry for the flow. Note this in lieu of
	  setting the running CPU in the entry. 2) Change get_rps_cpu to
	  query the sock_flow_table to see if a queue index has been
	  stored (as opposed to a CPU number). If a queue index is
	  present, use it for steering including for it to be the
	  target of ndo_rx_flow_steer.

Related features and concepts:

	- netprio and prio_tc_map: Similar to those, PTQ allows control,
	  via cgroups and per device maps, over mapping applications'
	  packets to transmit queues. However, PTQ is intended to
	  perform fine grained per application mapping to queues such
	  that each application thread, possibly thousands of them, can
	  have its own dedicate transmit queue.
	- aRFS: On the transmit side PTQ extends aRFS to steer packets
	  for a flow based on assigned global queue as opposed to only
	  running CPU for the processing thread. In PTQ, the queue
	  "follows" the thread so that when threads are scheduled to
	  run on a different CPU, the packets for flows of the thread
	  continue to be received on the right queue. This addresses
	  a problem in aRFS where when a thread is rescheduled all
	  of its aRFS steered flows may be to moved to a different queue
	  (i.e. ndo_rx_flow_steer needs to be called for each flow).
	- Busy polling: PTQ provides silo'ing of an application packets
	  into queues and busy polling of those queue can then be
	  applied for high performance. This is likely the fist
	  instantiation of PTQ to combine it with busy polling
	  (moving interrupts for those queues as threads are scheduled
	  is most likely prohibitive). Busy polling is only practical
	  with a few queues, like maybe at most one per CPU, and
	  won't scale to thousands of per thread queues in use.
          (to address that sleeping-busy-poll with completion
	  queues is suggested below).
	- Making Networking Queues a First Class Citizen in the Kernel
	  https://linuxplumbersconf.org/event/4/contributions/462/
	  attachments/241/422/LPC_2019_kernel_queue_manager.pdf:
	  The concept of "global queues" should be a good complement
	  to this proposal. Global queue provide an abstract
	  representation of device queues. the abstraction is resolved
	  when the global queue is mapped to a real hardware queue. This
	  layering allows exposing queues to the user and configuration
	  which might be associated with general attributes (like high
	  priority, QoS characteristics, etc.). The mapping to a
	  specific device queue gives the low level queue that satisfies
	  the implied service of the global queue.  Any attributes and
	  associations are configured and in no way hardcoded, so that
	  the use of queues in the manner is fully extensible and can be
	  driven be arbitrary user defined policy. Since global queues
	  are device agnostic they not just can be managed as local
	  system resource, but also across across the distributed
	  tasks for a job in the datacenter like as a property of a
	  container in Kubernetes (similar to how we might manage
	  network priority as a global DC resource, but global queues
	  provide much more granularity and richness in what they can
	  convey).

There are a number of possible extensions to this work

	- Queue selection could be done on a per process basis
	  or a per socket basis as well as a per thread basis. (per
	  packet basis probably makes little sense due to OOO)
	- The mechanism for selecting a queue to assign to a thread
	  could be programmed. For instance, an eBPF hook could be
	  added that would allow very fine grained policies to do
	  queue selection.
	- "Global queue groups" could be created where a global queue
	  identifier maps to some group of device queues and there is
	  a selection algorithm, possibly another eBPF hook, that
	  maps to a specific device queue for use.
	- Another attribute in the cgroup could be added to enable
	  or disable aRFS on a per thread basis.
	- Extend the net_queues cgroup to allow control over
	  busy-polling on a per cgroup basis. This could further
	  be enhanced by eBPF hooks to control busy-polling for
	  individual sockets of the cgroup per some arbitrary policy
	  (similar to eBPF hook for SO_RESUSEPORT).
	- Elasticity in listener sockets. As described in the
	  Documentation we expect that a filter can be installed to
	  direct packets an application to the set of queues for the
	  applications. The problem is that the application may
	  create threads on demand so that we don't know a priori
	  how many queues the application needs. Optimally, we
	  want a mechanism to dynamically enable/disable a
	  queue in the filter set so that at any given time the
	  application is receive packets only on queues it is
	  actively using. This may entail a new ndo_function.
	- The sleeping-busy-poll with completion queue model
	  described in the documentation could be integrated. This
	  would most entail creating a reverse mapping from queue
	  to threads, and then allowing the thread processing a
	  device completion queue to schedule the threads of interest.


Tom Herbert (11):
  cgroup: Export cgroup_{procs,threads}_start and cgroup_procs_next
  net: Create netqueue.h and define NO_QUEUE
  arfs: Create set_arfs_queue
  net-sysfs: Create rps_create_sock_flow_table
  net: Infrastructure for per queue aRFS
  net: Function to check against maximum number for RPS queues
  net: Introduce global queues
  ptq: Per Thread Queues
  ptq: Hook up transmit side of Per Queue Threads
  ptq: Hook up receive side of Per Queue Threads
  doc: Documentation for Per Thread Queues

 Documentation/networking/scaling.rst | 195 +++++++-
 include/linux/cgroup.h               |   3 +
 include/linux/cgroup_subsys.h        |   4 +
 include/linux/netdevice.h            | 204 +++++++-
 include/linux/netqueue.h             |  25 +
 include/linux/sched.h                |   4 +
 include/net/ptq.h                    |  45 ++
 include/net/sock.h                   |  75 ++-
 kernel/cgroup/cgroup.c               |   9 +-
 kernel/fork.c                        |   4 +
 net/Kconfig                          |  18 +
 net/core/Makefile                    |   1 +
 net/core/dev.c                       | 177 +++++--
 net/core/filter.c                    |   4 +-
 net/core/net-sysfs.c                 | 201 +++++++-
 net/core/ptq.c                       | 688 +++++++++++++++++++++++++++
 net/core/sysctl_net_core.c           | 152 ++++--
 net/ipv4/af_inet.c                   |   6 +
 18 files changed, 1693 insertions(+), 122 deletions(-)
 create mode 100644 include/linux/netqueue.h
 create mode 100644 include/net/ptq.h
 create mode 100644 net/core/ptq.c

-- 
2.25.1

