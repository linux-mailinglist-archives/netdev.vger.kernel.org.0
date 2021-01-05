Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723572EB535
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 23:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbhAEWH6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jan 2021 17:07:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61024 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731615AbhAEWHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 17:07:55 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 105LjeFH015415
        for <netdev@vger.kernel.org>; Tue, 5 Jan 2021 14:07:14 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 35tn76e3xy-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 14:07:14 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 14:07:12 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 12D916489D16; Tue,  5 Jan 2021 14:07:06 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <willemdebruijn.kernel@gmail.com>, <edumazet@google.com>,
        <dsahern@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH net-next v1 00/13] Generic zcopy_* functions
Date:   Tue, 5 Jan 2021 14:06:53 -0800
Message-ID: <20210105220706.998374-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_07:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0
 mlxlogscore=567 clxscore=1034 bulkscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

This is set of cleanup patches for zerocopy which are intended
to allow a introduction of a different zerocopy implementation.

The top level API will use the skb_zcopy_*() functions, while
the current TCP specific zerocopy ends up using msg_zerocopy_*()
calls.

There should be no functional changes from these patches.

Patch 1: remove dead function
Patch 2: simplify sock_zerocopy_put
Patch 3: push status/refcounts into sock_zerocopy_callback
Patch 4: replace sock_zerocopy_put with skb_zcopy_put
Patch 5: rename sock_zerocopy_get
Patch 6:
  Add an optional skb parameter to callback, allowing access to
  the attached skb from the callback.
Patch 7:
  Add skb_zcopy_put_abort, and move zerocopy logic into the
  callback function.  There unfortunately is still a check
  against the callback type here.
Patch 8: Relocate skb_zcopy_clear() in skb_release_data()
Patch 9: rename sock_zerocopy_ to msg_zerocopy_
Patch 10:
  Move zerocopy bits from tx_flags into flags for clarity.
  These bits will be used in the RX path in the future.
Patch 11:
  Set the skb flags from the ubuf being attached, instead
  of a fixed value, allowing different initialization types.
Patch 12: Replace open-coded assignments with skb_zcopy_init()
Patch 13: Rename skb_zcopy_{get|put} to net_zcopy_{get|put}

Jonathan Lemon (13):
  skbuff: remove unused skb_zcopy_abort function
  skbuff: simplify sock_zerocopy_put
  skbuff: Push status and refcounts into sock_zerocopy_callback
  skbuff: replace sock_zerocopy_put() with skb_zcopy_put()
  skbuff: replace sock_zerocopy_get with skb_zcopy_get
  skbuff: Add skb parameter to the ubuf zerocopy callback
  skbuff: Call sock_zerocopy_put_abort from skb_zcopy_put_abort
  skbuff: Call skb_zcopy_clear() before unref'ing fragments
  skbuff: rename sock_zerocopy_* to msg_zerocopy_*
  net: group skb_shinfo zerocopy related bits together.
  skbuff: add flags to ubuf_info for ubuf setup
  tap/tun: add skb_zcopy_init() helper for initialization.
  skbuff: Rename skb_zcopy_{get|put} to net_zcopy_{get|put}

 drivers/net/tap.c                   |   6 +-
 drivers/net/tun.c                   |   6 +-
 drivers/net/xen-netback/common.h    |   3 +-
 drivers/net/xen-netback/interface.c |   4 +-
 drivers/net/xen-netback/netback.c   |   5 +-
 drivers/vhost/net.c                 |   4 +-
 include/linux/skbuff.h              | 106 +++++++++++++++-------------
 net/core/skbuff.c                   |  65 ++++++++---------
 net/ipv4/ip_output.c                |   5 +-
 net/ipv4/tcp.c                      |   8 +--
 net/ipv6/ip6_output.c               |   5 +-
 net/kcm/kcmsock.c                   |   4 +-
 12 files changed, 113 insertions(+), 108 deletions(-)

-- 
2.24.1

