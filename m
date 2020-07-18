Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E65224B4F
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 15:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgGRNGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 09:06:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbgGRNGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 09:06:53 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ID1u3S089828;
        Sat, 18 Jul 2020 09:06:51 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32bsyefrg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Jul 2020 09:06:51 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06ID6AZh003328;
        Sat, 18 Jul 2020 13:06:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 32brq8065c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Jul 2020 13:06:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06ID6j6x23069084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jul 2020 13:06:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCB96AE045;
        Sat, 18 Jul 2020 13:06:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94A01AE04D;
        Sat, 18 Jul 2020 13:06:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 18 Jul 2020 13:06:45 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net v2 00/10] net/smc: fixes 2020-07-16
Date:   Sat, 18 Jul 2020 15:06:08 +0200
Message-Id: <20200718130618.16724-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-18_05:2020-07-17,2020-07-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 suspectscore=1 spamscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxlogscore=617 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007180095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net tree.

The patches address problems caused by late or unexpected link layer
control packets, dma sync calls for unmapped memory, freed buffers
that are not removed from the buffer list and a possible null pointer
access that results in a crash.

v1->v2: in patch 4, improve patch description and correct the comment
        for the new mutex

Thanks,
Karsten

Karsten Graul (10):
  net/smc: handle unexpected response types for confirm link
  net/smc: clear link during SMC client link down processing
  net/smc: fix link lookup for new rdma connections
  net/smc: protect smc ib device initialization
  net/smc: drop out-of-flow llc response messages
  net/smc: move add link processing for new device into llc layer
  net/smc: fix handling of delete link requests
  net/smc: do not call dma sync for unmapped memory
  net/smc: remove freed buffer from list
  net/smc: fix restoring of fallback changes

 net/smc/af_smc.c   |  12 +++--
 net/smc/smc_core.c | 105 ++++++++-----------------------------
 net/smc/smc_core.h |   5 ++
 net/smc/smc_ib.c   |  16 ++++--
 net/smc/smc_ib.h   |   1 +
 net/smc/smc_llc.c  | 127 ++++++++++++++++++++++++++++++---------------
 net/smc/smc_llc.h  |   2 +-
 7 files changed, 135 insertions(+), 133 deletions(-)

-- 
2.17.1

