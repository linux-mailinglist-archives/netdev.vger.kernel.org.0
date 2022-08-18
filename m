Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4042D59896E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344747AbiHRQ4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239140AbiHRQ4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:56:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9894CC9905
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660841763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=13sXuS2gPFrwN9Isv4Vp61eKZCdTNWrL5DbPcMYYstw=;
        b=Slzitf+BjKKEN0gg/p49midjw/ffg5aEB6kCE/0/E1Uhfuim+rRauvqHbGPdDXwU0hDvz/
        l3mSGP+NCluPK4HhCTdFZI+F6YkCkev4Q1Oq7YN9Ayc77hcWGb/W6rZh9G3c0Ng41R5UKu
        akzHmH9yVssfGzK3mfBJdXkEx3UGJE4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-QUaLWpzCM3q-B0eJ9hgnow-1; Thu, 18 Aug 2022 12:56:02 -0400
X-MC-Unique: QUaLWpzCM3q-B0eJ9hgnow-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B15FC800124;
        Thu, 18 Aug 2022 16:56:01 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.40.192.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89ED91415135;
        Thu, 18 Aug 2022 16:55:59 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>,
        Vitaly Grinberg <vgrinber@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] iavf: Detach device during reset task
Date:   Thu, 18 Aug 2022 18:55:58 +0200
Message-Id: <20220818165558.997984-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
Tested-by: Vitaly Grinberg <vgrinber@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 22 +++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f39440ad5c50..ee8f911b57ea 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2877,6 +2877,13 @@ static void iavf_reset_task(struct work_struct *work)
 	int i = 0, err;
 	bool running;
 
+	/*
+	 * Detach interface to avoid subsequent NDO callbacks
+	 */
+	rtnl_lock();
+	netif_device_detach(netdev);
+	rtnl_unlock();
+
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
@@ -2884,7 +2891,7 @@ static void iavf_reset_task(struct work_struct *work)
 		if (adapter->state != __IAVF_REMOVE)
 			queue_work(iavf_wq, &adapter->reset_task);
 
-		return;
+		goto reset_finish;
 	}
 
 	while (!mutex_trylock(&adapter->client_lock))
@@ -2954,7 +2961,6 @@ static void iavf_reset_task(struct work_struct *work)
 
 	if (running) {
 		netif_carrier_off(netdev);
-		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
 		iavf_napi_disable_all(adapter);
 	}
@@ -3081,10 +3087,8 @@ static void iavf_reset_task(struct work_struct *work)
 
 	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 
-	mutex_unlock(&adapter->client_lock);
-	mutex_unlock(&adapter->crit_lock);
+	goto reset_finish;
 
-	return;
 reset_err:
 	if (running) {
 		set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
@@ -3092,9 +3096,15 @@ static void iavf_reset_task(struct work_struct *work)
 	}
 	iavf_disable_vf(adapter);
 
+	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
+
+reset_finish:
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
-	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
+
+	rtnl_lock();
+	netif_device_attach(netdev);
+	rtnl_unlock();
 }
 
 /**
-- 
2.35.1

