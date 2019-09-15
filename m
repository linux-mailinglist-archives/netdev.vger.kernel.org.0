Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD4BB2DB5
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 04:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfIOCAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 22:00:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50426 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfIOCAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 22:00:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id 5so534947wmg.0
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 19:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=j1opGAkyAiu8yrOzFxy7OzCQnsLgY4dkPklXjU9n2kk=;
        b=gkN6ZkPNl/SYkO1j4Gpd2ZKTGEaywT5s9JgzXx9ATa+qf6ALqzLTvYrxr7qfLb8lce
         7bMngoQucWaWF3s1eLHIo2AVbTiNsT1gaHfhhwGNUymJtmELn57dSJ5SQkrE9nlq187W
         DVb6t6sFsvXHFD2bPdCylo9fmlmJgapPf9vxIfODGMl3PeOQTEK3UIDK17ECDywNnjiJ
         hPy6/EhXYS5iO2nDLXnrihQ67lf+pTjla/++kZNKXJxwvEI1VoEppMTmOZU/YIDX9ahH
         d2E0Nu0nxUb1jEOZASSmW7tabGHc24k8G6DembRfMNMNuru8EVyVzrFgFBBuCgLVI/e9
         UXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j1opGAkyAiu8yrOzFxy7OzCQnsLgY4dkPklXjU9n2kk=;
        b=mWRFpeiEXQNoCUGoS7aAi+4f/4A6++0TtCxpppnuO06xz/BYIBqDeLnerXi1GEe+8j
         IFC+S/vVifN1sWAU0S1joo//vBeIwOHZ2d+aJSR9aCOaPRZGSHpCZ3XptKZHPB+cZauy
         wTk0eU7kF1HE+Tct1+yTtldTm1lV9DeXSSp+AoTud7480IDysW/81hp5prG2w8GUFoH3
         7mesWPg+SoX1ih3HTGoq78HIMGDbKD2m1TzPYLX7/ccK26W2OjT98Zu1cNIzAbbCh4xk
         Fma53EfiW9oVbcpcXB07gujEZsqOovItlQe5U1hUl4HVInyWY/0GACraQNGzHkPtSMON
         yZjg==
X-Gm-Message-State: APjAAAW30C2zj/UAHEMjB1Enul0jKkkWoC55lqDREiHqchYu85I3xAYM
        akjUk6k24HSkgknP50xSZOTEgbVXE3d0HQ==
X-Google-Smtp-Source: APXvYqyMRsDDj3mFgYoO/9UFVJbfrGrlP2Ijdo9u0yq1yLLe0p0+bFmj5HIX5TBOm+NupcS9FljVmw==
X-Received: by 2002:a1c:f403:: with SMTP id z3mr8083988wma.74.1568512808618;
        Sat, 14 Sep 2019 19:00:08 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id q15sm7216333wmb.28.2019.09.14.19.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 19:00:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        jose.abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 0/6] tc-taprio offload for SJA1105 DSA
Date:   Sun, 15 Sep 2019 04:59:57 +0300
Message-Id: <20190915020003.27926-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third attempt to submit the tc-taprio offload model for
inclusion in the networking tree. The sja1105 switch driver will provide
the first implementation of the offload. Only the bare minimum is added:

- The offload model and a DSA pass-through
- The hardware implementation
- The interaction with the netdev queues in the tagger code
- Documentation

What has been removed from previous attempts is support for
PTP-as-clocksource in sja1105, as well as configuring the traffic class
for management traffic.  These will be added as soon as the offload
model is settled.

Vinicius Costa Gomes (1):
  taprio: Add support for hardware offloading

Vladimir Oltean (5):
  net: dsa: Pass ndo_setup_tc slave callback to drivers
  net: dsa: sja1105: Add static config tables for scheduling
  net: dsa: sja1105: Advertise the 8 TX queues
  net: dsa: sja1105: Configure the Time-Aware Scheduler via tc-taprio
    offload
  docs: net: dsa: sja1105: Add info about the Time-Aware Scheduler

 Documentation/networking/dsa/sja1105.rst      |  90 ++++
 drivers/net/dsa/sja1105/Kconfig               |   8 +
 drivers/net/dsa/sja1105/Makefile              |   4 +
 drivers/net/dsa/sja1105/sja1105.h             |   6 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   8 +
 drivers/net/dsa/sja1105/sja1105_main.c        |  26 +-
 .../net/dsa/sja1105/sja1105_static_config.c   | 167 +++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  48 +-
 drivers/net/dsa/sja1105/sja1105_tas.c         | 423 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_tas.h         |  41 ++
 include/linux/netdevice.h                     |   1 +
 include/net/dsa.h                             |   2 +
 include/net/pkt_sched.h                       |  23 +
 include/uapi/linux/pkt_sched.h                |   3 +-
 net/dsa/slave.c                               |  12 +-
 net/dsa/tag_sja1105.c                         |   3 +-
 net/sched/sch_taprio.c                        | 409 +++++++++++++++--
 17 files changed, 1222 insertions(+), 52 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.h

-- 

