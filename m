Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD324FF07F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiDMHZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiDMHZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:25:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 874954C407
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 00:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649834588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nkb2ciMsQESRphf5aIFi+X8zwqcBYIMXDJ6/hK2Ilpc=;
        b=TxXdHNNJ6Th6ZgwwqELZU8CSj+fPRV7LzBOuMLmLLWJmwoXRYdZoP6DHRuPSixWM8AmSOO
        F8H/rnMDPCG0zhoykO04YP9eju5tATxP9fCtg5vC+XtHqlVP7WjDi2VPN3BWYJ9oTsddUb
        rZxDnE3scIpLHoQ3JjpIeTMBiE3/hgQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-nX072MOGNf-pHAaISsLJnQ-1; Wed, 13 Apr 2022 03:23:04 -0400
X-MC-Unique: nX072MOGNf-pHAaISsLJnQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32A1B101AA44;
        Wed, 13 Apr 2022 07:23:04 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4854A111D3C8;
        Wed, 13 Apr 2022 07:23:00 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     poros@redhat.com, mschmidt@redhat.com, Fei Liu <feliu@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brett Creeley <brett.creeley@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] ice: Protect vf_state check by cfg_lock in ice_vc_process_vf_msg()
Date:   Wed, 13 Apr 2022 09:22:59 +0200
Message-Id: <20220413072259.3189386-1-ivecera@redhat.com>
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

Previous patch labelled "ice: Fix incorrect locking in
ice_vc_process_vf_msg()"  fixed an issue with ignored messages
sent by VF driver but a small race window still left.

Recently caught trace during 'ip link set ... vf 0 vlan ...' operation:

[ 7332.995625] ice 0000:3b:00.0: Clearing port VLAN on VF 0
[ 7333.001023] iavf 0000:3b:01.0: Reset indication received from the PF
[ 7333.007391] iavf 0000:3b:01.0: Scheduling reset task
[ 7333.059575] iavf 0000:3b:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 3
[ 7333.059626] ice 0000:3b:00.0: Invalid message from VF 0, opcode 3, len 4, error -1

Setting of VLAN for VF causes a reset of the affected VF using
ice_reset_vf() function that runs with cfg_lock taken:

1. ice_notify_vf_reset() informs IAVF driver that reset is needed and
   IAVF schedules its own reset procedure
2. Bit ICE_VF_STATE_DIS is set in vf->vf_state
3. Misc initialization steps
4. ice_sriov_post_vsi_rebuild() -> ice_vf_set_initialized() and that
   clears ICE_VF_STATE_DIS in vf->vf_state

Step 3 is mentioned race window because IAVF reset procedure runs in
parallel and one of its step is sending of VIRTCHNL_OP_GET_VF_RESOURCES
message (opcode==3). This message is handled in ice_vc_process_vf_msg()
and if it is received during the mentioned race window then it's
marked as invalid and error is returned to VF driver.

Protect vf_state check in ice_vc_process_vf_msg() by cfg_lock to avoid
this race condition.

Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and VF ndo ops")
Tested-by: Fei Liu <feliu@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 38 +++++++++----------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 5612c032f15a..553287a75b50 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3625,44 +3625,39 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
+	mutex_lock(&vf->cfg_lock);
+
 	/* Check if VF is disabled. */
 	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
 		err = -EPERM;
-		goto error_handler;
-	}
-
-	ops = vf->virtchnl_ops;
-
-	/* Perform basic checks on the msg */
-	err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg, msglen);
-	if (err) {
-		if (err == VIRTCHNL_STATUS_ERR_PARAM)
-			err = -EPERM;
-		else
-			err = -EINVAL;
+	} else {
+		/* Perform basic checks on the msg */
+		err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg,
+						  msglen);
+		if (err) {
+			if (err == VIRTCHNL_STATUS_ERR_PARAM)
+				err = -EPERM;
+			else
+				err = -EINVAL;
+		}
 	}
-
-error_handler:
 	if (err) {
 		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
 				      NULL, 0);
 		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
 			vf_id, v_opcode, msglen, err);
-		ice_put_vf(vf);
-		return;
+		goto finish;
 	}
 
-	mutex_lock(&vf->cfg_lock);
-
 	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
 		ice_vc_send_msg_to_vf(vf, v_opcode,
 				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
 				      0);
-		mutex_unlock(&vf->cfg_lock);
-		ice_put_vf(vf);
-		return;
+		goto finish;
 	}
 
+	ops = vf->virtchnl_ops;
+
 	switch (v_opcode) {
 	case VIRTCHNL_OP_VERSION:
 		err = ops->get_ver_msg(vf, msg);
@@ -3773,6 +3768,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 			 vf_id, v_opcode, err);
 	}
 
+finish:
 	mutex_unlock(&vf->cfg_lock);
 	ice_put_vf(vf);
 }
-- 
2.35.1

