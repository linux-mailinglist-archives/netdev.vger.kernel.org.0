Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1462C4A6B3C
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbiBBFHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbiBBFGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DE1C061744
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29D85B8299D
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513FDC340EC;
        Wed,  2 Feb 2022 05:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778394;
        bh=Y2/P6bkxmWHoGZDzsAXXkkl7+T7s/C2EmjmhJRvN1n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXRmzRfX9Ho7F6BE5LOCoTYONLFa0PvFz0F85ylgWDWa1e0XZjOvsOy3TtdPCQrdJ
         iwUeBbrXtutvgNU4DDCVsBvbv7u46sr7tdPdBbU5sdlbPP+aRP8C6CtnCWY5nSyxiW
         HiIEddo6s+yLxhibnbkaWlmUE7MDxZUlidR38o/T6mZdNCWjpzr4NU35xmFgepI+bZ
         ackgAbOJO0/b/eX5x6UGPCI6wf5V5Qo1zUthz0JlsVdZH1LeI5E6cLIh2vhtrYJRQL
         wQBFCfh1KIWmbimtYxpK46AKe8a5bdJ2GBkl//EatdW/6dmTSaBDva9jS3/9YG220T
         bGL/rin14K70g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/18] net/mlx5: Use del_timer_sync in fw reset flow of halting poll
Date:   Tue,  1 Feb 2022 21:03:51 -0800
Message-Id: <20220202050404.100122-6-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

Substitute del_timer() with del_timer_sync() in fw reset polling
deactivation flow, in order to prevent a race condition which occurs
when del_timer() is called and timer is deactivated while another
process is handling the timer interrupt. A situation that led to
the following call trace:
	RIP: 0010:run_timer_softirq+0x137/0x420
	<IRQ>
	recalibrate_cpu_khz+0x10/0x10
	ktime_get+0x3e/0xa0
	? sched_clock_cpu+0xb/0xc0
	__do_softirq+0xf5/0x2ea
	irq_exit_rcu+0xc1/0xf0
	sysvec_apic_timer_interrupt+0x9e/0xc0
	asm_sysvec_apic_timer_interrupt+0x12/0x20
	</IRQ>

Fixes: 38b9f903f22b ("net/mlx5: Handle sync reset request event")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 0b0234f9d694..84dbe46d5ede 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -132,7 +132,7 @@ static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 
-	del_timer(&fw_reset->timer);
+	del_timer_sync(&fw_reset->timer);
 }
 
 static void mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, bool poll_health)
-- 
2.34.1

