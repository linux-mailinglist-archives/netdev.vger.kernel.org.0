Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54799580080
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbiGYOKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235381AbiGYOKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:10:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAACDF7F;
        Mon, 25 Jul 2022 07:10:29 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PDktmg024174;
        Mon, 25 Jul 2022 14:10:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Z2DvxH+feuTeO10KiHwLusFC9eMJvag5kw4qQmoU2dY=;
 b=nRd9yZ+0y3ojlSMTnKlMiBFC105zen864yBMOdeihFLAlXFeYhuA6y3Tt431WjSfeAYr
 x6a3HyS8AO7WwGBKQkogX5LdJ8aXo5MMnbzP6d+ymxk4ZVldWbIMZVgFVgq/aY+sO1uu
 2dcWyo8Hm6mdtB/WPlvxuFX2RIj+JuL2J2MPJUsf7oICRs2ZxxiMDKePgCIkMdPAKXWi
 SwDOGP4hHNmpfH2t2/N4cQ/Y6H7RXI4k4bXA8dInnmftTbzXY4ea1AHGd8hHaJK1NabM
 LTkA/Nfcuk7+p5Px8/wPSGDNmAGcYtM98mL4jdi+pQhLUmTXvCzV/M70K0VXgNpKKYXn rg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhvc391em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 14:10:27 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26PE5vQl023064;
        Mon, 25 Jul 2022 14:10:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3hg98fh0ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 14:10:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26PEALOE20971904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 14:10:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7D5142042;
        Mon, 25 Jul 2022 14:10:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C05AE4203F;
        Mon, 25 Jul 2022 14:10:18 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.211.136.94])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Jul 2022 14:10:18 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Subject: [PATCH net-next 4/4] net/smc: Enable module load on netlink usage
Date:   Mon, 25 Jul 2022 16:10:00 +0200
Message-Id: <20220725141000.70347-5-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220725141000.70347-1-wenjia@linux.ibm.com>
References: <20220725141000.70347-1-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 09UH7VOr3W3sYg87-YVicofN0AQWXKdg
X-Proofpoint-ORIG-GUID: 09UH7VOr3W3sYg87-YVicofN0AQWXKdg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_09,2022-07-25_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207250059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Raspl <raspl@linux.ibm.com>

Previously, the smc and smc_diag modules were automatically loaded as
dependencies of the ism module whenever an ISM device was present.
With the pending rework of the ISM API, the smc module will no longer
automatically be loaded in presence of an ISM device. Usage of an AF_SMC
socket will still trigger loading of the smc modules, but usage of a
netlink socket will not.
This is addressed by setting the correct module aliases.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Wenjia Zhang < wenjia@linux.ibm.com>
---
 net/smc/af_smc.c   | 1 +
 net/smc/smc_diag.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6e70d9c10b78..79c1318af1fe 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3515,3 +3515,4 @@ MODULE_DESCRIPTION("smc socket address family");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_SMC);
 MODULE_ALIAS_TCP_ULP("smc");
+MODULE_ALIAS_GENL_FAMILY(SMC_GENL_FAMILY_NAME);
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 1fca2f90a9c7..80ea7d954ece 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -268,3 +268,4 @@ module_init(smc_diag_init);
 module_exit(smc_diag_exit);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_NETLINK, NETLINK_SOCK_DIAG, 43 /* AF_SMC */);
+MODULE_ALIAS_GENL_FAMILY(SMCR_GENL_FAMILY_NAME);
-- 
2.35.2

