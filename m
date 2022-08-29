Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C035A51C7
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiH2QbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiH2Qa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:30:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCD383F3A
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 09:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661790641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/zPHAN3qGo7NVF2OTVY04vNzvTw3myDXxymM/1eiXU4=;
        b=JyLzfO2Br/xlNrUNHbE2I3nsVutOWFyLG1jOwjBYms4j8sCPxZ6bKcLJ6L0+/0W07DCmbR
        VWLv4rGMGDhqw1w5AUe/6bpMW4bhgbMkhKCQuN+Ql0SdEEM2luQwGV3BMc2M/a0Ihj3xF5
        9FQklVWtsfoMKK/WEMz9PU8lZ8dnmsk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-x1L8TZyeOQWjNmjTjj8uVg-1; Mon, 29 Aug 2022 12:30:38 -0400
X-MC-Unique: x1L8TZyeOQWjNmjTjj8uVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 084FE85A58B;
        Mon, 29 Aug 2022 16:30:38 +0000 (UTC)
Received: from p1.luc.com (unknown [10.40.195.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD1E6C15BB3;
        Mon, 29 Aug 2022 16:30:36 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        Vitaly Grinberg <vgrinber@redhat.com>
Subject: [PATCH net v2] iavf: Detach device during reset task
Date:   Mon, 29 Aug 2022 18:30:35 +0200
Message-Id: <20220829163035.510624-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iavf_reset_task() takes crit_lock at the beginning and holds
it during whole call. The function subsequently calls
iavf_init_interrupt_scheme() that grabs RTNL. Problem occurs
when userspace initiates during the reset task any ndo callback
that runs under RTNL like iavf_open() because some of that
functions tries to take crit_lock. This leads to classic A-B B-A
deadlock scenario.

To resolve this situation the device should be detached in
iavf_reset_task() prior taking crit_lock to avoid subsequent
ndos running under RTNL and reattach the device at the end.

Fixes: 62fe2a865e6d ("i40evf: add missing rtnl_lock() around i40evf_set_interrupt_capability")
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
Cc: SlawomirX Laba <slawomirx.laba@intel.com>
Tested-by: Vitaly Grinberg <vgrinber@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f39440ad5c50..10aa99dfdcdb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2877,6 +2877,11 @@ static void iavf_reset_task(struct work_struct *work)
 	int i = 0, err;
 	bool running;
 
+	/* Detach interface to avoid subsequent NDO callbacks */
+	rtnl_lock();
+	netif_device_detach(netdev);
+	rtnl_unlock();
+
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
@@ -2884,7 +2889,7 @@ static void iavf_reset_task(struct work_struct *work)
 		if (adapter->state != __IAVF_REMOVE)
 			queue_work(iavf_wq, &adapter->reset_task);
 
-		return;
+		goto reset_finish;
 	}
 
 	while (!mutex_trylock(&adapter->client_lock))
@@ -2954,7 +2959,6 @@ static void iavf_reset_task(struct work_struct *work)
 
 	if (running) {
 		netif_carrier_off(netdev);
-		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
 		iavf_napi_disable_all(adapter);
 	}
@@ -3084,7 +3088,7 @@ static void iavf_reset_task(struct work_struct *work)
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 
-	return;
+	goto reset_finish;
 reset_err:
 	if (running) {
 		set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
@@ -3095,6 +3099,10 @@ static void iavf_reset_task(struct work_struct *work)
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
+reset_finish:
+	rtnl_lock();
+	netif_device_attach(netdev);
+	rtnl_unlock();
 }
 
 /**
-- 
2.35.1

