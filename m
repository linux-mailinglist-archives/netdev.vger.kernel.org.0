Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3455AED2
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfF3GGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:06:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49115 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbfF3GGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:06:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2448021470;
        Sun, 30 Jun 2019 02:06:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Jl6UG9/9n7AUz0ndyRTR+vJqQMkHCm9WMSmQxNYkuV0=; b=CDqAtQD+
        WaONZyDqH09+QCjTJW6CB5cVqGBj6o4gjczXAXi/wAegol3Tr76yfatkHO0nkLvW
        MeWHk+HbzBOu8JVDQWjx73kUzrPEUk/XLBLBTxCAzk/kotdxD42+gVkVj3y91pzC
        33fWxWNo+nQvb5LwgE9XdYCwrK6WxEVZdz3x6j2IHKAZuQ2zpfRPJtnLVlpY46Gw
        b3+tJp1nWiVcOWXcWrlYpw2Mtp77MV2HkgbFrGeLktXjErYdu4bw/Lazw8uBQCvk
        FjXLgjiN+D1Dtb05gPsXTAA0iF2O56wbUfy0Sz6Os6iFYAvZPtmdK+PSVxXcYnxJ
        nO/JLVc+IleHrA==
X-ME-Sender: <xms:UFEYXccrSdhNzXtFgLG603DZeUtx8L7WdR7BicJU2jP2fG8FBYfGjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeek
X-ME-Proxy: <xmx:UFEYXT-2PPVmnSUOH6V3wngazfoMKIYyWac8tuzkuD9GFzdjcCcK5w>
    <xmx:UFEYXbmBrXawGRMkXghkgWzejzskKWlBw-Q4Y6IX1bSpqB7w_xy_2Q>
    <xmx:UFEYXchYDHhu0pIArIGMcpC1rPr31sR8_pE9r8bwzdEaTaGERBGrAA>
    <xmx:UVEYXYejGNFbtAbL2moe0wKFxL10a8Swusurp3XbcBFlXEhPUdQN2w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E99AA8005B;
        Sun, 30 Jun 2019 02:06:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 11/16] mlxsw: spectrum: PTP: Disable BH when working with PHC
Date:   Sun, 30 Jun 2019 09:04:55 +0300
Message-Id: <20190630060500.7882-12-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Up until now, the PTP hardware clock code was only invoked in the process
context (SYS_clock_adjtime -> do_clock_adjtime -> k_clock::clock_adj ->
pc_clock_adjtime -> posix_clock_operations::clock_adjtime ->
ptp_clock_info::adjtime -> mlxsw_spectrum).

In order to enable HW timestamping, which is tied into trap handling, it
will be necessary to take the clock lock from the PCI queue handler
tasklets as well.

Therefore use the _bh variants when handling the clock lock. Incidentally,
Documentation/ptp/ptp.txt recommends _irqsave variants, but that's
unnecessarily strong for our needs.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 6725a4d53f87..1eb6eefa1afc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -117,9 +117,9 @@ mlxsw_sp1_ptp_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
 	next_sec = div_u64(nsec, NSEC_PER_SEC) + 1;
 	next_sec_in_nsec = next_sec * NSEC_PER_SEC;
 
-	spin_lock(&clock->lock);
+	spin_lock_bh(&clock->lock);
 	cycles = mlxsw_sp1_ptp_ns2cycles(&clock->tc, next_sec_in_nsec);
-	spin_unlock(&clock->lock);
+	spin_unlock_bh(&clock->lock);
 
 	mlxsw_reg_mtpps_vpin_pack(mtpps_pl, cycles);
 	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtpps), mtpps_pl);
@@ -152,11 +152,11 @@ static int mlxsw_sp1_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	adj *= ppb;
 	diff = div_u64(adj, NSEC_PER_SEC);
 
-	spin_lock(&clock->lock);
+	spin_lock_bh(&clock->lock);
 	timecounter_read(&clock->tc);
 	clock->cycles.mult = neg_adj ? clock->nominal_c_mult - diff :
 				       clock->nominal_c_mult + diff;
-	spin_unlock(&clock->lock);
+	spin_unlock_bh(&clock->lock);
 
 	return mlxsw_sp1_ptp_phc_adjfreq(clock, neg_adj ? -ppb : ppb);
 }
@@ -167,10 +167,10 @@ static int mlxsw_sp1_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
 	u64 nsec;
 
-	spin_lock(&clock->lock);
+	spin_lock_bh(&clock->lock);
 	timecounter_adjtime(&clock->tc, delta);
 	nsec = timecounter_read(&clock->tc);
-	spin_unlock(&clock->lock);
+	spin_unlock_bh(&clock->lock);
 
 	return mlxsw_sp1_ptp_phc_settime(clock, nsec);
 }
@@ -183,10 +183,10 @@ static int mlxsw_sp1_ptp_gettimex(struct ptp_clock_info *ptp,
 		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
 	u64 cycles, nsec;
 
-	spin_lock(&clock->lock);
+	spin_lock_bh(&clock->lock);
 	cycles = __mlxsw_sp1_ptp_read_frc(clock, sts);
 	nsec = timecounter_cyc2time(&clock->tc, cycles);
-	spin_unlock(&clock->lock);
+	spin_unlock_bh(&clock->lock);
 
 	*ts = ns_to_timespec64(nsec);
 
@@ -200,10 +200,10 @@ static int mlxsw_sp1_ptp_settime(struct ptp_clock_info *ptp,
 		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
 	u64 nsec = timespec64_to_ns(ts);
 
-	spin_lock(&clock->lock);
+	spin_lock_bh(&clock->lock);
 	timecounter_init(&clock->tc, &clock->cycles, nsec);
 	nsec = timecounter_read(&clock->tc);
-	spin_unlock(&clock->lock);
+	spin_unlock_bh(&clock->lock);
 
 	return mlxsw_sp1_ptp_phc_settime(clock, nsec);
 }
@@ -225,9 +225,9 @@ static void mlxsw_sp1_ptp_clock_overflow(struct work_struct *work)
 
 	clock = container_of(dwork, struct mlxsw_sp_ptp_clock, overflow_work);
 
-	spin_lock(&clock->lock);
+	spin_lock_bh(&clock->lock);
 	timecounter_read(&clock->tc);
-	spin_unlock(&clock->lock);
+	spin_unlock_bh(&clock->lock);
 	mlxsw_core_schedule_dw(&clock->overflow_work, clock->overflow_period);
 }
 
-- 
2.20.1

