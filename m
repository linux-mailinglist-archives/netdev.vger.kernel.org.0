Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2744EEBB5
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 12:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344971AbiDAKoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 06:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344969AbiDAKmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 06:42:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 821CF103DA9
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 03:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648809664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DjkNl878MF0d7RU+70oPmG5s+v89O1lNqPhsXPb8x2M=;
        b=SfHSSnN7DyYO45AA3MqBa2hcltJuxCt7CnczuU82h7XxQ9HgiF8ub0ZVQTQ0w7A3/RHNea
        3DOB/mnxumoF5exdembb/q9LX56HVqUyEKzBdiXpYvw7c0l0SEpYiaKEud6pEd8WZ4zAwo
        WWUkJDQGh/NqeBrMzTpOy+xH/acBOdQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-ewtEnXRZPAqk3RJgynQXIA-1; Fri, 01 Apr 2022 06:41:00 -0400
X-MC-Unique: ewtEnXRZPAqk3RJgynQXIA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84BCA811E83;
        Fri,  1 Apr 2022 10:40:59 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.192.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DEC21121315;
        Fri,  1 Apr 2022 10:40:52 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     poros@redhat.com, mschmidt@redhat.com, jacob.e.keller@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brett Creeley <brett.creeley@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v2] ice: Fix incorrect locking in ice_vc_process_vf_msg()
Date:   Fri,  1 Apr 2022 12:40:52 +0200
Message-Id: <20220401104052.1711721-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usage of mutex_trylock() in ice_vc_process_vf_msg() is incorrect
because message sent from VF is ignored and never processed.

Use mutex_lock() instead to fix the issue. It is safe because this
mutex is used to prevent races between VF related NDOs and
handlers processing request messages from VF and these handlers
are running in ice_service_task() context. Additionally move this
mutex lock prior ice_vc_is_opcode_allowed() call to avoid potential
races during allowlist acccess.

Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and VF ndo ops")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 21 +++++++------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 3f1a63815bac..a465f3743ffc 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3642,14 +3642,6 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 			err = -EINVAL;
 	}
 
-	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
-		ice_vc_send_msg_to_vf(vf, v_opcode,
-				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
-				      0);
-		ice_put_vf(vf);
-		return;
-	}
-
 error_handler:
 	if (err) {
 		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
@@ -3660,12 +3652,13 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
-	/* VF is being configured in another context that triggers a VFR, so no
-	 * need to process this message
-	 */
-	if (!mutex_trylock(&vf->cfg_lock)) {
-		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
-			 vf->vf_id);
+	mutex_lock(&vf->cfg_lock);
+
+	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
+		ice_vc_send_msg_to_vf(vf, v_opcode,
+				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
+				      0);
+		mutex_unlock(&vf->cfg_lock);
 		ice_put_vf(vf);
 		return;
 	}
-- 
2.35.1

