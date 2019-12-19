Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA9E126F3C
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfLSUy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:54:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbfLSUy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 15:54:26 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJKldog025968;
        Thu, 19 Dec 2019 15:54:22 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0g2998rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 15:54:22 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBJKmas9028812;
        Thu, 19 Dec 2019 15:54:22 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0g2998rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 15:54:22 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBJKqmp7027991;
        Thu, 19 Dec 2019 20:54:21 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 2wvqc7dyey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 20:54:21 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBJKsJHv13828424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 20:54:19 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 745B5BE056;
        Thu, 19 Dec 2019 20:54:19 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47C9CBE04F;
        Thu, 19 Dec 2019 20:54:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.22.203])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Dec 2019 20:54:18 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v3, 0/2] net/ethtool: Introduce link_ksettings API for virtual network devices
Date:   Thu, 19 Dec 2019 14:54:08 -0600
Message-Id: <20191219205410.5961-1-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=490 suspectscore=1 lowpriorityscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides an API for drivers of virtual network devices that allows
users to alter initial device speed and duplex settings to reflect the actual
capabilities of underlying hardware. The changes made include two helper
functions ethtool_virtdev_get/set_link_ksettings, which are used to retrieve or
update alterable link settings, respectively. In addition, there is a new
ethtool operation defined to validate those settings provided by the user. This
operation can use either a generic validation function,
ethtool_virtdev_validate_cmd, or one defined by the driver. These changes
resolve code duplication for existing virtual network drivers that have already
implemented this behavior.  In the case of the ibmveth driver, this API is used
to provide this capability for the first time.

---
v3: Factored out duplicated code to core/ethtool to provide API to virtual
    drivers
    
v2: Updated default driver speed/duplex settings to avoid breaking existing
    setups
---

Cris Forno (2):
  net: Factored out similar ethtool link settings for virtual devices to
    core
  net: Enable virtual network devices to use ethtool's set/get link
    settings functions

 drivers/net/ethernet/ibm/ibmveth.c | 60 +++++++++++++++++++++-----------------
 drivers/net/ethernet/ibm/ibmveth.h |  3 ++
 drivers/net/hyperv/netvsc_drv.c    | 21 ++++---------
 drivers/net/virtio_net.c           | 45 ++++------------------------
 include/linux/ethtool.h            |  2 ++
 net/core/ethtool.c                 | 58 ++++++++++++++++++++++++++++++++++++
 6 files changed, 106 insertions(+), 83 deletions(-)

-- 
1.8.3.1

