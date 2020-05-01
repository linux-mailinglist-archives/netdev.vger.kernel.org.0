Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129741C111C
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgEAKsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6706 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728606AbgEAKsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:31 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AY80O103870;
        Fri, 1 May 2020 06:48:27 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r821wrn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:27 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041AkETB011525;
        Fri, 1 May 2020 10:48:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 30mcu5bf8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AmMvQ44171386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:48:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65B05A4054;
        Fri,  1 May 2020 10:48:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 299F4A405B;
        Fri,  1 May 2020 10:48:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:22 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 00/13] net/smc: extent buffer mapping and port handling
Date:   Fri,  1 May 2020 12:48:00 +0200
Message-Id: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_03:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 suspectscore=1 bulkscore=0 adultscore=6
 priorityscore=1501 mlxlogscore=724 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functionality to map/unmap and register/unregister memory buffers for
specific SMC-R links and for the whole link group. Prepare LLC layer messages
for the support of multiple links and extent the processing of adapter events.
And add further small preparations needed for the SMC-R failover support.

Karsten Graul (13):
  net/smc: multiple link support for rmb buffer registration
  net/smc: unmapping of buffers to support multiple links
  net/smc: map and register buffers for a new link
  net/smc: extend smc_llc_send_add_link() and smc_llc_send_delete_link()
  net/smc: mutex to protect the lgr against parallel reconfigurations
  net/smc: remember PNETID of IB device for later device matching
  net/smc: add smcr_port_add() and smcr_link_up() processing
  net/smc: add smcr_port_err() and smcr_link_down() processing
  net/smc: take link down instead of terminating the link group
  net/smc: remove DELETE LINK processing from smc_core.c
  net/smc: introduce smc_pnet_find_alt_roce()
  net/smc: allocate index for a new link
  net/smc: llc_add_link_work to handle ADD_LINK LLC requests

 net/smc/af_smc.c   |  63 +++----
 net/smc/smc_core.c | 420 +++++++++++++++++++++++++++++++++++----------
 net/smc/smc_core.h |  18 +-
 net/smc/smc_ib.c   |   3 +-
 net/smc/smc_llc.c  | 150 ++++++++++------
 net/smc/smc_llc.h  |  19 +-
 net/smc/smc_pnet.c |  15 +-
 net/smc/smc_pnet.h |   5 +-
 net/smc/smc_tx.c   |   2 +-
 net/smc/smc_wr.c   |  19 +-
 10 files changed, 518 insertions(+), 196 deletions(-)

-- 
2.17.1

