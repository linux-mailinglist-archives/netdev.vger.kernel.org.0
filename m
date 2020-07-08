Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08618218ABC
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgGHPFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:05:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729909AbgGHPFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:05:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068F1YfZ090075;
        Wed, 8 Jul 2020 11:05:22 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325d2cfnan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 11:05:21 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068EtdKd019629;
        Wed, 8 Jul 2020 15:05:19 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3251dw0dye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 15:05:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068F5HiF21823488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 15:05:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01C98AE055;
        Wed,  8 Jul 2020 15:05:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA572AE056;
        Wed,  8 Jul 2020 15:05:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jul 2020 15:05:16 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 0/5] net/smc: fixes 2020-07-08
Date:   Wed,  8 Jul 2020 17:05:10 +0200
Message-Id: <20200708150515.44938-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_12:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0
 suspectscore=1 cotscore=-2147483648 adultscore=0 mlxlogscore=960
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080103
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net tree.

The patches fix problems found during more testing of SMC
functionality, resulting in hang conditions and unneeded link
deactivations. The clc module was hardened to be prepared for
possible future SMCD versions.

Thanks,
Karsten

Karsten Graul (2):
  net/smc: separate LLC wait queues for flow and messages
  net/smc: fix work request handling

Ursula Braun (3):
  net/smc: fix sleep bug in smc_pnet_find_roce_resource()
  net/smc: switch smcd_dev_list spinlock to mutex
  net/smc: tolerate future SMCD versions

 net/smc/smc_clc.c  | 45 ++++++++++++++++-------
 net/smc/smc_clc.h  |  2 +
 net/smc/smc_core.c | 51 +++++++++++++++-----------
 net/smc/smc_core.h |  4 +-
 net/smc/smc_ib.c   | 11 +++---
 net/smc/smc_ib.h   |  3 +-
 net/smc/smc_ism.c  | 11 +++---
 net/smc/smc_ism.h  |  3 +-
 net/smc/smc_llc.c  | 91 ++++++++++++++++++++++++++++------------------
 net/smc/smc_pnet.c | 37 ++++++++++---------
 net/smc/smc_wr.c   | 10 +++--
 11 files changed, 163 insertions(+), 105 deletions(-)

-- 
2.17.1

