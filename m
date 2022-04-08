Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD02B4F9915
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbiDHPNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235482AbiDHPNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:13:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D58FFF7E;
        Fri,  8 Apr 2022 08:11:05 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 238EcKJr027043;
        Fri, 8 Apr 2022 15:11:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CS566cIZRr6U6js1CtGwoj/4DLLOKGmsApPIto53KX4=;
 b=sQvBQoS4mDsFLXP9otBno9YI2Fyeaj7bFQ0tm92JCWiSJRTIh1WIMkbdn1nJ98HIVtAj
 2T3k55inIVffG4XCHugzCH46Q28+j9FF4akp7gSqmB0XHAjGmpJg9k84y//+YCwD5JIT
 IrdVN5pLv5sIX9JTsfIIPRfPwqkUR87Vodvvu5UtaAAvcnqMSDqfprUcol03KiosCGk4
 6AKfdGqfpgcuUD11sn6YqZ2ZtgNdXQ7owl2W8ip43DrerI90AlqA8eBLZFKmcd9ceuVm
 DVq/6v+ZrFo1+RR91IaSIGAIfMfsgH79RjvfyZuNzhdmoWvSxdS3S/+ypMZuelNg3sF5 +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fabs15yfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:11:01 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 238EGdD6010420;
        Fri, 8 Apr 2022 15:11:00 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fabs15yeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:11:00 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 238F3SjL011171;
        Fri, 8 Apr 2022 15:10:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3f6e48swhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:10:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 238FAum039518712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Apr 2022 15:10:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D2F952052;
        Fri,  8 Apr 2022 15:10:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 39F4352051;
        Fri,  8 Apr 2022 15:10:56 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, alibuda@linux.alibaba.com
Subject: [PATCH net 1/3] net/smc: use memcpy instead of snprintf to avoid out of bounds read
Date:   Fri,  8 Apr 2022 17:10:33 +0200
Message-Id: <20220408151035.1044701-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220408151035.1044701-1-kgraul@linux.ibm.com>
References: <20220408151035.1044701-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T6O52FaQvxfHoZt6BblR0Og8x7CW89Ad
X-Proofpoint-ORIG-GUID: qtKzgrQe6e7qOKajU207cGBf9kdnymQ_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_05,2022-04-08_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using snprintf() to convert not null-terminated strings to null
terminated strings may cause out of bounds read in the source string.
Therefore use memcpy() and terminate the target string with a null
afterwards.

Fixes: fa0866625543 ("net/smc: add support for user defined EIDs")
Fixes: 3c572145c24e ("net/smc: add generic netlink support for system EID")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_clc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index ce27399b38b1..f9f3f59c79de 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -191,7 +191,8 @@ static int smc_nl_ueid_dumpinfo(struct sk_buff *skb, u32 portid, u32 seq,
 			  flags, SMC_NETLINK_DUMP_UEID);
 	if (!hdr)
 		return -ENOMEM;
-	snprintf(ueid_str, sizeof(ueid_str), "%s", ueid);
+	memcpy(ueid_str, ueid, SMC_MAX_EID_LEN);
+	ueid_str[SMC_MAX_EID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_EID_TABLE_ENTRY, ueid_str)) {
 		genlmsg_cancel(skb, hdr);
 		return -EMSGSIZE;
@@ -252,7 +253,8 @@ int smc_nl_dump_seid(struct sk_buff *skb, struct netlink_callback *cb)
 		goto end;
 
 	smc_ism_get_system_eid(&seid);
-	snprintf(seid_str, sizeof(seid_str), "%s", seid);
+	memcpy(seid_str, seid, SMC_MAX_EID_LEN);
+	seid_str[SMC_MAX_EID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_SEID_ENTRY, seid_str))
 		goto err;
 	read_lock(&smc_clc_eid_table.lock);
-- 
2.32.0

