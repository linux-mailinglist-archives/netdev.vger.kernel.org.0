Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A4C5AF6A9
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiIFVNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiIFVNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:13:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B60B81FF
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662498789; x=1694034789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yF6N9MgKVSzzoiiOjle0IgG9t3Nvh57RkPFXzoZsD2g=;
  b=eeDg3NAGtsAzOWz6FBYbOxAemCUo8+MH8J/Sarr0OW47Cgu+ycEAHlBm
   b8fZK07QJe2Yegjj0mOEFi++pdzrqb8BzxXMkrqNkftLbc7lqo9ULXNex
   0K5ePZfunoBsX6XktbsdtS3sZA8bMIj+Sy+YX59dkuMoEDz0EedmO/z8c
   e/ofEmuJNpC43bv1uMq+PacM3SisovtuwLaNxbZIdIoewxN3ycAXLT0R1
   9yhxMxdxUSZI9TqRKBsByK/uUuiyld4TfBZ+BBvJ+pWHQSznUuoO84iiT
   lnxxVnz/PyMrK47ZXl37Tm2YdbRXh67R+Gw+FNfwy88Z4axBSEQ2cTKyL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="295441854"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="295441854"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:13:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="591421371"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Sep 2022 14:13:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 5/5] ice: Simplify memory allocation in ice_sched_init_port()
Date:   Tue,  6 Sep 2022 14:13:02 -0700
Message-Id: <20220906211302.3501186-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
References: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'buf' is locale to the ice_sched_init_port() function.
There is no point in using devm_kzalloc()/devm_kfree().

use kzalloc()/kfree() instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
As a side effect, it also require less memory. devm_kzalloc() has a small
memory overhead, and requesting ICE_AQ_MAX_BUF_LEN (i.e. 4096) bytes,
8192 are really allocated.
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 7947223536e3..118595763bba 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1212,7 +1212,7 @@ int ice_sched_init_port(struct ice_port_info *pi)
 	hw = pi->hw;
 
 	/* Query the Default Topology from FW */
-	buf = devm_kzalloc(ice_hw_to_dev(hw), ICE_AQ_MAX_BUF_LEN, GFP_KERNEL);
+	buf = kzalloc(ICE_AQ_MAX_BUF_LEN, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -1290,7 +1290,7 @@ int ice_sched_init_port(struct ice_port_info *pi)
 		pi->root = NULL;
 	}
 
-	devm_kfree(ice_hw_to_dev(hw), buf);
+	kfree(buf);
 	return status;
 }
 
-- 
2.35.1

