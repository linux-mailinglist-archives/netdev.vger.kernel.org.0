Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78B953ED80
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiFFSEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiFFSEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:04:04 -0400
Received: from EX-PRD-EDGE02.vmware.com (EX-PRD-EDGE02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470941C421D;
        Mon,  6 Jun 2022 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=SV77H0OmyZG86LnB/951XAXqvbh/6VYp/F55lWugqXA=;
    b=FMgT6dKPI4x/3Smv2rX6LEvEgwkRdu0Hs1tDYoSlE1aCUP/QG1aonsgVursYye
      kFR4UGPgMKo5hGH3Kn6c0ljploPViiRuKa5NuBK1GIlcFUOTsx20cEUlAMz1vD
      6uKpUon1e3kNAm34EIPyoY8OdQh+U2CMVuDL+BGMy4oWpMM=
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Mon, 6 Jun 2022 11:03:42 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 7436920198;
        Mon,  6 Jun 2022 11:03:48 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 6F707AA1E5; Mon,  6 Jun 2022 11:03:48 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 8/8] vmxnet3: update to version 7
Date:   Mon, 6 Jun 2022 11:03:14 -0700
Message-ID: <20220606180316.27793-9-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220606180316.27793-1-doshir@vmware.com>
References: <20220606180316.27793-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE02.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With all vmxnet3 version 7 changes incorporated in the vmxnet3 driver,
the driver can configure emulation to run at vmxnet3 version 7, provided
the emulation advertises support for version 7.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 7 ++++++-
 drivers/net/vmxnet3/vmxnet3_int.h | 4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index aa96441ea86c..e88c5459abd5 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3659,7 +3659,12 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		goto err_alloc_pci;
 
 	ver = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_VRRS);
-	if (ver & (1 << VMXNET3_REV_6)) {
+	if (ver & (1 << VMXNET3_REV_7)) {
+		VMXNET3_WRITE_BAR1_REG(adapter,
+				       VMXNET3_REG_VRRS,
+				       1 << VMXNET3_REV_7);
+		adapter->version = VMXNET3_REV_7 + 1;
+	} else if (ver & (1 << VMXNET3_REV_6)) {
 		VMXNET3_WRITE_BAR1_REG(adapter,
 				       VMXNET3_REG_VRRS,
 				       1 << VMXNET3_REV_6);
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index cb87731f5f1c..3367db23aa13 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -69,12 +69,12 @@
 /*
  * Version numbers
  */
-#define VMXNET3_DRIVER_VERSION_STRING   "1.6.0.0-k"
+#define VMXNET3_DRIVER_VERSION_STRING   "1.7.0.0-k"
 
 /* Each byte of this 32-bit integer encodes a version number in
  * VMXNET3_DRIVER_VERSION_STRING.
  */
-#define VMXNET3_DRIVER_VERSION_NUM      0x01060000
+#define VMXNET3_DRIVER_VERSION_NUM      0x01070000
 
 #if defined(CONFIG_PCI_MSI)
 	/* RSS only makes sense if MSI-X is supported. */
-- 
2.11.0

