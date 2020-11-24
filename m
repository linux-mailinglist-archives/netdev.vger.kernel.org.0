Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986EC2C2E7C
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390832AbgKXR0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:26:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7676 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390825AbgKXR0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:26:40 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOH1bst128785;
        Tue, 24 Nov 2020 12:26:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=FxLK2HZu1U7SnTHn2fS8+ElfbIjbvxVsikXKZqocNyk=;
 b=JQZKOGStuPTqJSd7kHgVjqSMLmNs7c90SGdA67pTLAS082XLtoJZpnTQ2WjQxdcDHnwB
 tuIHWDMUI9SY1IKUNtHoDIVVuKiSsAVliYDRQPOw385OM8XX3/Fs5U+kTp27uz0pW92i
 slBPYKmRQDsaYD9HW5SoO41N08EuksEJcFvrwnQk6lldwNTnLlb4h/18J13C2gCGfO41
 kRe7qgxxpYdCiZK1aLDHQxeWB9ZQ0kDQ+/mMNx3EoS3i9hlmIZcLidPsT1ftbDVPozxZ
 4oNHoOKeF5T+HFaS6il6h9PQtGGlYI3BYZhgTXT8elKESgpIdZkNwHLND44mnKlBblpY lQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ygtu5a29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:26:36 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHNbWK006253;
        Tue, 24 Nov 2020 17:26:35 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 34xth912x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:26:35 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHQX5E57999706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:26:33 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C30A6A04D;
        Tue, 24 Nov 2020 17:26:33 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADB796A054;
        Tue, 24 Nov 2020 17:26:31 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.17.166])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:26:31 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, cforno12@linux.ibm.com,
        ljp@linux.vnet.ibm.com, ricklind@linux.ibm.com,
        dnbanerg@us.ibm.com, drt@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        tlfalcon@linux.ibm.com
Subject: [PATCH net 2/2] ibmvnic: Fix TX completion error handling
Date:   Tue, 24 Nov 2020 11:26:16 -0600
Message-Id: <1606238776-30259-3-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606238776-30259-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1606238776-30259-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX completions received with an error return code are not
being processed properly. When an error code is seen, do not
proceed to the next completion before cleaning up the existing
entry's data structures.

Fixes: 032c5e828 ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 489ed5e..7097bcb 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3105,11 +3105,9 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 
 		next = ibmvnic_next_scrq(adapter, scrq);
 		for (i = 0; i < next->tx_comp.num_comps; i++) {
-			if (next->tx_comp.rcs[i]) {
+			if (next->tx_comp.rcs[i])
 				dev_err(dev, "tx error %x\n",
 					next->tx_comp.rcs[i]);
-				continue;
-			}
 			index = be32_to_cpu(next->tx_comp.correlators[i]);
 			if (index & IBMVNIC_TSO_POOL_MASK) {
 				tx_pool = &adapter->tso_pool[pool];
-- 
1.8.3.1

