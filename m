Return-Path: <netdev+bounces-5759-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2DE712AA8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5269C28192C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990A3171A2;
	Fri, 26 May 2023 16:31:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E82C27210
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:31:54 +0000 (UTC)
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BD5D9;
	Fri, 26 May 2023 09:31:49 -0700 (PDT)
Received: from localhost.localdomain (unknown [222.129.46.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C31F13F31A;
	Fri, 26 May 2023 16:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1685118707;
	bh=57miZDXOCNaK6tD9EQyTdzb3H2EJUEdxtiowrYgkh8M=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=vYJkBs4CRMDmglsfLsozufsMSpdWWObOoz+hbVQbTxd+nmNcC53zfm/H+Nv+/vD94
	 5INDWT7zg89xW1W7MqodtQUmF7AKCQpwb9Sxt142yXYUEMX6RQCPE+AkdPVXlCiWxr
	 UFubze04ej+LBU6p00lVYmwfpjcY3hb5c6BuNO0uTBckh3f20rtrgeZSgT/j7Wudsw
	 tzORwQha7V+EQiCFhp9HgiHvsxfu65Vif0el8fZo0OJDLGrlHxlHwdC56sdVjODLE4
	 H8my+zxCJ8muF4qSNkJYxQyWd04WL+bJYeyd39Z68m7fMQNKhLoEfKovP2dsvoInTu
	 QVayoXkbAy5rw==
From: Aaron Ma <aaron.ma@canonical.com>
To: intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] igb: fix hang issue of AER error during resume
Date: Sat, 27 May 2023 00:30:01 +0800
Message-Id: <20230526163001.67626-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PCIe AER error_detected caused a race issue with igb_resume.
Protect error_detected when igb is in down state.

Error logs:
kernel: igb 0000:02:00.0: disabling already-disabled device
kernel: WARNING: CPU: 0 PID: 277 at drivers/pci/pci.c:2248 pci_disable_device+0xc4/0xf0
kernel: RIP: 0010:pci_disable_device+0xc4/0xf0
kernel: Call Trace:
kernel:  <TASK>
kernel:  igb_io_error_detected+0x3e/0x60
kernel:  report_error_detected+0xd6/0x1c0
kernel:  ? __pfx_report_normal_detected+0x10/0x10
kernel:  report_normal_detected+0x16/0x30
kernel:  pci_walk_bus+0x74/0xa0
kernel:  pcie_do_recovery+0xb9/0x340
kernel:  ? __pfx_aer_root_reset+0x10/0x10
kernel:  aer_process_err_devices+0x168/0x220
kernel:  aer_isr+0x1b5/0x1e0
kernel:  ? __pfx_irq_thread_fn+0x10/0x10
kernel:  irq_thread_fn+0x21/0x70
kernel:  irq_thread+0xf8/0x1c0
kernel:  ? __pfx_irq_thread_dtor+0x10/0x10
kernel:  ? __pfx_irq_thread+0x10/0x10
kernel:  kthread+0xef/0x120
kernel:  ? __pfx_kthread+0x10/0x10
kernel:  ret_from_fork+0x29/0x50
kernel:  </TASK>
kernel: ---[ end trace 0000000000000000 ]---

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217446
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 58872a4c2540..8333d4ac8169 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9581,14 +9581,21 @@ static pci_ers_result_t igb_io_error_detected(struct pci_dev *pdev,
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
+	if (test_bit(__IGB_DOWN, &adapter->state))
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	rtnl_lock();
 	netif_device_detach(netdev);
 
-	if (state == pci_channel_io_perm_failure)
+	if (state == pci_channel_io_perm_failure) {
+		rtnl_unlock();
 		return PCI_ERS_RESULT_DISCONNECT;
+	}
 
 	if (netif_running(netdev))
 		igb_down(adapter);
 	pci_disable_device(pdev);
+	rtnl_unlock();
 
 	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
-- 
2.34.1


