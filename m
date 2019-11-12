Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FBDF88B9
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfKLGta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:49:30 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50733 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbfKLGt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:49:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0A6BF22114;
        Tue, 12 Nov 2019 01:49:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 12 Nov 2019 01:49:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UIHRYNpx6RbjbQzi1
        kr7XFvcwo2leei1I8nD+bV9xpA=; b=b8DBs3Et5mE8WPMvXPPKKfblt8qFUX4qa
        yO7ZOC+OdXS+IGtod7FHxDKP7aZXX5MR1HPsmMC2U3ePpP+VuDf8D4zLva1obMgG
        lHMAvIujenp0gcn4SUEGkyfgxccB55YSiyBb+Qhj9I/1nijJE8LZ9S42pgpxjXkM
        0uBZJA1alSheWwmfNWmvqauuVZlGmmuee2eLUpTBZE6ucxq306OaZ7MPsrpvp0rn
        08HDidS1bNrZNPZAv5tnZxxH9odAFceTgCQ0RVIC4oNyf0bm0qQPB+U6O4ag7Mjt
        4B8xDsL+mgf1Yx7RMbqo4z7fgGjT456k/yzgcbqWv3WkiOQPgX9uQ==
X-ME-Sender: <xms:-FXKXVHCyAT96ek587-cDq03eQKOs-WytGJLp-6x7XV53AnYVH3zJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvkedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:-FXKXadiwzbGdPQUsKCksN_6KipSZB4ZWWEBOeoSlDHVVSGzVePpgw>
    <xmx:-FXKXU9pnZqzO6a0-wrgffHhevZ6c-Vld3Wj8WDdfwWv30-f0hqVMw>
    <xmx:-FXKXfUPbGwCqvfd2zFWvpEKOnMHCrCpX13-rd6zVLtppdHxWLqypQ>
    <xmx:-VXKXZDZw9OafX19fi4be-03giXYVngrsB8WzMp22W9-IiapoowEaQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 51B1E80068;
        Tue, 12 Nov 2019 01:49:27 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 0/7] mlxsw: Add extended ACK for EMADs
Date:   Tue, 12 Nov 2019 08:48:23 +0200
Message-Id: <20191112064830.27002-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Shalom says:

Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
the driver and device's firmware. They are used to pass various
configurations to the device, but also to get events (e.g., port up)
from it. After the Ethernet header, these packets are built in a TLV
format.

Up until now, whenever the driver issued an erroneous register access it
only got an error code indicating a bad parameter was used. This patch
set adds a new TLV (string TLV) that can be used by the firmware to
encode a 128 character string describing the error. The new TLV is
allocated by the driver and set to zeros. In case of error, the driver
will check the length of the string in the response and report it using
devlink hwerr tracepoint.

Example:

$ perf record -a -q -e devlink:devlink_hwerr &

$ pkill -2 perf

$ perf script -F trace:event,trace | grep hwerr
devlink:devlink_hwerr: bus_name=pci dev_name=0000:03:00.0 driver_name=mlxsw_spectrum err=7 (tid=9913892d00001593,reg_id=8018(rauhtd)) bad parameter (inside er_rauhtd_write_query(), num_rec=32 is over the maximum  number of records supported)

Patch #1 parses the offsets of the different TLVs in incoming EMADs and
stores them in the skb's control block. This makes it easier to later
add new TLVs.

Patches #2-#3 remove deprecated TLVs and add string TLV definition.

Patches #4-#7 gradually add support for the new string TLV.

v2:
* Use existing devlink hwerr tracepoint to report the error string,
  instead of printing it to kernel log

Shalom Toledo (7):
  mlxsw: core: Parse TLVs' offsets of incoming EMADs
  mlxsw: emad: Remove deprecated EMAD TLVs
  mlxsw: core: Add EMAD string TLV
  mlxsw: core: Add support for EMAD string TLV parsing
  mlxsw: core: Extend EMAD information reported to devlink hwerr
  mlxsw: core: Add support for using EMAD string TLV
  mlxsw: spectrum: Enable EMAD string TLV

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 171 ++++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   2 +
 drivers/net/ethernet/mellanox/mlxsw/emad.h    |   7 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +
 4 files changed, 162 insertions(+), 20 deletions(-)

-- 
2.21.0

