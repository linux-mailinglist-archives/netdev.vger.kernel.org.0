Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9F017A06E
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgCEHRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:17:39 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36663 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726204AbgCEHRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:17:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 80BF921CBA;
        Thu,  5 Mar 2020 02:17:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Mar 2020 02:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YzbdgP6WGWwVtjHSd
        MbDDUwTB9II+/iOEQ+ajb+r198=; b=epc4oP9/gOL70eTrFzpKdU/udlK2cOab3
        3WVfrF3rTwkuugabSiX7aUcJuono+MsUqr3CAYYcRehFnAxBmTgXFAMwX9g9YZhX
        Dby5YxKebTaPeqneGqXs8Agt4g/D0ZMEr3hvt11itLD9WOByZEu1uF1HyxeHmtjw
        1V+OVn8kf0oQMTec6fqJHJdD+eOZiU86N0lvygwjDuJKmaGQR3aJuXcepqqlAxXr
        r8YpSFaBx9MYln/nBArcWdwkJC6VEjxhagBRt3QliATOlwIyU3Nq1y3a4oge/u7+
        amCueJ4H6+zvDZTHiZ1yUtkXwVMOtyJ+DzyMCEF8ExRtCHYkafE9g==
X-ME-Sender: <xms:j6dgXt56fZSfjvABKNryxkaqIaUr6Rdh5VHqppJVEUs4q8vplNSVmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtledguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:j6dgXg5aPMAmnND5pZ0BXGWAP-SWlNg2diIg9uPaqbuy7fS5HiXuog>
    <xmx:j6dgXuqVzdgiEEORuDTCw4Dnu-Fw_a9aULp6jzK02buJvTUT8vdh0w>
    <xmx:j6dgXqCQhX6Dg3lE0GUGs12hGkeiPWLpuSq8bOvkQMwl_CwcUDL8Ow>
    <xmx:j6dgXiDDuDxj3FQJZLfnHhLqmVVOz7ctrOOmyei1_fb72wqZvvcCrw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B3523280060;
        Thu,  5 Mar 2020 02:17:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/5] mlxsw: Offload FIFO
Date:   Thu,  5 Mar 2020 09:16:39 +0200
Message-Id: <20200305071644.117264-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

If an ETS or PRIO band contains an offloaded qdisc, it is possible to
obtain offloaded counters for that band. However, some of the bands will
likely simply contain the default invisible FIFO qdisc, which does not
present the counters.

To remedy this situation, make FIFO offloadable, and offload it by mlxsw
when below PRIO and ETS for the sole purpose of providing counters for the
bands that do not include other qdiscs.

- In patch #1, FIFO is extended to support offloading.
- Patches #2 and #3 restructure bits of mlxsw to facilitate
  the offload logic.
- Patch #4 then implements the offload itself.
- Patch #5 changes the ETS selftest to use the new counters.

Petr Machata (5):
  net: sched: Make FIFO Qdisc offloadable
  mlxsw: spectrum_qdisc: Introduce struct mlxsw_sp_qdisc_state
  mlxsw: spectrum_qdisc: Add handle parameter to ..._ops.replace
  mlxsw: spectrum_qdisc: Support offloading of FIFO Qdisc
  selftests: forwarding: ETS: Use Qdisc counters

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 249 ++++++++++++++----
 include/linux/netdevice.h                     |   1 +
 include/net/pkt_cls.h                         |  15 ++
 net/sched/sch_fifo.c                          |  97 ++++++-
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |  14 +-
 tools/testing/selftests/net/forwarding/lib.sh |  10 +
 .../selftests/net/forwarding/sch_ets.sh       |   9 +-
 .../selftests/net/forwarding/sch_ets_tests.sh |  10 +-
 10 files changed, 340 insertions(+), 73 deletions(-)

-- 
2.24.1

