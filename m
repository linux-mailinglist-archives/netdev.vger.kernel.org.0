Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168011BE22B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgD2PLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgD2PLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:38 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF34Vg028626;
        Wed, 29 Apr 2020 11:11:33 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q7qhsxtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:33 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFAxHc015235;
        Wed, 29 Apr 2020 15:11:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu70q0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBToQ63504530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2418AAE057;
        Wed, 29 Apr 2020 15:11:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D07E0AE05F;
        Wed, 29 Apr 2020 15:11:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:28 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 00/13] net/smc: preparations for SMC-R link failover
Date:   Wed, 29 Apr 2020 17:10:36 +0200
Message-Id: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=1
 mlxlogscore=947 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series prepares the SMC code for the implementation of SMC-R link 
failover capabilities which are still missing to reach full compliance with 
RFC 7609.
The code changes are separated into 65 patches which together form the new
functionality. I tried to create meaningful patches which allow to follow the 
implementation.

Question: how to handle the remaining 52 patches? All of them are needed for 
link failover to work and should make it into the same merge window. 
Can I send them all together?

The SMC-R implementation will transparently make use of the link failover 
feature when matching RoCE devices are available, no special setup is required.
All RoCE devices with the same PNET ID as the TCP device (hardware-defined or 
user-defined via the smc_pnet tool) are candidates to get used to form a link 
in a link group. When at least 2 RoCE devices are available on both 
communication endpoints then a symmetric link group is formed, meaning the link 
group has 2 independent links. If one RoCE device goes down then all connections 
on this link are moved to the surviving link. Upon recovery of the failing 
device or availability of a new one, the symmetric link group will be restored.

Karsten Graul (13):
  net/smc: rework pnet table to support SMC-R failover
  net/smc: separate function for link initialization
  net/smc: introduce link_idx for link group array
  net/smc: convert static link ID to dynamic references
  net/smc: convert static link ID instances to support multiple links
  net/smc: multi-link support for smc_rmb_rtoken_handling()
  net/smc: add new link state and related helpers
  net/smc: move testlink work to system work queue
  net/smc: simplify link deactivation
  net/smc: use worker to process incoming llc messages
  net/smc: process llc responses in tasklet context
  net/smc: use mutex instead of rwlock_t to protect buffers
  net/smc: move llc layer related init and clear into smc_llc.c

 net/smc/af_smc.c   |  79 ++++---
 net/smc/smc.h      |   1 +
 net/smc/smc_cdc.c  |   8 +-
 net/smc/smc_clc.c  |  12 +-
 net/smc/smc_clc.h  |   1 +
 net/smc/smc_core.c | 542 +++++++++++++++++++++++++++++----------------
 net/smc/smc_core.h |  78 ++++---
 net/smc/smc_ib.c   |  63 +++---
 net/smc/smc_ib.h   |  10 +-
 net/smc/smc_ism.c  |   3 +-
 net/smc/smc_llc.c  | 396 ++++++++++++++++++---------------
 net/smc/smc_llc.h  |  16 +-
 net/smc/smc_pnet.c | 539 +++++++++++++++++++++++++-------------------
 net/smc/smc_pnet.h |   2 +
 net/smc/smc_tx.c   |  13 +-
 net/smc/smc_wr.c   |   2 +-
 16 files changed, 1063 insertions(+), 702 deletions(-)

-- 
2.17.1