For those who want to follow along with the hardware implementation, the
manual is here:
https://www.nxp.com/docs/en/user-guide/UM10944.pdf

Changes in v3 (actually v4 which is what v3 should have been):
- Removed "[PATCH v2 net-next 5/7] net: dsa: sja1105: Make HOSTPRIO a
  kernel config", which was deemed non-critical at this point.
- A bit of cleanup in "[PATCH v3 net-next 5/6] net: dsa: sja1105:
  Configure the Time-Aware Scheduler via tc-taprio offload".

Notable changes in v2:
- Made the series independent from PTP (which is temporarily removed)
- Changed the meaning of the gate_mask - it is now acting on traffic
  classes even in the view exposed by taprio to drivers.
- Removed the next_sched hrtimer.
- Summarized one of the responses given to Vinicius into a new
  documentation section.

The first version of the net-next patch series can be found here:

https://www.spinics.net/lists/netdev/msg597214.html

Changes in the first version of the net-next series compared to RFC v2:
- Made "flags 1" and "flags 2" mutually exclusive in the taprio qdisc
- Moved taprio_enable_offload and taprio_disable_offload out of atomic
  context - spin_lock_bh(qdisc_lock(sch)). This allows drivers that
  implement the ndo_setup_tc to sleep and for taprio memory to be
  allocated with GFP_KERNEL. The only thing that was kept under the
  spinlock is the assignment of the q->dequeue and q->peek pointers.
- Finally making proper use of own API - added a taprio_alloc helper to
  avoid passing stack memory to drivers.

The second version of the RFC is at:
https://www.spinics.net/lists/netdev/msg596663.html

Changes in v2 of the RFC since v1:
- Adapted the taprio offload patch to work by specifying "flags 2" to
  the iproute2-next tc. At the moment I don't clearly understand whether
  the full offload and the txtime assist ("flags 1") are mutually
  exclusive or not (i.e. whether a "flags 3" mode should be rejected,
  which it currently isn't).
- Added reference counting to the taprio offload structure. Maybe the
  function names and placement could have been better though. As for the
  other complaint (cycle time calculation) it got fixed in the taprio
  parser in the meantime.
- Converted sja1105 to use the hardware PTP registers, and save/restore
  the PTP time across resets.
- Made the DSA callback for ndo_setup_tc a bit more generic, but I don't
  know whether it fulfills expectations. Drivers still can't do blocking
  operations in its execution context.
- Added a state machine for starting/stopping the scheduler based on the
  last command run on the PTP clock.

The first RFC from July can be seen at:
https://lists.openwall.net/netdev/2019/07/07/81

Original cover letter:

Using Vinicius Costa Gomes' configuration interface for 802.1Qbv (later
resent by Voon Weifeng for the stmmac driver), I am submitting for
review a draft implementation of this offload for a DSA switch.

I don't want to insist too much on the hardware specifics of SJA1105
which isn't otherwise very compliant to the IEEE spec.

In order to be able to test with Vedang Patel's iproute2 patch for
taprio offload (https://www.spinics.net/lists/netdev/msg573072.html)
I had to actually revert the txtime-assist branch as it had changed the
iproute2 interface.

In terms of impact for DSA drivers, I would like to point out that:

- Maybe somebody should pre-populate qopt->cycle_time in case the user
  does not provide one. Otherwise each driver needs to iterate over the
  GCL once, just to set the cycle time (right now stmmac does as well).

- Configuring the switch over SPI cannot apparently be done from this
  ndo_setup_tc callback because it runs in atomic context. I also have
  some downstream patches to offload tc clsact matchall with mirred
  action, but in that case it looks like the atomic context restriction
  does not apply.

- I had to copy the struct tc_taprio_qopt_offload to driver private
  memory because a static config needs to be constructed every time a
  change takes place, and there are up to 4 switch ports that may take a
  TAS configuration. I have created a private
  tc_taprio_qopt_offload_copy() helper for this - I don't know whether
  it's of any help in the general case.

There is more to be done however. The TAS needs to be integrated with
the PTP driver. This is because with a PTP clock source, the base time
is written dynamically to the PTPSCHTM (PTP schedule time) register and
must be a time in the future. Then the "real" base time of each port's
TAS config can be offset by at most ~50 ms (the DELTA field from the
Schedule Entry Points Table) relative to PTPSCHTM.
Because base times in the past are completely ignored by this hardware,
we need to decide if it's ok behaviorally for a driver to "roll" a past
base time into the immediate future by incrementally adding the cycle
time (so the phase doesn't change). If it is, then decide by how long in
the future it is ok to do so. Or alternatively, is it preferable if the
driver errors out if the user-supplied base time is in the past and the
hardware doesn't like it? But even then, there might be fringe cases
when the base time becomes a past PTP time right as the driver tries to
apply the config.
Also applying a tc-taprio offload to a second SJA1105 switch port will
inevitably need to roll the first port's (now past) base time into an
equivalent future time.
All of this is going to be complicated even further by the fact that
resetting the switch (to apply the tc-taprio offload) makes it reset its
PTP time.

2.17.1

