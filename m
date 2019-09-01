Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C427A4812
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 09:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfIAHRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 03:17:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36560 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfIAHRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 03:17:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x817EsaU187468;
        Sun, 1 Sep 2019 07:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=mDuEBtCINwvqkKU7OUTcCUMZtVRklkFKnKrVvRZbpWE=;
 b=gpwuY8ckDL1lkiGGeES0UPWV4OUffJq+gGlv9mYsnmsUxc/7K6+KypGlFd6VmZMo4pW4
 2xea+2a/nIs3VlNtrb7lefoTyBXWiUt9yCek+zsBHumoc5MHqyI2Gwq1Kb8MmmCdByA0
 b6Tv1T78xGdEp0sjRm0azy1wp2362k7VkJUCf+SpimCVEIVA291GjrfuCa/wMtihvn7K
 6X5NBLI+ntwJY9TQ1X7+NkHfox8dqZ77ESottETiSFNGcpuGWYdar/TqmNPymqFUppvj
 pOkJDJm5kBuR0v7yPsfLjlWlD4WLDMLjAViKy3rdxwRm9qSUSiQyuGHSgawySeGvdWgN zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ur99q00wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 07:17:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x817DW7s095849;
        Sun, 1 Sep 2019 07:17:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2uqg81kpcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 07:17:23 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x817HMUb007995;
        Sun, 1 Sep 2019 07:17:22 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Sep 2019 00:17:22 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     eric.dumazet@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCHv2 0/1] Fix deadlock problem and make performance better
Date:   Sun,  1 Sep 2019 03:26:12 -0400
Message-Id: <1567322773-5183-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9366 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=577
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909010084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9366 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=660 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909010085
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running with about 1Gbit/ses for very long time, running ifconfig
and netstat causes dead lock. These symptoms are similar to the
commit 5f6b4e14cada ("net: dsa: User per-cpu 64-bit statistics"). After
replacing network devices statistics with per-cpu 64-bit statistics,
the dead locks disappear even after very long time running with 1Gbit/sec.

Based on Eric's advice, "If the loops are ever restarted, the
storage->fields will have been modified multiple times.".

A similar change in the commit 5f6b4e14cada ("net: dsa: User per-cpu
64-bit statistics") is borrowed to fix the above problem.

Zhu Yanjun (1):
  forcedeth: use per cpu to collect xmit/recv statistics

 drivers/net/ethernet/nvidia/forcedeth.c | 143 ++++++++++++++++++++++----------
 1 file changed, 99 insertions(+), 44 deletions(-)

-- 
2.7.4

