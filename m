Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32606DED79
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjDLIVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDLIVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:21:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A1765A9
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681287605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vgM1/2w5Awfz7kmbjPCU33iMsxdh570loH34gDEC38E=;
        b=JgFhnAHMFTbhytemTtxg8FumbcoK92oinPXJ6Y79n7XjjaT4oDMvaZj7iLj3iJKk4WK1OT
        8FWv512wvlDYt9vlg6VN0Akfc3hzblVPtJHAbqQuBqoa4c0aJQ6zn0JJQz0XeJZLKkcGt2
        kNg4vtIywDjcIhCvBv9MsdRNqSKJudA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-BAp3Sv8PMkm3mdnslH5uyw-1; Wed, 12 Apr 2023 04:20:00 -0400
X-MC-Unique: BAp3Sv8PMkm3mdnslH5uyw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75BCD8996F3;
        Wed, 12 Apr 2023 08:19:59 +0000 (UTC)
Received: from toolbox.infra.bos2.lab (ovpn-192-9.brq.redhat.com [10.40.192.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 805F91415117;
        Wed, 12 Apr 2023 08:19:57 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Petr Oros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 5/6] ice: remove unused buffer copy code in ice_sq_send_cmd_retry()
Date:   Wed, 12 Apr 2023 10:19:28 +0200
Message-Id: <20230412081929.173220-6-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-1-mschmidt@redhat.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'buf_cpy'-related code in ice_sq_send_cmd_retry() looks broken.
'buf' is nowhere copied into 'buf_cpy'.

The reason this does not cause problems is that all commands for which
'is_cmd_for_retry' is true go with a NULL buf.

Let's remove 'buf_cpy'. Add a WARN_ON in case the assumption no longer
holds in the future.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 3638598d732b..c6200564304e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1619,7 +1619,6 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 {
 	struct ice_aq_desc desc_cpy;
 	bool is_cmd_for_retry;
-	u8 *buf_cpy = NULL;
 	u8 idx = 0;
 	u16 opcode;
 	int status;
@@ -1629,11 +1628,8 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	memset(&desc_cpy, 0, sizeof(desc_cpy));
 
 	if (is_cmd_for_retry) {
-		if (buf) {
-			buf_cpy = kzalloc(buf_size, GFP_KERNEL);
-			if (!buf_cpy)
-				return -ENOMEM;
-		}
+		/* All retryable cmds are direct, without buf. */
+		WARN_ON(buf);
 
 		memcpy(&desc_cpy, desc, sizeof(desc_cpy));
 	}
@@ -1645,17 +1641,12 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		    hw->adminq.sq_last_status != ICE_AQ_RC_EBUSY)
 			break;
 
-		if (buf_cpy)
-			memcpy(buf, buf_cpy, buf_size);
-
 		memcpy(desc, &desc_cpy, sizeof(desc_cpy));
 
 		mdelay(ICE_SQ_SEND_DELAY_TIME_MS);
 
 	} while (++idx < ICE_SQ_SEND_MAX_EXECUTE);
 
-	kfree(buf_cpy);
-
 	return status;
 }
 
-- 
2.39.2

