Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF96813F642
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437202AbgAPTCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:02:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388687AbgAPRFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD2DC24653;
        Thu, 16 Jan 2020 17:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194341;
        bh=e/9Z3XcsxP40y7lkufZoExY3PVKO3rkQTP7TqxKknR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2vd60uSVs2suaqcBHY0TGtKsswcWQp/8qeHS5uN4GNQRnj1Kz2rVUlbR8T0e0FuA
         NdlywprSF0Ynpie+IU2P1CGlgX6ZuRm3ZSWvtOim2cpezS1Pl5ZEX62qs5pRe2k84k
         W7hMNFoSPi3cvm2i4jL+VjM7aNdIlm8Vg3MS5JgM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leandro Dorileo <leandro.maciel.dorileo@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 284/671] net/sched: cbs: fix port_rate miscalculation
Date:   Thu, 16 Jan 2020 11:58:42 -0500
Message-Id: <20200116170509.12787-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leandro Dorileo <leandro.maciel.dorileo@intel.com>

[ Upstream commit e0a7683d30e91e30ee6cf96314ae58a0314a095e ]

The Credit Based Shaper heavily depends on link speed to calculate
the scheduling credits, we can't properly calculate the credits if the
device has failed to report the link speed.

In that case we can't dequeue packets assuming a wrong port rate that will
result into an inconsistent credit distribution.

This patch makes sure we fail to dequeue case:

1) __ethtool_get_link_ksettings() reports error or 2) the ethernet driver
failed to set the ksettings' speed value (setting link speed to
SPEED_UNKNOWN).

Additionally we properly re calculate the port rate whenever the link speed
is changed.

Fixes: 3d0bd028ffb4a ("net/sched: Add support for HW offloading for CBS")
Signed-off-by: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Reviewed-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cbs.c | 98 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 84 insertions(+), 14 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index e26a24017faa..81f84cb5dd23 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -61,16 +61,20 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/skbuff.h>
+#include <net/netevent.h>
 #include <net/netlink.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
 
