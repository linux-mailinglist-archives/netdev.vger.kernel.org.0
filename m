Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5726D649399
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 11:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiLKKMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 05:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLKKMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 05:12:21 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FFDBD2D5;
        Sun, 11 Dec 2022 02:12:20 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 12/12] ipvs: run_estimation should control the kthread tasks
Date:   Sun, 11 Dec 2022 11:12:04 +0100
Message-Id: <20221211101204.1751-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221211101204.1751-1-pablo@netfilter.org>
References: <20221211101204.1751-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Change the run_estimation flag to start/stop the kthread tasks.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Cc: yunhong-cgl jiang <xintian1976@gmail.com>
Cc: "dust.li" <dust.li@linux.alibaba.com>
Reviewed-by: Jiri Wiesner <jwiesner@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/ipvs-sysctl.rst |  4 ++--
 include/net/ip_vs.h                      |  6 +++--
 net/netfilter/ipvs/ip_vs_ctl.c           | 29 +++++++++++++++++++++++-
 net/netfilter/ipvs/ip_vs_est.c           |  2 +-
 4 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
index 1b778705d706..3fb5fa142eef 100644
--- a/Documentation/networking/ipvs-sysctl.rst
+++ b/Documentation/networking/ipvs-sysctl.rst
@@ -324,8 +324,8 @@ run_estimation - BOOLEAN
 	0 - disabled
 	not 0 - enabled (default)
 
-	If disabled, the estimation will be stop, and you can't see
-	any update on speed estimation data.
+	If disabled, the estimation will be suspended and kthread tasks
+	stopped.
 
 	You can always re-enable estimation by setting this value to 1.
 	But be careful, the first estimation after re-enable is not
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index dc51b5497cf7..c6c61100d244 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1605,8 +1605,10 @@ void ip_vs_est_kthread_stop(struct ip_vs_est_kt_data *kd);
 static inline void ip_vs_est_stopped_recalc(struct netns_ipvs *ipvs)
 {
 #ifdef CONFIG_SYSCTL
-	ipvs->est_stopped = ipvs->est_cpulist_valid &&
-			    cpumask_empty(sysctl_est_cpulist(ipvs));
+	/* Stop tasks while cpulist is empty or if disabled with flag */
+	ipvs->est_stopped = !sysctl_run_estimation(ipvs) ||
+			    (ipvs->est_cpulist_valid &&
+			     cpumask_empty(sysctl_est_cpulist(ipvs)));
 #endif
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 38df3ee655ed..c9f598505642 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2056,6 +2056,32 @@ static int ipvs_proc_est_nice(struct ctl_table *table, int write,
 	return ret;
 }
 
+static int ipvs_proc_run_estimation(struct ctl_table *table, int write,
+				    void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct netns_ipvs *ipvs = table->extra2;
+	int *valp = table->data;
+	int val = *valp;
+	int ret;
+
+	struct ctl_table tmp_table = {
+		.data = &val,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+	};
+
+	ret = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
+	if (write && ret >= 0) {
+		mutex_lock(&ipvs->est_mutex);
+		if (*valp != val) {
+			*valp = val;
+			ip_vs_est_reload_start(ipvs);
+		}
+		mutex_unlock(&ipvs->est_mutex);
+	}
+	return ret;
+}
+
 /*
  *	IPVS sysctl table (under the /proc/sys/net/ipv4/vs/)
  *	Do not change order or insert new entries without
@@ -2230,7 +2256,7 @@ static struct ctl_table vs_vars[] = {
 		.procname	= "run_estimation",
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= ipvs_proc_run_estimation,
 	},
 	{
 		.procname	= "est_cpulist",
@@ -4323,6 +4349,7 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
 	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
 	ipvs->sysctl_run_estimation = 1;
+	tbl[idx].extra2 = ipvs;
 	tbl[idx++].data = &ipvs->sysctl_run_estimation;
 
 	ipvs->est_cpulist_valid = 0;
diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index e0f5f5da5b6d..df56073bb282 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -212,7 +212,7 @@ static int ip_vs_estimation_kthread(void *data)
 				kd->est_timer = now;
 		}
 
-		if (sysctl_run_estimation(ipvs) && kd->tick_len[row])
+		if (kd->tick_len[row])
 			ip_vs_tick_estimation(kd, row);
 
 		row++;
-- 
2.30.2

