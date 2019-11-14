Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB4FC5D1
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfKNMC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:02:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbfKNMC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:02:58 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEBv3sq139684
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:02:57 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w95rat5r3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:02:57 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 14 Nov 2019 12:02:55 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 12:02:53 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEC2EjZ43057428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 12:02:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B98B4C04A;
        Thu, 14 Nov 2019 12:02:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F93B4C052;
        Thu, 14 Nov 2019 12:02:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 12:02:51 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 0/8] net/smc: improve termination handling (part 3)
Date:   Thu, 14 Nov 2019 13:02:39 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19111412-0012-0000-0000-0000036393A8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111412-0013-0000-0000-0000219F0CC7
Message-Id: <20191114120247.68889-1-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=658 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Part 3 of the SMC termination patches improves the link group
termination processing and introduces the ability to immediately
terminate a link group.

Ursula Braun (8):
  net/smc: fix final cleanup sequence for SMCD devices
  net/smc: immediate termination for SMCD link groups
  net/smc: abnormal termination of SMCD link groups
  net/smc: introduce bookkeeping of SMCD link groups
  net/smc: no WR buffer wait for terminating link group
  net/smc: abnormal termination without orderly flag
  net/smc: wait for tx completions before link freeing
  net/smc: immediate termination for SMCR link groups

 drivers/s390/net/ism.h |   2 -
 include/net/smc.h      |   4 +
 net/smc/smc_cdc.c      |   3 +
 net/smc/smc_clc.c      |   2 +-
 net/smc/smc_close.c    |  25 ++++--
 net/smc/smc_core.c     | 197 ++++++++++++++++++++++++++++++-----------
 net/smc/smc_core.h     |   8 +-
 net/smc/smc_ib.c       |   5 +-
 net/smc/smc_ism.c      |  22 ++++-
 net/smc/smc_llc.c      |   9 +-
 net/smc/smc_tx.c       |   2 +-
 net/smc/smc_wr.c       |  37 ++++++--
 net/smc/smc_wr.h       |  10 +++
 13 files changed, 250 insertions(+), 76 deletions(-)

-- 
2.17.1

