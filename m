Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0124DE993C
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 10:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfJ3JfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 05:35:09 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55637 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726225AbfJ3JfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 05:35:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A92421E56;
        Wed, 30 Oct 2019 05:35:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Oct 2019 05:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Kh3VhDxGTHNVwDk3ke13dr/GBfP13vmPWi8IS027GME=; b=I6dqE9dt
        ni2vG+TsMCR7INvvl9KmXU3/1vsY1j8dhvK5Ca7UdBrULbp1opDiCC/asu5hQJs5
        UUrUFlkPvgR+XCIABXlXzFoAZZLpr5owt5F3nWCo4VlRKk9M3JH88iYiR1doIyrw
        2e9PXIDZ6pUN+im6aqWNTmavm+E11QqqRLz/PioEIrBSSG/HjqoKh8hUp9lrvurF
        H3GxxZHgdn4rXnIxm11Md2Ip+oUWdxXpAFBITLiDa6SxiNx1dU6mnEVH5pw4AwHu
        txjs+9nzP/hRxA7iNPUJWSmtfs0yQOuk6Sk+4/0gUvJtVlzyx4hbEyyCtw/dfVtE
        tBm9/LMiwuPZXw==
X-ME-Sender: <xms:SVm5XY-VBXZwmdkrm6ZmTV7k5S2xXH5Ew305aHqfUXOjD3LC5hzxxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:SVm5XQTmKvRU76c-graWR9PJxYd5xOagr2aBJZfa0-0MaVVqxbwGxA>
    <xmx:SVm5XSEpT2LpJ-kBbgV4UwThIHbKCffgb8p1C33qHTdpCW5KmIxEKg>
    <xmx:SVm5XYO4hjY0DVYJoncziEhKfJLnFjQl1k7cI1PtvMdyTs_3_JbaAg>
    <xmx:SVm5XdT4biAG_iHP8mtQZdbJap-MalKx2qDqfltvw50ukitkv0x2Kg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77C5C3060060;
        Wed, 30 Oct 2019 05:35:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 2/4] mlxsw: pci: Increase PCI reset timeout for SN3800 systems
Date:   Wed, 30 Oct 2019 11:34:49 +0200
Message-Id: <20191030093451.26325-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030093451.26325-1-idosch@idosch.org>
References: <20191030093451.26325-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

SN3800 Spectrum-2 based systems have gearboxes that need to be
initialized by the firmware during its initialization flow. In certain
cases, the firmware might need to flash these gearboxes, which is
currently a time-consuming process.

In newer firmware versions, the firmware will not signal to the driver
that it is ready until the gearboxes are flashed. Increase the PCI reset
timeout for these situations. In normal cases, the driver will need to
wait no longer than 5 seconds.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 2b3aec482742..e0d7d2d9a0c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -27,7 +27,7 @@
 
 #define MLXSW_PCI_SW_RESET			0xF0010
 #define MLXSW_PCI_SW_RESET_RST_BIT		BIT(0)
-#define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	20000
+#define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
 #define MLXSW_PCI_SW_RESET_WAIT_MSECS		100
 #define MLXSW_PCI_FW_READY			0xA1844
 #define MLXSW_PCI_FW_READY_MASK			0xFFFF
-- 
2.21.0

