Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A424A8A86
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353031AbiBCRp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:45:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234361AbiBCRp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:45:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643910327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y0HNmgxmLxNYUa/mu5DTm3vHFzk7CSUGWJbL+LbLOPA=;
        b=dblI8eQwlUwE+CxCgKbQCTd7a/z9Jj7eSNGLpnkZlaan1aMtE5lytj6ZIa1BVaGseAs6Da
        Aza8ZSf0XoXtZ2KpbXAE58EhHLQ3i1heYaC/siXZkkyBsPrwibRx0PFm0Jq/KTa2wJL53t
        zyst6aln3qWfmwHHJ1Q0uxg/Td1IVrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-R4gKHM00NCun__whOSiC9A-1; Thu, 03 Feb 2022 12:45:23 -0500
X-MC-Unique: R4gKHM00NCun__whOSiC9A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F1671091DA1;
        Thu,  3 Feb 2022 17:45:21 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.33.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31E5F4CEC7;
        Thu,  3 Feb 2022 17:45:20 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, lihong.yang@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ice: change "can't set link" message to dbg level
Date:   Thu,  3 Feb 2022 12:45:16 -0500
Message-Id: <cfb30f5c84364c8eff96c0a3ea0231e5dfda17e4.1643910316.git.jtoppins@redhat.com>
In-Reply-To: <b25f9e524c404820b310c73012507c8e65a2ef97.1643834329.git.jtoppins@redhat.com>
References: <b25f9e524c404820b310c73012507c8e65a2ef97.1643834329.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 drivers/net/ethernet/intel/ice/ice_lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 0c187cf04fcf..81b152133d11 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4117,9 +4117,9 @@ int ice_set_link(struct ice_vsi *vsi, bool ena)
 	 */
 	if (status == -EIO) {
 		if (hw->adminq.sq_last_status == ICE_AQ_RC_EMODE)
-			dev_warn(dev, "can't set link to %s, err %d aq_err %s. not fatal, continuing\n",
-				 (ena ? "ON" : "OFF"), status,
-				 ice_aq_str(hw->adminq.sq_last_status));
+			dev_dbg(dev, "can't set link to %s, err %d aq_err %s. not fatal, continuing\n",
+				(ena ? "ON" : "OFF"), status,
+				ice_aq_str(hw->adminq.sq_last_status));
 	} else if (status) {
 		dev_err(dev, "can't set link to %s, err %d aq_err %s\n",
 			(ena ? "ON" : "OFF"), status,
-- 
2.27.0

