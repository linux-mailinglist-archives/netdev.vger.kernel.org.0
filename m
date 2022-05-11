Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D62522A58
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbiEKDU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239603AbiEKDTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:50 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F5E6CAA5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:48 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239170txbl9iwg
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:30 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: ACkb0FcbxRn3MEZSE2edghExxc0XOL9KoFQx2xICBbT8swO+soeZGKJIJ/Ys5
        ufMHlOjR+szhHTynjf0Q4tnSbkb2uQc4ZLk+HGvX4QJW2Q0O49QARv34PI9twJXrreJV7cc
        HtT7mbQavzjbXtroQuhv8KM+1IiNx4sy5qZhXLU1txZDVKefU/bg0M0erPqZl8K1Mn3q37O
        pCd0zNZK9dPi2xFv+eyrupKiQPgP7U5L+JUhy84XezuwgCpJSQl3ijoD+IxEbsoea6myMwm
        zL4WNQ9DiAsHezi3+UleRvou/rXw/EGaRZYDeXdOtCZDnFdv9j6ONNJcNXUwyaiEkOW9Myv
        9WHAAIKs6NQKYqfcNbWrLAm6xHYtNW50GQJoVIr
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 12/14] net: txgbe: Support power management
Date:   Wed, 11 May 2022 11:26:57 +0800
Message-Id: <20220511032659.641834-13-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign9
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for device power management.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index ab222bf9e828..474786bdec3d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -4086,12 +4086,62 @@ int txgbe_close(struct net_device *netdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int txgbe_resume(struct pci_dev *pdev)
+{
+	struct txgbe_adapter *adapter;
+	struct net_device *netdev;
+	u32 err;
+
+	adapter = pci_get_drvdata(pdev);
+	netdev = adapter->netdev;
+	adapter->hw.hw_addr = adapter->io_addr;
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	/* pci_restore_state clears dev->state_saved so call
+	 * pci_save_state to restore it.
+	 */
+	pci_save_state(pdev);
+
+	err = pci_enable_device_mem(pdev);
+	if (err) {
+		txgbe_dev_err("Cannot enable PCI device from suspend\n");
+		return err;
+	}
+	smp_mb__before_atomic();
+	clear_bit(__TXGBE_DISABLED, &adapter->state);
+	pci_set_master(pdev);
+
+	pci_wake_from_d3(pdev, false);
+
+	txgbe_reset(adapter);
+
+	rtnl_lock();
+
+	err = txgbe_init_interrupt_scheme(adapter);
+	if (!err && netif_running(netdev))
+		err = txgbe_open(netdev);
+
+	rtnl_unlock();
+
+	if (err)
+		return err;
+
+	netif_device_attach(netdev);
+
+	return 0;
+}
+#endif /* CONFIG_PM */
+
 static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
 	struct txgbe_hw *hw = &adapter->hw;
 	u32 wufc = adapter->wol;
+#ifdef CONFIG_PM
+	int retval = 0;
+#endif
 
 	netif_device_detach(netdev);
 
@@ -4102,6 +4152,12 @@ static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	txgbe_clear_interrupt_scheme(adapter);
 
+#ifdef CONFIG_PM
+	retval = pci_save_state(pdev);
+	if (retval)
+		return retval;
+#endif
+
 	if (wufc) {
 		txgbe_set_rx_mode(netdev);
 		txgbe_configure_rx(adapter);
@@ -4131,6 +4187,28 @@ static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int txgbe_suspend(struct pci_dev *pdev,
+			 pm_message_t __always_unused state)
+{
+	int retval;
+	bool wake;
+
+	retval = __txgbe_shutdown(pdev, &wake);
+	if (retval)
+		return retval;
+
+	if (wake) {
+		pci_prepare_to_sleep(pdev);
+	} else {
+		pci_wake_from_d3(pdev, false);
+		pci_set_power_state(pdev, PCI_D3hot);
+	}
+
+	return 0;
+}
+#endif /* CONFIG_PM */
+
 static void txgbe_shutdown(struct pci_dev *pdev)
 {
 	bool wake;
@@ -6599,6 +6677,10 @@ static struct pci_driver txgbe_driver = {
 	.id_table = txgbe_pci_tbl,
 	.probe    = txgbe_probe,
 	.remove   = txgbe_remove,
+#ifdef CONFIG_PM
+	.suspend  = txgbe_suspend,
+	.resume   = txgbe_resume,
+#endif
 	.shutdown = txgbe_shutdown,
 };
 
-- 
2.27.0



