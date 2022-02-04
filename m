Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7488A4A9D3C
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376703AbiBDQ7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:59:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41487 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233140AbiBDQ67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 11:58:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643993938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cnjW8yKbEyG0FqNYK6ZIIplhyg3mHtVTjDUJ3agdcfQ=;
        b=bAjYbmHs3Ur+Er6Eos+pYOuzb5QYumarMV3v6RvHFCICWKga2OLTsJk5pWLnO7xXmbmtfD
        OaexkqXvYZfCFcnx1cVMS7OMB+OxqzgRYu0aKY1cgZujnx2MAGFf/Lur3cnOkxOhtJo7KQ
        gWQa/JAcG2Uhg8imcsRD3SvBDeRNVlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-yB7x48wRPSGm60yek7yULw-1; Fri, 04 Feb 2022 11:58:53 -0500
X-MC-Unique: yB7x48wRPSGm60yek7yULw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2842F51081;
        Fri,  4 Feb 2022 16:58:52 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.16.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4FB2753FC;
        Fri,  4 Feb 2022 16:58:50 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     intel-wired-lan@lists.osuosl.org, lihong.yang@intel.com
Cc:     Jocelyn Falempe <jfalempe@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] ice: use msleep instead of mdelay
Date:   Fri,  4 Feb 2022 11:58:46 -0500
Message-Id: <c095aac80cac3fc103f13170a976def3aa4d0f78.1643993926.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
index 408d15a5b0e3..50987d513faf 100644
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
@@ -3196,7 +3196,7 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 			if (!status)
 				break;
 
-			mdelay(100);
+			msleep(100);
 		}
 
 		if (status)
-- 
2.27.0

