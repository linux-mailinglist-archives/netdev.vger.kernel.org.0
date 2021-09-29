Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6618241C1E0
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245137AbhI2JrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:47:06 -0400
Received: from mail.katalix.com ([3.9.82.81]:53936 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245124AbhI2JrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 05:47:04 -0400
Received: from jackdaw.fritz.box (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 313B07D434;
        Wed, 29 Sep 2021 10:45:21 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1632908721; bh=8NwZyuzfyNSEzyoipmuWIZPQVe1CRmCUvngaK/1vHM8=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[RFC=20PATCH=20net-next=200/3]=20suppor
         t=20"flow-based"=20datapath=20in=20l2tp|Date:=20Wed,=2029=20Sep=20
         2021=2010:45:11=20+0100|Message-Id:=20<20210929094514.15048-1-tpar
         kin@katalix.com>;
        b=0+Y8QQzX6eRkFv/7VeDOBmNtQbm4eIQSnvtF3kK5x8OhhsRMOJlFEHgmMTjfkzi3d
         mYmp4PMoCHCv0NXoJlbGos3nF2wtfn+e0vMdAQEPoxNnUWdzQBVznEb6uD/RL7nLUp
         gIZfgs1nF067ttTVwhMj4Eo9hIOu/B1atT1j1NwyTnqGA4SuqtNKkun9UPIPcKkdca
         I9ztol/8zn7dS7vvYvkOpY3Y6x7pxnPDSA9h/y6xNT2SYZgJDYUSbYAtZaz9gSEOiE
         56xQyWpEjyUQxhwgDgyOiQ1xpzG5GNX9HokR+ptYSoN8qkeGvmRppHd0RtLev/gsD+
         Es1p6IJwgYL/w==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [RFC PATCH net-next 0/3] support "flow-based" datapath in l2tp
Date:   Wed, 29 Sep 2021 10:45:11 +0100
Message-Id: <20210929094514.15048-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The traditional l2tp datapath in the kernel allocates of a netdev for
each l2tp session.  For larger session populations this limits
scalability.

Other protocols (such as geneve) support a mode whereby a single virtual
netdev is used to manage packetflows for multiple logical sessions: a
much more scalable solution.

This RFC patch series extends l2tp to support this mode of operation:

    * On creation of a tunnel instance a new tunnel virtual device is
      created (in this patch series it is named according to its ID for
      ease of testing, but this is potentially racy: alternatives are
      mentioned in the code comments).

    * For l2tp encapsulation, tc rules can be added to redirect traffic
      to the virtual tunnel device, e.g.

            tc qdisc add dev eth0 handle ffff: ingress
            tc filter add dev eth0 \
                    parent ffff: \
                    matchall \
                    action tunnel_key set \
                            src_ip 0.0.0.1 \
                            dst_ip 0.0.0.1 \
                            id 1 \
                    action mirred egress redirect dev l2tpt1

      This series utilises the 'id' parameter to refer to session ID
      within the tunnel, and the src_ip/dst_ip parameters are ignored.

    * For l2tp decapsulation, a new session data path is implemented.

      On receipt of an l2tp data packet on the tunnel socket, the l2tp
      headers are removed as normal, and the session ID of the target
      session associated with the skb using ip tunnel dst metadata.

      The skb is then redirected to the tunnel virtual netdev: tc rules
      can then be added to match traffic based on the session ID and
      redirect it to the correct interface:

            tc qdisc add dev l2tpt1 handle ffff: ingress
            tc filter add dev l2tpt1 \
                    parent ffff: \
                    flower enc_key_id 1 \
                    action mirred egress redirect dev eth0

      In the case that no tc rule matches an incoming packet, the tunnel
      virtual device implements an rx handler which swallows the packet
      in order to prevent it continuing through the network stack.

I welcome any comments on:

    1. Whether this RFC represents a good approach for improving
       the l2tp datapath?

    2. Architectural/design feedback on this implementation.

The code here isn't production-ready by any means, although any comments
on bugs or other issues with the series as it stands are also welcome.

Tom Parkin (3):
  net/l2tp: add virtual tunnel device
  net/l2tp: add flow-based session create API
  net/l2tp: add netlink attribute to enable flow-based session creation

 include/uapi/linux/l2tp.h |   1 +
 net/l2tp/l2tp_core.c      | 208 ++++++++++++++++++++++++++++++++++++++
 net/l2tp/l2tp_core.h      |   9 ++
 net/l2tp/l2tp_netlink.c   |  36 ++++---
 4 files changed, 241 insertions(+), 13 deletions(-)

-- 
2.17.1

