Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811BC12C258
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfL2Lsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 06:48:52 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51631 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbfL2Lsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 06:48:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D87721D46;
        Sun, 29 Dec 2019 06:48:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Dec 2019 06:48:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=93Krvoxt3LynX7CV2
        NxABc20RV+yKtoR8p9VCLnAam8=; b=vHlGWsUQHJvcnuiQ0ThHLlrlzHmEFajeC
        CbbA4Mfa44V/Tls3qb6Toxr4RCc7ooe/qYFV8MV4gkzVE0IyzFSHWdLNgoDMsStX
        utjS1MGiPaaUr0W1UyuRyH7qVQ18xJS5+lZnMKQ+cbmB0JVN0SwTP5lwO2h3Zzxh
        58ybXuZsU99Egor5e5OebKzH/Q12wvlckHHzpKB2RRSVdpigWDCoI6Hpq5PEMGG2
        nuhNs1uB818pPVklDCYz239Er3thopeD+GNAirirq518sJvGe+O6oq5bQjs2419X
        zvhwSgP9U+FxV7Bo74uZjTtxcCBDxZURJy/IPuqxJvzhaacv00k1Q==
X-ME-Sender: <xms:o5IIXjW_GSJ-U4tga35V3SJqQYILEJwbN83aZzE-K-NEui214HN-mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekuddriedurdduudejnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:o5IIXt8tDsWSs3HyUYg2OLWvWgNeT5pMADGKiY-78pupxX7a6RBaOQ>
    <xmx:o5IIXorjZkmsJora5lyYqMEY3fjeb4emH4PGGL-fx-FicuLxpro1Cw>
    <xmx:o5IIXheJNazskyOJXMokWNCK5tE4FFpsQcNyOkTzynC-sEAtslhu7g>
    <xmx:o5IIXn8ka8aq3yTtwAuNZPanmyGl38t7m9lljv231iL_cwfvvwXOPw>
Received: from splinter.mtl.com (bzq-79-181-61-117.red.bezeqint.net [79.181.61.117])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8C393060A32;
        Sun, 29 Dec 2019 06:48:49 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/3] mlxsw: Allow setting default port priority
Date:   Sun, 29 Dec 2019 13:48:26 +0200
Message-Id: <20191229114829.61803-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

When LLDP APP TLV selector 1 (EtherType) is used with PID of 0, the
corresponding entry specifies "default application priority [...] when
application priority is not otherwise specified."

mlxsw currently supports this type of APP entry, but uses it only as a
fallback for unspecified DSCP rules. However non-IP traffic is prioritized
according to port-default priority, not according to the DSCP-to-prio
tables, and thus it's currently not possible to prioritize such traffic
correctly.

This patchset extends the use of the abovementioned APP entry to also set
default port priority (in patches #1 and #2) and then (in patch #3) adds a
selftest.

Petr Machata (3):
  mlxsw: reg: Add QoS Port DSCP to Priority Mapping Register
  mlxsw: spectrum_dcb: Allow setting default port priority
  selftests: mlxsw: Add a self-test for port-default priority

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  33 ++++
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    |  17 ++
 .../drivers/net/mlxsw/qos_defprio.sh          | 176 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  23 +++
 4 files changed, 249 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh

-- 
2.24.1

