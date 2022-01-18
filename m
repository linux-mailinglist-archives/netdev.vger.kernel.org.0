Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1564919ED
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347741AbiARC5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57852 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346659AbiARCtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:49:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B12A5B8124B;
        Tue, 18 Jan 2022 02:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450C7C36AEF;
        Tue, 18 Jan 2022 02:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474151;
        bh=Sh+M3L0lB9KpZ1YUcJstaGMEojTqMlUaXuswNPJ9dYg=;
        h=From:To:Cc:Subject:Date:From;
        b=Po0v9JmXoitMEyXPOmCNTJ1uB3lcNsotODQVyKBcqVJVPlEFqAmYAx9C6LTjZnmhT
         lEYDnRFfjUXI9sPiuyc3boKBrc2ATgTMmsDgWO6lhBXxHs1ZI4IabTTsbBEJvu2tb4
         O4QLodqt2PeJlHFoFwe29lWaxOP9cFLfPthDE8YUDJhEul3ykJnEyKJBMIMc0EKQRE
         +m8z62FEPYVaRYK7ynL77psculXaRfCRHaJeDBM0zk3Ql6dtbuXgpRC3vv1u969yZn
         6fmgFfS+B1WJ4YUChsYKzFlGWZV/QSOmTbbTJz9DEDMXaKR0cH/GpfKSYRv4fNIeCU
         pswOZOz3lZ2nQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/56] Bluetooth: Fix debugfs entry leak in hci_register_dev()
Date:   Mon, 17 Jan 2022 21:48:13 -0500
Message-Id: <20220118024908.1953673-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 5a4bb6a8e981d3d0d492aa38412ee80b21033177 ]

Fault injection test report debugfs entry leak as follows:

debugfs: Directory 'hci0' with parent 'bluetooth' already present!

When register_pm_notifier() failed in hci_register_dev(), the debugfs
create by debugfs_create_dir() do not removed in the error handing path.

Add the remove debugfs code to fix it.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 1906adfd553ad..687b4d0e4c673 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3183,6 +3183,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	return id;
 
 err_wqueue:
+	debugfs_remove_recursive(hdev->debugfs);
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-- 
2.34.1

