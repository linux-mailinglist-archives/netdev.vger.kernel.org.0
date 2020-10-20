Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AFE294535
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439109AbgJTWjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:39:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392172AbgJTWjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 18:39:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09KMWhmU069735
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 18:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=E6WIcQz/l7y/qVgbAMha+iejqXQMr8AqQ7ZcNY1jaiU=;
 b=rNAtpBnipJglZa8THrthkjlM9uwVjJqcuuhsFb30E3c+G8zjNx/hyFmXlGuh9JkZ5Mko
 qW/kjU2RnFJLl+7mIjLl01CjdggjHriLv/oLsPzhJe6JSQeKo39mPMA2q5fSKHoaPbYR
 AAxF2T1fOKzHdttJbaQu1rCk7QPkgz70env+UskiU5gibOF85ijR4f9hJ2xLVhpnk1DF
 mzJ+ES1nMnrmIJvkUei7CE8c2QV85l+08EqQpZ/55EekcG07V1ak4QOWxHz7GSH3AjPY
 sQXKnc6tXk6FUEGWjkZy5yvxYDbvf4Xo4AbzNeBy/hLfFNQ/iRQiZITPFu+Z1l9Xszts jg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34a8se84hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 18:39:21 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09KMaq4N017008
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 22:39:20 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 347r893fmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 22:39:20 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09KMdK5M54722964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 22:39:20 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DF3C112080;
        Tue, 20 Oct 2020 22:39:20 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05D3911207D;
        Tue, 20 Oct 2020 22:39:19 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.179.149])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 20 Oct 2020 22:39:19 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net v2] ibmvnic: save changed mac address to adapter->mac_addr
Date:   Tue, 20 Oct 2020 17:39:19 -0500
Message-Id: <20201020223919.46106-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-20_12:2020-10-20,2020-10-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 mlxlogscore=871 bulkscore=0 suspectscore=1
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After mac address change request completes successfully, the new mac
address need to be saved to adapter->mac_addr as well as
netdev->dev_addr. Otherwise, adapter->mac_addr still holds old
data.

Fixes: 62740e97881c ("net/ibmvnic: Update MAC address settings after adapter reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: add a note to differentiate crq->change_mac_addr
    and crq->change_mac_addr.rsp.
    add a space in "Fixes" line

 drivers/net/ethernet/ibm/ibmvnic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 1b702a43a5d0..4dd3625a4fbc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4194,8 +4194,13 @@ static int handle_change_mac_rsp(union ibmvnic_crq *crq,
 		dev_err(dev, "Error %ld in CHANGE_MAC_ADDR_RSP\n", rc);
 		goto out;
 	}
+	/* crq->change_mac_addr.mac_addr is the requested one
+	 * crq->change_mac_addr_rsp.mac_addr is the returned valid one.
+	 */
 	ether_addr_copy(netdev->dev_addr,
 			&crq->change_mac_addr_rsp.mac_addr[0]);
+	ether_addr_copy(adapter->mac_addr,
+			&crq->change_mac_addr_rsp.mac_addr[0]);
 out:
 	complete(&adapter->fw_done);
 	return rc;
-- 
2.23.0

