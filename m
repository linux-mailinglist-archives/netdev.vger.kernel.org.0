Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C7B653CA3
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 08:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbiLVHml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 02:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiLVHmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 02:42:39 -0500
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D061A394;
        Wed, 21 Dec 2022 23:42:34 -0800 (PST)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id 6A8A55FF19;
        Thu, 22 Dec 2022 10:42:30 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:7202::1:0])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Qghs000QW4Y1-EePMyAkm;
        Thu, 22 Dec 2022 10:42:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1671694949; bh=Nh3QNQcJTJIK+UvLH0pvvJJvrDHgmqpRNGYuaw8yRFk=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=Stl8KRPvG9O1nfxTBE8+9fUvWngCVamt99XZQECWDA2j3nnHYdQKKaHXN4e7AabYN
         YMN6NB4Qq8pNTvB4aIRnr6kxwgI+tLNWwKsM8rn6nI4PzzDUkFkMlMoyE3h3YC6Vlt
         3K//owqxRua6yVtBxL2R/9tGZG/0ChJbCCgfSDq8=
Authentication-Results: vla1-81430ab5870b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     Shahed Shaikh <shshaikh@marvell.com>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure
Date:   Thu, 22 Dec 2022 10:42:23 +0300
Message-Id: <20221222074223.1746072-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

adapter->dcb would get silently freed inside qlcnic_dcb_enable() in
case qlcnic_dcb_attach() would return an error, which always happens
under OOM conditions. This would lead to use-after-free because both
of the existing callers invoke qlcnic_dcb_get_info() on the obtained
pointer, which is potentially freed at that point.

Propagate errors from qlcnic_dcb_enable(), and instead free the dcb
pointer at callsite using qlcnic_dcb_free(). This also removes the now
unused qlcnic_clear_dcb_ops() helper, which was a simple wrapper around
kfree() also causing memory leaks for partially initialized dcb.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 3c44bba1d270 ("qlcnic: Disable DCB operations from SR-IOV VFs")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
Changes since v1:
- Add a fixes tag + net as a target
- Remove qlcnic_clear_dcb_ops entirely & use qlcnic_dcb_free instead
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |  9 ++++++++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h       | 10 ++--------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      |  9 ++++++++-
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index dbb800769cb6..774f2c6875ec 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -2505,7 +2505,14 @@ int qlcnic_83xx_init(struct qlcnic_adapter *adapter)
 		goto disable_mbx_intr;
 
 	qlcnic_83xx_clear_function_resources(adapter);
-	qlcnic_dcb_enable(adapter->dcb);
+
+	err = qlcnic_dcb_enable(adapter->dcb);
+	if (err) {
+		qlcnic_dcb_free(adapter->dcb);
+		adapter->dcb = NULL;
+		goto disable_mbx_intr;
+	}
+
 	qlcnic_83xx_initialize_nic(adapter, 1);
 	qlcnic_dcb_get_info(adapter->dcb);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
index 7519773eaca6..22afa2be85fd 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
@@ -41,11 +41,6 @@ struct qlcnic_dcb {
 	unsigned long			state;
 };
 
-static inline void qlcnic_clear_dcb_ops(struct qlcnic_dcb *dcb)
-{
-	kfree(dcb);
-}
-
 static inline int qlcnic_dcb_get_hw_capability(struct qlcnic_dcb *dcb)
 {
 	if (dcb && dcb->ops->get_hw_capability)
@@ -112,9 +107,8 @@ static inline void qlcnic_dcb_init_dcbnl_ops(struct qlcnic_dcb *dcb)
 		dcb->ops->init_dcbnl_ops(dcb);
 }
 
-static inline void qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
+static inline int qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
 {
-	if (dcb && qlcnic_dcb_attach(dcb))
-		qlcnic_clear_dcb_ops(dcb);
+	return dcb ? qlcnic_dcb_attach(dcb) : 0;
 }
 #endif
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 28476b982bab..288eae201a31 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2599,7 +2599,14 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			 "Device does not support MSI interrupts\n");
 
 	if (qlcnic_82xx_check(adapter)) {
-		qlcnic_dcb_enable(adapter->dcb);
+		err = qlcnic_dcb_enable(adapter->dcb);
+		if (err) {
+			qlcnic_dcb_free(adapter->dcb);
+			adapter->dcb = NULL;
+			dev_err(&pdev->dev, "Failed to enable DCB\n");
+			goto err_out_free_hw;
+		}
+
 		qlcnic_dcb_get_info(adapter->dcb);
 		err = qlcnic_setup_intr(adapter);
 
-- 
2.25.1

