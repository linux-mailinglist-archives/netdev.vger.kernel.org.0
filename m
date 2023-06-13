Return-Path: <netdev+bounces-10393-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D318772E457
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B72601C20C6C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFF034CC0;
	Tue, 13 Jun 2023 13:39:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBF3522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:39:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6634AA0
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 06:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686663553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vjgXY1AGes3lRgQbH46LvYdzMgAj2Nwd6OpSrspQvOw=;
	b=Jl5DRdFjutFBhHZWZWgwBACCpmOhm78Ijblyd4EgKiiOVBNsroRSp/9R6rxMQ1eI+5nklz
	64bmwt3MCwCB8/12EH3vdpe+FLvzqdam6/CeCcu2ctUEWJxDgraaQAVduahdiTjyKqEr/S
	fqSYZhIYoJa75PTmR2vCVq+xD9QupdA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-qHnkEUPiMRunGMd3APaJNQ-1; Tue, 13 Jun 2023 09:39:04 -0400
X-MC-Unique: qHnkEUPiMRunGMd3APaJNQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73175811E8D;
	Tue, 13 Jun 2023 13:39:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.173])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A6B4F492C1B;
	Tue, 13 Jun 2023 13:39:02 +0000 (UTC)
From: =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To: ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-net-drivers@amd.com,
	=?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
	Yanghang Liu <yanghliu@redhat.com>
Subject: [PATCH net] sfc: fix XDP queues mode with legacy IRQ
Date: Tue, 13 Jun 2023 15:38:54 +0200
Message-Id: <20230613133854.37832-1-ihuguet@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In systems without MSI-X capabilities, xdp_txq_queues_mode is calculated
in efx_allocate_msix_channels, but when enabling MSI-X fails, it was not
changed to a proper default value. This was leading to the driver
thinking that it has dedicated XDP queues, when it didn't.

Fix it by setting xdp_txq_queues_mode to the correct value if the driver
fallbacks to MSI or legacy IRQ mode. The correct value is
EFX_XDP_TX_QUEUES_BORROWED because there are not XDP dedicated queues.

The issue can be easily visible if the kernel is started with pci=nomsi,
then a call trace is shown. It is not shown only with sfc's modparam
interrupt_mode=2. Call trace example:
 WARNING: CPU: 2 PID: 663 at drivers/net/ethernet/sfc/efx_channels.c:828 efx_set_xdp_channels+0x124/0x260 [sfc]
 [...skip...]
 Call Trace:
  <TASK>
  efx_set_channels+0x5c/0xc0 [sfc]
  efx_probe_nic+0x9b/0x15a [sfc]
  efx_probe_all+0x10/0x1a2 [sfc]
  efx_pci_probe_main+0x12/0x156 [sfc]
  efx_pci_probe_post_io+0x18/0x103 [sfc]
  efx_pci_probe.cold+0x154/0x257 [sfc]
  local_pci_probe+0x42/0x80

Fixes: 6215b608a8c4 ("sfc: last resort fallback for lack of xdp tx queues")
Reported-by: Yanghang Liu <yanghliu@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c       | 2 ++
 drivers/net/ethernet/sfc/siena/efx_channels.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index fcea3ea809d7..41b33a75333c 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -301,6 +301,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->tx_channel_offset = 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
 		rc = pci_enable_msi(efx->pci_dev);
 		if (rc == 0) {
 			efx_get_channel(efx, 0)->irq = efx->pci_dev->irq;
@@ -322,6 +323,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->tx_channel_offset = efx_separate_tx_channels ? 1 : 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
 		efx->legacy_irq = efx->pci_dev->irq;
 	}
 
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 06ed74994e36..1776f7f8a7a9 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -302,6 +302,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
 		efx->tx_channel_offset = 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
 		rc = pci_enable_msi(efx->pci_dev);
 		if (rc == 0) {
 			efx_get_channel(efx, 0)->irq = efx->pci_dev->irq;
@@ -323,6 +324,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
 		efx->tx_channel_offset = efx_siena_separate_tx_channels ? 1 : 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
+		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
 		efx->legacy_irq = efx->pci_dev->irq;
 	}
 
-- 
2.40.1


