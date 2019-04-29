Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D305ECEE
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfD2WtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:49:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:39185 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729593AbfD2WtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:49:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 15:49:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="166072445"
Received: from ellie.jf.intel.com ([10.54.70.78])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2019 15:49:08 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, olteanv@gmail.com,
        timo.koskiahde@tttech.com, m-karicheri2@ti.com
Subject: [PATCH net-next v1 0/4] net/sched: taprio change schedules
Date:   Mon, 29 Apr 2019 15:48:29 -0700
Message-Id: <20190429224833.18208-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes from RFC:
 - Removed the patches for taprio offloading, because of the lack of
   in-tree users;
 - Updated the links to point to the PATCH version of this series;  

Original cover letter:

Overview
--------

This RFC has two objectives, it adds support for changing the running
schedules during "runtime", explained in more detail later, and
proposes an interface between taprio and the drivers for hardware
offloading.

These two different features are presented together so it's clear what
the "final state" would look like. But after the RFC stage, they can
be proposed (and reviewed) separately.

Changing the schedules without disrupting traffic is important for
handling dynamic use cases, for example, when streams are
added/removed and when the network configuration changes.

Hardware offloading support allows schedules to be more precise and
have lower resource usage.


Changing schedules
------------------

The same as the other interfaces we proposed, we try to use the same
concepts as the IEEE 802.1Q-2018 specification. So, for changing
schedules, there are an "oper" (operational) and an "admin" schedule.
The "admin" schedule is mutable and not in use, the "oper" schedule is
immutable and is in use.

That is, when the user first adds an schedule it is in the "admin"
state, and it becomes "oper" when its base-time (basically when it
starts) is reached.

What this means is that now it's possible to create taprio with a schedule:

$ tc qdisc add dev IFACE parent root handle 100 taprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      base-time 10000000 \
      sched-entry S 03 300000 \
      sched-entry S 02 300000 \
      sched-entry S 06 400000 \
      clockid CLOCK_TAI
      
And then, later, after the previous schedule is "promoted" to "oper",
add a new ("admin") schedule to be used some time later:

$ tc qdisc change dev IFACE parent root handle 100 taprio \
      base-time 1553121866000000000 \
      sched-entry S 02 500000 \
      sched-entry S 0f 400000 \
      clockid CLOCK_TAI

When enabling the ability to change schedules, it makes sense to add
two more defined knobs to schedules: "cycle-time" allows to truncate a
cycle to some value, so it repeats after a well-defined value;
"cycle-time-extension" controls how much an entry can be extended if
it's the last one before the change of schedules, the reason is to
avoid a very small cycle when transitioning from a schedule to
another.

With these, taprio in the software mode should provide a fairly
complete implementation of what's defined in the Enhancements for
Scheduled Traffic parts of the specification.


Hardware offload
----------------

Some workloads require better guarantees from their schedules than
what's provided by the software implementation. This series proposes
an interface for configuring schedules into compatible network
controllers.

This part is proposed together with the support for changing
schedules, because it raises questions like, should the "qdisc" side
be responsible of providing visibility into the schedules or should it
be the driver?

In this proposal, the driver is called passing the new schedule as
soon as it is validated, and the "core" qdisc takes care of displaying
(".dump()") the correct schedules at all times. It means that some
logic would need to be duplicated in the driver, if the hardware
doesn't have support for multiple schedules. But as taprio doesn't
have enough information about the underlying controller to know how
much in advance a schedule needs to be informed to the hardware, it
feels like a fair compromise.

The hardware offloading part of this proposal also tries to define an
interface for frame-preemption and how it interacts with the
scheduling of traffic, see Section 8.6.8.4 of IEEE 802.1Q-2018 for
more information.

One important difference between the qdisc interface and the
qdisc-driver interface, is that the "gate mask" on the qdisc side
references traffic classes, that is bit 0 of the gate mask means
Traffic Class 0, and in the driver interface, it specifies the queues,
that is bit 0 means queue 0. That is to say that taprio converts the
references to traffic classes to references to queues before sending
the offloading request to the driver.


Request for help
----------------

I would like that interested driver maintainers could take a look at
the proposed interface and see if it's going to be too awkward for any
particular device. Also, pointers to available documentation would be
appreciated. The idea here is to start a discussion so we can have an
interface that would work for multiple vendors.


Links
-----

kernel patches:
https://github.com/vcgomes/net-next/tree/taprio-add-support-for-change-v3

iproute2 patches:
https://github.com/vcgomes/iproute2/tree/taprio-add-support-for-change-v3



Vinicius Costa Gomes (4):
  taprio: Fix potencial use of invalid memory during dequeue()
  taprio: Add support adding an admin schedule
  taprio: Add support for setting the cycle-time manually
  taprio: Add support for cycle-time-extension

 include/uapi/linux/pkt_sched.h |  13 +
 net/sched/sch_taprio.c         | 605 ++++++++++++++++++++++-----------
 2 files changed, 412 insertions(+), 206 deletions(-)

-- 
2.21.0