+static LIST_HEAD(cbs_list);
+static DEFINE_SPINLOCK(cbs_list_lock);
+
 #define BYTES_PER_KBIT (1000LL / 8)
 
 struct cbs_sched_data {
 	bool offload;
 	int queue;
-	s64 port_rate; /* in bytes/s */
+	atomic64_t port_rate; /* in bytes/s */
 	s64 last; /* timestamp in ns */
 	s64 credits; /* in bytes */
 	s32 locredit; /* in bytes */
@@ -82,6 +86,7 @@ struct cbs_sched_data {
 		       struct sk_buff **to_free);
 	struct sk_buff *(*dequeue)(struct Qdisc *sch);
 	struct Qdisc *qdisc;
+	struct list_head cbs_list;
 };
 
 static int cbs_child_enqueue(struct sk_buff *skb, struct Qdisc *sch,
@@ -180,6 +185,11 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 	s64 credits;
 	int len;
 
+	if (atomic64_read(&q->port_rate) == -1) {
+		WARN_ONCE(1, "cbs: dequeue() called with unknown port rate.");
+		return NULL;
+	}
+
 	if (q->credits < 0) {
 		credits = timediff_to_credits(now - q->last, q->idleslope);
 
@@ -206,7 +216,8 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 	/* As sendslope is a negative number, this will decrease the
 	 * amount of q->credits.
 	 */
-	credits = credits_from_len(len, q->sendslope, q->port_rate);
+	credits = credits_from_len(len, q->sendslope,
+				   atomic64_read(&q->port_rate));
 	credits += q->credits;
 
 	q->credits = max_t(s64, credits, q->locredit);
@@ -293,6 +304,50 @@ static int cbs_enable_offload(struct net_device *dev, struct cbs_sched_data *q,
 	return 0;
 }
 
+static void cbs_set_port_rate(struct net_device *dev, struct cbs_sched_data *q)
+{
+	struct ethtool_link_ksettings ecmd;
+	int port_rate = -1;
+
+	if (!__ethtool_get_link_ksettings(dev, &ecmd) &&
+	    ecmd.base.speed != SPEED_UNKNOWN)
+		port_rate = ecmd.base.speed * 1000 * BYTES_PER_KBIT;
+
+	atomic64_set(&q->port_rate, port_rate);
+	netdev_dbg(dev, "cbs: set %s's port_rate to: %lld, linkspeed: %d\n",
+		   dev->name, (long long)atomic64_read(&q->port_rate),
+		   ecmd.base.speed);
+}
+
+static int cbs_dev_notifier(struct notifier_block *nb, unsigned long event,
+			    void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct cbs_sched_data *q;
+	struct net_device *qdev;
+	bool found = false;
+
+	ASSERT_RTNL();
+
+	if (event != NETDEV_UP && event != NETDEV_CHANGE)
+		return NOTIFY_DONE;
+
+	spin_lock(&cbs_list_lock);
+	list_for_each_entry(q, &cbs_list, cbs_list) {
+		qdev = qdisc_dev(q->qdisc);
+		if (qdev == dev) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&cbs_list_lock);
+
+	if (found)
+		cbs_set_port_rate(dev, q);
+
+	return NOTIFY_DONE;
+}
+
 static int cbs_change(struct Qdisc *sch, struct nlattr *opt,
 		      struct netlink_ext_ack *extack)
 {
@@ -314,16 +369,7 @@ static int cbs_change(struct Qdisc *sch, struct nlattr *opt,
 	qopt = nla_data(tb[TCA_CBS_PARMS]);
 
 	if (!qopt->offload) {
-		struct ethtool_link_ksettings ecmd;
-		s64 link_speed;
-
-		if (!__ethtool_get_link_ksettings(dev, &ecmd))
-			link_speed = ecmd.base.speed;
-		else
-			link_speed = SPEED_1000;
-
-		q->port_rate = link_speed * 1000 * BYTES_PER_KBIT;
-
+		cbs_set_port_rate(dev, q);
 		cbs_disable_offload(dev, q);
 	} else {
 		err = cbs_enable_offload(dev, q, qopt, extack);
@@ -346,6 +392,7 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct cbs_sched_data *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	int err;
 
 	if (!opt) {
 		NL_SET_ERR_MSG(extack, "Missing CBS qdisc options  which are mandatory");
@@ -366,7 +413,17 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 
 	qdisc_watchdog_init(&q->watchdog, sch);
 
-	return cbs_change(sch, opt, extack);
+	err = cbs_change(sch, opt, extack);
+	if (err)
+		return err;
+
+	if (!q->offload) {
+		spin_lock(&cbs_list_lock);
+		list_add(&q->cbs_list, &cbs_list);
+		spin_unlock(&cbs_list_lock);
+	}
+
+	return 0;
 }
 
 static void cbs_destroy(struct Qdisc *sch)
@@ -374,8 +431,11 @@ static void cbs_destroy(struct Qdisc *sch)
 	struct cbs_sched_data *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 
-	qdisc_watchdog_cancel(&q->watchdog);
+	spin_lock(&cbs_list_lock);
+	list_del(&q->cbs_list);
+	spin_unlock(&cbs_list_lock);
 
+	qdisc_watchdog_cancel(&q->watchdog);
 	cbs_disable_offload(dev, q);
 
 	if (q->qdisc)
@@ -486,14 +546,24 @@ static struct Qdisc_ops cbs_qdisc_ops __read_mostly = {
 	.owner		=	THIS_MODULE,
 };
 
+static struct notifier_block cbs_device_notifier = {
+	.notifier_call = cbs_dev_notifier,
+};
+
 static int __init cbs_module_init(void)
 {
+	int err = register_netdevice_notifier(&cbs_device_notifier);
+
+	if (err)
+		return err;
+
 	return register_qdisc(&cbs_qdisc_ops);
 }
 
 static void __exit cbs_module_exit(void)
 {
 	unregister_qdisc(&cbs_qdisc_ops);
+	unregister_netdevice_notifier(&cbs_device_notifier);
 }
 module_init(cbs_module_init)
 module_exit(cbs_module_exit)
-- 
2.20.1

