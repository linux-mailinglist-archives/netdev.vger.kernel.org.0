Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17882D00A4
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 06:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgLFFWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 00:22:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725943AbgLFFWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 00:22:12 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B655L1s021720;
        Sun, 6 Dec 2020 00:21:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c/wUjwgwnuJEIKETRGamV8nHOVLREFCcmpn2zoHxiHw=;
 b=bBrUxQO7FvQsoBBB19Xz8HB+VdLZk85SmwzVMYm8qHBgX5IRWy1KM2jmk5fsXsH1hhE6
 qFfePcKf+P3NZvuTCZVIvnM7QSIE5qLEjmoq/TI/uOuaCqEuGoJTlVc18scqg6Hr3AnH
 VoKbSEG+WIH9+hzf25ySZ9Via0caweNkpZC4Bk+xf/LuKsyDE+fUcieQI0FIjA9TXUGu
 q527jkpHuzD5wr6bWeBCCH2t6PBcvPLHQfjF98fPUugYBQBAfQoXOjHhP+jUWztxRWsG
 Gir+v8ib+mGbwgeY7bsO/B3CZOzCeGAp10oDlW8NLBNeHuoZbMsASX4ed9LmYnPqL03d tQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 358rmxgd7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Dec 2020 00:21:30 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B65I8vZ029283;
        Sun, 6 Dec 2020 05:21:30 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 3581u8ggh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Dec 2020 05:21:30 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B65LTJr15336054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Dec 2020 05:21:29 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AC16124054;
        Sun,  6 Dec 2020 05:21:29 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9205124052;
        Sun,  6 Dec 2020 05:21:28 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.129.222])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun,  6 Dec 2020 05:21:28 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [RFC PATCH net-next 3/3] use netdev_notify_peers_locked in hyperv
Date:   Sat,  5 Dec 2020 23:21:27 -0600
Message-Id: <20201206052127.21450-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201206052127.21450-1-ljp@linux.ibm.com>
References: <20201206052127.21450-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-06_02:2020-12-04,2020-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060029
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start to use the lockless version of netdev_notify_peers.

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/hyperv/netvsc_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 261e6e55a907..5483ad697d19 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2129,10 +2129,10 @@ static void netvsc_link_change(struct work_struct *w)
 		break;
 	}
 
-	rtnl_unlock();
-
 	if (notify)
-		netdev_notify_peers(net);
+		netdev_notify_peers_locked(net);
+
+	rtnl_unlock();
 
 	/* link_watch only sends one notification with current state per
 	 * second, handle next reconfig event in 2 seconds.
-- 
2.23.0

