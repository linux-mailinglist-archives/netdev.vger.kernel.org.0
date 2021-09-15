Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9628040BE9B
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbhIODyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8384 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236475AbhIODyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:54:22 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18F1U6Vj006372
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=s9UgmSA5Q5oMi/jB4F1Iurt2iPNDtnBoycFp7GyHXYQ=;
 b=FmqztGmV7/GpFXODfwNdMqAfxyy97jhvzGZujoGCRyLiKKjNeqLakrPQHCN6tqpuIgMY
 KMk+E/nUnYQtop10LT7OLzEuP2iVkAwzgMJ4cpIcPkk+8kBre1uIB3WTe2Q8qBP3KbtF
 /MkyHP8+pPXTkcUeBpgWgd/wGiQq2MyROeHmon46eCJHniWOWAInYi47WkCAN0LwR879
 swNn4M+i2KVX+APrS/2ny41TkQG1IdsJJMvs/CPf6fuXTykV9rRZoecMpFvEYf009ckY
 qYxXaUGI0Z+DURCDdmWsTU8Dd590/58WrkeBj65IWOwT7k5wrHVIPJ72gOdYiTyQ/NA0 iw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b377kj295-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:03 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18F3lpsZ024773
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:02 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 3b0m3bhjnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:02 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18F3r1JW9962136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:53:01 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7992A112061;
        Wed, 15 Sep 2021 03:53:01 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30191112065;
        Wed, 15 Sep 2021 03:53:00 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.142.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 03:52:59 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next RESEND v2 0/9] ibmvnic: Reuse ltb, rx, tx pools
Date:   Tue, 14 Sep 2021 20:52:50 -0700
Message-Id: <20210915035259.355092-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xBW0HkfBjaSZRdHkjp_0Jb6YBF-HXDpc
X-Proofpoint-GUID: xBW0HkfBjaSZRdHkjp_0Jb6YBF-HXDpc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=1
 suspectscore=0 bulkscore=1 priorityscore=1501 impostorscore=0
 clxscore=1015 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It can take a long time to free and reallocate rx and tx pools and long
term buffer (LTB) during each reset of the VNIC. This is specially true
when the partition (LPAR) is heavily loaded and going through a Logical
Partition Migration (LPM). The long drawn reset causes the LPAR to lose
connectivity for extended periods of time and results in "RMC connection"
errors and the LPM failing.

What is worse is that during the LPM we could get a failover because
of the lost connectivity. At that point, the vnic driver releases
even the resources it has already allocated and starts over.

As long as the resources we have already allocated are valid/applicable,
we might as well hold on to them while trying to allocate the remaining
resources. This patch set attempts to reuse the resources previously
allocated as long as they are valid. It seems to vastly improve the
time taken for the vnic reset and signficantly reduces the chances of
getting the RMC connection errors. We do get still them occasionally,
but appears to be for reasons other than memory allocation delays and
those are still being investigated.

If the backing devices for a vnic adapter are not "matched" (see "pool
parameters" in patches 8 and 9) it is possible that we will still free
all the resources and allocate them. If that becomes a common problem,
we have to address it separately.

Thanks to input and extensive testing from Brian King, Cris Forno,
Dany Madden, Rick Lindsley.

Changelog[v2]
	[Jakub Kicinski] Fix kdoc issues

Sukadev Bhattiprolu (9):
  ibmvnic: consolidate related code in replenish_rx_pool()
  ibmvnic: Fix up some comments and messages
  ibmvnic: Use/rename local vars in init_rx_pools
  ibmvnic: Use/rename local vars in init_tx_pools
  ibmvnic: init_tx_pools move loop-invariant code out
  ibmvnic: use bitmap for LTB map_ids
  ibmvnic: Reuse LTB when possible
  ibmvnic: Reuse rx pools when possible
  ibmvnic: Reuse tx pools when possible

 drivers/net/ethernet/ibm/ibmvnic.c | 640 +++++++++++++++++++----------
 drivers/net/ethernet/ibm/ibmvnic.h |  10 +-
 2 files changed, 427 insertions(+), 223 deletions(-)

-- 
2.26.2

