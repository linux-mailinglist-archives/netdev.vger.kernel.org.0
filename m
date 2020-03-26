Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D281940AE
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgCZOBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:01:55 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35553 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727868AbgCZOBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:01:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A8405C0004;
        Thu, 26 Mar 2020 10:01:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 10:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bxhkoGPO/l3ms52Vq
        kOrW9ssZfTP6G5/0E86Z3W1QpI=; b=30WHyCfPRQagDYjt2x4VY9dWY/v79nqBc
        cNOn6XfwfwvugDM4IrB7U/dlBFxYnHKqLuoUS69NoSBhmllKIBdJ3HWzBv4HPGMh
        E1kzWMuDBEW4cysFiFFwsSle5fVkglVMg3y0EdQF0VhE8anEdyeg4Nxk8Y3MeBJ8
        bHdCEHRc3mmqrhQUvN8ZscvAEjX4XJU0tQtMSpjk/WcldwpLVPPUr3RmlnMXbZ+L
        22OYOqrvUbr6D3lNvbO7qg6SppQSIngdxZQo7t2SVWNjFHZQpU+ubJwV0nJi87Rh
        kpKAWf/ACJ7WyyyvgC9tdPgC+GOcfc0Uz3g09FJPQjALKun/33oAQ==
X-ME-Sender: <xms:zrV8XoJKr9xEmqkiXiWonCg0G0uIfLsx0XKUHMWaHj34q4ATtXhBlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:zrV8Xq8wLGuuuBcGHZO4c8NOtLLf02o_zREq5Be2cpFT9BlWpvdrcw>
    <xmx:zrV8Xrf9VDrikMZOoTHwbfKybNqWppFJTQRhTVlwZIrD3olG_-rUDw>
    <xmx:zrV8Xo6gm_ZyOh9E94zEnMg2s8_cVhBXoo6KMORpsOMEC7kiIximFQ>
    <xmx:z7V8XjDFGOBgGXL_BNP5npxIC0kvh_UCtMe85OhMiKizGo_8Bzrx3g>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 398013069B6B;
        Thu, 26 Mar 2020 10:01:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/6] mlxsw: Offload TC action pedit munge dsfield
Date:   Thu, 26 Mar 2020 16:01:08 +0200
Message-Id: <20200326140114.1393972-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

The Spectrum switches allow packet prioritization based on DSCP on ingress,
and update of DSCP on egress. This is configured through the DCB APP rules.
For some use cases, assigning a custom DSCP value based on an ACL match is
a better tool. To that end, offload FLOW_ACTION_MANGLE to permit changing
of dsfield as a whole, or DSCP and ECN values in isolation.

After fixing a commentary nit in patch #1, and mlxsw naming in patch #2,
patches #3 and #4 add the offload to mlxsw.

Patch #5 adds a forwarding selftest for pedit dsfield, applicable to SW as
well as HW datapaths. Patch #6 adds a mlxsw-specific test to verify DSCP
rewrite due to DCB APP rules is not performed on pedited packets.

The tests only cover IPv4 dsfield setting. We have tests for IPv6 as well,
but would like to postpone their contribution until the corresponding
iproute patches have been accepted.

Petr Machata (6):
  net: flow_offload.h: Fix a comment at flow_action_entry.mangle
  mlxsw: core: Rename mlxsw_afa_qos_cmd to mlxsw_afa_qos_switch_prio_cmd
  mlxsw: core: Add DSCP, ECN, dscp_rw to QOS_ACTION
  mlxsw: spectrum_flower: Offload FLOW_ACTION_MANGLE
  selftests: forwarding: Add a forwarding test for pedit munge dsfield
  selftests: mlxsw: qos_dscp_router: Test no DSCP rewrite after pedit

 .../mellanox/mlxsw/core_acl_flex_actions.c    | 134 +++++++++-
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   7 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   5 +
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  91 +++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  15 ++
 include/net/flow_offload.h                    |   3 +-
 .../drivers/net/mlxsw/qos_dscp_router.sh      |  30 +++
 .../selftests/net/forwarding/pedit_dsfield.sh | 238 ++++++++++++++++++
 8 files changed, 515 insertions(+), 8 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/pedit_dsfield.sh

-- 
2.24.1

