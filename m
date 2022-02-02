Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30514A799A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 21:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244154AbiBBUi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 15:38:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229750AbiBBUi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 15:38:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643834337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=S9TZGGpkY8ClrJIAqOZuOM+ORZH1aSNITt2XNgVBP98=;
        b=ggYTTkpSvNOYwSkfVl14sJ40AWpy9cpKxsL0OmRnTKr+w826Pa7N2Fb/fYiDHAyltMtz5N
        aZkATeXGMLaF7L3awRhptt1pXC6k+MQJtTFTjV1tSDZH33mnCVCoMosW9fxgOePYmTy7ec
        hU+3MnZTLXss95UZlHabFptkBFsKYjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-RBE7rWeDNaKCSpXrFXqccQ-1; Wed, 02 Feb 2022 15:38:56 -0500
X-MC-Unique: RBE7rWeDNaKCSpXrFXqccQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9733835B66;
        Wed,  2 Feb 2022 20:38:54 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.19.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C693D56F66;
        Wed,  2 Feb 2022 20:38:53 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, lihong.yang@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] ice: change "can't set link" message to dbg level
Date:   Wed,  2 Feb 2022 15:38:49 -0500
Message-Id: <b25f9e524c404820b310c73012507c8e65a2ef97.1643834329.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case where the link is owned by manageability, the firmware is
not allowed to set the link state, so an error code is returned.
This however is non-fatal and there is nothing the operator can do,
so instead of confusing the operator with messages they can do nothing
about hide this message behind the debug log level.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 0c187cf04fcf..2c6dad56a48d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4117,7 +4117,7 @@ int ice_set_link(struct ice_vsi *vsi, bool ena)
 	 */
 	if (status == -EIO) {
 		if (hw->adminq.sq_last_status == ICE_AQ_RC_EMODE)
-			dev_warn(dev, "can't set link to %s, err %d aq_err %s. not fatal, continuing\n",
+			dev_dbg(dev, "can't set link to %s, err %d aq_err %s. not fatal, continuing\n",
 				 (ena ? "ON" : "OFF"), status,
 				 ice_aq_str(hw->adminq.sq_last_status));
 	} else if (status) {
-- 
2.27.0

