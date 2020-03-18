Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73277189D4F
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgCRNtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47521 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726944AbgCRNto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C6ED75C008E;
        Wed, 18 Mar 2020 09:49:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DAjEWqzLSiyv5D50M
        qAXRoMytu+g6gSTVV1z5fiTkWw=; b=pbwz5ypvB5iMPKsXFkLvOhBWpw6pmDiLs
        M7UNxjQooN4pVqoRaOLptlC23r53NbxKW31NJDlreKOd9zhFhWEiGmO88O2pb7pe
        SsHt4l/kLl5/gWaA4Ws1RsrK8yN6CecJoOfOwDbQ8ANuBLYukXFlO1coa4DIpm0l
        eQY10m/4ndd20ZGW3AsEVgF5OygR8GK0r2XkVwbRE8juq3UPjCBmXaFoeJf+b7En
        Yrs6xWHNHhoziIdDNGHc8N+VgIY4y7k657xhd6SAM3HvWTMsUC03zUJ8U+63qxQV
        nPh18KQdAqaAE/me+zmKHH08E5gicjVSBUG09XHsaAN3ZGu/QM+Dw==
X-ME-Sender: <xms:9SZyXpSOsSwCYrU2Ffm9_UV8XS3ozVXgDSVtPtse7A5dKnA8rRnhgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:9SZyXnqgc1iBJsJdy49GuYsVfH7E39lbe4njTBNuTNnSW2nNuwElIw>
    <xmx:9SZyXsYADaCC-666y2vS2rEcgtFU2zW-3MEr3QIkpZPCfRzxXgwwbA>
    <xmx:9SZyXjEIZkvHqF_M37-27clPhQ4iwafdWppIAxlFj8zsztpXuyuTDg>
    <xmx:9SZyXvzP03ZOpI2IbZc4hUgUb4L80Gdjhfv8A0wXg2fAHi68OzXK_Q>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 029C13060F09;
        Wed, 18 Mar 2020 09:49:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/9] mlxsw: spectrum_cnt: Expose counter resources
Date:   Wed, 18 Mar 2020 15:48:48 +0200
Message-Id: <20200318134857.1003018-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Jiri says:

Capacity and utilization of existing flow and RIF counters are currently
unavailable to be seen by the user. Use the existing devlink resources
API to expose the information:

$ sudo devlink resource show pci/0000:00:10.0 -v
pci/0000:00:10.0:
  name kvd resource_path /kvd size 524288 unit entry dpipe_tables none
  name span_agents resource_path /span_agents size 8 occ 0 unit entry dpipe_tables none
  name counters resource_path /counters size 79872 occ 44 unit entry dpipe_tables none
    resources:
      name flow resource_path /counters/flow size 61440 occ 4 unit entry dpipe_tables none
      name rif resource_path /counters/rif size 18432 occ 40 unit entry dpipe_tables none

Jiri Pirko (9):
  mlxsw: spectrum_cnt: Query bank size from FW resources
  selftests: spectrum-2: Adjust tc_flower_scale limit according to
    current counter count
  mlxsw: spectrum_cnt: Move sub_pools under per-instance pool struct
  mlxsw: spectrum_cnt: Add entry_size_res_id for each subpool and use it
    to query entry size
  mlxsw: spectrum_cnt: Expose subpool sizes over devlink resources
  mlxsw: spectrum_cnt: Move config validation along with resource
    register
  mlxsw: spectrum_cnt: Consolidate subpools initialization
  mlxsw: spectrum_cnt: Expose devlink resource occupancy for counters
  selftests: mlxsw: Add tc action hw_stats tests

 .../net/ethernet/mellanox/mlxsw/resources.h   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  10 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   7 +
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    | 243 +++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_cnt.h    |   2 +
 .../net/mlxsw/spectrum-2/tc_flower_scale.sh   |   4 +-
 .../drivers/net/mlxsw/tc_action_hw_stats.sh   | 130 ++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   9 +
 8 files changed, 343 insertions(+), 64 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/tc_action_hw_stats.sh

-- 
2.24.1

