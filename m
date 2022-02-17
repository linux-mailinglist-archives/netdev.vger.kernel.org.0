Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5794BA55B
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242925AbiBQQGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:06:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242906AbiBQQFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:05:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 871E429C123
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 08:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645113936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=r5nrUKvcX+b7aId+txPEO+zGeNk/6rvUManBpz1jI/Q=;
        b=IEhO/utE1ko0coidl/bdyLhQzFVfrKeeYRjhuDW3F7qinndDxQzI86SPmt8T9cUWyJxX3/
        pmOkYeSjfQQqOt3S/EU7yDxMPyf3EsXLTODMHm0ba6Q3Ks9aBzU4vIsXztguTT0XW/HZjp
        +ggskBXCQdaaqS8YsZK9EdjTpLaOPX0=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-kv9GpChRP6aFt49pgc0Mqg-1; Thu, 17 Feb 2022 11:05:35 -0500
X-MC-Unique: kv9GpChRP6aFt49pgc0Mqg-1
Received: by mail-ot1-f70.google.com with SMTP id m8-20020a9d4c88000000b005acfd400231so26727otf.10
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 08:05:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r5nrUKvcX+b7aId+txPEO+zGeNk/6rvUManBpz1jI/Q=;
        b=zNE35AoEQ16Hk7PqeWBGxWn8YmEG+6L9qg38jR5k00ptAEXGWKPlKLmFWhn931mNhA
         uC2C6MzwgY/erxYGkBT/EZJKPMMA+UmtKzz3EEwUsoOgGufsieOJ1jBwWcxPuR7PrZHG
         sEK/1y1Qz+Tq4VGsd2PnFApMa7154AB+WA2SLjo14KgntiTqjdz9qhhE6iYrDD7bVmNd
         zu2WTxZRzbAkj5hg6n2CYBBGEgdSuZX3hA1B96cEvbQh9+LcM/ylhiRbHRviZrXfpNEZ
         0Dqsi1sZBvYZap1CTJhrpWn1ck8QG0uNDPSXOEa5mTiWI7XfrEqcIpgBrw9jvpdZIHR2
         3vzA==
X-Gm-Message-State: AOAM533COlNONInnEVF/yi7KFZeG5vyrqypjTX1XST5KZJdc+5tMtk4E
        cw52uQfzMxzXfbvD5Of3pzJC4Tq70Gp4kOGgr16jcTBXt1BYTJfpxqPUVMCo9v2N3tWFAtZrLyQ
        47R9em1nmCxmuU5y4
X-Received: by 2002:a05:6808:120d:b0:2ce:6a75:b816 with SMTP id a13-20020a056808120d00b002ce6a75b816mr1343421oil.221.1645113934185;
        Thu, 17 Feb 2022 08:05:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwy6TRBXvKt77O+bo/AS2p4Cq6idyWQ41pZWeBPmN57vJ2tL1XCT1prcOcicuDShC1iyvyuYA==
X-Received: by 2002:a05:6808:120d:b0:2ce:6a75:b816 with SMTP id a13-20020a056808120d00b002ce6a75b816mr1343392oil.221.1645113933887;
        Thu, 17 Feb 2022 08:05:33 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id p13sm35247otp.47.2022.02.17.08.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 08:05:33 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, rdunlap@infradead.org,
        esben@geanix.com, arnd@arndb.de, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moyufeng@huawei.com, michael@walle.cc,
        yuehaibing@huawei.com, prabhakar.mahadev-lad.rj@bp.renesas.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] net: ethernet: xilinx: cleanup comments
Date:   Thu, 17 Feb 2022 08:05:18 -0800
Message-Id: <20220217160518.3255003-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Remove the second 'the'.
Replacements:
endiannes to endianness
areconnected to are connected
Mamagement to Management
undoccumented to undocumented
Xilink to Xilinx
strucutre to structure

Change kernel-doc comment style to c style for
/* Management ...

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
---
v2: Change the /** to /* 
    Add Michal's Reviewed-by: tag

 drivers/net/ethernet/xilinx/Kconfig               | 2 +-
 drivers/net/ethernet/xilinx/ll_temac.h            | 4 ++--
 drivers/net/ethernet/xilinx/ll_temac_main.c       | 2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c     | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 911b5ef9e680..0014729b8865 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# Xilink device configuration
+# Xilinx device configuration
 #
 
 config NET_VENDOR_XILINX
diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 4a73127e10a6..c6395c406418 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -271,7 +271,7 @@ This option defaults to enabled (set) */
 
 #define XTE_TIE_OFFSET			0x000003A4 /* Interrupt enable */
 
-/**  MII Mamagement Control register (MGTCR) */
+/* MII Management Control register (MGTCR) */
 #define XTE_MGTDR_OFFSET		0x000003B0 /* MII data */
 #define XTE_MIIMAI_OFFSET		0x000003B4 /* MII control */
 
@@ -283,7 +283,7 @@ This option defaults to enabled (set) */
 
 #define STS_CTRL_APP0_ERR         (1 << 31)
 #define STS_CTRL_APP0_IRQONEND    (1 << 30)
-/* undoccumented */
+/* undocumented */
 #define STS_CTRL_APP0_STOPONEND   (1 << 29)
 #define STS_CTRL_APP0_CMPLT       (1 << 28)
 #define STS_CTRL_APP0_SOP         (1 << 27)
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index b900ab5aef2a..7171b5cdec26 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1008,7 +1008,7 @@ static void ll_temac_recv(struct net_device *ndev)
 		    (skb->len > 64)) {
 
 			/* Convert from device endianness (be32) to cpu
-			 * endiannes, and if necessary swap the bytes
+			 * endianness, and if necessary swap the bytes
 			 * (back) for proper IP checksum byte order
 			 * (be16).
 			 */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index de0a6372ae0e..6eeaab77fbe0 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -537,7 +537,7 @@ static int __axienet_device_reset(struct axienet_local *lp)
  * This function is called to reset and initialize the Axi Ethernet core. This
  * is typically called during initialization. It does a reset of the Axi DMA
  * Rx/Tx channels and initializes the Axi DMA BDs. Since Axi DMA reset lines
- * areconnected to Axi Ethernet reset lines, this in turn resets the Axi
+ * are connected to Axi Ethernet reset lines, this in turn resets the Axi
  * Ethernet core. No separate hardware reset is done for the Axi Ethernet
  * core.
  * Returns 0 on success or a negative error number otherwise.
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 519599480b15..f65a638b7239 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -498,7 +498,7 @@ static void xemaclite_update_address(struct net_local *drvdata,
  * @dev:	Pointer to the network device instance
  * @address:	Void pointer to the sockaddr structure
  *
- * This function copies the HW address from the sockaddr strucutre to the
+ * This function copies the HW address from the sockaddr structure to the
  * net_device structure and updates the address in HW.
  *
  * Return:	Error if the net device is busy or 0 if the addr is set
-- 
2.26.3

