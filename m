Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F92A129672
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfLWN2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:28:55 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55961 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbfLWN2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:28:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 28B9921B42;
        Mon, 23 Dec 2019 08:28:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=283rqeguAEs74wzhu
        SuPPyYdx5b6CEfHpEIqnvX+Jrg=; b=jrRaetg/mMMV4boAnwiQ1n+UBUOLMCbya
        5MvrqueaMXW6SC+bzsuB7aCPNyw1r3ksdaW/eJyHGS3MWMv6Cz8OXVqoRN/PedIZ
        MjNP3ctVm3uwUF65aRnG+0DEok0SV1MTOqTYAkc9EppDgiFceZqZkZIIBkXG4a8e
        9cC8k8Ke4ZMjr2G/bs2h8JmPGr6MR0WqbC7zQYNwwSRsL4A04tKTyd9gK9s8IeiY
        08kOZbCyVnUcE2DCBOqm5V804WqzCdHPEbfL30Rhtyb3Nj8+DNQuoV1EDbI4imzF
        2WdsM2BdtdfXAJS/7oxgAjsPntI38xEK4x6aVnrF1WRLqKH2bMt+A==
X-ME-Sender: <xms:FcEAXivct71GJrLNwGGdSCPfZ8YmOhVStgC99rSQpV6niQ1yV_u-Qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpohiilhgrsghsrdhorh
    hgnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhho
    mhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:FcEAXoHQnpkgBvmrwgIaZ_rvcOuixNsoHJJUNnrDYmUGenoGc84akQ>
    <xmx:FcEAXo58cINsuWKfO8lGKxelp9zjBslku6RJYJJU7caqnRnIdGYkhQ>
    <xmx:FcEAXhynXxhtPIee8khopqJPQCpLxOuNw2Qk6Gvk3Zf1VSyE1JTuTA>
    <xmx:FsEAXtw_ngEtyM-yq6q7jamABdqCldBcf1ZuUjqdD3b6dd6L19T7hA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A323430609A0;
        Mon, 23 Dec 2019 08:28:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/9] Simplify IPv6 route offload API
Date:   Mon, 23 Dec 2019 15:28:11 +0200
Message-Id: <20191223132820.888247-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Motivation
==========

This is the IPv6 counterpart of "Simplify IPv4 route offload API" [1].
The aim of this patch set is to simplify the IPv6 route offload API by
making the stack a bit smarter about the notifications it is generating.
This allows driver authors to focus on programming the underlying device
instead of having to duplicate the IPv6 route insertion logic in their
driver, which is error-prone.

Details
=======

Today, whenever an IPv6 route is added or deleted a notification is sent
in the FIB notification chain and it is up to offload drivers to decide
if the route should be programmed to the hardware or not. This is not an
easy task as in hardware routes are keyed by {prefix, prefix length,
table id}, whereas the kernel can store multiple such routes that only
differ in metric / nexthop info.

This series makes sure that only routes that are actually used in the
data path are notified to offload drivers. This greatly simplifies the
work these drivers need to do, as they are now only concerned with
programming the hardware and do not need to replicate the IPv6 route
insertion logic and store multiple identical routes.

The route that is notified is the first route in the IPv6 FIB node,
which represents a single prefix and length in a given table. In case
the route is deleted and there is another route with the same key, a
replace notification is emitted. Otherwise, a delete notification is
emitted.

Unlike IPv4, in IPv6 it is possible to append individual nexthops to an
existing multipath route. Therefore, in addition to the replace and
delete notifications present in IPv4, an append notification is also
used.

Testing
=======

To ensure there is no degradation in route insertion rates, I averaged
the insertion rate of 512k routes (/64 and /128) over 50 runs. Did not
observe any degradation.

Functional tests are available here [2]. They rely on route trap
indication, which is added in a subsequent patch set.

In addition, I have been running syzkaller for the past couple of weeks
with debug options enabled. Did not observe any problems.

Patch set overview
==================

Patches #1-#7 gradually introduce the new FIB notifications
Patch #8 converts mlxsw to use the new notifications
Patch #9 remove the old notifications

[1] https://patchwork.ozlabs.org/cover/1209738/
[2] https://github.com/idosch/linux/tree/fib-notifier

Ido Schimmel (9):
  net: fib_notifier: Add temporary events to the FIB notification chain
  ipv6: Notify newly added route if should be offloaded
  ipv6: Notify route if replacing currently offloaded one
  ipv6: Notify multipath route if should be offloaded
  ipv6: Only Replay routes of interest to new listeners
  ipv6: Handle route deletion notification
  ipv6: Handle multipath route deletion notification
  mlxsw: spectrum_router: Start using new IPv6 route notifications
  ipv6: Remove old route notifications and convert listeners

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 218 ++++++------------
 drivers/net/netdevsim/fib.c                   |   1 -
 include/net/ip6_fib.h                         |   1 +
 net/ipv6/ip6_fib.c                            | 108 +++++++--
 net/ipv6/route.c                              |  86 +++++--
 5 files changed, 238 insertions(+), 176 deletions(-)

-- 
2.24.1

