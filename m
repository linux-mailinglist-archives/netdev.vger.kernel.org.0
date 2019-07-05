Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B824600D8
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfGEGLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 02:11:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34460 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfGEGLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 02:11:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6569kjC038927;
        Fri, 5 Jul 2019 06:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=njjchbeyQ9ZPNqX2QySAMtFMIZChJrkqlsouNqAkdUA=;
 b=AeSSQQCS73GquiO7eM3I7wF5z01t8+ZzqxjPIY95KBGyHsR7iRlHPAMBtALj7tVCXpQz
 ejioFeNVYA2ioW85xZid4AZXMuTmoAgUwE+EcxywDONA3nPr5UuMzi+e64jIbLx7TwPv
 IezsLKutjwsi5BFdrChdR7P3BnVFcwcx8oMcoDS5Jnaf0s9YU0105JhgpyP3WfVZllbd
 TOPSnVtYQSqmnQoOMuBMHYJJZ337orGhHiFXK282aubPTLDTpI9liZt+HWaYMNGtd5ss
 K6g10XphSxA/aemIbCSeXqhWpfi/S8cDL1cS9L7v02O/ZLjNNN/fZIRR2s8Ob+AwRAns hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61eh5jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 06:11:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6567dKG107958;
        Fri, 5 Jul 2019 06:11:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2th9ec9ces-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 06:11:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x656BQRB000313;
        Fri, 5 Jul 2019 06:11:26 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Jul 2019 23:11:26 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     yanjun.zhu@oracle.com, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH 0/2] forcedeth: recv cache support 
Date:   Fri,  5 Jul 2019 02:19:26 -0400
Message-Id: <1562307568-21549-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9308 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=829
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9308 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=885 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This recv cache is to make NIC work steadily when the system memory is
not enough.

From long time testing, the NIC worked very well when the system memory
is not enough. And the NIC performance is better from about 920M to
about 940M.

Some simple tests are made:

ip link set forcedeth_nic down/up
modprobe/rmmod forcedeth
ip link set mtu 1500 dev forcedeth_nic
ethtool -G forcedeth_nic tx 512 rx 1024
And other tests, the NIC with the recv cache can work well.

Since the recv cache will reserve 125M memory for NIC, normally this recv
cache is disabled by default.

Zhu Yanjun (2):
  forcedeth: add recv cache make nic work steadily
  forcedeth: disable recv cache by default

 drivers/net/ethernet/nvidia/Kconfig     |  11 +++
 drivers/net/ethernet/nvidia/Makefile    |   1 +
 drivers/net/ethernet/nvidia/forcedeth.c | 128 +++++++++++++++++++++++++++++++-
 3 files changed, 138 insertions(+), 2 deletions(-)

-- 
2.7.4

