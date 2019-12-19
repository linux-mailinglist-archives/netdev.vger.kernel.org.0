Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21AFB126E1B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 20:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfLSTlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 14:41:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbfLSTlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 14:41:15 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJJcFrA067132;
        Thu, 19 Dec 2019 14:41:12 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0c659gdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 14:41:11 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBJJcNLk067694;
        Thu, 19 Dec 2019 14:41:11 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0c659gcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 14:41:11 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBJJeW5N010959;
        Thu, 19 Dec 2019 19:41:10 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 2wvqc7ddwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 19:41:10 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBJJf9Be49611248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 19:41:09 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27501BE051;
        Thu, 19 Dec 2019 19:41:09 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C70A8BE056;
        Thu, 19 Dec 2019 19:41:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.22.203])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Dec 2019 19:41:07 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v3, 0/2] net/ethtool: Introduce link_ksettings API for virtual network devices
Date:   Thu, 19 Dec 2019 13:40:55 -0600
Message-Id: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 mlxlogscore=645 adultscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 suspectscore=1 bulkscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190145
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
  Three virtual devices (ibmveth, virtio_net, and netvsc) all have
    similar code to set/get link settings and validate ethtool command.
    To     eliminate duplication of code, it is factored out into
    core/ethtool.c.
  With get/set link settings functions in core/ethtool.c, ibmveth,
    netvsc, and virtio now use the core's helper function.

 drivers/net/ethernet/ibm/ibmveth.c | 60 +++++++++++++++++++++-----------------
 drivers/net/ethernet/ibm/ibmveth.h |  3 ++
 drivers/net/hyperv/netvsc_drv.c    | 21 ++++---------
 drivers/net/virtio_net.c           | 45 ++++------------------------
 include/linux/ethtool.h            |  2 ++
 net/core/ethtool.c                 | 56 +++++++++++++++++++++++++++++++++++
 6 files changed, 104 insertions(+), 83 deletions(-)

--
1.8.3.1
