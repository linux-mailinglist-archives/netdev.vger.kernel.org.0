Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61BE6E8866
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbjDTDGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjDTDGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:06:11 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8700065BF;
        Wed, 19 Apr 2023 20:05:35 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q22V24YXrzStZC;
        Thu, 20 Apr 2023 11:00:58 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 11:05:05 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <kuniyu@amazon.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH 4.14 0/5] inet6: Backport complete patchset for inet6_destroy_sock() call modification
Date:   Thu, 20 Apr 2023 11:04:55 +0800
Message-ID: <cover.1681952136.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

4.14 LTS has backported commit ca43ccf41224 ("dccp/tcp: Avoid negative
sk_forward_alloc by ipv6_pinfo.pktoptions.") and commit 62ec33b44e0f ("net:
Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues()."),
but these are incomplete. There are some patches that have not been
backported including key pre-patches commit d38afeec26ed ("tcp/udp:
Call inet6_destroy_sock() in IPv6 sk->sk_destruct().") and commit
b5fc29233d28 ("inet6: Remove inet6_destroy_sock() in
sk->sk_prot->destroy()."). Without them, there are some memory leak bugs.

Backport complete patchset for inet6_destroy_sock() call modification.

Kuniyuki Iwashima (5):
  udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
  tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
  inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
  dccp: Call inet6_destroy_sock() via sk->sk_destruct().
  sctp: Call inet6_destroy_sock() via sk->sk_destruct().

 include/net/ipv6.h       |  2 ++
 include/net/udp.h        |  2 +-
 include/net/udplite.h    |  8 --------
 net/dccp/dccp.h          |  1 +
 net/dccp/ipv6.c          | 15 ++++++++-------
 net/dccp/proto.c         |  8 +++++++-
 net/ipv4/udp.c           |  9 ++++++---
 net/ipv4/udplite.c       |  8 ++++++++
 net/ipv6/af_inet6.c      | 15 ++++++++++++++-
 net/ipv6/ipv6_sockglue.c | 20 ++++++++------------
 net/ipv6/ping.c          |  6 ------
 net/ipv6/raw.c           |  2 --
 net/ipv6/tcp_ipv6.c      |  8 +-------
 net/ipv6/udp.c           | 17 ++++++++++++++---
 net/ipv6/udp_impl.h      |  1 +
 net/ipv6/udplite.c       |  9 ++++++++-
 net/l2tp/l2tp_ip6.c      |  2 --
 net/sctp/socket.c        | 29 +++++++++++++++++++++--------
 18 files changed, 100 insertions(+), 62 deletions(-)

-- 
2.25.1

