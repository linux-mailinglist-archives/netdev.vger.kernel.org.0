Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCEE678456
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbjAWSSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjAWSSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:18:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35CECA28;
        Mon, 23 Jan 2023 10:18:40 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NGUXJ8013549;
        Mon, 23 Jan 2023 18:18:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=eijx75EMWzOEnkolUuY7smuZ9FzwWk2aw0VoVKGflFU=;
 b=mCALP/4xP7A+LqAOXfa75x8zEB7Fj7+yLECpbv8rIDf4PPNc41Vw5RrpVcRGaT1iRjaa
 MYwDobiW7ETB1lxvmXoV6kNf5fNaWm3w3nLa8p0VdMm/0KuiP5rHZaiXubfFfPeKwEPC
 9AIvl+yzU+ybpbBoWHNRRSTcH599OxFOLaDx9yL9j3znlvYx6KU/AkcW2yh+lPjHfGKN
 h+lNlVAZlg0KeBVdp8NjXtUNrOYaijBCE4H1SoRZcjEu8KFCWl3zhrfkL4tYnLPyb7Ha
 4mU5RlVHL7FFj3+dsGY2d+eCWQmV9LXPYsAsvGr7km3pvNZI0OXTtHFxEck8enNKfWA6 /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9wtsjy1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:31 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30NGgUuA002329;
        Mon, 23 Jan 2023 18:18:30 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n9wtsjy0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:30 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30N668XG019104;
        Mon, 23 Jan 2023 18:18:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n87p6jqbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 18:18:27 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30NIIOp442008872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 18:18:24 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2261B2004B;
        Mon, 23 Jan 2023 18:18:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E0B220040;
        Mon, 23 Jan 2023 18:18:23 +0000 (GMT)
Received: from LAPTOP-8S6R7U4L.localdomain (unknown [9.171.0.149])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 23 Jan 2023 18:18:22 +0000 (GMT)
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
Subject: [net-next v2 0/8] drivers/s390/net/ism: Add generalized interface
Date:   Mon, 23 Jan 2023 19:17:44 +0100
Message-Id: <20230123181752.1068-1-jaka@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H6Nc3H5l29aSNreBYH78V5mAGi6nWRzH
X-Proofpoint-GUID: vSF9-UVb_0uOuoTlRaYC44vOekYOq9jU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 mlxlogscore=708 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230173
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

v1 -> v2:
  Removed s390x dependency which broke config for other archs.

Stefan Raspl (8):
  net/smc: Terminate connections prior to device removal
  net/ism: Add missing calls to disable bus-mastering
  s390/ism: Introduce struct ism_dmb
  net/ism: Add new API for client registration
  net/smc: Register SMC-D as ISM client
  net/smc: Separate SMC-D and ISM APIs
  s390/ism: Consolidate SMC-D-related code
  net/smc: De-tangle ism and smc device initialization

 drivers/s390/net/ism.h     |  19 +-
 drivers/s390/net/ism_drv.c | 376 ++++++++++++++++++++++++++++++-------
 include/linux/ism.h        |  98 ++++++++++
 include/net/smc.h          |  24 +--
 net/smc/af_smc.c           |   9 +-
 net/smc/smc_clc.c          |  11 +-
 net/smc/smc_core.c         |  13 +-
 net/smc/smc_diag.c         |   3 +-
 net/smc/smc_ism.c          | 180 ++++++++++--------
 net/smc/smc_ism.h          |   3 +-
 net/smc/smc_pnet.c         |  40 ++--
 11 files changed, 560 insertions(+), 216 deletions(-)
 create mode 100644 include/linux/ism.h

-- 
2.25.1

