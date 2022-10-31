Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBDD6139AB
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiJaPG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiJaPGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:06:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBB21116C
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:06:53 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VEj8IO001306
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=vhqIuqfE+8s8WXlqmcDSkSmeg9DtPFOfETTTdvO+Tgk=;
 b=CRJlb6DKo40NmfAzTHgRK+GEGMTlbFHV+W3eEecUdKb5hS37Rh9cv7T0wVg8WgM1NsK/
 a9MIN1wC88LTpGahoHM4i33vXkyJ0cgQXgLsPc21gC4LHjHgGTgUl/vpa0VCxYskTu43
 l2ZL5bBZH0gLxUzyfaBr5jPCkZMYCniG4QX5Y8pgL6px0cFxtsx3uVr8hfYN3DJ0bCuK
 F4NldUik4SQQtAtaaPCoVehOkqt0aa8wQ12zsiaoBPk90VKBmyqxm5Md+3Y5g/BePLuL
 2mF1F1xqjg88BXvGq6oFa/MQeWDkm4Q+rEHV1xRJuV/lksnovqdFizO4L496W2cwquZ2 iQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kjgd70sqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:06:52 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29VF5gf4006760
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:06:51 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3kgut9x8aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:06:51 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29VF6mxF19792454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 15:06:49 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED4E65805A;
        Mon, 31 Oct 2022 15:06:46 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C95158065;
        Mon, 31 Oct 2022 15:06:46 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.160.167.41])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 31 Oct 2022 15:06:46 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     haren@linux.ibm.com, ricklind@linux.ibm.com, danymadden@us.ibm.com,
        tlfalcon@linux.ibm.com, Nick Child <nnac123@linux.ibm.com>
Subject: [PATCH net] ibmvnic: Free rwi on reset success
Date:   Mon, 31 Oct 2022 10:06:42 -0500
Message-Id: <20221031150642.13356-1-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rWGqVlOzMhCnjI3CXUrLcFvIeA7dnwGc
X-Proofpoint-ORIG-GUID: rWGqVlOzMhCnjI3CXUrLcFvIeA7dnwGc
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_17,2022-10-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210310094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Free the rwi structure in the event that the last rwi in the list
processed successfully. The logic in commit 4f408e1fa6e1 ("ibmvnic:
retry reset if there are no other resets") introduces an issue that
results in a 32 byte memory leak whenever the last rwi in the list
gets processed.

Fixes: 4f408e1fa6e1 ("ibmvnic: retry reset if there are no other resets")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
---

Links to related discussions:
 - Same patch sent to net-next:
    https://lore.kernel.org/netdev/20221018130606.46c4ed3d@kernel.org/
 - Updated ibmvnic maintainers:
    https://lore.kernel.org/netdev/20221028203509.4070154-1-ricklind@us.ibm.com/

 drivers/net/ethernet/ibm/ibmvnic.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 65dbfbec487a..9282381a438f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3007,19 +3007,19 @@ static void __ibmvnic_reset(struct work_struct *work)
 		rwi = get_next_rwi(adapter);
 
 		/*
-		 * If there is another reset queued, free the previous rwi
-		 * and process the new reset even if previous reset failed
-		 * (the previous reset could have failed because of a fail
-		 * over for instance, so process the fail over).
-		 *
 		 * If there are no resets queued and the previous reset failed,
 		 * the adapter would be in an undefined state. So retry the
 		 * previous reset as a hard reset.
+		 *
+		 * Else, free the previous rwi and, if there is another reset
+		 * queued, process the new reset even if previous reset failed
+		 * (the previous reset could have failed because of a fail
+		 * over for instance, so process the fail over).
 		 */
-		if (rwi)
-			kfree(tmprwi);
-		else if (rc)
+		if (!rwi && rc)
 			rwi = tmprwi;
+		else
+			kfree(tmprwi);
 
 		if (rwi && (rwi->reset_reason == VNIC_RESET_FAILOVER ||
 			    rwi->reset_reason == VNIC_RESET_MOBILITY || rc))
-- 
2.31.1

