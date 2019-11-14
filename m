Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 105EBFD0C6
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 23:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKNWNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 17:13:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26012 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726613AbfKNWNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 17:13:13 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEMD6BR010149
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 14:13:13 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8rgdrg4c-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 14:13:12 -0800
Received: from 2401:db00:2120:80e1:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 14:13:02 -0800
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id CD2D062B6029; Thu, 14 Nov 2019 14:13:00 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <ilias.apalodimas@linaro.org>, <brouer@redhat.com>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [net-next PATCH v3 0/1] Change page_pool timeout handling
Date:   Thu, 14 Nov 2019 14:12:59 -0800
Message-ID: <20191114221300.1002982-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1034 priorityscore=1501
 phishscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It isn't safe to remove the page pool until all in-flight pages 
are returned.  If the pages are handed up the stack, it might be
a while before they are returned.

The page pool can also be used independently of xdp, so it shouldn't
be depending on timeout handling from the xdp memory model.  Change
things around so the pool handles its own timeout.

v3:
 - restore tracepoint handling, use atomic_inc_return instead.

v2:
 - fix wording in commit log
 - fix compile error for !PAGE_POOL case
 - revise tracepoint handling

Jonathan Lemon (1):
  page_pool: do not release pool until inflight == 0.

 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
 include/net/page_pool.h                       |  54 +++-----
 include/net/xdp_priv.h                        |   4 -
 include/trace/events/xdp.h                    |  19 +--
 net/core/page_pool.c                          | 124 ++++++++++-------
 net/core/xdp.c                                | 125 +++++++-----------
 6 files changed, 143 insertions(+), 187 deletions(-)

-- 
2.17.1

