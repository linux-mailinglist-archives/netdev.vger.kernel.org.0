Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59122808F7
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbgJAVBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:01:30 -0400
Received: from david.siemens.de ([192.35.17.14]:54201 "EHLO david.siemens.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgJAVBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:01:30 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2020 17:01:28 EDT
Received: from mail3.siemens.de (mail3.siemens.de [139.25.208.14])
        by david.siemens.de (8.15.2/8.15.2) with ESMTPS id 091KqGnL029133
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 22:52:16 +0200
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.50])
        by mail3.siemens.de (8.15.2/8.15.2) with ESMTP id 091KpxYX027868;
        Thu, 1 Oct 2020 22:52:15 +0200
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
Subject: [PATCH 4/7] Fix qdisc_watchdog_schedule_range_ns range check
Date:   Thu,  1 Oct 2020 22:51:38 +0200
Message-Id: <20201001205141.8885-5-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201001205141.8885-1-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

   - As all parameters are unsigned.

   - If 'expires' is bigger than 'last_expires' then the left expression
     overflows.

   - It is better to use addition and check both ends of the range.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 net/sched/sch_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 2a76a2f5ed88..ebf59ca1faab 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -632,7 +632,8 @@ void qdisc_watchdog_schedule_range_ns(struct qdisc_watchdog *wd, u64 expires,
 		/* If timer is already set in [expires, expires + delta_ns],
 		 * do not reprogram it.
 		 */
-		if (wd->last_expires - expires <= delta_ns)
+		if (wd->last_expires >= expires &&
+		    wd->last_expires <= expires + delta_ns)
 			return;
 	}
 
-- 
2.20.1

