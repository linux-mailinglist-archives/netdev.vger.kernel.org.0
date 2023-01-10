Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0302B663A5D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjAJICW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjAJIBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:01:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0891E1AA3E
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673337643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VbV+3mBuPRg5iwF3LHk2SJLW0Ekjn5LgQSo5mIGhQwE=;
        b=A3Xjduvnb5/waB2mqLvQmbmKBJwEWAd09CzDhdLFDpAmKH7bGMlTmdv30AksumNeE/dTt+
        gb0IpSI8i/qBNzvdqE35qclAjXsKqvyVVnfb3U8Jo5i1bICVcDCXZoZIbchy479BnjFT1j
        6OzMmdk4cn3U37IOQb59UWCuvhsXPKY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-pOTG5Lg-PH-Bf9xfhBrWlg-1; Tue, 10 Jan 2023 03:00:39 -0500
X-MC-Unique: pOTG5Lg-PH-Bf9xfhBrWlg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 763AE1C07581;
        Tue, 10 Jan 2023 08:00:39 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.39.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D068240C2064;
        Tue, 10 Jan 2023 08:00:37 +0000 (UTC)
From:   Stefan Assmann <sassmann@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        patryk.piotrowski@intel.com, sassmann@kpanic.de
Subject: [PATCH net-queue] iavf: schedule watchdog immediately when changing primary MAC
Date:   Tue, 10 Jan 2023 09:00:18 +0100
Message-Id: <20230110080018.2838769-1-sassmann@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

iavf_replace_primary_mac() utilizes queue_work() to schedule the
watchdog task but that only ensures that the watchdog task is queued
to run. To make sure the watchdog is executed asap use
mod_delayed_work().

Without this patch it may take up to 2s until the watchdog task gets
executed, which may cause long delays when setting the MAC address.

Fixes: a3e839d539e0 ("iavf: Add usage of new virtchnl format to set default MAC")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
Depends on net-queue patch
ca7facb6602f iavf: fix temporary deadlock and failure to set MAC address

 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index fff06f876c2c..1d3aa740caea 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1033,7 +1033,7 @@ int iavf_replace_primary_mac(struct iavf_adapter *adapter,
 
 	/* schedule the watchdog task to immediately process the request */
 	if (f) {
-		queue_work(adapter->wq, &adapter->watchdog_task.work);
+		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 		return 0;
 	}
 	return -ENOMEM;
-- 
2.38.1

