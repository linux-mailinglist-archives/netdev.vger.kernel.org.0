Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2204513090B
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 17:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgAEQWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 11:22:24 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39755 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726368AbgAEQV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 11:21:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1739A2106A;
        Sun,  5 Jan 2020 11:21:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 Jan 2020 11:21:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/EN9qw
        wcXjpiEkSV9dauwmk/4TW/3FtuHLjbkt8wfGk=; b=ZiKVwtzRsuIBFb9bbwMFAU
        lBXpHywjHdUvn1fTE6bKpoXj0InIdgPp7Kd+WKztIiw7rjphr9KZSLKcaE3nOp5J
        0NbTM6/JDzGjmUY1MHDpJ/aPOgDmAqRjjMiD4Q/VXlkcViGwSVl+gBHVoYRpxxUn
        qvJymS6i/wLSMaxF1UQ8YqF8NOArUwW6kQoTNa5bUF/kLR1d9PCyZb7wsMR2LCBZ
        VkTZc5GW5ZNl9y8qIzv+NEq/Qbivmq5tkIDdod6c/rtmNwQsSwFWxm0TV1zWdyGW
        7k8jDVZeGDdGX2t8oWbqDu/zo5wbGolfqxp/rk0OQ8SMeF7qXSB3RcJ77HU2Kxlw
        ==
X-ME-Sender: <xms:JA0SXiKNv0j1XnrzYUmCrcWzh4i5QfcH-HgFn_txg_VE2FYxvPhJ3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofggtgfgsehtkeertd
    ertdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:JA0SXjnZ9FaJTUGWTKnkVHPBDh5TngfL6Z9r4Eho7R3t56MyO_daPA>
    <xmx:JA0SXiQBjP6F8iIuVoeik0qvradMcCG7mJPqAjRDfeGn5eOpVuYoug>
    <xmx:JA0SXtLnvffYd_-2ycH9GtwjwQ6rVYrLA1eSePVt81cZ-fHAgih9Iw>
    <xmx:JQ0SXtJBszMHtiuGFv1wMd5hZV7gYEcqTAt5AlsRtCTXlaJzASO1RQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B40068005A;
        Sun,  5 Jan 2020 11:21:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/8] mlxsw: Disable checks in hardware pipeline
Date:   Sun,  5 Jan 2020 18:20:49 +0200
Message-Id: <20200105162057.182547-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Amit says:

The hardware pipeline contains some checks that, by default, are
configured to drop packets. Since the software data path does not drop
packets due to these reasons and since we are interested in offloading
the software data path to hardware, then these checks should be disabled
in the hardware pipeline as well.

This patch set changes mlxsw to disable four of these checks and adds
corresponding selftests. The tests pass both when the software data path
is exercised (using veth pair) and when the hardware data path is
exercised (using mlxsw ports in loopback).

Amit Cohen (8):
  mlxsw: spectrum: Disable SIP_CLASS_E check in hardware pipeline
  selftests: forwarding: router: Add test case for source IP in class E
  mlxsw: spectrum: Disable MC_DMAC check in hardware pipeline
  selftests: forwarding: router: Add test case for multicast destination
    MAC mismatch
  mlxsw: spectrum: Disable SIP_DIP check in hardware pipeline
  selftests: forwarding: router: Add test case for source IP equals
    destination IP
  mlxsw: spectrum: Disable DIP_LINK_LOCAL check in hardware pipeline
  selftests: forwarding: router: Add test case for destination IP
    link-local

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   8 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   4 +
 .../selftests/net/forwarding/router.sh        | 189 +++++++++++++++++-
 3 files changed, 200 insertions(+), 1 deletion(-)

-- 
2.24.1

