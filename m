Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50D280906
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733120AbgJAVDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:03:08 -0400
Received: from goliath.siemens.de ([192.35.17.28]:55451 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733099AbgJAVDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:03:07 -0400
Received: from mail3.siemens.de (mail3.siemens.de [139.25.208.14])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 091Kq2BK008877
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 22:52:02 +0200
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.50])
        by mail3.siemens.de (8.15.2/8.15.2) with ESMTP id 091KpxYT027868;
        Thu, 1 Oct 2020 22:52:00 +0200
From:   Erez Geva <erez.geva.ext@siemens.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: [PATCH 0/7] TC-ETF support PTP clocks series
Date:   Thu,  1 Oct 2020 22:51:34 +0200
Message-Id: <20201001205141.8885-1-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for using PTP clock with
 Traffic control Earliest TxTime First (ETF) Qdisc.

Why do we need ETF to use PTP clock?
Current ETF requires to synchronization the system clock
 to the PTP Hardware clock (PHC) we want to send through.
But there are cases that we can not synchronize the system clock with
 the desire NIC PHC.
1. We use several NICs with several PTP domains that our device
    is not allowed to be PTP master.
   And we are not allowed to synchronize these PTP domains.
2. We are using another clock source which we need for our system.
   Yet our device is not allowed to be PTP master.
Regardless of the exact topology, as the Linux tradition is to allow
 the user the freedom to choose, we propose a patch that will allow
 the user to configure the TC-ETF with a PTP clock as well as
 using the system clock.
* NOTE: we do encourage the users to synchronize the system clock with
  a PTP clock.
 As the ETF watchdog uses the system clock.
 Synchronizing the system clock with a PTP clock will probably
  reduce the frequency different of the PHC and the system clock.
 As sequence, the user might be able to reduce the ETF delta time
  and the packets latency cross the network.

Follow the decision to derive a dynamic clock ID from the file description
 of an opened PTP clock device file.
We propose a simple way to use the dynamic clock ID with the ETF Qdisc.
We will submit a patch to the "tc" tool from the iproute2 project
 once this patch is accepted.

The patches contain:
1. Add function to verify that a dynamic clock ID is derived
    from file description.
   The function follows the clock ID convention for dynamic clock ID
    for file description.
  The function will be used in the second patch.

2. Function to get main system oscillator calibration state.

3. Functions to get and put POSIX clock reference of
    a PTP Hardware Clock (PHC).
   The get function uses a dynamic clock ID created by application space.
   The purpose is that a module can hold a POSIX clock reference after the
    configuration application closed the PTP clock device file,
    and though the dynamic clock ID can not be used any further.
   The POSIX clock refereces are used by the TC-ETF.

4. A fix of the range check in qdisc_watchdog_schedule_range_ns().

5. During testing of ETF, we notice issue with the high-resolution timer
    the ETF Qdisc watchdog uses.
   The timer was set for a sleep of 300 nanoseconds but
    end up sleeping for 3 milliseconds.
   The problem happens when the timer is already active and
    the current expire is earlier then a new expire.
   So, we add a new TC schedule function that do not reprogram the timer
    under these conditions.
   The use of the function make sense as the Qdisc watchdog does act as
    watchdog.
   The Qdisc watchdog can expire earlier.
   However, if the watchdog is late, packets are dropped.

6. Add kernel configuration for TC-ETF watchdog range.
   As the range is characteristic of Hardware,
   that seems to be the proper way.

7. Add support for using PHC clock with TC-ETF.

Erez Geva (7):
  POSIX clock ID check function
  Function to retrieve main clock state
  Functions to fetch POSIX dynamic clock object
  Fix qdisc_watchdog_schedule_range_ns range check
  Traffic control using high-resolution timer issue
  TC-ETF code improvements
  TC-ETF support PTP clocks

 include/linux/posix-clock.h     |  39 +++++++++
 include/linux/posix-timers.h    |   5 ++
 include/linux/timex.h           |   1 +
 include/net/pkt_sched.h         |   2 +
 include/uapi/linux/net_tstamp.h |   5 ++
 kernel/time/posix-clock.c       |  76 ++++++++++++++++
 kernel/time/posix-timers.c      |   2 +-
 kernel/time/timekeeping.c       |   9 ++
 net/sched/Kconfig               |   8 ++
 net/sched/sch_api.c             |  36 +++++++-
 net/sched/sch_etf.c             | 148 +++++++++++++++++++++++++-------
 11 files changed, 298 insertions(+), 33 deletions(-)


base-commit: a1b8638ba1320e6684aa98233c15255eb803fac7
-- 
2.20.1

