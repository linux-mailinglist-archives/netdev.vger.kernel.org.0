Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9A9615AE
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 19:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfGGR3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 13:29:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43721 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfGGR3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 13:29:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so14553962wru.10
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 10:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Jg10yt5e1hk7KDl6JJMa90s8QpPDD9tkngIcGvDY4yE=;
        b=simMihbM/kDcDgpxw6tOcUl/4u8b/jyYkUKb2rjZbjWXe/JwMHEF+2HQWiSCNjEIlC
         MnZn1uN8lb4c8Z3YIddeQruGNYpX1T95ouaocWrxbZQchMrl/hh79wnuzNoE0pPxshlk
         mW0wM8RcRrHoZ6QTY+MHe0sEY2MWGKQA8Qa+emjWAsNZBAK2zOx/XqXoUSo0GH9o0jec
         FOoiSYyUtZsghpnMnhsb0YzVj3x0hKdDjxRwsMa+wXOHQWFMdXzkAvTMzGo295DUUT7Z
         KEqsCcEZlztjqKHHGd6SJ7wl5jUEjh8lplpwXi5Z3tMUj6ntrytDi6Nrh1efqBUaPv7l
         vw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jg10yt5e1hk7KDl6JJMa90s8QpPDD9tkngIcGvDY4yE=;
        b=aX78v70LgAFsDJnBafMG6eXRiudzObZzOOh6KdJUuIp205tbe+JJJ9u18UGJEqz6Y9
         nY6SAXN1+LQb9FOT3d3GcagISQ3Mg8nNwuvtHNnnxfSMp7IhU6bL8lv8wHz+ntm3MOJC
         GOqLe7D8xG47tHZc3hiLpPBElzRSlLuDq2bXoy6xD8PEGCB/HHnQZV03gGCnvWk1/lgr
         VfVigEH3ukaFRzKzh4TCoJpXRq0zFe9tYZkoqqL9lAWL/qaMj7t29xmXqbZ0OLMDdTd3
         WotFLUF6+yU/ZPcc9fPxi1hrZEaW9gmg+7INLbR1MVHfj9xJxqlilQHllJunHofLaa45
         bXYw==
X-Gm-Message-State: APjAAAXQ1edMgmaD1jOkhMDycx/pHc6GlxWh+PzhKBotH1vEntHwOQ83
        VW/PZS1J2le2re+4wF9EkNs=
X-Google-Smtp-Source: APXvYqwJiv+ElOw0HTR1MULebOiO1yuNNNtAjZqc3tg6AAwbu8AJ1ihOusg+JQd+nbGpk2S3Y2I38A==
X-Received: by 2002:a5d:670b:: with SMTP id o11mr14293864wru.311.1562520572934;
        Sun, 07 Jul 2019 10:29:32 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id g14sm14280463wro.11.2019.07.07.10.29.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 10:29:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 0/6] tc-taprio offload for SJA1105 DSA
Date:   Sun,  7 Jul 2019 20:29:15 +0300
Message-Id: <20190707172921.17731-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Vinicius Costa Gomes (1):
  taprio: Add support for hardware offloading

Vladimir Oltean (5):
  Revert "Merge branch 'net-sched-Add-txtime-assist-support-for-taprio'"
  net: dsa: Pass tc-taprio offload to drivers
  net: dsa: sja1105: Add static config tables for scheduling
  net: dsa: sja1105: Advertise the 8 TX queues
  net: dsa: sja1105: Configure the Time-Aware Shaper via tc-taprio
    offload

 drivers/net/dsa/sja1105/Kconfig               |   8 +
 drivers/net/dsa/sja1105/Makefile              |   4 +
 drivers/net/dsa/sja1105/sja1105.h             |   6 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   8 +
 drivers/net/dsa/sja1105/sja1105_main.c        |  19 +-
 .../net/dsa/sja1105/sja1105_static_config.c   | 167 +++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  48 +-
 drivers/net/dsa/sja1105/sja1105_tas.c         | 452 ++++++++++++
 drivers/net/dsa/sja1105/sja1105_tas.h         |  22 +
 drivers/net/ethernet/intel/igb/igb_main.c     |   1 -
 include/linux/netdevice.h                     |   1 +
 include/net/dsa.h                             |   3 +
 include/net/pkt_sched.h                       |  18 +
 include/uapi/linux/pkt_sched.h                |  11 +-
 net/dsa/slave.c                               |  14 +
 net/dsa/tag_sja1105.c                         |   3 +-
 net/sched/sch_etf.c                           |  10 -
 net/sched/sch_taprio.c                        | 666 ++++++++----------
 18 files changed, 1060 insertions(+), 401 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.h

-- 
2.17.1

