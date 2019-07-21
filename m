Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C875B6F33F
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 14:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfGUMps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 08:45:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfGUMps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 08:45:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6LCiOdl158269;
        Sun, 21 Jul 2019 12:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=E3kt7vwB09QfSWu8X421VygLMKKArzWWNvCF/cwOkno=;
 b=gbBv3O/8bjAbDcEWUwKjA8MpQFRkDukzZHPwaGtyOda0HFHYItrG6DOqoIwD4QZJVeKS
 7Eixe2jwlPh1eYiWsjy/tbpg7UazsGQ2MLEXZSD/WTzYHsHMekglKNJSr16DYE7YsWt6
 5yMfMiRX81gdRcHXcph024MXo7gHd/Q1h76jT/09qXmJ5SW43FfaVq11zpLOU+7UEsk3
 TUe1hDlD+REtre2ZmOLjt0/V8xUGN132WrDsS1/w0SzUozbdXKSpmt3wDlcPCL40inV4
 gEg8Ggkrnyppe+2t6kUfp/p7NyLlnRZeHxCMvCUHd4La2EzWqLkZ5UYntgdF1f9Rb9xy ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tuukqapnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 12:45:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6LChKiN119257;
        Sun, 21 Jul 2019 12:45:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tur2tdjfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 12:45:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6LCjc1R027829;
        Sun, 21 Jul 2019 12:45:39 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 21 Jul 2019 12:45:38 +0000
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     yanjun.zhu@oracle.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCHv2 0/2] forcedeth: recv cache to make NIC work steadily
Date:   Sun, 21 Jul 2019 08:53:51 -0400
Message-Id: <1563713633-25528-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9324 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907210153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9324 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907210153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are to this scenario:

"
When the host run for long time, there are a lot of memory fragments in
the hosts. And it is possible that kernel will compact memory fragments.
But normally it is difficult for NIC driver to allocate a memory from
kernel. From this variable stat_rx_dropped, we can confirm that NIC driver
can not allocate skb very frequently.
"

Since NIC driver can not allocate skb in time, this makes some important
tasks not be completed in time.
To avoid it, a recv cache is created to pre-allocate skb for NIC driver.
This can make the important tasks be completed in time.
From Nan's tests in LAB, these patches can make NIC driver work steadily.
Now in production hosts, these patches are applied.

With these patches, one NIC port needs 125MiB reserved. This 125MiB memory
can not be used by others. To a host on which the communications are not
mandatory, it is not necessary to reserve so much memory. So this recv cache
is disabled by default.

V1->V2:
1. ndelay is replaced with GFP_KERNEL function __netdev_alloc_skb.
2. skb_queue_purge is used when recv cache is destroyed.
3. RECV_LIST_ALLOCATE bit is removed.
4. schedule_delayed_work is moved out of while loop.

Zhu Yanjun (2):
  forcedeth: add recv cache make nic work steadily
  forcedeth: disable recv cache by default

 drivers/net/ethernet/nvidia/Kconfig     |  11 +++
 drivers/net/ethernet/nvidia/Makefile    |   1 +
 drivers/net/ethernet/nvidia/forcedeth.c | 129 +++++++++++++++++++++++++++++++-
 3 files changed, 139 insertions(+), 2 deletions(-)

-- 
2.7.4

