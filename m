Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269402E0345
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgLVAKf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 19:10:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15306 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbgLVAKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:10:13 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BM09LL0023891
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:32 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35k0du9tbr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 16:09:32 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 16:09:28 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 0D5DA5BD9C26; Mon, 21 Dec 2020 16:09:26 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <willemdebruijn.kernel@gmail.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH 00/12 v2 RFC]  Generic zcopy_* functions
Date:   Mon, 21 Dec 2020 16:09:14 -0800
Message-ID: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-21_13:2020-12-21,2020-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 suspectscore=0 mlxlogscore=590 adultscore=0 phishscore=0 impostorscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210164
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

v1->v2:
 Break changes to skb_zcopy_put into 3 patches, in order to
 make it easier to follow the changes.  Add Willem's suggestion
 about renaming sock_zerocopy_

Patch 1:
  Move zerocopy bits from tx_flags into zc_flags for clarity.
  These bits will be used in the RX path in the future.
Patch 2: remove dead function
Patch 3: simplify sock_zerocopy_put
Patch 4: push status/refcounts into sock_zerocopy_callback
Patch 5: replace sock_zerocopy_put with skb_zcopy_put
Patch 6: rename sock_zerocopy_get
Patch 7:
  Add an optional skb parameter to callback, allowing access to
  the attached skb from the callback.
Patch 8:
  Add skb_zcopy_put_abort, and move zerocopy logic into the
  callback function.  There unfortunately is still a check
  against the callback type here.
Patch 9:
  Set the skb zc_flags from the ubuf being attached, instead
  of a fixed value, allowing different initialization types.
Patch 10: Replace open-coded assignments
Patch 11: Relocate skb_zcopy_clear() in skb_release_data()
Patch 12: rename sock_zerocopy_ to msg_zerocpy_

Jonathan Lemon (12):
  net: group skb_shinfo zerocopy related bits together.
  skbuff: remove unused skb_zcopy_abort function
  skbuff: simplify sock_zerocopy_put
  skbuff: Push status and refcounts into sock_zerocopy_callback
  skbuff: replace sock_zerocopy_put() with skb_zcopy_put()
  skbuff: replace sock_zerocopy_get with skb_zcopy_get
  skbuff: Add skb parameter to the ubuf zerocopy callback
  skbuff: Call sock_zerocopy_put_abort from skb_zcopy_put_abort
  skbuff: add zc_flags to ubuf_info for ubuf setup
  tap/tun: use skb_zcopy_set() instead of open coded assignment
  skbuff: Call skb_zcopy_clear() before unref'ing fragments
  skbuff: rename sock_zerocopy_* to msg_zerocopy_*

 drivers/net/tap.c                   |  6 +-
 drivers/net/tun.c                   |  6 +-
 drivers/net/xen-netback/common.h    |  3 +-
 drivers/net/xen-netback/interface.c |  4 +-
 drivers/net/xen-netback/netback.c   |  7 ++-
 drivers/vhost/net.c                 |  4 +-
 include/linux/skbuff.h              | 95 +++++++++++++++--------------
 net/core/skbuff.c                   | 66 ++++++++++----------
 net/ipv4/ip_output.c                |  5 +-
 net/ipv4/tcp.c                      |  8 +--
 net/ipv6/ip6_output.c               |  5 +-
 net/kcm/kcmsock.c                   |  4 +-
 12 files changed, 106 insertions(+), 107 deletions(-)

-- 
2.24.1

