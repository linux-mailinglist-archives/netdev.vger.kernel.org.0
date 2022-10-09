Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9415F9034
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiJIWW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiJIWVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:21:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376A8218A;
        Sun,  9 Oct 2022 15:16:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED1A460D57;
        Sun,  9 Oct 2022 22:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A240C433B5;
        Sun,  9 Oct 2022 22:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353728;
        bh=86sBV2qtfryQCC0tnr7qDvXObYavIWhzE4hrzmMFdMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/UZCNnF++BicchiJUL7Mg/yuFtptunGN5NQ3bu97r4tc6ne2bPF9xqQnX6Qcjc+A
         /WRiq1CBstZP00tJTz9IfLabsUhALBesytZB4R1urermdLCgjNCfBl1+2Yc+pYeTce
         DU0TJXMavjnZi6B0I9GRyK94d0R31NnbErwxlWd8EFQg8RhrgFjwmjI4r/vaFFz9LK
         W83U1qch1lu4Z//5FyF9qojufIw/4DBs+znpBRaJM4tQ7w5rnqk51SeX3TYqAsYUAu
         Qg0sIkCOtvM1EHn16xVxAexKfCqJxxTwgv+A9jfApIpugfaATj9VgBMtqd35jltXK5
         lLC+FautghoTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 06/73] ice: set tx_tstamps when creating new Tx rings via ethtool
Date:   Sun,  9 Oct 2022 18:13:44 -0400
Message-Id: <20221009221453.1216158-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit b3b173745c8cab1e24d6821488b60abed3acb24d ]

When the user changes the number of queues via ethtool, the driver
allocates new rings. This allocation did not initialize tx_tstamps. This
results in the tx_tstamps field being zero (due to kcalloc allocation), and
would result in a NULL pointer dereference when attempting a transmit
timestamp on the new ring.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4efa5e5846e0..4dfdec11ddc1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2826,6 +2826,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		tx_rings[i].count = new_tx_cnt;
 		tx_rings[i].desc = NULL;
 		tx_rings[i].tx_buf = NULL;
+		tx_rings[i].tx_tstamps = &pf->ptp.port.tx;
 		err = ice_setup_tx_ring(&tx_rings[i]);
 		if (err) {
 			while (i--)
-- 
2.35.1

