Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0292280904
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733006AbgJAVDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:03:00 -0400
Received: from goliath.siemens.de ([192.35.17.28]:55423 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbgJAVDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:03:00 -0400
Received: from mail3.siemens.de (mail3.siemens.de [139.25.208.14])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 091Kq7rb008970
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 22:52:07 +0200
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.50])
        by mail3.siemens.de (8.15.2/8.15.2) with ESMTP id 091KpxYU027868;
        Thu, 1 Oct 2020 22:52:06 +0200
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
Subject: [PATCH 1/7] POSIX clock ID check function
Date:   Thu,  1 Oct 2020 22:51:35 +0200
Message-Id: <20201001205141.8885-2-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201001205141.8885-1-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add function to check whether a clock ID refer to
a file descriptor of a POSIX dynamic clock.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 include/linux/posix-timers.h | 5 +++++
 kernel/time/posix-timers.c   | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 896c16d2c5fb..7cb551bbb763 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -57,6 +57,11 @@ static inline int clockid_to_fd(const clockid_t clk)
 	return ~(clk >> 3);
 }
 
+static inline bool is_clockid_fd_clock(const clockid_t clk)
+{
+	return (clk < 0) && ((clk & CLOCKFD_MASK) == CLOCKFD);
+}
+
 #ifdef CONFIG_POSIX_TIMERS
 
 /**
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index bf540f5a4115..806465233303 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1400,7 +1400,7 @@ static const struct k_clock *clockid_to_kclock(const clockid_t id)
 	clockid_t idx = id;
 
 	if (id < 0) {
-		return (id & CLOCKFD_MASK) == CLOCKFD ?
+		return is_clockid_fd_clock(id) ?
 			&clock_posix_dynamic : &clock_posix_cpu;
 	}
 
-- 
2.20.1

