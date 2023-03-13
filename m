Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E146B7371
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCMKJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCMKJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:09:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B8F5708C;
        Mon, 13 Mar 2023 03:09:03 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32D93Gow032395;
        Mon, 13 Mar 2023 10:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2SCMWWOjl4WhyyjysLDBzL1j/E5ymC8xeIzpF4bp+j8=;
 b=oDOfZIBSWhRUv+1xhEVOCeuV7ntq8d3JJuLs0fxeoJ9iQ0ZWN5QW8NadEMuft0DeuBSL
 088FVlvpEv39esiWcsrApxw8JCqj4tWIZ9ii3J1oz6Ebwa5ZkGbXAWToRux7CnIPAMeq
 JrtxRbpxrePaZT3id86dbJSVEc1J2bbtbxKsc6XKGRjP6i0RqGoP4HuLNsczeWfLUwlF
 A5/ufhgj9sn67mFPcl8HfxPQv+9wklPLh1ZRXAX55+5rxHPfK6HT5zXihm4+aPLsZvdh
 1H95x+5FVk7/oNtkG+DqWKiJmUYUUlNxXzMCWz+v+82n6Oe1Fkofu3AflBYA6Li97yVa 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p93k2hc0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:08:58 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32D907QU014904;
        Mon, 13 Mar 2023 10:08:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p93k2hbys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:08:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32D23Mb6028663;
        Mon, 13 Mar 2023 10:08:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3p8h96k5ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 10:08:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32DA8pju1769988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 10:08:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22F6C201E8;
        Mon, 13 Mar 2023 10:08:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB3F9201EA;
        Mon, 13 Mar 2023 10:08:46 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.163.87.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Mar 2023 10:08:46 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH net 2/2] net/smc: Fix device de-init sequence
Date:   Mon, 13 Mar 2023 11:08:29 +0100
Message-Id: <20230313100829.13136-3-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313100829.13136-1-wenjia@linux.ibm.com>
References: <20230313100829.13136-1-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R8m3JLlHSfUA9w6md6R78dO24vLqF365
X-Proofpoint-GUID: BvTtGOgltMhMBeSLd9dwVbF6klpMhQ4S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_02,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303130078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

CLC message initialization was not properly reversed in error handling path.

Reported-and-suggested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
---
 net/smc/af_smc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index a4cccdfdc00a..50052f53a1dd 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3498,6 +3498,7 @@ static int __init smc_init(void)
 out_nl:
 	smc_nl_exit();
 out_ism:
+	smc_clc_exit();
 	smc_ism_exit();
 out_pernet_subsys_stat:
 	unregister_pernet_subsys(&smc_net_stat_ops);
-- 
2.37.2

