Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2058024EC20
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgHWIID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:08:03 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54635 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728453AbgHWIHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:07:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 960E95C0089;
        Sun, 23 Aug 2020 04:07:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 23 Aug 2020 04:07:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Pj2Q1rfmHlz2YEUcKFeAta5Pq8HUg7fxfichU41VxU8=; b=NxOfJ1mo
        z8dBzv6279e9X9p6pZGWQZnlWX8IUw5LLE8EAXIkRoQDSx3q1Tm1yKYn93LLP0+/
        kj0BtKgD4KLmq89Ln/KphKGG2ZQRlw1CguFoAGGxxb6tP99m+80Jabuh1PNWJ6YA
        b34tA7wdVFcjMOkuIInqhCNDyEwD46w0Sf+TPADcIA39ADrau4/4/rsY5IYAioRe
        Qpu9Xin6/AWG+7Z5S3NN0Iksr+OagHnAhjYojR7+6j6w+gKULgFFYfp7K/oyOzsM
        GJmvSIKFnrHs5xcbhz83jcTjEfx81hTHKiX8rYzDAb2P0QrQ97eTLlkIIVpGaps3
        zhmrha7YrvlImg==
X-ME-Sender: <xms:2CNCX3lU6iOt3imAoQbNTMHd6WN30QQWVQICReJ1OuJJ0S_4-liiRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhefgtd
    fftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeekrddufedurdefheenucev
    lhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2CNCX63JLOjZ62IwgJuj5Bi6SvXZvxg3cjFqm7PdXlCNRxrHBIKCyQ>
    <xmx:2CNCX9qkHwFaklagDPpMloXWk36PgKLRobh4m_Cq818nWVoSkcc4zQ>
    <xmx:2CNCX_l4cDJkVx6lmosm5IjM3tehKxHzhbBBAqsP48A9YrhDJHKxtQ>
    <xmx:2CNCX29K9pljscIzh4OLEXRalHlCRlZXbZHEoUIRpk0E1Bl-xEJVmg>
Received: from shredder.mtl.com (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9FD7C3280059;
        Sun, 23 Aug 2020 04:07:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/7] selftests: mlxsw: Increase burst size for burst test
Date:   Sun, 23 Aug 2020 11:06:25 +0300
Message-Id: <20200823080628.407637-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200823080628.407637-1-idosch@idosch.org>
References: <20200823080628.407637-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The current combination of rate and burst size does not adhere to
Spectrum-{2,3} limitation which states that the minimum burst size
should be 40% of the rate.

Increase the burst size in order to honor above mentioned limitation and
avoid intermittent failures of this test case on Spectrum-{2,3}.

Remove the first sub-test case as the variation in number of received
packets is simply too large to reliably test it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/devlink_trap_policer.sh | 27 ++-----------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
index ecba9ab81c2a..508a702f0021 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
@@ -288,35 +288,12 @@ __burst_test()
 
 	RET=0
 
-	devlink trap policer set $DEVLINK_DEV policer $id rate 1000 burst 32
+	devlink trap policer set $DEVLINK_DEV policer $id rate 1000 burst 512
 	devlink trap group set $DEVLINK_DEV group l3_drops policer $id
 
-	# Send a burst of 64 packets and make sure that about 32 are received
-	# and the rest are dropped by the policer
-	log_info "=== Tx burst size: 64, Policer burst size: 32 pps ==="
-
-	t0_rx=$(devlink_trap_rx_packets_get blackhole_route)
-	t0_drop=$(devlink_trap_policer_rx_dropped_get $id)
-
-	start_traffic $h1 192.0.2.1 198.51.100.100 $rp1_mac -c 64
-
-	t1_rx=$(devlink_trap_rx_packets_get blackhole_route)
-	t1_drop=$(devlink_trap_policer_rx_dropped_get $id)
-
-	rx=$((t1_rx - t0_rx))
-	pct=$((100 * (rx - 32) / 32))
-	((-20 <= pct && pct <= 20))
-	check_err $? "Expected burst size of 32 packets, got $rx packets, which is $pct% off. Required accuracy is +-20%"
-	log_info "Expected burst size of 32 packets, measured burst size of $rx packets"
-
-	drop=$((t1_drop - t0_drop))
-	(( drop > 0 ))
-	check_err $? "Expected non-zero policer drops, got 0"
-	log_info "Measured policer drops of $drop packets"
-
 	# Send a burst of 16 packets and make sure that 16 are received
 	# and that none are dropped by the policer
-	log_info "=== Tx burst size: 16, Policer burst size: 32 pps ==="
+	log_info "=== Tx burst size: 16, Policer burst size: 512 ==="
 
 	t0_rx=$(devlink_trap_rx_packets_get blackhole_route)
 	t0_drop=$(devlink_trap_policer_rx_dropped_get $id)
-- 
2.26.2

