Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC7279F5E
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgI0Huo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:50:44 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60945 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727263AbgI0Huo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:50:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 59BF845A;
        Sun, 27 Sep 2020 03:50:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DX2YdbB3YwexJ8Wm0
        DsdSa4cGwnppFWm2DxPfzrY6m0=; b=dUwP+UutfLRSVp7E+YfByF+uAlc+qoqbw
        CsV5O22lRXbberXYBjVlJUM9PufPJegPigq1EPi+xtF9Lx7xK74XQve1StzYxZXo
        FMf2ThUfTrNVdggADkVyMhzaE4ifVtPCXbeRUkkuKjbf73U1y6PhDLI04hV/3AB8
        HSUrb+9HD0+nV2K7WE3oKdaIxDuZQNW63u2UqROwMZOYT5yduKujIus408LCnt89
        sl+vkM0zp0/ERr40ZTpevZWd9+WNYJV6zZTKou1sxX82M6d9btHbo3St2at29D2L
        ulOm3zRz4wlDGT3Haoa8DH/g15QCEvq2XAeIs0WJdg9E3vo0YhI0g==
X-ME-Sender: <xms:UkRwX2IzFoDcMuw3fla9vs6gd0klruehA28VMfL_TvJk0tt9qW9boA>
    <xme:UkRwX-II7B1k38pJhRclNAQStuSS7RQAFzymv5XdeZygMwsRf47ai1HDvuU5QymEW
    thz51qJxyqBVc0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeejrddugeeknecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:UkRwX2ssM_HsuK_w2J5wU5wh_Vdu85G3Jau51qDakb9DSu70AYNeQA>
    <xmx:UkRwX7Z3Oa6jvpKBgFvN_fRYV0siXN5q1JAApuSwPs89IvX9Mbtzrg>
    <xmx:UkRwX9ZAETzqRZTntsjWfoKq2um8kGBpopucZC6A39bk6bL9irQH2g>
    <xmx:UkRwXxHfOdkHi0-wRYVj-VkNHNPozfenI3VHqT09WUDJb92j-WRA_Q>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id A95973280059;
        Sun, 27 Sep 2020 03:50:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: Expose transceiver overheat counter
Date:   Sun, 27 Sep 2020 10:50:05 +0300
Message-Id: <20200927075015.1417714-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Amit says:

An overheated transceiver can be the root cause of various network
problems such as link flapping. Counting the number of times a
transceiver's temperature was higher than its configured threshold can
therefore help in debugging such issues.

This patch set exposes a transceiver overheat counter via ethtool. This
is achieved by configuring the Spectrum ASIC to generate events whenever
a transceiver is overheated. The temperature thresholds are queried from
the transceiver (if available) and set to the default otherwise.

Example:

# ethtool -S swp1
...
transceiver_overheat: 2

Patch set overview:

Patches #1-#3 add required device registers
Patches #4-#5 add required infrastructure in mlxsw to configure and
count overheat events
Patches #6-#9 gradually add support for the transceiver overheat counter
Patch #10 exposes the transceiver overheat counter via ethtool

Amit Cohen (10):
  mlxsw: reg: Add Management Temperature Warning Event Register
  mlxsw: reg: Add Port Module Plug/Unplug Event Register
  mlxsw: reg: Add Ports Module Administrative and Operational Status
    Register
  mlxsw: core_hwmon: Query MTMP before writing to set only relevant
    fields
  mlxsw: core: Add an infrastructure to track transceiver overheat
    counter
  mlxsw: Update transceiver_overheat counter according to MTWE
  mlxsw: Enable temperature event for all supported port module sensors
  mlxsw: spectrum: Initialize netdev's module overheat counter
  mlxsw: Update module's settings when module is plugged in
  mlxsw: spectrum_ethtool: Expose transceiver_overheat counter

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  27 ++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   5 +
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 368 ++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |   6 +
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  |  21 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 132 +++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  44 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   1 +
 .../mellanox/mlxsw/spectrum_ethtool.c         |  57 ++-
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   4 +
 10 files changed, 660 insertions(+), 5 deletions(-)

-- 
2.26.2

