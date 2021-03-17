Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1145533EE6B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhCQKjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:39:41 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38457 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229876AbhCQKjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:39:15 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C42B5C0148;
        Wed, 17 Mar 2021 06:39:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Mar 2021 06:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HNENXLOJfKIaj5ej9
        IqyqI7ykGX5S2u9RMWVEMeIeDg=; b=RXVs6kEchFe5Ni2FetrmaIt5XAS6fad3M
        hBj7MS5ykNP1bFJH/RvS+dl/WR4C6WlOFrHW3nYGxP5D3FtWw3J8PNokXGrJKjTA
        SdDKcNgXB8e/SQCvSgMFux/RfP7dE1UoyxbEl2eKcGez1KbK31VlBSh4mL3YyTt7
        bC41Afsw846QHX3po2ZFF6WuRGG14CxlWDVm2zqgn7dyL00ZgnVGJJEoGsqNPC0Q
        uXsi94cyPIr0eHo+RAjWlhW1/WO4dvex57YQgkiQrBjxT19hvP0F9cndZf7HaroN
        vO/V5y4/vTCxLBToGVzWuWqpKQwfcLn91khZfYozcyAiGWnToW15w==
X-ME-Sender: <xms:UtxRYC30XET0I35f2WOpYHn-6uoNQgC3JOCU1-Klnie1FsRnPSlCEw>
    <xme:UtxRYFGBZgZuIMAVopOW-f-Umr1CLz-di7alt8zFZXHcM0RB6FuQtzRzTeVF3QHHt
    RBaCBBUzmwbaSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefgedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:UtxRYK4t4D18VDomy92jFY_4NragN2qzcxglZWag83FIHiePUCsWyw>
    <xmx:UtxRYD0zyQbCdc8omTLl5zJnFlsQY9X37tKjyh212IScRngOJeeZFA>
    <xmx:UtxRYFFjMwZkzNXjl-tyOkugQsdNUCEE8m1fBW-iJImiAWUwbhGODw>
    <xmx:U9xRYJiNGON8Vi83hDFNfd2A9ofN1-SyVYHEWYpqwbKexpjo5K4zgw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2D711080057;
        Wed, 17 Mar 2021 06:39:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/7] mlxsw: Allow 802.1d and .1ad VxLAN bridges to coexist on Spectrum>=2
Date:   Wed, 17 Mar 2021 12:35:22 +0200
Message-Id: <20210317103529.2903172-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset allows user space to simultaneously configure both 802.1d
and 802.1ad VxLAN bridges on Spectrum-2 and later ASICs. 802.1ad VxLAN
bridges are still forbidden on Spectrum-1.

The reason for the current limitation is that up until now the EtherType
that was pushed to decapsulated VxLAN packets was a property of the
tunnel port, of which there is only one. This meant that a 802.1ad VxLAN
bridge could not be configured if the tunnel port was already configured
to push a 802.1q tag.

This patchset improves the situation by making two changes. First,
decapsulated packets are marked as having their EtherType decided by the
egress port. Second, local ports member in the bridge (e.g., swp1) are
configured to set the correct egress EtherType.

Patchset overview:

Patch #1 adds a register required for the first change

Patches #2-#3 add the register required for the second change and a
corresponding API

Patch #4 prepares the driver for the split in behavior between
Spectrum-1 and later ASICs

Patch #5 performs the two above mentioned changes to allow the driver to
support simultaneous 802.1ad and 802.1d VxLAN bridges on Spectrum-2 and
later ASICs

Patch #6 adds a selftest

Patch #7 removes a selftest that verified the limitation that was lifted
by this patchset

Amit Cohen (7):
  mlxsw: reg: Add egr_et_set field to SPVID
  mlxsw: reg: Add Switch Port Egress VLAN EtherType Register
  mlxsw: spectrum: Add mlxsw_sp_port_egress_ethtype_set()
  mlxsw: Add struct mlxsw_sp_switchdev_ops per ASIC
  mlxsw: Allow 802.1d and .1ad VxLAN bridges to coexist on Spectrum>=2
  selftests: forwarding: Add test for dual VxLAN bridge
  selftests: mlxsw: spectrum-2: Remove q_in_vni_veto test

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  45 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  19 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   8 +
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |   1 -
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       |  15 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  74 +++-
 .../net/mlxsw/spectrum-2/q_in_vni_veto.sh     |  77 ----
 .../net/forwarding/dual_vxlan_bridge.sh       | 366 ++++++++++++++++++
 8 files changed, 513 insertions(+), 92 deletions(-)
 delete mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh
 create mode 100755 tools/testing/selftests/net/forwarding/dual_vxlan_bridge.sh

-- 
2.29.2

