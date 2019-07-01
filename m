Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73B5C2B9
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfGASOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGASOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 14:14:38 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51DE321721;
        Mon,  1 Jul 2019 18:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562004878;
        bh=BT6XXhInwBIdeNK23C6xW9sO0X7syFcLMZVh2E/HHSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2mBOCNMGdb4Qw87E0TNsnptLVWlQacw+yYZhdXUUJ/cy1j9Z1HaFdsSqUhNK/w/5
         IqinmSd8EjNQUn1RBMX2gaAjUJc+ajvyHE9ZS4c6NlGlUVwtaf4wmsSnJVb5xL3j83
         61zGu8srcaSto5O/iHCBAGhshCaHkYVICsTLSwrM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Introduce VHCA tunnel device capability
Date:   Mon,  1 Jul 2019 21:14:01 +0300
Message-Id: <20190701181402.25286-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190701181402.25286-1-leon@kernel.org>
References: <20190701181402.25286-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

When using the device emulation feature (introduced in Bluefield-1 SOC),
a privileged function (the device emulation manager) will be able to
create a channel to execute commands on behalf of the emulated function.

This channel will be a general object of type VHCA_TUNNEL that will have
a unique ID for each emulated function. This ID will be passed in each
cmd that will be issued by the emulation SW in a well known offset in
the command header.

This channel is needed since the emulated function doesn't have a normal
command interface to the HCA HW, but some basic configuration for that
function is needed (e.g. initialize and enable the HCA). For that matter,
a specific command-set was defined and only those commands will be issued
by the HCA.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5d2bf91e130b..a35e545a8de0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1329,7 +1329,13 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_6c0[0x4];
 	u8         flex_parser_id_geneve_tlv_option_0[0x4];
-	u8         reserved_at_6c8[0x138];
+	u8         reserved_at_6c8[0x18];
+
+	u8         reserved_at_6e0[0xa0];
+
+	u8         vhca_tunnel_commands[0x40];
+
+	u8         reserved_at_7c0[0x40];
 };
 
 enum mlx5_flow_destination_type {
@@ -9560,7 +9566,7 @@ struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 	u8         opcode[0x10];
 	u8         uid[0x10];
 
-	u8         reserved_at_20[0x10];
+	u8         vhca_tunnel_id[0x10];
 	u8         obj_type[0x10];
 
 	u8         obj_id[0x20];
-- 
2.20.1

