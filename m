Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443D72D5089
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 03:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgLJBzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:55:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgLJByv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 20:54:51 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BA1VVna180529;
        Wed, 9 Dec 2020 20:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=Bn45qJF7UV/++Ba01sUnJsB/3sgj12m0X4s0AM79ToQ=;
 b=K/+f4FNPh9vkxDWhy9UMg1atvihma43Mry31gsyNOTjFfpZ3MqNWfFloMtauilOURc7V
 HzDQFSsB70Zvk10Udvc0qYUf304YphlPX1zDYVLsq2ecChowcQ0pctbIv/g8iONzj7u0
 lnVHI2vElJwNttDwvz37l+fKlSwh+RRuxKknPiuZUeh0kbRlNmOt9qf7VM4+xpo0Cju1
 9C99nVPreiJ77fltYAP00S9RNeWsdpO1uWNgI9mzkA1LAdRayuJ5mrc5IA/9A2PWxpAU
 PIgJ3/yi+SDBBmApZaBrsdNBNLoSRrTkm3c1+yGUKF1v/6UrzeFBNv7KT0GdOKu98dNX Dg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35b9579qeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 20:54:01 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BA1jtF8004388;
        Thu, 10 Dec 2020 01:54:00 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 3581u9jk0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 01:54:00 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BA1rxSl19530434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 01:54:00 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCF27112066;
        Thu, 10 Dec 2020 01:53:59 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55890112064;
        Thu, 10 Dec 2020 01:53:59 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 10 Dec 2020 01:53:59 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     dnbanerg@us.ibm.com, drt@linux.ibm.com, ljp@linux.ibm.com,
        sukadev@linux.ibm.com, netdev@vger.kernel.org
Subject: [PATCH net-next] ibmvnic: fix rx buffer tracking and index management in replenish_rx_pool partial success
Date:   Wed,  9 Dec 2020 20:53:31 -0500
Message-Id: <20201210015331.44966-1-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_19:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=900
 impostorscore=0 malwarescore=0 mlxscore=0 suspectscore=2
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012100006
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Dwip N. Banerjee" <dnbanerg@us.ibm.com>

We observed that in the error case for batched send_subcrq_indirect() the
driver does not account for the partial success case. This caused Linux to
crash when free_map and pool index are inconsistent.

Driver needs to update the rx pools "available" count when some batched
sends worked but an error was encountered as part of the whole operation.
Also track replenish_add_buff_failure for statistic purposes.

Fixes: 4f0b6812e9b9a ("ibmvnic: Introduce batched RX buffer descriptor transmission")
Signed-off-by: Dwip N. Banerjee <dnbanerg@us.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cb701a6c0712..a2191392ca4f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -398,6 +398,8 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 		dev_kfree_skb_any(pool->rx_buff[index].skb);
 		pool->rx_buff[index].skb = NULL;
 	}
+	adapter->replenish_add_buff_failure += ind_bufp->index;
+	atomic_add(buffers_added, &pool->available);
 	ind_bufp->index = 0;
 	if (lpar_rc == H_CLOSED || adapter->failover_pending) {
 		/* Disable buffer pool replenishment and report carrier off if
-- 
2.18.2

