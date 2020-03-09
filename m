Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B040D17E744
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgCISfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:35:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55053 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbgCISfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:35:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D0C7B22011;
        Mon,  9 Mar 2020 14:35:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Mar 2020 14:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e/5tzVU4o9caqCCVq
        AYr8i2TtvDMoqG4qa9kpxNNQP8=; b=lNkL6bfdnuZar3OqioKvoqXF/t0iNCjGD
        a84yAcfcybb0ZwIWzDXJW4qKxTJAdvz7osvrFTt0toZ1fjbEH3spEx7DmaJrA6G/
        oyzEg6J9RuFYbXHNDJRWciq+eGySMAu+Ph7P1KEnYYLHHq6+Yd/8sALyuVP3aAcX
        4C+R5rbA7+v1B6SdFEDp3JNEEV1iiChk5lnQEMApaP9UcKUZ04o496XxS48cbNVV
        F9SIDZWpi6zvQs92HDyzRPutxIneC1AyHJuk3cS5rWwwQA38ZtPmlR8xaF/dwa81
        SnUpOtW6VDxwaBhE3/XCXDMPNKjUK9P+r3ObY6oK9suN8AuhT0Pww==
X-ME-Sender: <xms:f4xmXjDkMLHlHx34KrLeZkEFxNxVICI5h-MjrT_gASKPUAZ6YZM17w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeejrddufeekrddvgeelrddvtdelnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:f4xmXsxvv4dvpB_yoFQBM_DSWA5_6TkFe0_Pafz8kziRC4x2ZgXiJQ>
    <xmx:f4xmXipOk8wY7_RuIwYdP4RGA7_RgHSmS-Ok0psabXIPDDUUBJV-bQ>
    <xmx:f4xmXvw-NbbwdScTOnEWA0zHZPvVaQW20CDsxKkxb75lgR4MHxw1aA>
    <xmx:f4xmXiWCTsutgRZAKvxw3S5Ai8P3ot3UuNJskWIGWgFXpbukait-Pg>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id DAF7E3061393;
        Mon,  9 Mar 2020 14:35:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/6] RED: Introduce an ECN tail-dropping mode
Date:   Mon,  9 Mar 2020 20:34:57 +0200
Message-Id: <20200309183503.173802-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

When the RED Qdisc is currently configured to enable ECN, the RED algorithm
is used to decide whether a certain SKB should be marked. If that SKB is
not ECN-capable, it is early-dropped.

It is also possible to keep all traffic in the queue, and just mark the
ECN-capable subset of it, as appropriate under the RED algorithm. Some
switches support this mode, and some installations make use of it.
There is currently no way to put the RED qdiscs to this mode.

To that end, add a new RED flag, TC_RED_TAILDROP. When the Qdisc is
configured with this flag, non-ECT traffic is enqueued (and tail-dropped
when the queue size is exhausted) instead of being early-dropped.

- The patchset starts with adding in patch #1 a TDC testsuite that covers
  the existing RED flags. This test is extended with the new flag later
  in the patchset.

- Patches #2 and #3 add the taildrop support to the RED qdisc itself resp.
  mlxsw.

- Patches #4 and #5 add tests to, respectively, the newly-introduced TDC
  suite, and the mlxsw-specific RED selftests.

To test the qdisc itself (apart from offloading or configuration, which are
covered above), I took the mlxsw selftest and adapted it for SW datapath in
mostly obvious ways. The test is stable enough to verify that RED, ECN and
ECN taildrop actually work. However, I have no confidence in its
portability to other people's machines or mildly different configurations.
I therefore do not find it suitable for upstreaming.

Petr Machata (6):
  selftests: qdiscs: Add TDC test for RED
  net: sched: Add centralized RED flag checking
  net: sched: RED: Introduce an ECN tail-dropping mode
  mlxsw: spectrum_qdisc: Offload RED ECN tail-dropping mode
  selftests: qdiscs: RED: Add taildrop tests
  selftests: mlxsw: RED: Test RED ECN taildrop offload

 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |   9 +-
 include/net/pkt_cls.h                         |   1 +
 include/net/red.h                             |  17 +++
 include/uapi/linux/pkt_sched.h                |   1 +
 net/sched/sch_choke.c                         |   5 +
 net/sched/sch_gred.c                          |   7 +-
 net/sched/sch_red.c                           |  35 ++++-
 net/sched/sch_sfq.c                           |  10 +-
 .../drivers/net/mlxsw/sch_red_core.sh         |  50 +++++-
 .../drivers/net/mlxsw/sch_red_ets.sh          |  11 ++
 .../drivers/net/mlxsw/sch_red_root.sh         |   8 +
 .../tc-testing/tc-tests/qdiscs/red.json       | 142 ++++++++++++++++++
 12 files changed, 273 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json

-- 
2.24.1

