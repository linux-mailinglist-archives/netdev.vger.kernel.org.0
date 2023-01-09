Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0FB66346B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 23:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbjAIWxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 17:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237534AbjAIWx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 17:53:27 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61044140F5
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 14:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673304806; x=1704840806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fxQ7UJnSKWi8czKTK4IY9Sk758sMmkOveEAgX6MCR6s=;
  b=QMmXH8ZcK0imlOuG5KcrQ2wNrRiE+7W0DltH3gqT5V4adroG4R+SK/sm
   +s6tBuEgE6LeRPrChLwAbUn95LlHAAkjfuob2GPIQB9Rzn1Z0vYxoYgS5
   /ko696aqH5A7aEcBtm9ILPdm1xhAdxjqXBR998KWNUW34Rb/bdIYEuW4b
   pIJKNn2XJDN47Ev4t1w7TYfxrHMX9g3+xe4io2qt9j6Qqp2Yg55MxwRSP
   pOfA5dWjDj1m7Rxby2Bkggk+ff5YFi2pa5C/wJbH/NJNvUMHNuO6ruTxa
   sZpDexFGqFRBiX2aOSkB7VbntIqcJf3zx5hh3R8//PUH1BbEiMzHgAuKY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="387456086"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="387456086"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 14:53:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="689197513"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="689197513"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 09 Jan 2023 14:53:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Jiri Pirko <jiri@nvidia.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/2] ice: Add check for kzalloc
Date:   Mon,  9 Jan 2023 14:53:58 -0800
Message-Id: <20230109225358.3478060-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230109225358.3478060-1-anthony.l.nguyen@intel.com>
References: <20230109225358.3478060-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Add the check for the return value of kzalloc in order to avoid
NULL pointer dereference.
Moreover, use the goto-label to share the clean code.

Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index a1915551c69a..43e199b5b513 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -461,6 +461,9 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
 		pf->gnss_tty_port[i] = kzalloc(sizeof(*pf->gnss_tty_port[i]),
 					       GFP_KERNEL);
+		if (!pf->gnss_tty_port[i])
+			goto err_out;
+
 		pf->gnss_serial[i] = NULL;
 
 		tty_port_init(pf->gnss_tty_port[i]);
@@ -470,21 +473,23 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	err = tty_register_driver(tty_driver);
 	if (err) {
 		dev_err(dev, "Failed to register TTY driver err=%d\n", err);
-
-		for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
-			tty_port_destroy(pf->gnss_tty_port[i]);
-			kfree(pf->gnss_tty_port[i]);
-		}
-		kfree(ttydrv_name);
-		tty_driver_kref_put(pf->ice_gnss_tty_driver);
-
-		return NULL;
+		goto err_out;
 	}
 
 	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++)
 		dev_info(dev, "%s%d registered\n", ttydrv_name, i);
 
 	return tty_driver;
+
+err_out:
+	while (i--) {
+		tty_port_destroy(pf->gnss_tty_port[i]);
+		kfree(pf->gnss_tty_port[i]);
+	}
+	kfree(ttydrv_name);
+	tty_driver_kref_put(pf->ice_gnss_tty_driver);
+
+	return NULL;
 }
 
 /**
-- 
2.38.1

