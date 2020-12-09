Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF2F2D3B5B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 07:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgLIGS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 01:18:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725878AbgLIGSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 01:18:55 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B95cGTh111611
        for <netdev@vger.kernel.org>; Wed, 9 Dec 2020 01:18:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LKe+xdz2PdFcE1oixNWGESeCsb0Uy5wyY41bcbK8/uA=;
 b=ry7okDYs4YCbwZ85Ew5iGGgicapRZYrop6Lat92LOY2lcavx4IEBDlRQ9GaDB5jFz03/
 wy9rYd6d1ytzUygBWohhEMKlI3AP7OYs8iHivdwxmHfN5ISJTL0kRH3DZCg1bY0CPR0U
 68JLuv0eRnJ+hWnhJzkoLcvMae9FJI2lt+QOHFXwN39Q+7WQybKkrMPGIrhuhYAdXg9X
 5IznMy4LcYkmjZBDVWaXg8rGFTxd+8u2A98BZUsNiup2xZUflVF7gI03YMMpsPm5CEXu
 pphpgQbUNx5QphTeLCCXSdh6d7aeXoYqdzHu8XpBZLib06FTl9wqpi+ZuzCZVgbuwTq6 kA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ahbdty8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 01:18:15 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B96BwJf031082
        for <netdev@vger.kernel.org>; Wed, 9 Dec 2020 06:18:14 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3581u9cnmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:18:14 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B96ICdM18022756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 06:18:12 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 910426A04D;
        Wed,  9 Dec 2020 06:18:12 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21B176A047;
        Wed,  9 Dec 2020 06:18:12 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.139.133])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 06:18:11 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 0/3] lockless version of netdev_notify_peers
Date:   Wed,  9 Dec 2020 00:18:08 -0600
Message-Id: <20201209061811.48524-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_03:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=1
 mlxlogscore=929 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 bulkscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduce the lockless version of netdev_notify_peers
and then apply it to the relevant drivers.

In v1, a more appropriate name __netdev_notify_peers is used;
netdev_notify_peers is converted to call the new helper. 

Lijun Pan (3):
  net: core: introduce __netdev_notify_peers
  use __netdev_notify_peers in ibmvnic
  use __netdev_notify_peers in hyperv

 drivers/net/ethernet/ibm/ibmvnic.c |  9 +++------
 drivers/net/hyperv/netvsc_drv.c    |  6 +++---
 include/linux/netdevice.h          |  1 +
 net/core/dev.c                     | 22 ++++++++++++++++++++--
 4 files changed, 27 insertions(+), 11 deletions(-)

-- 
2.23.0

