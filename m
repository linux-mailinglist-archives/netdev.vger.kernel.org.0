Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3BCC13BEE7
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgAOLyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:54:13 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51709 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730090AbgAOLyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 06:54:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 515092202A;
        Wed, 15 Jan 2020 06:54:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 06:54:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=D1G32YglMuEjal6lv
        hC0bDIgtl0EnCcy9YoVlqiu6QI=; b=lzDshJ6X6kr67jEjshQ3JcPLfVgOT5TsZ
        0Yh+NySMwqeRnF57ZmP15iJtCDiwzy2Bd0pzGbqAKtzStMC7wQ7f6IR66Y1uifHY
        2ZDwxorFAq+siPwmEttLgzeUAFq4F6aJpdDiqpaGDI/swtsVOsG0IEhZOFabDycb
        hejWmKeWnppGG7N7LHu5ntkEOCmk6KAGuA2+nNR41H9IC0J/khDmJuSfm6ibVEnW
        HojydRGhoyYIH2C0EA2mEwp7+jPZHH56zv/Qmn+dfrj99WCI3RvcumVLehGheV9l
        L1rDWteDprn/ZLqOkOWbkmLrArTF5tzlBDS1CdGacM/syZNCksVDg==
X-ME-Sender: <xms:ZP0eXlaZ0Ori6kElFURbj3z7cTSmiwFm4YM6dJr3COrOEMIPq0-SKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:ZP0eXj2FrgXBNUuM1oF3DVq_jNOaaDrstdUWaO-VAgleXBf7Go-vKA>
    <xmx:ZP0eXlWRvSUF1MX-CGmla88jzEWGuVtOs1zGrNf1scbTBO-To1hjhA>
    <xmx:ZP0eXtXCb_soWPgN8RmJhrg3qw0pt_3l17nG6IniAiulHkA4bId3qQ>
    <xmx:ZP0eXlf7ax-51oXkaV2_NR0rBVq08PRs4noGG7uZhRXxCl5DZMpHwg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 098F280069;
        Wed, 15 Jan 2020 06:54:10 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 0/6] mlxsw: Various fixes
Date:   Wed, 15 Jan 2020 13:53:43 +0200
Message-Id: <20200115115349.1273610-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set contains various fixes for mlxsw.

Patch #1 splits the init() callback between Spectrum-2 and Spectrum-3 in
order to avoid enforcing the same firmware version for both ASICs, as
this can't possibly work. Without this patch the driver cannot boot with
the Spectrum-3 ASIC.

Patches #2-#3 fix a long standing race condition that was recently
exposed while testing the driver on an emulator, which is very slow
compared to the actual hardware. The problem is explained in detail in
the commit messages.

Patch #4 fixes a selftest.

Patch #5 prevents offloaded qdiscs from presenting a non-zero backlog to
the user when the netdev is down. This is done by clearing the cached
backlog in the driver when the netdev goes down.

Patch #6 fixes qdisc statistics (backlog and tail drops) to also take
into account the multicast traffic classes.

v2:
* Patches #2-#3: use skb_cow_head() instead of skb_unshare() as
  suggested by Jakub. Remove unnecessary check regarding headroom
* Patches #5-#6: new

Ido Schimmel (3):
  mlxsw: spectrum: Do not enforce same firmware version for multiple
    ASICs
  mlxsw: spectrum: Do not modify cloned SKBs during xmit
  mlxsw: switchx2: Do not modify cloned SKBs during xmit

Petr Machata (3):
  selftests: mlxsw: qos_mc_aware: Fix mausezahn invocation
  mlxsw: spectrum: Wipe xstats.backlog of down ports
  mlxsw: spectrum_qdisc: Include MC TCs in Qdisc counters

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 54 ++++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 30 ++++++++---
 .../net/ethernet/mellanox/mlxsw/switchx2.c    | 17 +++---
 .../drivers/net/mlxsw/qos_mc_aware.sh         |  8 ++-
 4 files changed, 76 insertions(+), 33 deletions(-)

-- 
2.24.1

