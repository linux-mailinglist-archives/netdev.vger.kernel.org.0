Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C01021F3C6
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgGNOVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51155 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgGNOVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6CA795C00EA;
        Tue, 14 Jul 2020 10:21:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=+U1iV9fPFlgss3MWNZE21+bBmj2WzTw26MskcdrNadc=; b=QBlWdsNu
        C0/jd9QUeJzdVny77znr+Qn4gRJCM6BytFr7MOE3C8EeifEOJxf6b8xu6ApL05N0
        mt0ke7KfsLSNEJD1+RwphzbhZoVm4g6FPZSvAaS+gVY/YfvOv8slDAUR64uYYQkm
        XdpkTqN1opGDHzFiWa+X9CwSmfnITuguNFUM6ym5T/fFrEchYulgKaEKrGMi1fwI
        pso11lVahGkT8Msf5plxiQRQXXZ4IXmeWOSJqiiUsN6UFgA6YS26qSwOF7I+cqJB
        heFef11JudB2LcnCh6qrRCrcsHglOChLuquDtMODuCTSIVUPc4ZO7x3iM1SlYqC/
        aaVZ9jryZlHCdA==
X-ME-Sender: <xms:d78NX7HGfpAUSbu6-EWk9jOnqc2JeqwAA2ux2JtY29ZefZ_VztJESw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:d78NX4W7n12XZp42KUolHFL5ewlGxdI2m-sAp8ULhlRk5bMCYwL8mA>
    <xmx:d78NX9KteIsmzd68FzIaEWwUih51xgJIPCodzjGQb5c-2H9sxGR_QA>
    <xmx:d78NX5EaCG1cohB8WaqCPHlJKhHDRyugnt8XexufDmE4PRivV8EyGg>
    <xmx:d78NX0SAa8eHP73hzB9av7T5GvoaFoYb76VJNixqxPlpBsDpln40ag>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96BD530600A9;
        Tue, 14 Jul 2020 10:21:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/13] mlxsw: spectrum_span: Do not dereference destination netdev
Date:   Tue, 14 Jul 2020 17:20:58 +0300
Message-Id: <20200714142106.386354-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, the destination netdev to which we mirror must be a valid
netdev. However, this is going to change with the introduction of
mirroring towards the CPU port, as the CPU port does not have a backing
netdev.

Avoid dereferencing the destination netdev when it is not clear if it is
valid or not.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 40289afdaaa8..0ef9505d336f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -692,16 +692,15 @@ mlxsw_sp_span_entry_configure(struct mlxsw_sp *mlxsw_sp,
 		goto set_parms;
 
 	if (sparms.dest_port->mlxsw_sp != mlxsw_sp) {
-		netdev_err(span_entry->to_dev, "Cannot mirror to %s, which belongs to a different mlxsw instance",
-			   sparms.dest_port->dev->name);
+		dev_err(mlxsw_sp->bus_info->dev,
+			"Cannot mirror to a port which belongs to a different mlxsw instance\n");
 		sparms.dest_port = NULL;
 		goto set_parms;
 	}
 
 	err = span_entry->ops->configure(span_entry, sparms);
 	if (err) {
-		netdev_err(span_entry->to_dev, "Failed to offload mirror to %s",
-			   sparms.dest_port->dev->name);
+		dev_err(mlxsw_sp->bus_info->dev, "Failed to offload mirror\n");
 		sparms.dest_port = NULL;
 		goto set_parms;
 	}
-- 
2.26.2

