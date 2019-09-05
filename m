Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E7CA9DC5
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732973AbfIEJG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:06:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42674 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731737AbfIEJG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 05:06:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x858xRe7135167;
        Thu, 5 Sep 2019 09:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=1UVlVK5NB/19I7lsUZaSiNPwLU/7bYEfIKVNYCUZ6BU=;
 b=HwoaTdu3AQl/TF8kzGe3g+CPP1CuOzRb/izcDinpqzsdKDNjG7Kr48k7z4n87gsW4fap
 IZT+rXPMeB58QKKAOLyFoP41UmQGdswt8PjkvLwhqPPQCM/7GBVbW0yNkad6QUftJRba
 UY6u1K0Op3mWyxscf28iq3Uz1PI2UBi7qR+0jUSKNtN/CgPIJTlKD6wfavycduPq1EiX
 DFhvLFpdc5k1xYeG3vBqMixKl5I2El7zzXEo7FzyVQUrBW9PgHytAKNn39lAYaXXNuwi
 I4zMHdnCg/5vm/YqbUjcRAj/Tz4Dd9Xg5hI9ak80jsaOh43KrHB20oDPFipTUsDJdYuk Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uty3yr5ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 09:06:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x858xBMl123957;
        Thu, 5 Sep 2019 09:06:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2utvr37xxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 09:06:47 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8596k37020563;
        Thu, 5 Sep 2019 09:06:46 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 02:06:46 -0700
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     eric.dumazet@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCHv3 0/1] Fix deadlock problem and make performance better
Date:   Thu,  5 Sep 2019 05:15:41 -0400
Message-Id: <1567674942-5132-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=372
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=438 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running with about 1Gbit/ses for very long time, running ifconfig
and netstat causes dead lock. These symptoms are similar to the
commit 5f6b4e14cada ("net: dsa: User per-cpu 64-bit statistics"). After
replacing network devices statistics with per-cpu 64-bit statistics,
the dead locks disappear even after very long time running with 1Gbit/sec.

V2->V3:
Based on David's advice, "Never use the inline keyword in foo.c files,
let the compiler decide.".

The inline keyword is removed from the functions nv_get_stats and
rx_missing_handler.

V1->V2:
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

