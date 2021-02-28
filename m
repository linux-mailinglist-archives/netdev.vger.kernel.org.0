Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574A2327296
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 15:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhB1O2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 09:28:14 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53237 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230140AbhB1O2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 09:28:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E276D5C00D5;
        Sun, 28 Feb 2021 09:27:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 28 Feb 2021 09:27:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6rhtoj4jE6ms6ente
        rRzquM4Zn7AtjtustgyHbybfJs=; b=hTzLf+1JsyDc1AhCWqSgNFqH+8Rb0gDcj
        f9OMsS51K428nI0EwHD7khMlCwV+/idJe2VwKTJLdUo5TXJ+qphrmCJBAWwvKYpp
        4bgd0QZCruhwM/Hx1glOO9oFC/LCUPslJ53DwxDMDDWln81Q+gEf6VLOa3b9mMtC
        k5+eEUQEWZXo3raKmXjqKOjClv6zhQDvXW7V09f+G6TGyQivGtS8NaNMG92BSPuu
        4rGmyJQeyivb5Wfz5r8ieSBndMu4htAHnywk9LDiEPiEkjICaVCxC6GTryWrsPQ6
        l3E5OewHxmey0u/J5+Fz727odH4Tt0NT0iKukSDf4jKdOoolQmvPQ==
X-ME-Sender: <xms:T6g7YGvcVBLKUq9bPDrenl2Qqco5XzrcHMBRvcNOmKef3ELCg9O_fQ>
    <xme:T6g7YLcXxFC9lecnxNrBqbPK-vNxe-f9MZjMpN7tdVSzFbpByEtNBF3eYz8FJVf63
    VRJaXXYH5r0RBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:T6g7YBzb4BbvAOFlBQ1kEHEI0bbluG9bwT5cMHf7rsXULdiAz-BlpA>
    <xmx:T6g7YBPfS03rhPKY5wUaAwTwaOZyLsga-oqpPc3Qq2EnRyGUCJkYAA>
    <xmx:T6g7YG_RgG_NwqJ9CrKw1AvLG88g1ZNIvTh-h0evLkauf-GDuDvEMQ>
    <xmx:T6g7YKYfM_kgm0uTHOSEvzSKgleURUJhAVdI8K3AyOQ4b_TlNbWMYw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BF031080054;
        Sun, 28 Feb 2021 09:27:25 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, sharpd@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net 0/2] nexthop: Do not flush blackhole nexthops when loopback goes down
Date:   Sun, 28 Feb 2021 16:26:11 +0200
Message-Id: <20210228142613.1642938-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 prevents blackhole nexthops from being flushed when the
loopback device goes down given that as far as user space is concerned,
these nexthops do not have a nexthop device.

Patch #2 adds a test case.

This is a user visible change, so sending as RFC.

Personally, I think it is worth making the change. The flow is quite
obscure and therefore unlikely to result in any regressions, especially
when the nexthop API is quite new compared to the legacy API. In
addition, the current behavior is very puzzling to those not familiar
with the inner workings of the nexthop code.

Regardless, there are no regressions in fib_nexthops.sh with this
change:

 # ./fib_nexthops.sh
 ...
 Tests passed: 165
 Tests failed:   0

Ido Schimmel (2):
  nexthop: Do not flush blackhole nexthops when loopback goes down
  selftests: fib_nexthops: Test blackhole nexthops when loopback goes
    down

 net/ipv4/nexthop.c                          | 10 +++++++---
 tools/testing/selftests/net/fib_nexthops.sh |  8 ++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.29.2

