Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E154616F60
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiKBVK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiKBVKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:10:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0084E001
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667423419; x=1698959419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F+ehNosoNEdgk7LeRFefHzuU8TCd2k1L00rDUBYLtgQ=;
  b=UeBAwPeIcKIlmgD6HGpLIpyBA+ltJ6/e+jOhLdDn465kj2EBu+30JAVu
   BdZp8nPIbbWWF/ZwGLEeHVGg+rsQqn70e2/m/dQMnvON+Jhb9yLDYFTgw
   Huziti67K7EtkSSf1vRZDyU/dJL5s1ZYCyh5pt/kGUCJYzO6JX7S2illD
   UH67XlD3iwTnS9uu+e18JGvyYnw3JJJUwhujeqWD89UuR4Sy6lK4lRcrf
   x/SkyTO5BBrqAKOj/fDa7gEJ1HfrU1TeGr0/DHTAOuIntdwTpadSm/gKg
   49dKIG22CzYts+N/1rc31xjEPII/BFatSuSo2n58TM1gt1I7eiHgYpvuX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="311245984"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="311245984"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 14:10:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="629102987"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="629102987"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 02 Nov 2022 14:10:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/7] i40e: Store the irq number in i40e_q_vector
Date:   Wed,  2 Nov 2022 14:10:05 -0700
Message-Id: <20221102211011.2944983-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
References: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Damato <jdamato@fastly.com>

Make it easy to figure out the IRQ number for a particular i40e_q_vector by
storing the assigned IRQ in the structure itself.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 9a60d6b207f7..60e351665c70 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -992,6 +992,7 @@ struct i40e_q_vector {
 	struct rcu_head rcu;	/* to avoid race with update stats on free */
 	char name[I40E_INT_NAME_STR_LEN];
 	bool arm_wb_state;
+	int irq_num;		/* IRQ assigned to this q_vector */
 } ____cacheline_internodealigned_in_smp;
 
 /* lan device */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1a1fab94205d..4880b740fa6e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4123,6 +4123,7 @@ static int i40e_vsi_request_irq_msix(struct i40e_vsi *vsi, char *basename)
 		}
 
 		/* register for affinity change notifications */
+		q_vector->irq_num = irq_num;
 		q_vector->affinity_notify.notify = i40e_irq_affinity_notify;
 		q_vector->affinity_notify.release = i40e_irq_affinity_release;
 		irq_set_affinity_notifier(irq_num, &q_vector->affinity_notify);
-- 
2.35.1

