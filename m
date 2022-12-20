Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2A65210F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiLTM5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiLTM5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:57:03 -0500
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D24BBC29;
        Tue, 20 Dec 2022 04:57:01 -0800 (PST)
Received: from vla5-b2806cb321eb.qloud-c.yandex.net (vla5-b2806cb321eb.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3e0d:0:640:b280:6cb3])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id A85675FEA8;
        Tue, 20 Dec 2022 15:56:59 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:b519::1:14])
        by vla5-b2806cb321eb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id pukBv71RZ8c1-9pi6xWIM;
        Tue, 20 Dec 2022 15:56:59 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1671541019; bh=vFwXBebNUlstJNleJj/+YwuX9WYFUWsusCZsNeUI/tI=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=P26cwXMrMC1AmK/pAG1ea6we/Fx114ISiscz/reQIKWtSQMQRAfe4T1GEVXhwF2Ve
         PgT8lrWrjGhs/gL5rWPxSieC8+eM8TuwEgh0jtlCVmf2Cys2Zi1DdpjqSF/mJUjW66
         HXc7Jdh8mGWdgHesa59oAalESOX1si+/mUpgtJtA=
Authentication-Results: vla5-b2806cb321eb.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
Subject: [PATCH v1] qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure
Date:   Tue, 20 Dec 2022 15:56:49 +0300
Message-Id: <20221220125649.1637829-1-d-tatianin@yandex-team.ru>
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
pointer at callsite.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 9 ++++++++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h       | 5 ++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      | 9 ++++++++-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index dbb800769cb6..465f149d94d4 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -2505,7 +2505,14 @@ int qlcnic_83xx_init(struct qlcnic_adapter *adapter)
 		goto disable_mbx_intr;
 
 	qlcnic_83xx_clear_function_resources(adapter);
-	qlcnic_dcb_enable(adapter->dcb);
+
+	err = qlcnic_dcb_enable(adapter->dcb);
+	if (err) {
+		qlcnic_clear_dcb_ops(adapter->dcb);
+		adapter->dcb = NULL;
+		goto disable_mbx_intr;
+	}
+
 	qlcnic_83xx_initialize_nic(adapter, 1);
 	qlcnic_dcb_get_info(adapter->dcb);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
index 7519773eaca6..e1460f9c38bf 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
@@ -112,9 +112,8 @@ static inline void qlcnic_dcb_init_dcbnl_ops(struct qlcnic_dcb *dcb)
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
index 28476b982bab..36ba15fc9776 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2599,7 +2599,14 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			 "Device does not support MSI interrupts\n");
 
 	if (qlcnic_82xx_check(adapter)) {
-		qlcnic_dcb_enable(adapter->dcb);
+		err = qlcnic_dcb_enable(adapter->dcb);
+		if (err) {
+			qlcnic_clear_dcb_ops(adapter->dcb);
+			adapter->dcb = NULL;
+			dev_err(&pdev->dev, "Failed to enable DCB\n");
+			goto err_out_free_hw;
+		}
+
 		qlcnic_dcb_get_info(adapter->dcb);
 		err = qlcnic_setup_intr(adapter);
 
-- 
2.25.1

