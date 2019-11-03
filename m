Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94A4ED294
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 09:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfKCIg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 03:36:28 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36969 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726408AbfKCIg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 03:36:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 76A9E20E72;
        Sun,  3 Nov 2019 03:36:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 03 Nov 2019 03:36:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=N2ZyJwDhwVbwTPws0
        lTq1bmo32FmD7n4KRd0dOyqUwQ=; b=B6Qj2/CAhLwgAj0O6wmH0ollxJlCrHMv4
        o4VD9lb4BIoY5sWpY70l/2KA13zyrmkE4bS+puyCmmhGEg/vNFGNMlTr2xqjfqDr
        yPXLvcSjppZ6KGPzj9lxBiqlFXEL8uRdmeUzrOS7/nGNbpT1NMtFjnOVbAU8inRh
        90EEhqbAagMGSwhRWOvvgbYu6/D9muP29QtIXsBI52LgZcdItj8yCc8YfGho9YX5
        myI/9T1/SfV6vpUjAIoHhA3l/Y+7x2vYn3PNpJESDaCwIGasVSHdGHEqwxiBigxO
        FDh8qMHiLVqvytwj0erw30TLwL9911GwkzI69HjBEcHejp3Vkc2aA==
X-ME-Sender: <xms:ipG-XWFN-_K6Zr8o870F3yZeL2UR7u2-aYSTi6RDI7lf3lmCycLUeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddutddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:ipG-XUskwFYstnREVxKVE8KmqP30uUp3psMuGvS7e9NWHPPwW1XAdA>
    <xmx:ipG-XVwDfbnR0JdggkYKDWS8t-KNU2lySuN6_W8xXUcLsLsV89iKlQ>
    <xmx:ipG-XaoYcn0Nb-jGP98Upm2DkhHWlSXyf1YaG42G2l4mF85ENaX_-Q>
    <xmx:ipG-XUwjweiGnnrBmJ22jFeXuF6aYBN6gasPJ_3UKWS9tW-ZyberQg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 01558306005C;
        Sun,  3 Nov 2019 03:36:24 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Date:   Sun,  3 Nov 2019 10:35:48 +0200
Message-Id: <20191103083554.6317-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
the driver and device's firmware. They are used to pass various
configurations to the device, but also to get events (e.g., port up)
from it. After the Ethernet header, these packets are built in a TLV
format.

Up until now, whenever the driver issued an erroneous register access it
only got an error code indicating a bad parameter was used. This patch
set from Shalom adds a new TLV (string TLV) that can be used by the
firmware to encode a 128 character string describing the error. The new
TLV is allocated by the driver and set to zeros. In case of error, the
driver will check the length of the string in the response and print it
to the kernel log.

Example output:

mlxsw_spectrum 0000:03:00.0: EMAD reg access failed (tid=a9719f9700001306,reg_id=8018(rauhtd),type=query,status=7(bad parameter))
mlxsw_spectrum 0000:03:00.0: Firmware error (tid=a9719f9700001306,emad_err_string=inside er_rauhtd_write_query(), num_rec=32 is over the maximum number of records supported)

Patch #1 parses the offsets of the different TLVs in incoming EMADs and
stores them in the skb's control block. This makes it easier to later
add new TLVs.

Patches #2-#3 remove deprecated TLVs and add string TLV definition.

Patches #4-#6 gradually add support for the new string TLV.

Shalom Toledo (6):
  mlxsw: core: Parse TLVs' offsets of incoming EMADs
  mlxsw: emad: Remove deprecated EMAD TLVs
  mlxsw: core: Add EMAD string TLV
  mlxsw: core: Add support for EMAD string TLV parsing
  mlxsw: core: Add support for using EMAD string TLV
  mlxsw: spectrum: Enable EMAD string TLV

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 154 ++++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   2 +
 drivers/net/ethernet/mellanox/mlxsw/emad.h    |   7 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +
 4 files changed, 147 insertions(+), 18 deletions(-)

-- 
2.21.0

