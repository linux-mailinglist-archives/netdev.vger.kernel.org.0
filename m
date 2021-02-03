Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D96A30D2C0
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 06:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBCFHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 00:07:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhBCFHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 00:07:40 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11352aed166101
        for <netdev@vger.kernel.org>; Wed, 3 Feb 2021 00:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KRmCh9HtqAKGB4GSrLBuyuU6QVAQ38lzZaW1R0CCnOg=;
 b=pLFvQ93kHQW5yFyh2n37fcAZJcqNBIvWayQvSJ7GkhNXNrafAdeEFLwN3s9M+o7MD2Q8
 CSRX6sc9x2e+aggU2koUcIC/xDE5rAQSqr+iPRvk+vaSKBz6SY2zu5QqvW26KR6RWUGt
 zmfga15w5APtxmvhzfB3gBnzNcMYtymiV0nToN2HhPAvabJPlFlKfhYnf8c88Y36TKrs
 44DPzHpJWfdBD4kMfhusjCWbKhDlT0sPlKLEXEQq+KTAICfmU45ViZWQunnJeNl8hQ5X
 BLiLENav//scZNT2L8GevpuqNuKMuhtIDnn4vci0lVBJ+5OcKuZ+5mZdmz2lqAonK3/8 CA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fn2xgenn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:06:59 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 113535PO026243
        for <netdev@vger.kernel.org>; Wed, 3 Feb 2021 05:06:57 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 36f4tupadm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 05:06:57 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11356smg12780020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 05:06:54 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6DE313605D;
        Wed,  3 Feb 2021 05:06:54 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EBA0136051;
        Wed,  3 Feb 2021 05:06:53 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.202.29])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 05:06:53 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com,
        sukadev@linux.ibm.com
Subject: [PATCH v2 2/2] ibmvnic: fix race with multiple open/close
Date:   Tue,  2 Feb 2021 21:06:50 -0800
Message-Id: <20210203050650.680656-2-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210203050650.680656-1-sukadev@linux.ibm.com>
References: <20210203050650.680656-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_01:2021-02-02,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=965 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If two or more instances of 'ip link set' commands race and first one
already brings the interface up (or down), the subsequent instances
can simply return without redoing the up/down operation.

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
Tested-by: Abdul Haleem <abdhalee@in.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

---
Changelog[v2] For consistency with ibmvnic_open() use "goto out" and return
	      from end of function.
---
 drivers/net/ethernet/ibm/ibmvnic.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 78d244aeee69..df1b4884b4e8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1219,6 +1219,14 @@ static int ibmvnic_open(struct net_device *netdev)
 		goto out;
 	}
 
+	/* If adapter is already open, we don't have to do anything. */
+	if (adapter->state == VNIC_OPEN) {
+		netdev_dbg(netdev, "[S:%d] adapter already open\n",
+			   adapter->state);
+		rc = 0;
+		goto out;
+	}
+
 	if (adapter->state != VNIC_CLOSED) {
 		rc = ibmvnic_login(netdev);
 		if (rc)
@@ -1392,6 +1400,12 @@ static int ibmvnic_close(struct net_device *netdev)
 		return 0;
 	}
 
+	/* If adapter is already closed, we don't have to do anything. */
+	if (adapter->state == VNIC_CLOSED) {
+		netdev_dbg(netdev, "[S:%d] adapter already closed\n",
+			   adapter->state);
+		return 0;
+	}
 	rc = __ibmvnic_close(netdev);
 	ibmvnic_cleanup(netdev);
 
-- 
2.26.2

