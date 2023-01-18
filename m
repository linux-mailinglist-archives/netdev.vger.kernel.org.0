Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8845D6722DF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjARQWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjARQVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:21:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDE15927F
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674058670;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pU6AC9cRWg3g9Q98YLxAbBqb6BOxub7aw+UutKP+hlQ=;
        b=gG+pQyrmCSfMJhA+AUtBa7AVJtOyzt8bKZce8QwzaEhrL+7Gc8fN8IuR01CCqI+DLuDK/w
        v8bahqG7BmxCoND8lmTVbltGtJIxvyBgBOW/CXOtnDZg/hKiASDx7x/EAyEsMBd/poTKla
        H+MoIz2dhMTbznhZj1+urnBs3V/gQ/s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-ZFMX-FN7OVCPNumI5uwNgg-1; Wed, 18 Jan 2023 11:17:47 -0500
X-MC-Unique: ZFMX-FN7OVCPNumI5uwNgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE2B91C05AB7;
        Wed, 18 Jan 2023 16:17:46 +0000 (UTC)
Received: from metal.redhat.com (ovpn-192-69.brq.redhat.com [10.40.192.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 531EE2026D4B;
        Wed, 18 Jan 2023 16:17:44 +0000 (UTC)
From:   Daniel Vacek <neelx@redhat.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Daniel Vacek <neelx@redhat.com>, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ice/ptp: fix the PTP worker retrying indefinitely if the link went down
Date:   Wed, 18 Jan 2023 17:17:26 +0100
Message-Id: <20230118161727.2485457-1-neelx@redhat.com>
Reply-To: 20230117181533.2350335-1-neelx@redhat.com
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the link goes down the ice_ptp_tx_tstamp() may loop re-trying to
process the packets till the 2 seconds timeout finally drops them.
In such a case it makes sense to just drop them right away.

Signed-off-by: Daniel Vacek <neelx@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index d63161d73eb16..cb776a7199839 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -680,6 +680,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	u64 tstamp_ready;
+	bool link_up;
 	int err;
 	u8 idx;
 
@@ -695,11 +696,14 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 	if (err)
 		return false;
 
+	/* Drop packets if the link went down */
+	link_up = hw->port_info->phy.link_info.link_info & ICE_AQ_LINK_UP;
+
 	for_each_set_bit(idx, tx->in_use, tx->len) {
 		struct skb_shared_hwtstamps shhwtstamps = {};
 		u8 phy_idx = idx + tx->offset;
 		u64 raw_tstamp = 0, tstamp;
-		bool drop_ts = false;
+		bool drop_ts = !link_up;
 		struct sk_buff *skb;
 
 		/* Drop packets which have waited for more than 2 seconds */
@@ -728,7 +732,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
 
 		err = ice_read_phy_tstamp(hw, tx->block, phy_idx, &raw_tstamp);
-		if (err)
+		if (err && !drop_ts)
 			continue;
 
 		ice_trace(tx_tstamp_fw_done, tx->tstamps[idx].skb, idx);
-- 
2.39.0

