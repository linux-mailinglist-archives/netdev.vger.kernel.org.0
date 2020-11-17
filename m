Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279172B6BD3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgKQRer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:34:47 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:52817 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726397AbgKQRer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:34:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0F723F52;
        Tue, 17 Nov 2020 12:34:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:34:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=p6Bmo3RMBGqpxTkIg0mFRYZNb6VALPNmNzgT6dai92M=; b=hbirwSA1
        TVXMdN/RMOGqVuZWV5LXuR8fPVvqXBFT/QMDed1E5sURzEObt15w9RUaQNwpRy5R
        E7qHrCT/395UTQC2x0waKAoqei++G64rtKEuVC7tPZJir4gegxpWlJaOU0UCExQl
        cLgSan3Ub4a5cqT27NALv4otVRNVFahvwmIftW8JlZ+3PJ798lwb0I7t1nOua/PW
        u9l2GearWzAccbWP7rKvaxGmrUO4FB6H7y9UMaCVP+fRL8S1V5VcCDrlAPms1saK
        vyA14qz+fgtpqVDN1z9i/FIcLhRDlVg6OtTSxcMxLAcPPHph06AW4o/6XmkZGvag
        SSeAtAdOqnc1bQ==
X-ME-Sender: <xms:tQm0X0WdKg4AoywMSmrYikDweb7bsQ8zRlvaPNlDVrsNghOX25uTlQ>
    <xme:tQm0X4kQA2vsXtnv2eGyXJGzi3CejgnwpVWiYhSPmy-Uc_MXASTihhraJIM6a7_vb
    llfLl-nUHxZ690>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tQm0X4Z41VQlfNRLrtWXNo02rScGRAQX0orpvdvWVQ7XDNRBrrVN8g>
    <xmx:tQm0XzUhmH2EHN7x5sF7xhDrGp7LvE-GMEX2m9Hg7K9HlgeFYKrekw>
    <xmx:tQm0X-mFu_YO9RqK5OQGZ5gmTwfpWDcLWKFBkICKnb6RsOIXhDMr3A>
    <xmx:tQm0XzwH0BQa8-EivE850aGqt72pYN1fkSAMubmT59UD7c7vrKkDLw>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id E661E3064AAE;
        Tue, 17 Nov 2020 12:34:43 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] mlxsw: Fix firmware flashing
Date:   Tue, 17 Nov 2020 19:33:51 +0200
Message-Id: <20201117173352.288491-2-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117173352.288491-1-idosch@idosch.org>
References: <20201117173352.288491-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The commit cited below moved firmware flashing functionality from
mlxsw_spectrum to mlxsw_core, but did not adjust the Kconfig
dependencies. This makes it possible to have mlxsw_core as built-in and
mlxfw as a module. The mlxfw code is therefore not reachable from
mlxsw_core and firmware flashing fails:

# devlink dev flash pci/0000:01:00.0 file mellanox/mlxsw_spectrum-13.2008.1310.mfa2
devlink answers: Operation not supported

Fix by having mlxsw_core select mlxfw.

Fixes: b79cb787ac70 ("mlxsw: Move fw flashing code into core.c")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Vadim Pasternak <vadimp@nvidia.com>
Tested-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index 872e9910bb7c..a619d90559f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -6,6 +6,7 @@
 config MLXSW_CORE
 	tristate "Mellanox Technologies Switch ASICs support"
 	select NET_DEVLINK
+	select MLXFW
 	help
 	  This driver supports Mellanox Technologies Switch ASICs family.
 
@@ -82,7 +83,6 @@ config MLXSW_SPECTRUM
 	select GENERIC_ALLOCATOR
 	select PARMAN
 	select OBJAGG
-	select MLXFW
 	imply PTP_1588_CLOCK
 	select NET_PTP_CLASSIFY if PTP_1588_CLOCK
 	default m
-- 
2.28.0

