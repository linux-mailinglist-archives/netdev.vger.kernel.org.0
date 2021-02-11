Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D1F31831E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 02:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhBKBma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 20:42:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42734 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229584AbhBKBm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 20:42:28 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11B1cOZ1059576
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 20:41:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ArLfCy1BhkKXzO7KodNCjof7pUH03Oeafg3by3p3SCc=;
 b=f6B3VtCDADikkp/JIs0+tnnV3U4I/VBWzRRrwSbwh2ZrWMrfagiCkPY/ysj4CechQsOb
 0CFXE2RP/GnHst5CUCA9LidIYkM+odXJt69TWdywmp5alRhskh6l2466Ax5sbrj+QP+v
 eZhYOlUVg3Qx64u0YWl2XSJpDnUBpRhTbU4Asl6lq58kVANWI7gM4T+nKUOfnnr+s4pP
 Buza0QVDBITDr5UQhUkeU+T9iyjuSDijZt9N6mTX3NICelIqzhBPfgIgi9hD8sRAtdVV
 7ARIfvNwnIOBbe6jIeCIaF/rSZMjYuo4wgxtfuFEsTsTLrPZBaKL2+1m/ZxS0D2roE6/ 6Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mtqy8d8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 20:41:48 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11B1SLNG015039
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 01:41:47 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 36hjraay77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 01:41:47 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11B1fjNg27590966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 01:41:45 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A82D112063;
        Thu, 11 Feb 2021 01:41:45 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3F32112061;
        Thu, 11 Feb 2021 01:41:44 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.134.9])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 01:41:44 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com,
        sukadev@linux.ibm.com
Subject: [PATCH 1/1] ibmvnic: Set to CLOSED state even on error
Date:   Wed, 10 Feb 2021 17:41:43 -0800
Message-Id: <20210211014144.881861-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 mlxlogscore=943 bulkscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110005
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If set_link_state() fails for any reason, we still cleanup the adapter
state and cannot recover from a partial close anyway. So set the adapter
to CLOSED state. That way if a new soft/hard reset is processed, the
adapter will remain in the CLOSED state until the next ibmvnic_open().

Fixes: 01d9bd792d16 ("ibmvnic: Reorganize device close")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 96c2b0985484..ce6b1cb0b0f9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1367,10 +1367,8 @@ static int __ibmvnic_close(struct net_device *netdev)
 
 	adapter->state = VNIC_CLOSING;
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
-	if (rc)
-		return rc;
 	adapter->state = VNIC_CLOSED;
-	return 0;
+	return rc;
 }
 
 static int ibmvnic_close(struct net_device *netdev)
-- 
2.26.2

