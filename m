Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F66FB2DA1
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 03:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfIOBxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 21:53:42 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36746 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfIOBxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 21:53:42 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so35467754wrd.3
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 18:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yK5EI9pWNYVGtFZ1I1ATBu57WYrOlRIdlmTNhI8Knwo=;
        b=IOdjPBY69xkyEyQOm5eVn3CFgDUlYUk9h531Mf7OoKnHeo0B3bchon39oe3USqSsma
         7Pi7BgSOoMmKTGI10jVl8EJMwszm1m2gJqwOym9QH5pvmuNcJx9//WXrC5uNddomjPDg
         veFRzi1D+r9AEbVnH99vwuf6Nmzp4kA/f4olObI6sqQOS1cVTALNpNcal5cgALZmsOF4
         F4txdbFwky2q+mV98+ur0bUr9Xw5C3x9ae3QU7tREK47MQvQ9vErYlPLapTn6I/Fz87k
         Wx4WOTtIWGmcLqSIPBQNYiHX7is5egPhEJ+YU0+vC6l6/BxL6NxdXR/ZtRyvMIZAbwn3
         jF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yK5EI9pWNYVGtFZ1I1ATBu57WYrOlRIdlmTNhI8Knwo=;
        b=WhdffimZAr5TmkLNU/F/I/FtpQlczxS/b7cPEXNrGFCfetaLj778oSMsOVisEPo5zu
         ynN+Jf8kbUQ4KtYXab7JTtpXLZxiKBdXr8oTrAmHwOREL1hyyoLevScNj92CDDv9ScKt
         GUD3OUbaqE6NRBqQprbv/lBmvwC97zpahGwYA/sPcr4Bryu7heGOD3ICTICoYKQZBG2M
         sC0petmK3LvRke7C6Zf7h1IMwoCBhkwE5ATPMi8LOjt/lIcX+ODHbtoj6+lPpHrfYBoE
         xAaaif1VBx4JjXelaEF6qdFIw3RONawktzE6j66H/5fD900+bFK+/jRczrIznGcU5yKt
         +z1w==
X-Gm-Message-State: APjAAAUXzVzfiTwpKyduzaFu1FB4KBrwQSEN6UM91B72byZhwxBgp2m0
        dozg8qR3lRQcn/gGLMYklFg=
X-Google-Smtp-Source: APXvYqxprOz36k9SiD5Hf3xF+Hk61UwYhqol2oD5NxKFceIj+yZ/Qq49p1founKLkDrE1XKXBP9/yw==
X-Received: by 2002:a5d:4e89:: with SMTP id e9mr1058665wru.48.1568512419032;
        Sat, 14 Sep 2019 18:53:39 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id p19sm5627044wmg.31.2019.09.14.18.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 18:53:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 0/7] tc-taprio offload for SJA1105 DSA
Date:   Sun, 15 Sep 2019 04:53:07 +0300
Message-Id: <20190915015314.26605-1-olteanv@gmail.com>
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
 drivers/net/dsa/sja1105/sja1105_tas.c         | 427 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_tas.h         |  42 ++
 include/linux/netdevice.h                     |   1 +
 include/net/dsa.h                             |   2 +
 include/net/pkt_sched.h                       |  23 +
 include/uapi/linux/pkt_sched.h                |   3 +-
 net/dsa/slave.c                               |  12 +-
 net/dsa/tag_sja1105.c                         |   3 +-
 net/sched/sch_taprio.c                        | 409 +++++++++++++++--
 17 files changed, 1237 insertions(+), 53 deletions(-)
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

