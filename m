Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1FA26D404
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIQG4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:56:40 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60075 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbgIQG4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 02:56:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CD255828;
        Thu, 17 Sep 2020 02:50:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 17 Sep 2020 02:50:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=d8BOLbx9+HnAzROue
        DOfPMsUImxBxj0eRSOLnbFMpic=; b=ItSsc+EU7RmXb8wg8/RUiv2dGfUyO+w9N
        K4YKIDMskQ1DgplC35NT1JIVxCiVbQy21esv9S5OkeoLpJo0jXNi2I39gY9R1uxd
        pFZtDVisB+HByPW/VUjrSD336j/q/eI2qKLdxMMd5p7Md40Dc1/+0tgkkCPoBP4q
        yZab2/leHHHke5XiR6Q1MaAZ9oIh3PT7b6vXuWjeUnth3byckneBgWBQUxPtrjXB
        66yghx4iCQTbZA2cCZbnxmaR113ODtlUg41A9TtGKfiTxxTmbiL3ABOspPyDtP5o
        /QDrfl1sraoJLilixyV/q549kfo/g96C6BLEK3ENT0pukS/YqQTDA==
X-ME-Sender: <xms:HwdjX1uPJEQrmHVvhdqhsWuxn9MWDZZTy50n9ad6Z9esbGZ7nQ687w>
    <xme:HwdjX-fnNjZ7dwu6RFU_pMKD9gxFoYytv2jtoMM9kXg-X02ZPUFW7QDJNsVyPhBU6
    DZbGVcikzlIa8U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtdefgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeeirdekvdenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:HwdjX4yfDnwx5CVEkLEFJxoPL6zYS35AxS6w0i5ZrJGE4jmfmX3fXw>
    <xmx:HwdjX8Mihbe0wVabKnDo3VmoHEV2ndZ-x14QQpGMaKVc4p3elsPonA>
    <xmx:HwdjX1_D8iJtFaK10q8ecwZbJ6UvaQuRls2xunC6ZKjIfbsjWWoobw>
    <xmx:HwdjXwaf2jVHNzSWjDravByvcL1m2I2551GM2j8WEaNy77OOfXk1pQ>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 455AC3064683;
        Thu, 17 Sep 2020 02:50:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/3] mlxsw: Support dcbnl_setbuffer, dcbnl_getbuffer
Date:   Thu, 17 Sep 2020 09:49:00 +0300
Message-Id: <20200917064903.260700-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Petr says:

On Spectrum, port buffers, also called port headroom, is where packets are
stored while they are parsed and the forwarding decision is being made. For
lossless traffic flows, in case shared buffer admission is not allowed,
headroom is also where to put the extra traffic received before the sent
PAUSE takes effect.

Linux supports two DCB interfaces related to the headroom: dcbnl_setbuffer
for configuration, and dcbnl_getbuffer for inspection. This patch set
implements them.

With dcbnl_setbuffer in place, there will be two sources of authority over
the ingress configuration: the DCB ETS hook, because ETS configuration is
mirrored to ingress, and the DCB setbuffer hook. mlxsw is in a similar
situation on the egress side, where there are two sources of the ETS
configuration: the DCB ETS hook, and the TC qdisc hooks. This is a
non-intuitive situation, because the way the ASIC ends up being configured
depends not only on the actual configured bits, but also on the order in
which they were configured.

To prevent these issues on the ingress side, two configuration modes will
exist: DCB mode and TC mode. DCB ETS will keep getting projected to ingress
in the (default) DCB mode. When a qdisc is installed on a port, it will be
switched to the TC mode, the ingress configuration will be done through the
dcbnl_setbuffer callback. The reason is that the dcbnl_setbuffer hook is
not standardized and supported by lldpad. Projecting DCB ETS configuration
to ingress is a reasonable heuristic to configure ingress especially when
PFC is in effect.

In patch #1, the toggle between the DCB and TC modes of headroom
configuration, described above, is introduced.

Patch #2 implements dcbnl_getbuffer and dcbnl_setbuffer. dcbnl_getbuffer
can be always used to determine the current port headroom configuration.
dcbnl_setbuffer is only permitted in the TC mode.

In patch #3, make the qdisc module toggle the headroom mode from DCB to TC
and back, depending on whether there is an offloaded qdisc on the port.

Petr Machata (3):
  mlxsw: spectrum_buffers: Support two headroom modes
  mlxsw: spectrum_dcb: Implement dcbnl_setbuffer / getbuffer
  mlxsw: spectrum_qdisc: Disable port buffer autoresize with qdiscs

 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 11 ++++
 .../mellanox/mlxsw/spectrum_buffers.c         | 22 ++++++-
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 59 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 34 ++++++++++-
 4 files changed, 122 insertions(+), 4 deletions(-)

-- 
2.26.2

