Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE91B611378
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiJ1Nqv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Oct 2022 09:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiJ1Nqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:46:33 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767761BE424
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:45:32 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-KHC31jlENvC4OZ7p6aimog-1; Fri, 28 Oct 2022 09:45:30 -0400
X-MC-Unique: KHC31jlENvC4OZ7p6aimog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0FBE803D48;
        Fri, 28 Oct 2022 13:45:29 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.39.193.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95C74FD48;
        Fri, 28 Oct 2022 13:45:28 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        patryk.piotrowski@intel.com, sassmann@kpanic.de
Subject: [PATCH net-next] iavf: check that state transitions happen under lock
Date:   Fri, 28 Oct 2022 15:45:15 +0200
Message-Id: <20221028134515.253022-1-sassmann@kpanic.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kpanic.de
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a check to make sure crit_lock is being held during every state
transition and print a warning if that's not the case. For convenience
a wrapper is added that helps pointing out where the locking is missing.

Make an exception for iavf_probe() as that is too early in the init
process and generates a false positive report.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/iavf/iavf.h      | 23 +++++++++++++++------
 drivers/net/ethernet/intel/iavf/iavf_main.c |  2 +-
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 3f6187c16424..28f41bbc9c86 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -498,19 +498,30 @@ static inline const char *iavf_state_str(enum iavf_state_t state)
 	}
 }
 
-static inline void iavf_change_state(struct iavf_adapter *adapter,
-				     enum iavf_state_t state)
+static inline void __iavf_change_state(struct iavf_adapter *adapter,
+				       enum iavf_state_t state,
+				       const char *func,
+				       int line)
 {
 	if (adapter->state != state) {
 		adapter->last_state = adapter->state;
 		adapter->state = state;
 	}
-	dev_dbg(&adapter->pdev->dev,
-		"state transition from:%s to:%s\n",
-		iavf_state_str(adapter->last_state),
-		iavf_state_str(adapter->state));
+	if (mutex_is_locked(&adapter->crit_lock))
+		dev_dbg(&adapter->pdev->dev, "%s:%d state transition %s to %s\n",
+			func, line,
+			iavf_state_str(adapter->last_state),
+			iavf_state_str(adapter->state));
+	else
+		dev_warn(&adapter->pdev->dev, "%s:%d state transition %s to %s without locking!\n",
+			 func, line,
+			 iavf_state_str(adapter->last_state),
+			 iavf_state_str(adapter->state));
 }
 
+#define iavf_change_state(adapter, state) \
+	__iavf_change_state(adapter, state, __func__, __LINE__)
+
 int iavf_up(struct iavf_adapter *adapter);
 void iavf_down(struct iavf_adapter *adapter);
 int iavf_process_config(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3fc572341781..bbc0c9f347a7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4892,7 +4892,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw->back = adapter;
 
 	adapter->msg_enable = BIT(DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
-	iavf_change_state(adapter, __IAVF_STARTUP);
+	adapter->state = __IAVF_STARTUP;
 
 	/* Call save state here because it relies on the adapter struct. */
 	pci_save_state(pdev);
-- 
2.37.3

