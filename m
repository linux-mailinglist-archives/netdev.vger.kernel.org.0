Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC32F6E81
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfKKGUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:20:43 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52266 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726360AbfKKGUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 01:20:43 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAB6Abqs029150
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 22:20:41 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w5w7j6w87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 22:20:41 -0800
Received: from 2401:db00:2120:81dc:face:0:23:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 10 Nov 2019 22:20:40 -0800
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id A28065F8677D; Sun, 10 Nov 2019 22:20:38 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>, <brouer@redhat.com>,
        <ilias.apalodimas@linaro.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 0/1] Change page_pool timeout handling
Date:   Sun, 10 Nov 2019 22:20:37 -0800
Message-ID: <20191111062038.2336521-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-11_01:2019-11-08,2019-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1034 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911110060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It isn't safe to remove the page pool until all in-flight pages 
are returned.  If the pages are handed up the stack, it might be
a while before they are returned.

The page pool can also be used independently of xdp, so it shouldn't
be depending on timeout handling from xdp.  Change things around so
the pool handles its own timeout.

I wanted to send this out to clarify how I see things working.  This
is currently being tested with the mlx4/mlx5 drivers for attaching 
DMA-mapped pages to skbs, sending them up the stack, and then putting
them back in the page pool afterwards.

Jonathan Lemon (1):
  page_pool: do not release pool until inflight == 0.

 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
 include/net/page_pool.h                       |  55 +++-----
 include/net/xdp_priv.h                        |   4 -
 include/trace/events/xdp.h                    |  19 +--
 net/core/page_pool.c                          | 115 ++++++++++------
 net/core/xdp.c                                | 130 +++++++-----------
 6 files changed, 138 insertions(+), 189 deletions(-)

-- 
2.17.1

