Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F72D4C8E31
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbiCAOtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbiCAOtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:49:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D87712655E
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 06:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646146139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ET15GgI57duVbTvcVtFigSD+iRUjJs12PG+P2LL5kB0=;
        b=HK4wn6nVfF+EeR5PaPB904WkOEp2TKc+CLkBpz4men3pEej9KIRqGea03Zq2A1G4GakGNX
        UIzgFi4mBjdRxOgSR8DKd5x5OTPcE/8fexQ4Mz5a9+Q7ETg5k+NbPmTSdK8CgAzTcRLgWX
        l43VAn5M/+TnhTSE3YyqgsJMv5x4wQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-z7946cAUOFeUJBROxtD_Rw-1; Tue, 01 Mar 2022 09:48:53 -0500
X-MC-Unique: z7946cAUOFeUJBROxtD_Rw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EE821854E21;
        Tue,  1 Mar 2022 14:48:52 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F90D838BC;
        Tue,  1 Mar 2022 14:48:49 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     intel-wired-lan@lists.osuosl.org, lihong.yang@intel.com
Cc:     Jocelyn Falempe <jfalempe@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ice: use msleep instead of mdelay
Date:   Tue,  1 Mar 2022 09:48:45 -0500
Message-Id: <370e9909d8e00d4a1c8abcd405c321fc41646478.1646146125.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use msleep for long delays instead of spinning in the driver.

Suggested-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 0e4434e3c290..75860259c6d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1107,7 +1107,7 @@ int ice_check_reset(struct ice_hw *hw)
 			GLGEN_RSTCTL_GRSTDEL_S) + 10;
 
 	for (cnt = 0; cnt < grst_timeout; cnt++) {
-		mdelay(100);
+		msleep(100);
 		reg = rd32(hw, GLGEN_RSTAT);
 		if (!(reg & GLGEN_RSTAT_DEVSTATE_M))
 			break;
@@ -3235,7 +3235,7 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 			if (!status)
 				break;
 
-			mdelay(100);
+			msleep(100);
 		}
 
 		if (status)
-- 
2.27.0

