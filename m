Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154F2222765
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgGPPj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:39:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729368AbgGPPjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:16 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GFXYAM012255;
        Thu, 16 Jul 2020 11:39:14 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32afvmc4sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 11:39:14 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GFZdBQ023539;
        Thu, 16 Jul 2020 15:39:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 327527wwdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 15:39:12 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GFbs8s18743796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 15:37:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96DE442045;
        Thu, 16 Jul 2020 15:37:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C9A742041;
        Thu, 16 Jul 2020 15:37:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 15:37:54 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net 00/10] net/smc: fixes 2020-07-16
Date:   Thu, 16 Jul 2020 17:37:36 +0200
Message-Id: <20200716153746.77303-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_07:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=549
 bulkscore=0 clxscore=1015 spamscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch series for smc to netdev's net tree.

The patches address problems caused by late or unexpected link layer
control packets, dma sync calls for unmapped memory, freed buffers
that are not removed from the buffer list and a possible null pointer
access that results in a crash.

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

