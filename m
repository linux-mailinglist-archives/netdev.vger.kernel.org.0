Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350D12BB934
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgKTWkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728951AbgKTWkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:19 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMW01I131665
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9uxPTzWgAxzMCL/YoP1Cbdn2RKjfmLd8zBCQPh0orEg=;
 b=N7h/pan3KBv2wikLaPfFhkuwxHO+7lTYo8cwQIM/is8iqkHgaOvpw/WMB3Qpp17WH+Ie
 HSWzP3DXqZA1sOcY8EUD/giHCGenfVqllpZ+lnbhznEF3o+utwUdl6TM021002dR1mRP
 dQY3375tF2RqcO1EyrW5TBEgp8pHRqpbba0ojIIA9qe1F2/vFobbWnumQFVGDh68QJxA
 9lMzSCY3+MNCls1CEL+J1vhdZF45hVWirSWPdGnA9/LQ8ooKtvrNdVxbayVRhoia1142
 WibnxzYU+3jW/JmZqawkkZVkgtqfMoPvDKht/4Rzxv+pBIrWRnQjx7AqbtTJqp6I5kWN Ew== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xm9e3hvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:18 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMbcJr019451
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:18 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 34w263h7va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:17 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMeAnS20775612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:10 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 273C96E056;
        Fri, 20 Nov 2020 22:40:16 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62E786E054;
        Fri, 20 Nov 2020 22:40:15 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:15 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net v2 1/3] ibmvnic: fix call_netdevice_notifiers in do_reset
Date:   Fri, 20 Nov 2020 16:40:11 -0600
Message-Id: <20201120224013.46891-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224013.46891-1-ljp@linux.ibm.com>
References: <20201120224013.46891-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 phishscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When netdev_notify_peers was substituted in
commit 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device reset"),
call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev) was missed.
Fix it now.

Fixes: 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: split from v1's 1/2

 drivers/net/ethernet/ibm/ibmvnic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index da15913879f8..eface3543b2c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2074,8 +2074,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	for (i = 0; i < adapter->req_rx_queues; i++)
 		napi_schedule(&adapter->napi[i]);
 
-	if (adapter->reset_reason != VNIC_RESET_FAILOVER)
+	if (adapter->reset_reason != VNIC_RESET_FAILOVER) {
 		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
+		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
+	}
 
 	rc = 0;
 
-- 
2.23.0

