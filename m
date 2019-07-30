Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD4887A1A0
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 09:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfG3HL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 03:11:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58946 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726180AbfG3HL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 03:11:58 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 32C8A978192D47138D60;
        Tue, 30 Jul 2019 15:11:54 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Jul 2019
 15:11:47 +0800
Subject: [PATCH net v2] ipvs: Improve robustness to the ipvs sysctl
From:   hujunwei <hujunwei4@huawei.com>
To:     <wensong@linux-vs.org>, <horms@verge.net.au>,
        <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <davem@davemloft.net>, "Julian Anastasov" <ja@ssi.bg>,
        Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <lvs-devel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, Mingfangsen <mingfangsen@huawei.com>,
        <wangxiaogang3@huawei.com>, <xuhanbing@huawei.com>
References: <1997375e-815d-137f-20c9-0829a8587ee9@huawei.com>
Message-ID: <4a0476d3-57a4-50e0-cae8-9dffc4f4d556@huawei.com>
Date:   Tue, 30 Jul 2019 15:11:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1997375e-815d-137f-20c9-0829a8587ee9@huawei.com>
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
I delete proc_do_sync_mode and use extra1/2 in table for the
proc_dointvec_minmax call.

Fixes: f73181c8288f ("ipvs: add support for sync threads")
Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
---
V1->V2:
- delete proc_do_sync_mode and use proc_dointvec_minmax call.
---
 net/netfilter/ipvs/ip_vs_ctl.c | 69 +++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 060565e..7aed7b0 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1737,12 +1737,18 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
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
+		if (val < 0 || val > 3) {
+			rc = -EINVAL;
+		} else {
 			*valp = val;
-		} else {
 			update_defense_level(ipvs);
 		}
 	}
@@ -1756,33 +1762,20 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
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
-	}
-	return rc;
-}
-
-static int
-proc_do_sync_mode(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int *valp = table->data;
-	int val = *valp;
-	int rc;
-
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (write && (*valp != val)) {
-		if ((*valp < 0) || (*valp > 1)) {
-			/* Restore the correct value */
-			*valp = val;
-		}
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
@@ -1795,12 +1788,18 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
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
@@ -1860,7 +1859,9 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
 		.procname	= "sync_version",
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_do_sync_mode,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "sync_ports",
-- 
1.7.12.4

