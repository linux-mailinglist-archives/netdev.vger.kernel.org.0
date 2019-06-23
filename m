Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C254FBAE
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 14:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfFWM5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 08:57:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59317 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726086AbfFWM5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 08:57:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A00B222077;
        Sun, 23 Jun 2019 08:57:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 23 Jun 2019 08:57:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aS/1Cx7S5X9tG+4lE
        UqI45zzYbZ5GxZ/F+ve4UHZ/QI=; b=e9EwJGj7nBZzLo7g/1JwurLY4GZGeORiS
        629pg9xryOBZhpM0JLOuSKrSAgN7qg50zMWyCXdLrHpYA3ZZb98eM5HBxQt9qZwe
        VQF+KSpIpPfX8rKUdR1nMZ6RU3SXlLJUTYfkScri72lNMRKdOZnAXb3suAXxGGmp
        o9Gw6ldvNhqYesC5ppP5wpqhd8RtypzJbXCAhz7WJYTbCpUdowUXdymHTsKxPosa
        uMStrYWCPvKQ9Fi4M9QaNW56BIDbzo9ytPnmQyPlxm67Lsr7CJ1qqp7kdHIX9FxV
        j4AgOkNrPSChWKzv2pVT95uNzWzciSap/r31DF5X0tjPb3vKWIR4A==
X-ME-Sender: <xms:LncPXWurlEdxAl8WUj8spFNUVMza5cIi_2Ue3iDH3bFpZ6EYGjLJjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucffohhmrghinhepohiilhgrsghsrdhorhhgnecukfhppeduleefrdegje
    drudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:LncPXYWn3K87d-5Tbj8o2bLwgB8AxztGSw6NXF3sa27hOtaLww4xaA>
    <xmx:LncPXUyHFjAysssssDzJc-1HmF7pIbn4PnVKHHvUxI6GBC_0yu7jbg>
    <xmx:LncPXWEzrD7Kd1W3BmWPSGgmrbl_uASYHKI1FwmWijUzFS_eW7p7ig>
    <xmx:LncPXegH8Wo5Hot9hnVn5hn11Tb3nD497Zk8_mE9hBGNaIzSchfC4g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3F11380079;
        Sun, 23 Jun 2019 08:57:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/3] mlxsw: Thermal and hwmon extensions
Date:   Sun, 23 Jun 2019 15:56:42 +0300
Message-Id: <20190623125645.2663-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset from Vadim includes various enhancements to thermal and
hwmon code in mlxsw.

Patch #1 adds a thermal zone for each inter-connect device (gearbox).
These devices are present in SN3800 systems and code to expose their
temperature via hwmon was added in commit 2e265a8b6c09 ("mlxsw: core:
Extend hwmon interface with inter-connect temperature attributes").

Currently, there are multiple thermal zones in mlxsw and only a few
cooling devices. Patch #2 detects the hottest thermal zone and the
cooling devices are switched to follow its trends. RFC was sent last
month [1].

Patch #3 allows to read and report negative temperature of the sensors
mlxsw exposes via hwmon and thermal subsystems.

[1] https://patchwork.ozlabs.org/patch/1107161/

Vadim Pasternak (3):
  mlxsw: core: Extend thermal core with per inter-connect device thermal
    zones
  mlxsw: core: Add the hottest thermal zone detection
  mlxsw: core: Add support for negative temperature readout

 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  |  12 +-
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 208 +++++++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  12 +-
 3 files changed, 208 insertions(+), 24 deletions(-)

-- 
2.20.1

