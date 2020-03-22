Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290FE18EBA1
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgCVSuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:50:19 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58471 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbgCVSuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:50:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1ACDF5C0175;
        Sun, 22 Mar 2020 14:50:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 22 Mar 2020 14:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6ypWmdn/Mf31SorFa
        bS1CcVQ96U1VBiIyoKLRzckONs=; b=xCbTcmJXGyqQ3mplF/tDNqUAknFcKuNWo
        bx3gVXQYaKndjuuvqF/aHaOiI7u1SjmttjnDg/jnQkZLBOpYuYtUMbWCXdHYnuz3
        5xjYWjeevHzvCXDfXO/+k+8uDVDhorFNgbO0ohVybGdHttxDoUR6n10xAjKtblL/
        kAFheIfxAkzRDQ0ktBb8b3W/SefLc88pIBLlVurDk7514r+gC203p4nVAsKqf3rT
        oNHosdBCQgZdkGqcPEDb4xD6nK5JEQbIyVt7aVVToGRyDA9nWWlaomY8nYkVg6+f
        rYTOwrvzoq9GgiCMjX2hJHTWJFmIcb2bLYYGTJQGlJ/BdxNUoomPg==
X-ME-Sender: <xms:abN3XlR3qG819PVFBJiVaJ1o9XSP6P8sv9mzcmOSRD-Wa0raDkWeCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegiedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeejledrud
    ektddrleegrddvvdehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:abN3Xqh87ruaXLTeLAJUtP6uWTQzF49uWp6DghcxcmyviXSO8DCBOw>
    <xmx:abN3XtnU14Kx-JWtzy5bdv3PlqmS7m3kK_I3ATYH0DnFUIhSErtlYw>
    <xmx:abN3XjCVEvUyil39YIeulhORugzyP-utJXE4w9b011vDjXdx4eH2ng>
    <xmx:arN3XoMUGkIOKt09gK49ySImFlXE_eNAG9pYEGbuhZ4IZEBXYzxNRQ>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED0F1328005A;
        Sun, 22 Mar 2020 14:50:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/5] devlink: Preparations for trap policers support
Date:   Sun, 22 Mar 2020 20:48:25 +0200
Message-Id: <20200322184830.1254104-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set prepares the code for devlink-trap policer support in a
follow-up patch set [1][2]. No functional changes intended.

Policers are going to be added as attributes of packet trap groups,
which are entities used to aggregate logically related packet traps.
This will allow users, for example, to limit all the packets that
encountered an exception during routing to 10Kpps.

However, currently, device drivers register their packet trap groups
implicitly when they register their packet traps via
devlink_traps_register(). This makes it difficult to pass additional
attributes for the groups. For example, the policer bound to the group.

Therefore, this patch set converts device drivers to explicitly register
their packet trap groups. This will later allow these drivers to
register the group with additional attributes, if any.

API today:
devlink_traps_register(traps)

API after this patch set:
devlink_trap_groups_register(groups)
devlink_traps_register(traps)

API after follow-up patch set:
devlink_trap_policers_register(policers)
devlink_trap_groups_register(groups)
devlink_traps_register(traps)

Patch set overview:
Patch #1 adds the new API to register packet trap groups
Patches #2-#3 convert mlxsw and netdevsim to use the new API
Patches #4-#5 remove the old API

Tested successfully with current devlink-trap selftests.

[1] https://github.com/idosch/linux/tree/trap-policers
[2] https://github.com/idosch/iproute2/tree/trap-policers

Ido Schimmel (5):
  devlink: Add API to register packet trap groups
  mlxsw: spectrum_trap: Explicitly register packet trap groups
  netdevsim: Explicitly register packet trap groups
  devlink: Stop reference counting packet trap groups
  devlink: Only pass packet trap group identifier in trap structure

 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  38 ++-
 drivers/net/netdevsim/dev.c                   |  27 +-
 include/net/devlink.h                         |  19 +-
 net/core/devlink.c                            | 233 ++++++++++--------
 4 files changed, 202 insertions(+), 115 deletions(-)

-- 
2.24.1

