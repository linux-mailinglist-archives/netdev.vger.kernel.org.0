Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787383A7ACD
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhFOJis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:38:48 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56648 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231187AbhFOJim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 05:38:42 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4A6781A29E3;
        Tue, 15 Jun 2021 11:36:37 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2B6BA1A29D6;
        Tue, 15 Jun 2021 11:36:31 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 30CB340310;
        Tue, 15 Jun 2021 17:36:23 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: [net-next, v3, 03/10] ptp: track available ptp vclocks information
Date:   Tue, 15 Jun 2021 17:45:10 +0800
Message-Id: <20210615094517.48752-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210615094517.48752-1-yangbo.lu@nxp.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track available ptp vclocks information. Record index values
of available ptp vclocks during registering and unregistering.

This is preparation for supporting ptp vclocks info query
through ethtool.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Change for v3:
	- Added this patch.
---
 drivers/ptp/ptp_clock.c   | 2 ++
 drivers/ptp/ptp_private.h | 1 +
 drivers/ptp/ptp_sysfs.c   | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 78414b3e16dd..38842a76acf8 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -236,6 +236,8 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	if (parent->class && strcmp(parent->class->name, "ptp") == 0)
 		ptp->vclock_flag = true;
 
+	memset(ptp->vclock_index, -1, sizeof(ptp->vclock_index));
+
 	err = ptp_populate_pin_groups(ptp);
 	if (err)
 		goto no_pin_groups;
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 6949afc9d733..5671710ca0fa 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -47,6 +47,7 @@ struct ptp_clock {
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work aux_work;
 	u8 n_vclocks;
+	int vclock_index[PTP_MAX_VCLOCKS];
 	struct mutex n_vclocks_mux; /* protect concurrent n_vclocks access */
 	bool vclock_flag;
 };
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 600edd7a90af..d9534935c1e6 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -207,6 +207,9 @@ static ssize_t n_vclocks_store(struct device *dev,
 				goto out;
 			}
 
+			ptp->vclock_index[ptp->n_vclocks + i] =
+				vclock->clock->index;
+
 			dev_info(dev, "new virtual clock ptp%d\n",
 				 vclock->clock->index);
 		}
@@ -217,6 +220,9 @@ static ssize_t n_vclocks_store(struct device *dev,
 		i = ptp->n_vclocks - num;
 		device_for_each_child_reverse(dev, &i,
 					      unregister_vclock);
+
+		for (i = 1; i <= ptp->n_vclocks - num; i++)
+			ptp->vclock_index[ptp->n_vclocks - i] = -1;
 	}
 
 	if (num == 0)
-- 
2.25.1

