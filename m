Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4B728FD7E
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 06:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732247AbgJPE5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 00:57:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65196 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730479AbgJPE5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 00:57:19 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09G4uWM6165771
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 00:57:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=V7Tb5S84MEAlhi/TgOgWisZRL0A7sMYagN0a2VaiBdY=;
 b=NH37r4lxN7kE5vDeFkNez01HQBbTIgboI8TU1TSPDVx1W+3vgLfQqNWE4FQ3XAMwAt/I
 oW7WF2rplxONesJijHxtbo46DSRKsbYM39DBl5XScze4jaPDQFJ4xaG35G02nsJ38gtz
 Q6CpNMUutiK8q2qhws77cmzGjbJ/E5M8tsytrFZkQLE4wNJ5zKGG+oa3o5NzOZ2v524m
 NYsVq9BofiKvTyYfGxBf25uZSyMRUnnbchXd7CLXgiTDXLEY6b4p5REB4GYycd0AApMn
 mhXNzhfCUxiJPkVpWK4QGdl2BDvp8zw458EsDU4WAudXnvEaHtl01oyWgNtTQnF4Drzt dw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3474r0g8s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 00:57:18 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09G4pxob015169
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 04:57:18 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3434kab34j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 04:57:18 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09G4vBg334865646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Oct 2020 04:57:11 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 870AF6E058;
        Fri, 16 Oct 2020 04:57:16 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16DCD6E04E;
        Fri, 16 Oct 2020 04:57:15 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.140.17])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 16 Oct 2020 04:57:15 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net] ibmvnic: save changed mac address to adapter->mac_addr
Date:   Thu, 15 Oct 2020 23:57:15 -0500
Message-Id: <20201016045715.26768-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-16_01:2020-10-16,2020-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 suspectscore=1 mlxlogscore=817 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010160025
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After mac address change request completes successfully, the new mac
address need to be saved to adapter->mac_addr as well as
netdev->dev_addr. Otherwise, adapter->mac_addr still holds old
data.

Fixes: 62740e97881c("net/ibmvnic: Update MAC address settings after adapter reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1b702a43a5d0..021968d1db9c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4196,6 +4196,8 @@ static int handle_change_mac_rsp(union ibmvnic_crq *crq,
 	}
 	ether_addr_copy(netdev->dev_addr,
 			&crq->change_mac_addr_rsp.mac_addr[0]);
+	ether_addr_copy(adapter->mac_addr,
+			&crq->change_mac_addr_rsp.mac_addr[0]);
 out:
 	complete(&adapter->fw_done);
 	return rc;
-- 
2.23.0

