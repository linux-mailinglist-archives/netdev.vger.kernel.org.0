Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934A568C8F3
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjBFVtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjBFVs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:59 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7074E2DE76
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720138; x=1707256138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kk1EU67atN7w8FMf2yrBZ5FZBXQaJk2DaX6J4f2mhxk=;
  b=PiiKB8aewiTnNBnL/loC48ko5DVbapRznpXedDeQ0Mb3YfRpLe/9BbDt
   zdL467JTziCeVFUVutySnj5iR698hev9fLy6wTft9uagDykizD3OQvGaL
   djDQtWTmAl5STWJT0nAkZS+ihGRzClqSFvNil7Sqr/bTbQz3JODQ5Q1+M
   54ip/1rWHg0XeUOk4QZ9IXMoVilnu3FcTUQVsKirbvMZHe2ZcXuB8Wtro
   caoQ9qsdTylOud/g9AmNEPYuXwAFUdrG0ilX//4nONFVII9TTswHoCknO
   I9xFTS6ThgOMUuKopYIJBBfwi+tD+xZ3YQ6En8/M3IWsj4thOoN0Nnyse
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338151"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338151"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576215"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576215"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:33 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 12/13] ice: introduce .irq_close VF operation
Date:   Mon,  6 Feb 2023 13:48:12 -0800
Message-Id: <20230206214813.20107-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The Scalable IOV implementation will require notifying the VDCM driver when
an IRQ must be closed. This allows the VDCM to handle releasing stale IRQ
context values and properly reconfigure.

To handle this, introduce a new optional .irq_close callback to the VF
operations structure. This will be implemented by Scalable IOV to handle
the shutdown of the IRQ context.

Since the SR-IOV implementation does not need this, we must check that its
non-NULL before calling it.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  | 1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 4 ++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h | 1 +
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 4d8930b83b35..356ac76ef90f 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -807,6 +807,7 @@ static const struct ice_vf_ops ice_sriov_vf_ops = {
 	.trigger_reset_register = ice_sriov_trigger_reset_register,
 	.poll_reset_status = ice_sriov_poll_reset_status,
 	.clear_reset_trigger = ice_sriov_clear_reset_trigger,
+	.irq_close = NULL,
 	.create_vsi = ice_sriov_create_vsi,
 	.post_vsi_rebuild = ice_sriov_post_vsi_rebuild,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 2ea801ebb2ac..d16c2ea83873 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -237,6 +237,10 @@ static void ice_vf_clear_counters(struct ice_vf *vf)
  */
 static void ice_vf_pre_vsi_rebuild(struct ice_vf *vf)
 {
+	/* Close any IRQ mapping now */
+	if (vf->vf_ops->irq_close)
+		vf->vf_ops->irq_close(vf);
+
 	ice_vf_clear_counters(vf);
 	vf->vf_ops->clear_reset_trigger(vf);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 5bb75edb6cef..b4e6480f30a7 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -61,6 +61,7 @@ struct ice_vf_ops {
 	void (*trigger_reset_register)(struct ice_vf *vf, bool is_vflr);
 	bool (*poll_reset_status)(struct ice_vf *vf);
 	void (*clear_reset_trigger)(struct ice_vf *vf);
+	void (*irq_close)(struct ice_vf *vf);
 	int (*create_vsi)(struct ice_vf *vf);
 	void (*post_vsi_rebuild)(struct ice_vf *vf);
 };
-- 
2.38.1

