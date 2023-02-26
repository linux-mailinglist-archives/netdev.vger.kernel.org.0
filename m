Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA45B6A3103
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjBZO4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjBZOyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:54:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D194A1B336;
        Sun, 26 Feb 2023 06:50:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2054760C19;
        Sun, 26 Feb 2023 14:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286FBC433A0;
        Sun, 26 Feb 2023 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423006;
        bh=vFw+NrHPookW98X6GbA95VLxJzY6awTkFvIBF2LclnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkOGmTkNwXLV2WJpdtEq/rWJsOGRGwhOqvcRuVhZpZoi4JAMDDBlOoh2HvTzDvSl5
         Q9X5mEbnewVIyiTASS36wSfA2PoqWBvEE0GEUw5oYSRfLee/3ha/zi8G+20ax2dauy
         4eDgCmLC0tHGm+rDjfducy265Cr61JLqjkKrPHL3r/aHiZWUm5h1T00ltJnL7JNMDa
         BtjjPnXCCaIQfTv+7NEyVkMGaRarAeYwck+b1LIVFIzkDnal91sS0HRv1vC/hAjHrs
         gE+wZeChk/AEpxibBZLLv8aDb+olKK20u8dF64iuzeyzwTuCqcOfmLONWWW+5eYSMU
         iBwZcS3FfYRxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kys@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 34/36] hv_netvsc: Check status in SEND_RNDIS_PKT completion message
Date:   Sun, 26 Feb 2023 09:48:42 -0500
Message-Id: <20230226144845.827893-34-sashal@kernel.org>
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

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit dca5161f9bd052e9e73be90716ffd57e8762c697 ]

Completion responses to SEND_RNDIS_PKT messages are currently processed
regardless of the status in the response, so that resources associated
with the request are freed.  While this is appropriate, code bugs that
cause sending a malformed message, or errors on the Hyper-V host, go
undetected. Fix this by checking the status and outputting a rate-limited
message if there is an error.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://lore.kernel.org/r/1676264881-48928-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index fb2448f9a8b17..4156299e039d8 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -814,6 +814,7 @@ static void netvsc_send_completion(struct net_device *ndev,
 	u32 msglen = hv_pkt_datalen(desc);
 	struct nvsp_message *pkt_rqst;
 	u64 cmd_rqst;
+	u32 status;
 
 	/* First check if this is a VMBUS completion without data payload */
 	if (!msglen) {
@@ -885,6 +886,23 @@ static void netvsc_send_completion(struct net_device *ndev,
 		break;
 
 	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
+		if (msglen < sizeof(struct nvsp_message_header) +
+		    sizeof(struct nvsp_1_message_send_rndis_packet_complete)) {
+			if (net_ratelimit())
+				netdev_err(ndev, "nvsp_rndis_pkt_complete length too small: %u\n",
+					   msglen);
+			return;
+		}
+
+		/* If status indicates an error, output a message so we know
+		 * there's a problem. But process the completion anyway so the
+		 * resources are released.
+		 */
+		status = nvsp_packet->msg.v1_msg.send_rndis_pkt_complete.status;
+		if (status != NVSP_STAT_SUCCESS && net_ratelimit())
+			netdev_err(ndev, "nvsp_rndis_pkt_complete error status: %x\n",
+				   status);
+
 		netvsc_send_tx_complete(ndev, net_device, incoming_channel,
 					desc, budget);
 		break;
-- 
2.39.0

