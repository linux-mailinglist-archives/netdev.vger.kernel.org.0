Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A219D1CC459
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgEIUGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42041 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728420AbgEIUGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2C1385C00C2;
        Sat,  9 May 2020 16:06:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=C2X+i4oc8Hx37DX+J
        kRz7VL0SyRWOlAx5y1U9XP2wsk=; b=tBCXM3AdLFQLUIed1bSPAv2aJgcCSEjVg
        UAtZcyg9JkFexVj1BicA0Xowg0VjmLf3hf3O34xvyDT1IW5RLyn6PfhOaREM/vQ6
        3XuSk+8P8AimE80MSmgzHkuWbnek7A7uXygf3wZjGzYKxTsXTasgYw7XzwjBSdVZ
        vYFqWchlloB28dImmhtBbFYLLcy9/1ZY7ZgsmfETKNWKu+JhS7mxdTywnTWCOMWd
        VfgLgz/A4rtk/MtediIigHFz7u44sLfOY3P1FAX0TypbnDA1kh5wWvw/8IYHNaWF
        n5iVDPO9etZiQB/f16/Zj5U7cY9wjKd4JTk8viYa5d6/GKzUI/lFQ==
X-ME-Sender: <xms:TA23XpHqyC31pifj4fkiha2FHnZLvnhXGp9zqRS0joMy60kf2EhT0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejiedrvdegrddutdejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:TQ23Xvmmz5hnJeHKIa0IoaMQq0k14qc4mw-6Nk3ylxniDeLq3MYkIA>
    <xmx:TQ23XgeJmcmdJ_O5wtFD4DTSBgz09dyU4qX_c5KrhF91jz9zEU2sZw>
    <xmx:TQ23XtAzKPveqgPqSJCVXLG04z5iQBhDGCqElO9_ifB2AwpFa0w5WQ>
    <xmx:TQ23XqnGexvZIZ1ZsxQ1WPxgz1axPpL7CMzEG55GY2kGB30ztP3ReA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C37C4306612B;
        Sat,  9 May 2020 16:06:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/9] mlxsw: spectrum: Enforce some HW limitations for matchall TC offload
Date:   Sat,  9 May 2020 23:06:01 +0300
Message-Id: <20200509200610.375719-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Jiri says:

There are some limitations for TC matchall classifier offload that are
given by the mlxsw HW dataplane. It is not possible to do sampling on
egress and also the mirror/sample vs. ACL (flower) ordering is fixed. So
check this and forbid to offload incorrect setup.

Jiri Pirko (9):
  mlxsw: spectrum_matchall: Restrict sample action to be allowed only on
    ingress
  mlxsw: spectrum_flower: Expose a function to get min and max rule
    priority
  mlxsw: spectrum_matchall: Put matchall list into substruct of flow
    struct
  mlxsw: spectrum_matchall: Expose a function to get min and max rule
    priority
  mlxsw: spectrum_matchall: Forbid to insert matchall rules in collision
    with flower rules
  mlxsw: spectrum_flower: Forbid to insert flower rules in collision
    with matchall rules
  selftests: mlxsw: rename tc_flower_restrictions.sh to
    tc_restrictions.sh
  selftests: mlxsw: tc_restrictions: add test to check sample action
    restrictions
  selftests: mlxsw: tc_restrictions: add couple of test for the correct
    matchall-flower ordering

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  18 ++-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  13 +-
 .../mellanox/mlxsw/spectrum_acl_tcam.c        |  39 +++++-
 .../mellanox/mlxsw/spectrum_acl_tcam.h        |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  52 +++++++
 .../mellanox/mlxsw/spectrum_matchall.c        |  86 +++++++++++-
 ...wer_restrictions.sh => tc_restrictions.sh} | 132 ++++++++++++++++++
 8 files changed, 332 insertions(+), 17 deletions(-)
 rename tools/testing/selftests/drivers/net/mlxsw/{tc_flower_restrictions.sh => tc_restrictions.sh} (53%)

-- 
2.26.2

