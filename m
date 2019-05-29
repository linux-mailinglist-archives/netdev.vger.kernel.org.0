Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040F22D82A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfE2Irl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55627 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbfE2Irl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BC5BB2239D;
        Wed, 29 May 2019 04:47:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=byy/jEiE7PoLWEkSp
        Dn/ULnSev2e+NSFkNFyq5qxQDw=; b=p4AE/k1JWf2KOgiyhqSdDt+E5hy0KwOcT
        dTmeFOFKTzuFQ2GFusdrvG39auXKtFbaNFkd2sCbx7HjYBI1Z4ZhpgO/lwDc/27E
        xMnn3KEfB3PNRZhRbKj47cgnyLCd4AnDk96ekdKgnB/xw6HU0YlAbt+yDpmSxT0V
        83fbAAEIw/ppXjTJCdo3rODpkKTE/Ce1HtxoV2tO3E5mR5rzpzeHTKB2kQz99uK/
        ODlw4vPhGfXZLBB9JsSlMkRyqJtn8Ie8RwlmFUc1rkauTxVBMYScWwD/f+OygD+E
        TJx1Qwnnk5ZNafREP1Zbtm0PNkEJn/VXfCV/d11FrjJvaJR4PTzrQ==
X-ME-Sender: <xms:K0fuXO4vQnAYFDjEwphUieqeHSvAlfazREtZ0a6aVwRg5xiUVk3IOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:K0fuXHVgDfINTv5E6fogKcLIrN85IfP3LK92H0syNj4HoPbmS_AJEQ>
    <xmx:K0fuXOg0YgpCNdfngDah04AQzVgpyYlxkYVcG8U3kD79YSLgDjnhnA>
    <xmx:K0fuXPdp49By2ZoK1PY6-uKSzu5Sj0T3SIQoTmmGlKLPR2BXW6p6kw>
    <xmx:K0fuXN7qM6fw1EhdflWKK9hwqWiwX7WDccyqRqu4spmTSkW8ERLc6Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 136268005A;
        Wed, 29 May 2019 04:47:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/8] mlxsw: Hardware monitoring enhancements
Date:   Wed, 29 May 2019 11:47:14 +0300
Message-Id: <20190529084722.22719-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset from Vadim provides various hardware monitoring related
improvements for mlxsw.

Patch #1 allows querying firmware version from the switch driver when
the underlying bus is I2C. This is useful for baseboard management
controller (BMC) systems that communicate with the ASIC over I2C.

Patch #2 improves driver's performance over I2C by utilizing larger
transactions sizes, if possible.

Patch #3 re-orders driver's initialization sequence to enforce a
specific firmware version before new firmware features are utilized.
This is a prerequisite for patches #4-#6.

Patches #4-#6 expose the temperature of inter-connect devices
(gearboxes) that are present in Mellanox SN3800 systems and split
2x50Gb/s lanes to 4x25Gb/s lanes.

Patches #7-#8 reduce the transaction size when reading SFP modules
temperatures, which is crucial when working over I2C.

Ido Schimmel (1):
  mlxsw: core: Re-order initialization sequence

Vadim Pasternak (7):
  mlxsw: i2c: Extend initialization with querying firmware info
  mlxsw: i2c: Allow flexible setting of I2C transactions size
  mlxsw: reg: Extend sensor index field size of Management Temperature
    Register
  mlxsw: reg: Add Management General Peripheral Information Register
  mlxsw: core: Extend hwmon interface with inter-connect temperature
    attributes
  mlxsw: core: Extend the index size for temperature sensors readout
  mlxsw: core: Reduce buffer size in transactions for SFP modules
    temperature readout

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  21 +--
 .../net/ethernet/mellanox/mlxsw/core_env.c    |  27 +---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 135 +++++++++++++-----
 .../ethernet/mellanox/mlxsw/core_thermal.c    |  46 +++---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c     |  76 +++++++---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  18 +++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  62 +++++++-
 7 files changed, 274 insertions(+), 111 deletions(-)

-- 
2.20.1

