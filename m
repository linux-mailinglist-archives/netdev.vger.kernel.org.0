Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417D7268000
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgIMPqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 11:46:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48479 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbgIMPqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 11:46:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EAE065C00F0;
        Sun, 13 Sep 2020 11:46:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 13 Sep 2020 11:46:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Pcb6xQjPH+m1eWwob
        3WjfHGJBkTXnNWqxR+UCQD6p3M=; b=c33izycgpYZGVN3j5Kv/LsYutmc+i/bhP
        /7RqXW95f0o2ZZRAkTHlMDKZhghiC6R88VY09YQX1yN3X3kyIMFd7rxJtC2xDWes
        0zMScZC9zVvyCeRKE6hZ7Agn9j7n3oSvIT0Fnalb2h0gEUvWmVBObQD2Evs+lzRx
        PdUCH9zhNk/n0FCv1a69eSoS4RLEaenA+RxE3rtAfA34GUngJRxjXrMmVeBJ4hhY
        z5pLywdRpFBh4Z3lC23/bX53xpND3vt7r39i2WGRXxzqF96dVk4R3cQUB8WlqlPA
        /THwCqHenrpK0JK63HhviAknAQflvxOLoZCauBu5PsUd0Pvg3q+zA==
X-ME-Sender: <xms:4j5eX5EXjGHOYn61_IS69ZaYIpfe0RY6JjPE7TIXfT12mJVYKr75Kg>
    <xme:4j5eX-VqdCUGd3rPhLhmQMwwVvDBN7sqcmxnxch0CPWekS2riu4uKrsJ_0SB54VRB
    I0gbofT23MtbIo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeigedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeeirdekvdenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4j5eX7KZF6PomZfTvRUngTfnSjkkeT7RLe7W14x6rc7THWrFB3O28A>
    <xmx:4j5eX_HIHfYXu6ejeLMGF8LMQzaqcRkqRXlmWKGOPrN2k7woLyqAkA>
    <xmx:4j5eX_XYpgUZ6B2lp_rS1V8NtBH7ebSrzhoblRacKGvaGxWLGqEFag>
    <xmx:4j5eX6QRnzIhUBj6Y3ueYH4sNYAuw_fDPCsjx1Uo-ZET8pf1_v_J3A>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id AAA24328005D;
        Sun, 13 Sep 2020 11:46:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/5] mlxsw: Derive SBIB from maximum port speed & MTU
Date:   Sun, 13 Sep 2020 18:46:04 +0300
Message-Id: <20200913154609.14870-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Petr says:

Internal buffer is a part of port headroom used for packets that are
mirrored due to triggers that the Spectrum ASIC considers "egress". Besides
ACL mirroring on port egresss this includes also packets mirrored due to
ECN marking.

This patchset changes the way the internal mirroring buffer is reserved.
Currently the buffer reflects port MTU and speed accurately. In the future,
mlxsw should support dcbnl_setbuffer hook to allow the users to set buffer
sizes by hand. In that case, there might not be enough space for growth of
the internal mirroring buffer due to MTU and speed changes. While vetoing
MTU changes would be merely confusing, port speed changes cannot be vetoed,
and such change would simply lead to issues in packet mirroring.

For these reasons, with these patches the internal mirroring buffer is
derived from maximum MTU and maximum speed achievable on the port.

Patches #1 and #2 introduce a new callback to determine the maximum speed a
given port can achieve.

With patches #3 and #4, the information about, respectively, maximum MTU
and maximum port speed, is kept in struct mlxsw_sp_port.

In patch #5, maximum MTU and maximum speed are used to determine the size
of the internal buffer. MTU update and speed update hooks are dropped,
because they are no longer necessary.

Petr Machata (5):
  mlxsw: spectrum_ethtool: Extract a helper to get Ethernet attributes
  mlxsw: spectrum_ethtool: Introduce ptys_max_speed callback
  mlxsw: spectrum: Keep maximum MTU around
  mlxsw: spectrum: Keep maximum speed around
  mlxsw: spectrum_span: Derive SBIB from maximum port speed & MTU

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 43 ++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 82 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 59 +------------
 4 files changed, 108 insertions(+), 82 deletions(-)

-- 
2.26.2

