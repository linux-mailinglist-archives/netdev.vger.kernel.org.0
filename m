Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0832D5B49E7
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 23:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiIJVY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 17:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiIJVXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 17:23:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F893844F;
        Sat, 10 Sep 2022 14:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 825EFCE0AF3;
        Sat, 10 Sep 2022 21:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1462C43141;
        Sat, 10 Sep 2022 21:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844750;
        bh=iw5VxxdpmG4eV6+L/tprOv7+8QHc3taUs95F7OTGuWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQwlWva1bU0fNoHJJmDS4PZMsIffj5cPzm+HW3UxfzLglp+ez0ZTfXQLmq1eOwrB6
         wGFsIs0evMOuldQOF3PIaQrDx9nWJ7K8mrcNv8G4YISs3NzzaCtlGNToA5FWjdUHkq
         0kg2bFWHG5VJ/kMLy58gANItD0fcRG7inqv2bUy399KxK+T1xPGRL1x+pzLI1AWQ9S
         COg/L7ReN6V1fccBUJGkynIWf/4O2k0LdaUjj1QqHt7c5v9vkPOGusmcMgiu9aP9xu
         v7s1ek1YEcNQF84ZLVzOQWfe3TaF2aCsA0Bc2DhT6C6i49ET8Z4xbUg+L2g+hID/xv
         1SO1iV6F4kGDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, siva.kallam@broadcom.com,
        prashant@broadcom.com, mchan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/10] tg3: Disable tg3 device on system reboot to avoid triggering AER
Date:   Sat, 10 Sep 2022 17:18:55 -0400
Message-Id: <20220910211901.70760-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211901.70760-1-sashal@kernel.org>
References: <20220910211901.70760-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 2ca1c94ce0b65a2ce7512b718f3d8a0fe6224bca ]

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
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20220826002530.1153296-1-kai.heng.feng@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 70bd79dc43f2e..a9962474d551d 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18154,16 +18154,20 @@ static void tg3_shutdown(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct tg3 *tp = netdev_priv(dev);
 
+	tg3_reset_task_cancel(tp);
+
 	rtnl_lock();
+
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
2.35.1

