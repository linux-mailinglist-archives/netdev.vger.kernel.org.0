Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A0C281B50
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388367AbgJBTBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:01:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:55787 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgJBTBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 15:01:49 -0400
IronPort-SDR: +8s2b7G7hTPgt2T/cnAImsvxcMRP4NKHmczGgFamSfPJ4+GuAuQ01cmuV5QdrGnaz71kJDrOVr
 LhS0uFPBFv1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9762"; a="162291709"
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="162291709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 12:01:47 -0700
IronPort-SDR: 7ZXFDPt2U2URGQibqNJARaRDhHITm0x8nIHE7g0b9a7MQ9j3/r01M6j1SxKbFYYJ5OPV1cy5f2
 1tyUrjrrxIpg==
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="352450628"
Received: from ssing11-mobl.amr.corp.intel.com (HELO ellie) ([10.209.68.166])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 12:01:45 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Erez Geva <erez.geva.ext@siemens.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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
Subject: Re: [PATCH 0/7] TC-ETF support PTP clocks series
In-Reply-To: <20201001205141.8885-1-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
Date:   Fri, 02 Oct 2020 12:01:45 -0700
Message-ID: <87eemg5u5i.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Erez,

Erez Geva <erez.geva.ext@siemens.com> writes:

> Add support for using PTP clock with
>  Traffic control Earliest TxTime First (ETF) Qdisc.
>
> Why do we need ETF to use PTP clock?
> Current ETF requires to synchronization the system clock
>  to the PTP Hardware clock (PHC) we want to send through.
> But there are cases that we can not synchronize the system clock with
>  the desire NIC PHC.
> 1. We use several NICs with several PTP domains that our device
>     is not allowed to be PTP master.
>    And we are not allowed to synchronize these PTP domains.
> 2. We are using another clock source which we need for our system.
>    Yet our device is not allowed to be PTP master.
> Regardless of the exact topology, as the Linux tradition is to allow
>  the user the freedom to choose, we propose a patch that will allow
>  the user to configure the TC-ETF with a PTP clock as well as
>  using the system clock.
> * NOTE: we do encourage the users to synchronize the system clock with
>   a PTP clock.
>  As the ETF watchdog uses the system clock.
>  Synchronizing the system clock with a PTP clock will probably
>   reduce the frequency different of the PHC and the system clock.
>  As sequence, the user might be able to reduce the ETF delta time
>   and the packets latency cross the network.
>
> Follow the decision to derive a dynamic clock ID from the file description
>  of an opened PTP clock device file.
> We propose a simple way to use the dynamic clock ID with the ETF Qdisc.
> We will submit a patch to the "tc" tool from the iproute2 project
>  once this patch is accepted.
>

In addition to what Thomas said, I would like to add some thoughts
(mostly re-wording some of Thomas' comments :-)).

I think that there's an underlying problem/limitation that is the cause
of the issue (or at least a step in the right direction) you are trying
to solve: the issue is that PTP clocks can't be used as hrtimers.

I didn't spend a lot of time thinking about how to solve this (the only
thing that comes to mind is having a timecounter, or similar, "software
view" over the PHC clock).

Anyway, my feeling is that until this is solved, we would only be
working around the problem, and creating even more hard to handle corner
cases.


Cheers,
-- 
Vinicius
