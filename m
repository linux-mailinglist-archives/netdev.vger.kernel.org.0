Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9BB6940E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404558AbfGOOsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:48:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43894 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404564AbfGOOsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:48:37 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 54249BD5A6834CEA0A9A;
        Mon, 15 Jul 2019 22:48:33 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 15 Jul 2019
 22:48:25 +0800
To:     <wensong@linux-vs.org>, <horms@verge.net.au>, <ja@ssi.bg>,
        <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <lvs-devel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, Mingfangsen <mingfangsen@huawei.com>,
        <wangxiaogang3@huawei.com>, <xuhanbing@huawei.com>
From:   hujunwei <hujunwei4@huawei.com>
Subject: [PATCH net] ipvs: Improve robustness to the ipvs sysctl
Message-ID: <1997375e-815d-137f-20c9-0829a8587ee9@huawei.com>
Date:   Mon, 15 Jul 2019 22:48:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.191.73]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junwei Hu <hujunwei4@huawei.com>

The ipvs module parse the user buffer and save it to sysctl,
then check if the value is valid. invalid value occurs
over a period of time.
Here, I add a variable, struct ctl_table tmp, used to read
the value from the user buffer, and save only when it is valid.

Fixes: f73181c8288f ("ipvs: add support for sync threads")
Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 61 +++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 741d91aa4a8d..e78fd05f108b 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1680,12 +1680,18 @@ proc_do_defense_mode(struct ctl_table *table, int write,
 	int val = *valp;
 	int rc;

-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+	};
+
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 	if (write && (*valp != val)) {
-		if ((*valp < 0) || (*valp > 3)) {
-			/* Restore the correct value */
+		if (val < 0 || val > 3)
+			rc = -EINVAL;
+		else {
 			*valp = val;
-		} else {
 			update_defense_level(ipvs);
 		}
 	}
@@ -1699,15 +1705,20 @@ proc_do_sync_threshold(struct ctl_table *table, int write,
 	int *valp = table->data;
 	int val[2];
 	int rc;
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = table->maxlen,
+		.mode = table->mode,
+	};

-	/* backup the value first */
 	memcpy(val, valp, sizeof(val));
-
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (write && (valp[0] < 0 || valp[1] < 0 ||
-	    (valp[0] >= valp[1] && valp[1]))) {
-		/* Restore the correct value */
-		memcpy(valp, val, sizeof(val));
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
+	if (write) {
+		if (val[0] < 0 || val[1] < 0 ||
+		    (val[0] >= val[1] && val[1]))
+			rc = -EINVAL;
+		else
+			memcpy(valp, val, sizeof(val));
 	}
 	return rc;
 }
@@ -1720,12 +1731,18 @@ proc_do_sync_mode(struct ctl_table *table, int write,
 	int val = *valp;
 	int rc;

-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+	};
+
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 	if (write && (*valp != val)) {
-		if ((*valp < 0) || (*valp > 1)) {
-			/* Restore the correct value */
+		if (val < 0 || val > 1)
+			rc = -EINVAL;
+		else
 			*valp = val;
-		}
 	}
 	return rc;
 }
@@ -1738,12 +1755,18 @@ proc_do_sync_ports(struct ctl_table *table, int write,
 	int val = *valp;
 	int rc;

-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+	};
+
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 	if (write && (*valp != val)) {
-		if (*valp < 1 || !is_power_of_2(*valp)) {
-			/* Restore the correct value */
+		if (val < 1 || !is_power_of_2(val))
+			rc = -EINVAL;
+		else
 			*valp = val;
-		}
 	}
 	return rc;
 }
-- 
2.21.GIT

