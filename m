Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0CC6A323A
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjBZP2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjBZP2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:28:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33DD1D931;
        Sun, 26 Feb 2023 07:24:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7FCECCE0E95;
        Sun, 26 Feb 2023 14:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6A9C4339B;
        Sun, 26 Feb 2023 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422962;
        bh=sB4qmt7A4dKezC7XbRxJu7JVBeriEdk0CE62+dhbjpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9+CiHhUjVX2m8BNHXbk4gvvuc0djIYwRxaqVzT7nFEK4VeFJBciA4t1VaLWgiil8
         E51OOLcwM7N3rTKeGSchkXwuOFDlfwD34KT8zy5Ecwt0Bgwv7AJdS6pKy2AJPIUchf
         2GzpzFb02NyfEZ9SflGYBLYuunAA7a9SwtB8r3xWm8vv76XNhD0M+uJJHP3jIS7pSE
         vsF4hHh7Jq0LGFFjJcQm61Bgty4JQT7blBghU+ATvkviqtRXyUuPFhPK4ns9fA5SgT
         MHE/pJ1o7NE6y7eerBj1XBz2fGyeSo1fcedwCSO+zsPejkcyD8JetDoRGnLKdkVS5A
         oqRM03XtVkDHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siddaraju DH <siddaraju.dh@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/36] ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB
Date:   Sun, 26 Feb 2023 09:48:21 -0500
Message-Id: <20230226144845.827893-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144845.827893-1-sashal@kernel.org>
References: <20230226144845.827893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Siddaraju DH <siddaraju.dh@intel.com>

[ Upstream commit 8aa4318c3a122b8670bc09af142de3872ca63b88 ]

The PHY provides only 39b timestamp. With current timing
implementation, we discard lower 7b, leaving 32b timestamp.
The driver reconstructs the full 64b timestamp by correlating the
32b timestamp with cached_time for performance. The reconstruction
algorithm does both forward & backward interpolation.

The 32b timeval has overflow duration of 2^32 counts ~= 4.23 second.
Due to interpolation in both direction, its now ~= 2.125 second
IIRC, going with at least half a duration, the cached_time is updated
with periodic thread of 1 second (worst-case) periodicity.

But the 1 second periodicity is based on System-timer.
With PPB adjustments, if the 1588 timers increments at say
double the rate, (2s in-place of 1s), the Nyquist rate/half duration
sampling/update of cached_time with 1 second periodic thread will
lead to incorrect interpolations.

Hence we should restrict the PPB adjustments to at least half duration
of cached_time update which translates to 500,000,000 PPB.

Since the periodicity of the cached-time system thread can vary,
it is good to have some buffer time and considering practicality of
PPB adjustments, limiting the max_adj to 100,000,000.

Signed-off-by: Siddaraju DH <siddaraju.dh@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 9b50e9e6042a5..4d7aa49b7c147 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1090,7 +1090,7 @@ static void ice_ptp_set_caps(struct ice_pf *pf)
 	snprintf(info->name, sizeof(info->name) - 1, "%s-%s-clk",
 		 dev_driver_string(dev), dev_name(dev));
 	info->owner = THIS_MODULE;
-	info->max_adj = 999999999;
+	info->max_adj = 100000000;
 	info->adjtime = ice_ptp_adjtime;
 	info->adjfine = ice_ptp_adjfine;
 	info->gettimex64 = ice_ptp_gettimex64;
-- 
2.39.0

