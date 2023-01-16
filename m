Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EA966BA3F
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjAPJ1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjAPJ12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:27:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D434166DF;
        Mon, 16 Jan 2023 01:27:27 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30G8d1XS005079;
        Mon, 16 Jan 2023 09:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=nBmVwqKm6pAyHknSyUy7U+JeXFcrtiZcVvJUMP/x0Z0=;
 b=L01DLgTV0MkxN5snS3u0IC8wupUClzdW7NWpyz711dUEDnReHHMLzUdkk+R3nWr5rL5c
 uF7Zu3tERc2F5Q5vbKcjYm9QP6KTH1GWK/dhWmIg1smFJngNBBs4cPTSI+ACPLMALSvW
 ze8BsGAc2hV/YHmBNW9Sv2QWK16qH+h6tOBsdvIF0NnlxRPwZf0L3XVtebuombiJ/PdT
 FKGXjO17MZ7kGJDI3wk8KcFP0IQJTIyWaTAjvuu6s7z5AC+g4Pc1Ts9Rdqx+WVgCD/ea
 uKluakemhmZeaXNuY3uuGn/yWViSaT7kN7uj/Vr+i6Ve9df5PadMtLHGwJvhdsTGY75j 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n48y5hjpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:21 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30G9KX8C001233;
        Mon, 16 Jan 2023 09:27:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n48y5hjnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:21 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30G1j8Ja007008;
        Mon, 16 Jan 2023 09:27:19 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfj6w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 09:27:19 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30G9RFaT24248762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 09:27:15 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D1C02004B;
        Mon, 16 Jan 2023 09:27:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C587B20040;
        Mon, 16 Jan 2023 09:27:14 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.177.79])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 09:27:14 +0000 (GMT)
From:   Jan Karcher <jaka@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
Subject: [net-next 0/8] drivers/s390/net/ism: Add generalized interface
Date:   Mon, 16 Jan 2023 10:27:04 +0100
Message-Id: <20230116092712.10176-1-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KaE-cy3lDTIzSWyxEtlHLUNoPUqx2e1F
X-Proofpoint-ORIG-GUID: IdEAzlPz8pnWlI0wCxOx9_g_q8NQyDuT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_06,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 clxscore=1011 spamscore=0 mlxscore=0
 mlxlogscore=743 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, there was no clean separation between SMC-D code and the ISM
device driver.This patch series addresses the situation to make ISM available
for uses outside of SMC-D.
In detail: SMC-D offers an interface via struct smcd_ops, which only the
ISM module implements so far. However, there is no real separation between
the smcd and ism modules, which starts right with the ISM device
initialization, which calls directly into the SMC-D code.
This patch series introduces a new API in the ISM module, which allows
registration of arbitrary clients via include/linux/ism.h: struct ism_client.
Furthermore, it introduces a "pure" struct ism_dev (i.e. getting rid of
dependencies on SMC-D in the device structure), and adds a number of API
calls for data transfers via ISM (see ism_register_dmb() & friends).
Still, the ISM module implements the SMC-D API, and therefore has a number
of internal helper functions for that matter.
Note that the ISM API is consciously kept thin for now (as compared to the
SMC-D API calls), as a number of API calls are only used with SMC-D and
hardly have any meaningful usage beyond SMC-D, e.g. the VLAN-related calls.

Stefan Raspl (8):
  net/smc: Terminate connections prior to device removal
  net/ism: Add missing calls to disable bus-mastering
  s390/ism: Introduce struct ism_dmb
  net/ism: Add new API for client registration
  net/smc: Register SMC-D as ISM client
  net/smc: Separate SMC-D and ISM APIs
  s390/ism: Consolidate SMC-D-related code
  net/smc: De-tangle ism and smc device initialization

 drivers/s390/net/ism.h     |  21 +--
 drivers/s390/net/ism_drv.c | 376 ++++++++++++++++++++++++++++++-------
 include/linux/ism.h        |  96 ++++++++++
 include/net/smc.h          |  24 +--
 net/smc/af_smc.c           |   9 +-
 net/smc/smc_clc.c          |  11 +-
 net/smc/smc_core.c         |  13 +-
 net/smc/smc_diag.c         |   3 +-
 net/smc/smc_ism.c          | 181 ++++++++++--------
 net/smc/smc_ism.h          |   3 +-
 net/smc/smc_pnet.c         |  40 ++--
 11 files changed, 561 insertions(+), 216 deletions(-)
 create mode 100644 include/linux/ism.h

-- 
2.25.1

