Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF624ED7F4
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbiCaKwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234746AbiCaKv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:51:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F4861BA69D
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648723811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=v8/zU1sMY3yS+tcb1Sho2mb+pIX+PEBuc2KI2UecOM0=;
        b=gB5lzsT8rtZ02+djng84ylf7g1/lPQ+Zf74pYcs52C96LSbQuy19VnsUF1J2IenGqrKXx2
        +wVmT1JLMZJ+6sswx8+3qdHQ2H/IzQgSg57rgdxFzO7q2mxYYFCY9DFgc1Knsxw5Tn7F5Y
        3q1uMbB9J/R0akRn4pL9BHgnIIO9MUQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-dC_MAcA4MsujrC9QVAF6yw-1; Thu, 31 Mar 2022 06:50:08 -0400
X-MC-Unique: dC_MAcA4MsujrC9QVAF6yw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D67003C01D9D;
        Thu, 31 Mar 2022 10:50:07 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0D92140262B;
        Thu, 31 Mar 2022 10:50:05 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brett Creeley <brett.creeley@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] ice: Fix incorrect locking in ice_vc_process_vf_msg()
Date:   Thu, 31 Mar 2022 12:50:04 +0200
Message-Id: <20220331105005.2580771-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
are running in ice_service_task() context.

Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and VF ndo ops")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 3f1a63815bac..9bf5bb008128 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3660,15 +3660,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
-	/* VF is being configured in another context that triggers a VFR, so no
-	 * need to process this message
-	 */
-	if (!mutex_trylock(&vf->cfg_lock)) {
-		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
-			 vf->vf_id);
-		ice_put_vf(vf);
-		return;
-	}
+	mutex_lock(&vf->cfg_lock);
 
 	switch (v_opcode) {
 	case VIRTCHNL_OP_VERSION:
-- 
2.34.1

