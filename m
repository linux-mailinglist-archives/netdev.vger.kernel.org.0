Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70285B2945
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 03:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390921AbfINBUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 21:20:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51187 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390908AbfINBUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 21:20:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id c10so4447666wmc.0
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 18:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xpGyrpYsqYNs3gqzpuKuC1wf0f5uDZOrK/D+7hf9LMA=;
        b=FbaXwXbkPNlYvASqS2i83WyU0BQHc6V0G+hXI7WVj/Ofp1ll8bsfyef+PgJgPUreu6
         GLkMpUTcefWPCbNIY2X2XZpngETOI+E8RYeB50uTKZeVGARX9wiOFiE/nZ/flEaoAb4v
         mkcRmPvWF2suVzXqz0vyP21IpE+EAMd0/d9inX+TwEJUbP0g4uHybqFksRpHDPZYn8+t
         xyUmWUZ0HSaAz6UnAEmHfycxxz0WTt4WU3dVAHnFaE74cBGk94IOWDldQFiqc8gE8atH
         urC8NJheK36WQLGYg96EShu943cqgmKnQJpr2e+VSPEhHPzd2LGFP3gJJ2+c7yz3iHqS
         2BwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xpGyrpYsqYNs3gqzpuKuC1wf0f5uDZOrK/D+7hf9LMA=;
        b=BWHLFsNAJLh0DLQqOPZW5sMEyFf1HgKcOwO8YwgoG6TZpf3nZyjoyYsERkAvGv8stm
         G901WhlT2W8+3K1dDE+5YLfmZC77uoaMERMJjLeFi7uQg3YlTPo+PFH+g4sk2Hn2Hvb5
         Rvm4Lfrfgje1eJ1k4qG3wZR5KHhpgn8SJqagKGQ8UV1tnX0ZDxMry/j47iZ2IyKsfKvh
         tmDbyVaZ/DrRUkBEYnTirKjW50G7A8ETNJwfBbsTna/MSZvzfjSs9p1WWLh9fa8X3lPj
         1I9LarnVIbYt7oU+z34hyq6CJ+M2rJfFgowqnJF32yBspN/nTlX+Jit8iD/+1UfJ/x5i
         WplQ==
X-Gm-Message-State: APjAAAUQGAnMbyaQOd3a16jP+WGauGoaSlbgaubExnN4t06sNzKnRRW2
        zQc0VmPHPtAmC+C2+X7Fk1Y=
X-Google-Smtp-Source: APXvYqy6jxwSJ/AUJ7BGo0BXsm9sYklBKZlqjzeVwb5hC6g0DmDgTfL9ulN5Qmizt7l+8GqWl8bRoQ==
X-Received: by 2002:a05:600c:214:: with SMTP id 20mr5788175wmi.112.1568424047185;
        Fri, 13 Sep 2019 18:20:47 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id o14sm21857979wrw.11.2019.09.13.18.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 18:20:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 0/7] tc-taprio offload for SJA1105 DSA
Date:   Sat, 14 Sep 2019 04:17:55 +0300
Message-Id: <20190914011802.1602-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second attempt to submit the tc-taprio offload model for
inclusion in the net tree. The sja1105 switch driver will provide the
first implementation of the offload. Only the bare minimum is added:

- The offload model and a DSA pass-through
- The hardware implementation
- The interaction with the netdev queues in the tagger code
- Documentation

What has been removed from the first attempt is support for
PTP-as-clocksource in sja1105.  This will be added as soon as the
offload model is settled.

Vinicius Costa Gomes (1):
  taprio: Add support for hardware offloading

Vladimir Oltean (6):
  net: dsa: Pass ndo_setup_tc slave callback to drivers
  net: dsa: sja1105: Add static config tables for scheduling
  net: dsa: sja1105: Advertise the 8 TX queues
  net: dsa: sja1105: Make HOSTPRIO a kernel config
  net: dsa: sja1105: Configure the Time-Aware Scheduler via tc-taprio
    offload
  docs: net: dsa: sja1105: Add info about the time-aware scheduler

 Documentation/networking/dsa/sja1105.rst      |  90 ++++
 drivers/net/dsa/sja1105/Kconfig               |  17 +
 drivers/net/dsa/sja1105/Makefile              |   4 +
 drivers/net/dsa/sja1105/sja1105.h             |   6 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   8 +
 drivers/net/dsa/sja1105/sja1105_main.c        |  28 +-
 .../net/dsa/sja1105/sja1105_static_config.c   | 167 +++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  48 +-
 drivers/net/dsa/sja1105/sja1105_tas.c         | 419 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_tas.h         |  44 ++
 include/linux/netdevice.h                     |   1 +
 include/net/dsa.h                             |   2 +
 include/net/pkt_sched.h                       |  23 +
 include/uapi/linux/pkt_sched.h                |   3 +-
 net/dsa/slave.c                               |  12 +-
 net/dsa/tag_sja1105.c                         |   3 +-
 net/sched/sch_taprio.c                        | 409 +++++++++++++++--
 17 files changed, 1231 insertions(+), 53 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.h

-- 

For those who want to follow along with the hardware implementation, the
manual is here:
https://www.nxp.com/docs/en/user-guide/UM10944.pdf

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

