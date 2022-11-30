Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4781863D054
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 09:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbiK3IWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 03:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiK3IWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 03:22:11 -0500
Received: from EX-PRD-EDGE02.vmware.com (ex-prd-edge02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248945915A;
        Wed, 30 Nov 2022 00:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=l2wRLhIEBDsfPv3cERhwpGHkEzokdwLhIG0YQM1eeac=;
    b=ectokALGnvwmm4SaVqKWMoDjlcFe8lwyxAqSMaSnIlFeFWweqvxPSmN8a0vkm/
      CmFvjorNoz4B//mcjgJC1jHH42oeX1dnNbnZGRBNTKxNOKUYnN4Ch8y9Or27SN
      t6uIuOCKm9g3uMMCRlb+Tlmfpr9NiFWIKcIXefiMb1fQ/iE=
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Wed, 30 Nov 2022 00:21:48 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 8E1CC20301;
        Wed, 30 Nov 2022 00:22:02 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 88447AE1D1; Wed, 30 Nov 2022 00:22:02 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net  2/2] vmxnet3: use correct intrConf reference when using extended queues
Date:   Wed, 30 Nov 2022 00:21:47 -0800
Message-ID: <20221130082148.9605-3-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20221130082148.9605-1-doshir@vmware.com>
References: <20221130082148.9605-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE02.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")
added support for 32Tx/Rx queues. As a part of this patch, intrConf
structure was extended to incorporate increased queues.

This patch fixes the issue where incorrect reference is being used.

Fixes: 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3111a8a6b26a..6f1e560fb15c 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -75,8 +75,14 @@ vmxnet3_enable_all_intrs(struct vmxnet3_adapter *adapter)
 
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_enable_intr(adapter, i);
-	adapter->shared->devRead.intrConf.intrCtrl &=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl &=
 					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl &=
+					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	}
 }
 
 
@@ -85,8 +91,14 @@ vmxnet3_disable_all_intrs(struct vmxnet3_adapter *adapter)
 {
 	int i;
 
-	adapter->shared->devRead.intrConf.intrCtrl |=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl |=
 					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl |=
+					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	}
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_disable_intr(adapter, i);
 }
-- 
2.11.0

