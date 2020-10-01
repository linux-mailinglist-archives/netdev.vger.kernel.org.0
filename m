Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3AF28092D
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733186AbgJAVIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:08:07 -0400
Received: from thoth.sbs.de ([192.35.17.2]:56913 "EHLO thoth.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgJAVIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:08:06 -0400
Received: from mail3.siemens.de (mail3.siemens.de [139.25.208.14])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id 091KqE4a024200
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 22:52:14 +0200
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.50])
        by mail3.siemens.de (8.15.2/8.15.2) with ESMTP id 091KpxYW027868;
        Thu, 1 Oct 2020 22:52:12 +0200
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
Subject: [PATCH 3/7] Functions to fetch POSIX dynamic clock object
Date:   Thu,  1 Oct 2020 22:51:37 +0200
Message-Id: <20201001205141.8885-4-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201001205141.8885-1-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kernel functions to fetch a pointer to a POSIX dynamic clock
using a user file description dynamic clock ID.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 include/linux/posix-clock.h | 39 +++++++++++++++++++
 kernel/time/posix-clock.c   | 76 +++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
index 468328b1e1dd..e90bd90d3a01 100644
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -116,4 +116,43 @@ int posix_clock_register(struct posix_clock *clk, struct device *dev);
  */
 void posix_clock_unregister(struct posix_clock *clk);
 
+/**
+ * posix_clock_get_clock() - get reference to a posix clock
+ * @id: A user clockid that uses a posix clock
+ *
+ * Used by kernel code to get a reference to a posix clock.
+ * Increase the reference count, ensure the referece is not removed.
+ */
+struct posix_clock *posix_clock_get_clock(clockid_t id);
+
+/**
+ * posix_clock_put_clock() - release a reference to a posix clock
+ * @clk: The reference to a posix clock to release
+ *
+ * Release a reference to a posix clock.
+ * Reduce the reference count.
+ */
+int posix_clock_put_clock(struct posix_clock *clk);
+
+/**
+ * posix_clock_gettime() - get time from posix clock
+ * @clk: A reference to a posix clock
+ * @ts: pointer to a time structure used to store the time from the posix clock
+ *
+ * Retrieve the time from a posix clock.
+ * In case the clock device was removed, the function return error.
+ */
+int posix_clock_gettime(struct posix_clock *clk, struct timespec64 *ts);
+
+/**
+ * posix_clock_adjtime() - get tune parameters from posix clock
+ * @clk: A reference to a posix clock
+ * @tx: pointer to a kernel timex structure used to store
+ *      the tune parameters from the posix clock
+ *
+ * Retrieve the tune parameters from a posix clock.
+ * In case the clock device was removed, the function return error.
+ */
+int posix_clock_adjtime(struct posix_clock *clk, struct __kernel_timex *tx);
+
 #endif
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index 77c0c2370b6d..1e205eea6ebd 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -315,3 +315,79 @@ const struct k_clock clock_posix_dynamic = {
 	.clock_get_timespec	= pc_clock_gettime,
 	.clock_adj		= pc_clock_adjtime,
 };
+
+struct posix_clock *posix_clock_get_clock(clockid_t id)
+{
+	int err;
+	struct posix_clock_desc cd;
+
+	/* Verify we use posix clock ID */
+	if (!is_clockid_fd_clock(id))
+		return ERR_PTR(-EINVAL);
+
+	err = get_clock_desc(id, &cd);
+	if (err)
+		return ERR_PTR(err);
+
+	get_device(cd.clk->dev);
+
+	put_clock_desc(&cd);
+
+	return cd.clk;
+}
+EXPORT_SYMBOL_GPL(posix_clock_get_clock);
+
+int posix_clock_put_clock(struct posix_clock *clk)
+{
+	if (IS_ERR_OR_NULL(clk))
+		return -EINVAL;
+	put_device(clk->dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(posix_clock_put_clock);
+
+int posix_clock_gettime(struct posix_clock *clk, struct timespec64 *ts)
+{
+	int err;
+
+	if (IS_ERR_OR_NULL(clk))
+		return -EINVAL;
+
+	down_read(&clk->rwsem);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (clk->ops.clock_gettime)
+		err = clk->ops.clock_gettime(clk, ts);
+	else
+		err = -EOPNOTSUPP;
+
+	up_read(&clk->rwsem);
+	return err;
+}
+EXPORT_SYMBOL_GPL(posix_clock_gettime);
+
+int posix_clock_adjtime(struct posix_clock *clk, struct __kernel_timex *tx)
+{
+	int err;
+
+	/* Allow read only */
+	if (tx->modes != 0)
+		return -EINVAL;
+
+	if (IS_ERR_OR_NULL(clk))
+		return -EINVAL;
+
+	down_read(&clk->rwsem);
+
+	if (clk->zombie)
+		err = -ENODEV;
+	else if (clk->ops.clock_adjtime)
+		err = clk->ops.clock_adjtime(clk, tx);
+	else
+		err = -EOPNOTSUPP;
+
+	up_read(&clk->rwsem);
+	return err;
+}
+EXPORT_SYMBOL_GPL(posix_clock_adjtime);
-- 
2.20.1

