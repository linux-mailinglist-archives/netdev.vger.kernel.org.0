Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F977DEF0C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfJUONo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:13:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729216AbfJUONk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:13:40 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9LEDKq3059776
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:40 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vsbkn7epv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:39 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Mon, 21 Oct 2019 15:13:25 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 21 Oct 2019 15:13:22 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9LEDLoo42598814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 14:13:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2B644C04E;
        Mon, 21 Oct 2019 14:13:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A94494C05A;
        Mon, 21 Oct 2019 14:13:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Oct 2019 14:13:19 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 0/8] net/smc: improve termination handling (part 2)
Date:   Mon, 21 Oct 2019 16:13:07 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19102114-0020-0000-0000-0000037BFAEB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102114-0021-0000-0000-000021D23247
Message-Id: <20191021141315.58969-1-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=555 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910210135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More patches to address abnormal termination processing of
sockets and link groups.

Ursula Braun (8):
  net/smc: cancel send and receive for terminated socket
  net/smc: terminate link group without holding lgr lock
  net/smc: improve abnormal termination locking
  net/smc: improve link group freeing
  net/smc: tell peers about abnormal link group termination
  net/smc: improve abnormal termination of link groups
  net/smc: introduce link group termination worker
  net/smc: remove close abort worker

 net/smc/af_smc.c    |   4 ++
 net/smc/smc.h       |   1 +
 net/smc/smc_cdc.c   |   4 +-
 net/smc/smc_close.c |  32 ++++++-----
 net/smc/smc_close.h |   2 +
 net/smc/smc_core.c  | 129 +++++++++++++++++++++++++++++++-------------
 net/smc/smc_core.h  |   9 ++++
 net/smc/smc_llc.c   |   2 +-
 net/smc/smc_rx.c    |  10 +++-
 net/smc/smc_tx.c    |  26 +++++----
 net/smc/smc_wr.c    |  10 ++--
 11 files changed, 157 insertions(+), 72 deletions(-)

-- 
2.17.1

