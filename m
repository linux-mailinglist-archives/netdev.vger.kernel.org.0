Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047391C3922
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgEDMTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbgEDMTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:14 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044C34Se124906;
        Mon, 4 May 2020 08:19:12 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5d3s1fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9xaY029269;
        Mon, 4 May 2020 12:19:10 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5mryf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJ7I062193666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E0ACA4040;
        Mon,  4 May 2020 12:19:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF346A4059;
        Mon,  4 May 2020 12:19:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:06 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 00/12] net/smc: add failover processing
Date:   Mon,  4 May 2020 14:18:36 +0200
Message-Id: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_07:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 adultscore=0
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=725 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds the actual SMC-R link failover processing and 
improved link group termination. There will be one more (very small) 
series after this which will complete the SMC-R link failover support.

Karsten Graul (12):
  net/smc: save state of last sent CDC message
  net/smc: switch connections to alternate link
  net/smc: send failover validation message
  net/smc: handle incoming CDC validation message
  net/smc: wait for departure of an IB message
  net/smc: send DELETE_LINK,ALL message and wait for send to complete
  net/smc: assign link to a new connection
  net/smc: asymmetric link tagging
  net/smc: add termination reason and handle LLC protocol violation
  net/smc: improve termination processing
  net/smc: create improved SMC-R link_uid
  net/smc: save SMC-R peer link_uid

 net/smc/af_smc.c   |   2 +
 net/smc/smc.h      |   6 +
 net/smc/smc_cdc.c  |  86 +++++++++++--
 net/smc/smc_cdc.h  |   2 +
 net/smc/smc_core.c | 303 +++++++++++++++++++++++++++++++++++++--------
 net/smc/smc_core.h |  14 ++-
 net/smc/smc_llc.c  | 111 +++++++++++++++--
 net/smc/smc_llc.h  |  12 ++
 net/smc/smc_tx.c   |  12 +-
 net/smc/smc_wr.c   |  39 ++++++
 net/smc/smc_wr.h   |   2 +
 11 files changed, 514 insertions(+), 75 deletions(-)

-- 
2.17.1

