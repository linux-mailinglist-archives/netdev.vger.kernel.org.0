Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A808529F8E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiEQKgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344598AbiEQKgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:36:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D176417;
        Tue, 17 May 2022 03:35:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B516165E;
        Tue, 17 May 2022 10:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6701C385B8;
        Tue, 17 May 2022 10:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652783758;
        bh=lAksy8oepqE8iH2ITwCihZnI9L3nnQyBWYqoVUXqlUo=;
        h=From:To:Cc:Subject:Date:From;
        b=J4VVh6cFjDb1jIJK8SYjto2TV3c/jw1kHwiDZN006Xmam81unpFPSThWn4ldxHTYE
         DKpLfJC312AWUUSiZ4/T7FCDwjprWzSu4EWs/G0YLfZL8Zor4UUK+KMtDudRLjJU0X
         tNiMAYBysrP0AAoM6IgFtmeQeUz+Nxo5PMA+gPR1XgeFUmmp6gcCcUjBzCVFYRvBIP
         kxB3p4o/cCq+jdbZzhkIJ58GRY8uzjGbTRG7imw25kyUCbfjbzrF0YmqB370oE1zgz
         GslT0WoKU0CbEadEdAAMZxd9ilOd3HbshVQ1irycMGx81GI0UXmJue+znaU9kgM4nW
         EHSC/xgMTuKjg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1nquYX-00048Z-OB; Tue, 17 May 2022 12:35:57 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [RFC] ath11k: fix netdev open race
Date:   Tue, 17 May 2022 12:34:36 +0200
Message-Id: <20220517103436.15867-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure to allocate resources needed before registering the device.

This specifically avoids having a racing open() trigger a BUG_ON() in
mod_timer() when ath11k_mac_op_start() is called before the
mon_reap_timer as been set up.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Fixes: 840c36fa727a ("ath11k: dp: stop rx pktlog before suspend")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---

I started hitting a BUG_ON() during ath11k probe due to a timer which
hasn't been initialised. Turns out the netdev is registered before
having been fully set up:

[  421.232410] ath11k_core_pdev_create
[  421.233854] ath11k_dp_pdev_alloc
[  421.233863] ath11k_dp_rx_pdev_srng_alloc
[  421.259161] ath11k_mac_config_mon_status_default - NULL reap timer function
[  421.259165] ath11k_pci 0006:01:00.0: failed to configure monitor status ring with default rx_filter: (-22)
[  421.373066] ath11k_dp_rx_pdev_srng_alloc - reap timer setup

Sending as an RFC as I'm not familiar with the code. It looks like
ath11k_dp_pdev_alloc() may need to be split in an alloc and attach
function.

Johan


 drivers/net/wireless/ath/ath11k/core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index ea073be60c12..e090dfbfa4e2 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1218,23 +1218,23 @@ static int ath11k_core_pdev_create(struct ath11k_base *ab)
 		return ret;
 	}
 
-	ret = ath11k_mac_register(ab);
+	ret = ath11k_dp_pdev_alloc(ab);
 	if (ret) {
-		ath11k_err(ab, "failed register the radio with mac80211: %d\n", ret);
+		ath11k_err(ab, "failed to attach DP pdev: %d\n", ret);
 		goto err_pdev_debug;
 	}
 
-	ret = ath11k_dp_pdev_alloc(ab);
+	ret = ath11k_mac_register(ab);
 	if (ret) {
-		ath11k_err(ab, "failed to attach DP pdev: %d\n", ret);
-		goto err_mac_unregister;
+		ath11k_err(ab, "failed register the radio with mac80211: %d\n", ret);
+		goto err_dp_pdev_free;
 	}
 
 	ret = ath11k_thermal_register(ab);
 	if (ret) {
 		ath11k_err(ab, "could not register thermal device: %d\n",
 			   ret);
-		goto err_dp_pdev_free;
+		goto err_mac_unregister;
 	}
 
 	ret = ath11k_spectral_init(ab);
@@ -1247,10 +1247,10 @@ static int ath11k_core_pdev_create(struct ath11k_base *ab)
 
 err_thermal_unregister:
 	ath11k_thermal_unregister(ab);
-err_dp_pdev_free:
-	ath11k_dp_pdev_free(ab);
 err_mac_unregister:
 	ath11k_mac_unregister(ab);
+err_dp_pdev_free:
+	ath11k_dp_pdev_free(ab);
 err_pdev_debug:
 	ath11k_debugfs_pdev_destroy(ab);
 
-- 
2.35.1

