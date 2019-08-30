Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A07FA324C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfH3I2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 04:28:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54304 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfH3I2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 04:28:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U8NWRx147445;
        Fri, 30 Aug 2019 08:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=gxVjB/oN5DD7m60vJcFswjKz2rM+d5F0c8Ly6zDWk1w=;
 b=CRL9RnnfchbkWU+VtAn/SP3XcJimx59jEr09Y8+klX1tVtYSWp9vdIMlBoJVRSRojlVW
 1zU5qvyVKqtNrT99phsMINPWFKtcjJEomTpv24aAFdDcY/56UB/J3jm8b63zH7TAbJJU
 2hoY0UYDN/eGzBCG4azd8NXpwdATMVW2VEAB/CeWXT8R2x/ea62IaUdGqAju709rNioP
 LIb0qzsy2soRcmIihLsZFYl2p1dM9GOZwq6JqG4TrZD9mQnXZk2dfAq0zjibDX0xPeLB
 bbTtDk2RmjzQaewAWqmRfvHyDW8yPhtOnLPSEyyr1kCC3PPVhHZ7MwBODs3/X8IpF8m0 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uq009g424-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 08:28:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U8O7gD020137;
        Fri, 30 Aug 2019 08:26:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2upkrg190c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 08:26:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7U8QQY1016131;
        Fri, 30 Aug 2019 08:26:26 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 01:26:26 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     yanjun.zhu@oracle.com, netdev@vger.kernel.org, davem@davemloft.net,
        nan.1986san@gmail.com
Subject: [PATCH 0/1] Fix deadlock problem and make performance better
Date:   Fri, 30 Aug 2019 04:35:10 -0400
Message-Id: <1567154111-23315-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=604
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300090
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=681 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running with about 1Gbit/ses for very long time, running ifconfig
and netstat causes dead lock. These symptoms are similar to the
commit 5f6b4e14cada ("net: dsa: User per-cpu 64-bit statistics"). After
replacing network devices statistics with per-cpu 64-bit statistics,
the dead locks disappear even after very long time running with 1Gbit/sec.

Zhu Yanjun (1):
  forcedeth: use per cpu to collect xmit/recv statistics

 drivers/net/ethernet/nvidia/forcedeth.c | 132 +++++++++++++++++++++-----------
 1 file changed, 88 insertions(+), 44 deletions(-)

-- 
2.7.4

