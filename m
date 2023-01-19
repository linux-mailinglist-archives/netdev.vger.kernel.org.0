Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16E067437D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjASUYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjASUYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:24:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F359CB94
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 12:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674159812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=chrJCnGKSxZ+Gqnkqp1hMJQsXXkdPAS4UelZoHmwcGY=;
        b=fNdizY8JDN+O5ERC0Nr0nOcJ8LW8D4eVD2yaVszdR3tnC5Zb1BGA/yIjUHPj3WvSM3PKhN
        +arVR5hhUAROajqq9Ozm9gM+gAe9i4EeCBjHv/QPg+1l0s9YPfqnyvbAzoKIup78Y5ST7F
        kprMqmer5IqCHQB3j6DKkjsReVSdhJE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-pXzxzMvAN1C6_QctN5KchA-1; Thu, 19 Jan 2023 15:23:29 -0500
X-MC-Unique: pXzxzMvAN1C6_QctN5KchA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1DE138149C1;
        Thu, 19 Jan 2023 20:23:28 +0000 (UTC)
Received: from metal.redhat.com (ovpn-192-69.brq.redhat.com [10.40.192.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9336040C2064;
        Thu, 19 Jan 2023 20:23:26 +0000 (UTC)
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
Subject: [PATCH v3] ice/ptp: fix the PTP worker retrying indefinitely if the link went down
Date:   Thu, 19 Jan 2023 21:23:16 +0100
Message-Id: <20230119202317.2741092-1-neelx@redhat.com>
In-Reply-To: <20230117181533.2350335-1-neelx@redhat.com>
References: <20230117181533.2350335-1-neelx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
index d63161d73eb16..3c39ae3ed2426 100644
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
+	link_up = ptp_port->link_up;
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

