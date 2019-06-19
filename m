Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0844B243
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbfFSGlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:41:47 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50077 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbfFSGlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:41:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B73B720CA5;
        Wed, 19 Jun 2019 02:41:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 02:41:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ERGIrIcl3trOjgz7n
        RJynhXfi6+CTGGMYyV7l0ADM2w=; b=aUXRvQ95q+Wzia+H/qFx+Mle6EKWr8NVU
        BeVCvLiHIMIRjFyLH4IY+qEYVsG4psqwAfFeu7yDyQyA0hgiDG2vyHzZGT9aI1/H
        zRWaMPLiTlKPqDPczvjCeI3wXUyeniTQ96qdW+tjqKz3HGIPSvrGwWm8Whcmg8wh
        zM4Mc72hkGqg6coxcSEk+aibSvZpd7Y5J1amjBLSY9wKn412LqA2i7ZRDewE9Pee
        GkU7Xxdh6jgOatIR5G1fY2BYFnS8ZvT8WIh/eNj9fgrLLBo27PuA4c+AvIbnw2db
        u/CPhZSdiZ+zLUBTLzVwM+iIYpMJuQp8D2IZj9B+1bRqp4ZJb1izw==
X-ME-Sender: <xms:KNkJXfXVVKfymwx6dPVBy3yuwHwidmQwBbDOJQjF_rw5mKj0dweRJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddugdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:KNkJXX3s1vUcfx9fwTHowkoyMBkd_ynwEDA7H1d9LKL2Z27zg-l6uA>
    <xmx:KNkJXUSyZahIEiWuvUziFoG1wYmT9ATBJJZ_u5tcA9RiQ-TiQk1TxA>
    <xmx:KNkJXePjk5J5b06LwhXLOGUSIEkIVhuDuBX94ouzi9Q79KW0Fiqonw>
    <xmx:KdkJXevY5IyQuq_wWXbdIVajxzFWj-hXvPKu4dd6QUnPyw1aUjGOXg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D36A8005A;
        Wed, 19 Jun 2019 02:41:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/8] mlxsw: Implement flower ingress device matching offload
Date:   Wed, 19 Jun 2019 09:41:01 +0300
Message-Id: <20190619064109.849-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Jiri says:

In case of using shared block, user might find it handy to be able to insert
filters to match on particular ingress device. This patchset exposes the
ingress ifindex through flow_dissector and flow_offload so mlxsw can use it to
push down to HW. See the selftests for examples of usage.

Jiri Pirko (8):
  flow_dissector: add support for ingress ifindex dissection
  net: sched: cls_flower: use flow_dissector for ingress ifindex
  net: flow_offload: implement support for meta key
  mlxsw: spectrum_acl: Write RX_ACL_SYSTEM_PORT acl element correctly
  mlxsw: spectrum_acl: Avoid size check for RX_ACL_SYSTEM_PORT element
  mlxsw: spectrum_acl: Fix SRC_SYS_PORT element size
  mlxsw: spectrum_flower: Implement support for ingress device matching
  selftests: tc: add ingress device matching support

 .../mellanox/mlxsw/core_acl_flex_keys.c       |  18 +-
 .../mellanox/mlxsw/core_acl_flex_keys.h       |  22 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   9 +
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |   9 +-
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c   |  10 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  50 ++++-
 include/linux/skbuff.h                        |   4 +
 include/net/flow_dissector.h                  |   9 +
 include/net/flow_offload.h                    |   6 +
 net/core/flow_dissector.c                     |  16 ++
 net/core/flow_offload.c                       |   7 +
 net/sched/cls_flower.c                        |  14 +-
 .../selftests/net/forwarding/tc_flower.sh     |  26 ++-
 .../net/forwarding/tc_flower_router.sh        | 172 ++++++++++++++++++
 .../selftests/net/forwarding/tc_shblocks.sh   |  29 ++-
 15 files changed, 367 insertions(+), 34 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_router.sh

-- 
2.20.1

