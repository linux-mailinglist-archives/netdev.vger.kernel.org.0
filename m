Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6E2F384E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392191AbhALSP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:15:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391180AbhALSPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:15:25 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CI1t1S060522
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2ysn6dBFHdOfGm4pt1NI3dNswx+REmyZ7EkSfQeun8s=;
 b=Wh+8Fg7rNYcqph8sgmzhn15dRxiFsUyYe3EfRwLTqzUX6MgKVbC4h+pRxVbLh5HgoOXw
 9hLlJZlgc0SalCp12FPHNZ986fpCjZclQ8QlXH61s/+5bjQSWSChKZ4gMKCwTEAeyyYu
 wQX6453oJTfFBbNbnDb1Sz4xJRz7JQ3v2pIgm8mlzJRQiYWO7TfE8BX9cgBfdsH/da44
 aI3+Wep2uXJbGpX5uXZf3KqUq4BmINl0VmFAHeN6Jx/tOGqToRrfCaMQ2D/4GaepYBDV
 xY1Ta2pDQ8fNK0p6x+R/Vn+aiW6BO0pNE8BfoKHst61DCYz6bydc7CT5kGMHk11mmmA1 Ow== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361fh62tyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:14:44 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CI82Ck028871
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:44 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 35y4495u0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:14:44 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CIEheR7340522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:14:43 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EAA6B206B;
        Tue, 12 Jan 2021 18:14:43 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74DE6B2065;
        Tue, 12 Jan 2021 18:14:42 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.179.93])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 18:14:42 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com
Subject: [PATCH net-next v2 0/7] ibmvnic: Use more consistent locking
Date:   Tue, 12 Jan 2021 10:14:34 -0800
Message-Id: <20210112181441.206545-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=580 malwarescore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use more consistent locking when reading/writing the adapter->state
field. This patch set fixes a race condition during ibmvnic_open()
where the adapter could be left in the PROBED state if a reset occurs
at the wrong time. This can cause networking to not come up during
boot and potentially require manual intervention in bringing up
applications that depend on the network.

Changelog[v2] [Address comments from Jakub Kicinski]
	- Fix up commit log for patch 5/7 and drop unnecessary variable
	- Format Fixes line properly (no wrapping, no blank lines)

Sukadev Bhattiprolu (7):
  ibmvnic: restore state in change-param reset
  ibmvnic: update reset function prototypes
  ibmvnic: avoid allocating rwi entries
  ibmvnic: switch order of checks in ibmvnic_reset
  ibmvnic: serialize access to work queue
  ibmvnic: check adapter->state under state_lock
  ibmvnic: add comments about state_lock

 drivers/net/ethernet/ibm/ibmvnic.c | 347 ++++++++++++++++++++---------
 drivers/net/ethernet/ibm/ibmvnic.h |  70 +++++-
 2 files changed, 306 insertions(+), 111 deletions(-)

-- 
2.26.2

