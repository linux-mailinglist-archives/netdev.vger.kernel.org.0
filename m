Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E7132CF2F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 10:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbhCDI7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:59:42 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52407 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237147AbhCDI7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:59:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5B2C15C0109;
        Thu,  4 Mar 2021 03:58:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Mar 2021 03:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B+eabceFRT1QgRR/c
        OfM+gQyyNBwRHp4Wx+XFc6HBLc=; b=Wjl/0+sCCegpQ9vj69bODV5ZevIOHL4mQ
        qytJnKO8QBz8+Sx4HKa5pq50MCUs6gKhYZTF+dX4/HglcCEIIuEmVftvYcvAU/vH
        cWhSEDXyJhhrTm/KifCaOkuOF/oz8Ma1sDNSLTsWN7Xpet//oKjO98IBItedwjWL
        QP86aJhFjnPqx9EoOsPT3y/ZLum58X91OdAOT9UQVUG4J0riLeak9JEnXeDpIcwb
        2DNBedQvq7YPmbzdAY0HAv1DMTJuCrzv68TSG3dD5DGEDHGXqS9Kg9XuKu7EShUK
        kK7Tq0Q/l9YsC28Of9bC0DF5jEy4EdmOHS6Gea60dPiGHoCw81sbA==
X-ME-Sender: <xms:MaFAYGYxJQBzhqmP8lMRGcG6AvjtLyoewRCIdG_VZKjQLxZdYUAZpg>
    <xme:MaFAYJbINcCN3ObtaOKhukZHeDuYZaDXz-P4kUpuL0YAWl22RN4IB0952WfkBsiMn
    4qTCMgfCeD44wo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtfedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:MaFAYA-ExR5QgvZibNrMyonR1tXb3kkkgSpnRgdQqP_BL3hgctwp7A>
    <xmx:MaFAYIogdpNbfsP5FH6Ufe8gCMx6UlL55BXwm6had0JqTrQhX1nIXA>
    <xmx:MaFAYBqbA9K5s2UaTiaT1eRhRRERYkLUTcuK32O95-XSv5C7nE4K7g>
    <xmx:MqFAYCnmZGJ8EBJ9f8la9wLQ_C5_gU1yL_41CjOyVieOsZ20C0mrdw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD0F01080059;
        Thu,  4 Mar 2021 03:58:23 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, sharpd@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] nexthop: Do not flush blackhole nexthops when loopback goes down
Date:   Thu,  4 Mar 2021 10:57:52 +0200
Message-Id: <20210304085754.1929848-1-idosch@idosch.org>
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

There are no regressions in fib_nexthops.sh with this change:

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

