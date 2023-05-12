Return-Path: <netdev+bounces-2319-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CFF70128B
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 01:40:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D19A11C212DD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 23:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91210DF63;
	Fri, 12 May 2023 23:40:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DC0D50E
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 23:40:08 +0000 (UTC)
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 12 May 2023 16:40:06 PDT
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B891FC1;
	Fri, 12 May 2023 16:40:06 -0700 (PDT)
Received: by air.basealt.ru (Postfix, from userid 490)
	id E56FE2F20239; Fri, 12 May 2023 23:20:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
Received: from localhost.localdomain (unknown [176.59.56.94])
	by air.basealt.ru (Postfix) with ESMTPSA id 000B02F20227;
	Fri, 12 May 2023 23:20:12 +0000 (UTC)
From: kovalev@altlinux.org
To: kovalev@altlinux.org,
	nickel@altlinux.org,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	davem@davemloft.net,
	kuba@kernel.org,
	sasha.neftin@intel.com,
	jeffrey.t.kirsher@intel.com,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH] e1000e: Fix bind network card with ID = 0x0D4F
Date: Sat, 13 May 2023 02:19:44 +0300
Message-Id: <20230512231944.100501-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.6
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasiliy Kovalev <kovalev@altlinux.org>

This solution fixes packet loss during download, allowing you
to get into the range of network cards of 639e298f432fb0 commit.

Below is a summary of the hardware:
$ cat /sys/devices/cpu_core/caps/pmu_name
alderlake_hybrid
$ lspci -nn | grep 'Ethernet'
00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet
Connection (10) I219-V [8086:0d4f] (rev 01)

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217436
Fixes: 914ee9c436cbe9 ("e1000e: Add support for Comet Lake")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index db8e06157da29..8b13f19309c39 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7887,7 +7887,7 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ICP_I219_LM9), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ICP_I219_V9), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM10), board_pch_cnp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V10), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V10), board_pch_adp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM11), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V11), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM12), board_pch_spt },
-- 
2.33.5


