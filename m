Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80996D092C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbfJIIH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:07:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729844AbfJIIH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:07:58 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9987cWE037507
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 04:07:57 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vha2xk8ma-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 04:07:57 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Wed, 9 Oct 2019 09:07:55 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 9 Oct 2019 09:07:53 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9987MNL35652086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Oct 2019 08:07:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DEB9A4066;
        Wed,  9 Oct 2019 08:07:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7A3AA4065;
        Wed,  9 Oct 2019 08:07:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Oct 2019 08:07:51 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 0/5] net/smc: improve termination handling
Date:   Wed,  9 Oct 2019 10:07:42 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19100908-0012-0000-0000-000003566064
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100908-0013-0000-0000-000021916479
Message-Id: <20191009080747.95516-1-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-09_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=696 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910090076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First set of patches to improve termination handling.

Ursula Braun (5):
  net/smc: separate SMCD and SMCR link group lists
  net/smc: separate locks for SMCD and SMCR link group lists
  net/smc: increase device refcount for added link group
  net/smc: no new connections on disappearing devices
  net/smc: improve close of terminated socket

 include/net/smc.h   |   3 ++
 net/smc/smc_close.c |  40 ++++------------
 net/smc/smc_core.c  | 113 ++++++++++++++++++++++++++++++++++----------
 net/smc/smc_ib.c    |  15 +++++-
 net/smc/smc_ib.h    |   1 +
 net/smc/smc_ism.c   |   5 ++
 net/smc/smc_pnet.c  |   5 +-
 7 files changed, 124 insertions(+), 58 deletions(-)

-- 
2.17.1

