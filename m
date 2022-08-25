Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722F55A08F3
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 08:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiHYGjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 02:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiHYGjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 02:39:11 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2066AA0278;
        Wed, 24 Aug 2022 23:39:10 -0700 (PDT)
Received: from HP-EliteBook-840-G7.. (1-171-197-52.dynamic-ip.hinet.net [1.171.197.52])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 0BC483F4C2;
        Thu, 25 Aug 2022 06:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661409545;
        bh=XfNld7B+q9+PTSF5LGqeEIE7E9ua29nFSz2ie2o+XHg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=HpKIYhqdqyTnRCikckXz7AuL5TcSZrPwFnT/KWVwuxwWglJS6vHePuS5pS6tbHs+Y
         PtAVKS61YzAR+MuQmUlyiYo0B85DKmi8DJZbDLicT6DCo1fY1vocA7V8iqJs4f0o01
         Tj6tlTI0oSYCKpr7VJhgu//wFaZTiiQyZeNZvobj6RnImiB9yZOOnalR2Lq8TShemw
         R0af82mVHCb0lZK08LVjPT5mqXj16+1pjEoFrY2EDLgQuQhTkbDdLainAPv5KYlhpR
         n0LRE6v07GpuM0Ah9MLhWV9A8ioYZgBBUOU5V0K9iZI2REeompWiIpqobQPOxgySjy
         tBJsXpJDqVqmA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     siva.kallam@broadcom.com, prashant@broadcom.com, mchan@broadcom.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tg3: Disable tg3 device on system reboot to avoid triggering AER
Date:   Thu, 25 Aug 2022 14:38:52 +0800
Message-Id: <20220825063852.1120632-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d60cd06331a3 ("PM: ACPI: reboot: Use S5 for reboot") caused a
reboot hang on one Dell servers so the commit was reverted.

Someone managed to collect the AER log and it's caused by MSI:
[ 148.762067] ACPI: Preparing to enter system sleep state S5
[ 148.794638] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 5
[ 148.803731] {1}[Hardware Error]: event severity: recoverable
[ 148.810191] {1}[Hardware Error]: Error 0, type: fatal
[ 148.816088] {1}[Hardware Error]: section_type: PCIe error
[ 148.822391] {1}[Hardware Error]: port_type: 0, PCIe end point
[ 148.829026] {1}[Hardware Error]: version: 3.0
[ 148.834266] {1}[Hardware Error]: command: 0x0006, status: 0x0010
[ 148.841140] {1}[Hardware Error]: device_id: 0000:04:00.0
[ 148.847309] {1}[Hardware Error]: slot: 0
[ 148.852077] {1}[Hardware Error]: secondary_bus: 0x00
[ 148.857876] {1}[Hardware Error]: vendor_id: 0x14e4, device_id: 0x165f
[ 148.865145] {1}[Hardware Error]: class_code: 020000
[ 148.870845] {1}[Hardware Error]: aer_uncor_status: 0x00100000, aer_uncor_mask: 0x00010000
[ 148.879842] {1}[Hardware Error]: aer_uncor_severity: 0x000ef030
[ 148.886575] {1}[Hardware Error]: TLP Header: 40000001 0000030f 90028090 00000000
[ 148.894823] tg3 0000:04:00.0: AER: aer_status: 0x00100000, aer_mask: 0x00010000
[ 148.902795] tg3 0000:04:00.0: AER: [20] UnsupReq (First)
[ 148.910234] tg3 0000:04:00.0: AER: aer_layer=Transaction Layer, aer_agent=Requester ID
[ 148.918806] tg3 0000:04:00.0: AER: aer_uncor_severity: 0x000ef030
[ 148.925558] tg3 0000:04:00.0: AER: TLP Header: 40000001 0000030f 90028090 00000000

The MSI is probably raised by incoming packets, so power down the device
and disable bus mastering to stop the traffic, as user confirmed this
approach works.

In addition to that, be extra safe and cancel reset task if it's running.

Cc: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/all/b8db79e6857c41dab4ef08bdf826ea7c47e3bafc.1615947283.git.josef@toxicpanda.com/
BugLink: https://bugs.launchpad.net/bugs/1917471
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index db1e9d810b416..4fe9e2539eac1 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18077,15 +18077,18 @@ static void tg3_shutdown(struct pci_dev *pdev)
 	struct tg3 *tp = netdev_priv(dev);
 
 	rtnl_lock();
+
+	tg3_reset_task_cancel(tp);
 	netif_device_detach(dev);
 
 	if (netif_running(dev))
 		dev_close(dev);
 
-	if (system_state == SYSTEM_POWER_OFF)
-		tg3_power_down(tp);
+	tg3_power_down(tp);
 
 	rtnl_unlock();
+
+	pci_disable_device(pdev);
 }
 
 /**
-- 
2.36.1

