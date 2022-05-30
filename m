Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B87C538052
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiE3OKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239172AbiE3OFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:05:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AC7CEBA8;
        Mon, 30 May 2022 06:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEE3460F9B;
        Mon, 30 May 2022 13:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6DCC341C4;
        Mon, 30 May 2022 13:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918087;
        bh=6PJF83MYmr1iD+sEdmRIMreTQhVP/kon/lfjZYqbT1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icb/ZZ0DkwNaDItV6NotVU2rOSxnRLm3iyklYDFV2ktbh8gK759W/ThOoicdYteTP
         iptq9zjkZzTpIu/EQ1OeREdS7flJvO84hj+tzqT4li9kTwiXp2Jt92RYIuXpgXFTGj
         pQ3krN3n7IIN2WHG1nPG1/6OfWlATjrcdkvw1yCW2nkd3f4mzIZzfwBjFvRoiwK2OY
         Y/3VWIPiALpAKBIHRlNWSWm9eY9A+JsQL3VuRqnLlkaTgKowz0LZbwnJ+uws1OJwMC
         2WMv/O4Iw8IRN3kxs1mj147tnVmvI738+aIaia9pr3Epwh1VfRGxvc5K/bK7WB7Gwe
         hQU6hN7FWG1FQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@nvidia.com>,
        Maksym Yaremchuk <maksymy@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 056/109] mlxsw: Treat LLDP packets as control
Date:   Mon, 30 May 2022 09:37:32 -0400
Message-Id: <20220530133825.1933431-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
index 26d01adbedad..ce6f6590a777 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -864,7 +864,7 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
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

