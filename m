Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3475381A4
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240865AbiE3OUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241359AbiE3ORc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:17:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874138E1B2;
        Mon, 30 May 2022 06:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46731B80AE8;
        Mon, 30 May 2022 13:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96EFC36AE5;
        Mon, 30 May 2022 13:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918340;
        bh=UAo6LCwq6BdnSWAM2NkTDxIo7p5zcc9lLplkkTTl0vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGgJqaOGe6qLqcSZGk8QviJfQ75PJfXg4NjcWCcKQC0u+Gt+Jxl/Jxpv18rXuCb/m
         xAuzgC1DeYjeOBlz5sKQhQGy1IG1tQehBHZmmRf3cvYGDebw9LrE2q5zwtx3GjEn+2
         VyfbtXDTzjt0fTDVJBiEGpqjcfuHQtgz1WbyaOkQ8WtrVl5chbARoNxWDu6XPaHp7n
         3ioq5TNZW0lV14H09Txly3wltAykXsXEWccEcqHwPOv+9Cw4wwx8VBvAYZLzHbuBSd
         IEdIDpgFr1y30Xwd3aW4a4cOGVofoZB+sBwlHMSuDzyBCcFVpqphZenG+u8JE/6qDp
         WU5iNdGiHSgBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@nvidia.com>,
        Maksym Yaremchuk <maksymy@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 42/76] mlxsw: Treat LLDP packets as control
Date:   Mon, 30 May 2022 09:43:32 -0400
Message-Id: <20220530134406.1934928-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 0106668cd2f91bf913fb78972840dedfba80a3c3 ]

When trapping packets for on-CPU processing, Spectrum machines
differentiate between control and non-control traps. Traffic trapped
through non-control traps is treated as data and kept in shared buffer in
pools 0-4. Traffic trapped through control traps is kept in the dedicated
control buffer 9. The advantage of marking traps as control is that
pressure in the data plane does not prevent the control traffic to be
processed.

When the LLDP trap was introduced, it was marked as a control trap. But
then in commit aed4b5721143 ("mlxsw: spectrum: PTP: Hook into packet
receive path"), PTP traps were introduced. Because Ethernet-encapsulated
PTP packets look to the Spectrum-1 ASIC as LLDP traffic and are trapped
under the LLDP trap, this trap was reconfigured as non-control, in sync
with the PTP traps.

There is however no requirement that PTP traffic be handled as data.
Besides, the usual encapsulation for PTP traffic is UDP, not bare Ethernet,
and that is in deployments that even need PTP, which is far less common
than LLDP. This is reflected by the default policer, which was not bumped
up to the 19Kpps / 24Kpps that is the expected load of a PTP-enabled
Spectrum-1 switch.

Marking of LLDP trap as non-control was therefore probably misguided. In
this patch, change it back to control.

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 433f14ade464..02ba6aa01105 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -709,7 +709,7 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 		.trap = MLXSW_SP_TRAP_CONTROL(LLDP, LLDP, TRAP),
 		.listeners_arr = {
 			MLXSW_RXL(mlxsw_sp_rx_ptp_listener, LLDP, TRAP_TO_CPU,
-				  false, SP_LLDP, DISCARD),
+				  true, SP_LLDP, DISCARD),
 		},
 	},
 	{
-- 
2.35.1

