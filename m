Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9845F8F6E
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiJIWIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiJIWIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79E7286FB;
        Sun,  9 Oct 2022 15:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E90360C93;
        Sun,  9 Oct 2022 22:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D81C433C1;
        Sun,  9 Oct 2022 22:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353294;
        bh=Xkhp6qFYAJNu1xrHgYYTR3y2exUAugmzcx115MDESBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QP8+pUWmgelOTE0ABp0o0bZ0DckZswlyeWcy0ps3cJmNxE1L7RH2x71kzuCCF0Fw3
         fe/YhY62kyrNdkpNR32JQxL0yUZf5KUKBkEvJsqN9ppJolqHJk/p7NhiRxjjoyJnT9
         koWNcHnP6QzT+jo3ephNBGagOFqXw1HAi+mUrdddikR9DAUabPuj03aM3MJF0OBrE5
         SJzseCWABY2/MbIyaP9xmzbHYROdaUFY7fm9hc6sFOCw4le59jGIh5FV0rnw6jl7k5
         80JrmYR3jgdCdsBj8Xn395+n0kJZS0SiqoEoz8GxgDy0LMlZAf/agpZz1MXyQxnsN4
         xX/WG3L98lkiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 07/77] ice: set tx_tstamps when creating new Tx rings via ethtool
Date:   Sun,  9 Oct 2022 18:06:44 -0400
Message-Id: <20221009220754.1214186-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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
index a6fff8ebaf9d..bbf6a300078e 100644
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

