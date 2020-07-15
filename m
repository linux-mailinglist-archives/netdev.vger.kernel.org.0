Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D25220723
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgGOI2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:03 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49499 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726396AbgGOI2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E4C235C013E;
        Wed, 15 Jul 2020 04:28:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cm28tMqjKiS5lyYL7
        4tjxvF1/kZhdWjB9haVRuB6gzo=; b=sIoh8GdRCYTAFF6iVU5XXOm2+/P6asPnh
        RqGvf1/0WrAX6X26INjl99FDT278ADMsaYzY8gD75MrYoY1itfdUbae7CZ7ieXY8
        4s2XGnDNec72gqih74YolLrdcBuRrITgZwfutdOfxTNSPFMCZetb2SemPdBcPgrX
        Ih62ABFIFvhYdDNwB7QYe+zzi4zE1w8sws3gT41rCBLhO0+a7vNd0mqfj5uhUpI9
        8BS3SlCagz5eq0ISx8ENTy7mmV8Ff1ASMrBoAIwrscffr5U5Iiqk+H1DKM5/zv6/
        v9BcbqaIJRlfmmod0z7v7LOS75HM16T8kLEnbuuu2lmDcDBYmwr3A==
X-ME-Sender: <xms:Eb4OXxUqEQ7yXxxUwo72AK0v7ISZJHhF_UaJUDbmA2v2J5WmBCbJEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepuddtledrieehrddufeelrddukedtnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Eb4OXxnlb7KBI4jNDTYCmQ_-xvSHLyLrLr3Pcx3JrqKarxqUTjMPEQ>
    <xmx:Eb4OX9ZZ5VnKn0vJEfPGf8uSY93sckigGqaYiKbOy8NbGuXrKTEi5Q>
    <xmx:Eb4OX0XwiP-sNCn18n_D3AbQLHJ4JfrazzRAhydKvj09gLFpQtBkow>
    <xmx:Eb4OXwz72a_pISefpbmrJ4HGEnQP5buj2dmF2cyIu6tW7noA8w292Q>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 096743280063;
        Wed, 15 Jul 2020 04:27:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/11] mlxsw: Offload tc police action
Date:   Wed, 15 Jul 2020 11:27:22 +0300
Message-Id: <20200715082733.429610-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set adds support for tc police action in mlxsw.

Patches #1-#2 add defines for policer bandwidth limits and resource
identifiers (e.g., maximum number of policers).

Patch #3 adds a common policer core in mlxsw. Currently it is only used
by the policy engine, but future patch sets will use it for trap
policers and storm control policers. The common core allows us to share
common logic between all policer types and abstract certain details from
the various users in mlxsw.

Patch #4 exposes the maximum number of supported policers and their
current usage to user space via devlink-resource. This provides better
visibility and also used for selftests purposes.

Patches #5-#7 gradually add support for tc police action in the policy
engine by calling into previously mentioned policer core.

Patch #8 adds a generic selftest for tc-police that can be used with
veth pairs or physical loopbacks.

Patches #9-#11 add mlxsw-specific selftests.

Ido Schimmel (11):
  mlxsw: reg: Add policer bandwidth limits
  mlxsw: resources: Add resource identifier for global policers
  mlxsw: spectrum_policer: Add policer core
  mlxsw: spectrum_policer: Add devlink resource support
  mlxsw: core_acl_flex_actions: Work around hardware limitation
  mlxsw: core_acl_flex_actions: Add police action
  mlxsw: spectrum_acl: Offload FLOW_ACTION_POLICE
  selftests: forwarding: Add tc-police tests
  selftests: mlxsw: tc_restrictions: Test tc-police restrictions
  selftests: mlxsw: Add scale test for tc-police
  selftests: mlxsw: Test policers' occupancy

 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 304 +++++++++++-
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   8 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   9 +
 .../net/ethernet/mellanox/mlxsw/resources.h   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  20 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  46 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  33 +-
 .../mlxsw/spectrum_acl_flex_actions.c         |  27 +
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  30 +-
 .../mellanox/mlxsw/spectrum_policer.c         | 468 ++++++++++++++++++
 .../net/mlxsw/spectrum-2/resource_scale.sh    |   2 +-
 .../net/mlxsw/spectrum-2/tc_police_scale.sh   |  16 +
 .../net/mlxsw/spectrum/resource_scale.sh      |   2 +-
 .../net/mlxsw/spectrum/tc_police_scale.sh     |  16 +
 .../drivers/net/mlxsw/tc_police_occ.sh        | 108 ++++
 .../drivers/net/mlxsw/tc_police_scale.sh      |  92 ++++
 .../drivers/net/mlxsw/tc_restrictions.sh      |  76 +++
 .../selftests/net/forwarding/devlink_lib.sh   |   5 +
 .../selftests/net/forwarding/tc_police.sh     | 333 +++++++++++++
 20 files changed, 1575 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_police_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/tc_police_scale.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/tc_police_occ.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh
 create mode 100755 tools/testing/selftests/net/forwarding/tc_police.sh

-- 
2.26.2

