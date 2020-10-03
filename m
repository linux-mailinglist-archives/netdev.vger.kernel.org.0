Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7EE2821A1
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 07:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgJCFnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 01:43:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48978 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCFnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 01:43:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0935dw1J156091;
        Sat, 3 Oct 2020 05:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=9KxNDqQb/daFeFk4axWtWUrYIM1JzBO5oMsjX6VTYv4=;
 b=eIu0EI35rkEjtQ6/BtqEmRp6xWyCUxGkUmlkEzOrQbVq26a1x9Uh8wssQZeRZ8rAL3/H
 gvFuNAEwcPxA5HkUNwBtuzniYvmzhzDN9k02TZgRCUyISbCHE/Esnf1m8KglU8vVGpD6
 g+bJMWzr9d8ICsYIaAOZuZj72cgopeOKYK5xsnRDHtI6Siy6WJFsLvw9WM3IntXPxCHB
 WTCk4rzKuoV83v6syIBOxlpZT8Sm3z5AaFw1UwzVWWAptLOXZcoDwPjgE7irVBt2kWiu
 ozhVLH/ZVMHtRdGKrieZndZZOV/7kzNAxOmHJQt+Im3Q39NzS72qTLn7t1w5LQvbz33P EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetagabk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 05:43:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0935eaSP071195;
        Sat, 3 Oct 2020 05:43:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33xh3y29ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 05:43:13 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0935hDsX026233;
        Sat, 3 Oct 2020 05:43:13 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 22:43:12 -0700
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, lingshan.zhu@intel.com
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v3 0/2] vhost-vdpa mapping error path fixes
Date:   Sat,  3 Oct 2020 01:02:08 -0400
Message-Id: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
has following issues in the failure path of IOTLB update:

1) vhost_vdpa_map() does not clean up dangling iotlb entry
   upon mapping failure

2) vhost_vdpa_process_iotlb_update() has leakage of pinned
   pages in case of vhost_vdpa_map() failure

This patchset attempts to address the above issues.

Changes in v3:
- Factor out changes in vhost_vdpa_map() and the fix for
  page pinning leak to separate patches (Jason)

---
Si-Wei Liu (2):
  vhost-vdpa: fix vhost_vdpa_map() on error condition
  vhost-vdpa: fix page pinning leakage in error path

 drivers/vhost/vdpa.c | 122 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 74 insertions(+), 48 deletions(-)

-- 
1.8.3.1

