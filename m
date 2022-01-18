Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BE2491D5C
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345409AbiARDfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359845AbiARDb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:31:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29CCC0219B3;
        Mon, 17 Jan 2022 19:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A413601E3;
        Tue, 18 Jan 2022 03:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53DBC36AEB;
        Tue, 18 Jan 2022 03:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475306;
        bh=i5PnfJ5ACF12zxhZM9oXbHuElB0dKR9hdwAK0CLrRJE=;
        h=From:To:Cc:Subject:Date:From;
        b=epguTbfMd7zM9GfUIx0lkN2XEQApTuvwPQhNFaeNehuWpv5l+H4ea5DXGhIe3MrYO
         bDqu3H2AtosYOqrCoknUnRaZGw/d7MZkFAERAflCcwRWFmgz3BXiJ5JlVGYTMIdT5P
         +jrd4gC6UfN5gWVB6ft2u70ggJxl6iTAVwNWzqbNbu0IY/ltUWAHovVU7dRWwi4Lrc
         Y1+sK6hPtzR3nq2fpNSLuwn5EGxKJanA1ryvSKcRLp+z311uPXrICMZYX3JAgb9q8z
         diRDkYKAuFi9lRrUFbPPQuiQnKDSFixH2BL4Dlpr9LeeaI311MHbgol5cpIZRigVbA
         1RteFe9RFySuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/29] Bluetooth: Fix debugfs entry leak in hci_register_dev()
Date:   Mon, 17 Jan 2022 22:07:54 -0500
Message-Id: <20220118030822.1955469-1-sashal@kernel.org>
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
index eefaa10c74dbb..1cc78b88a0d9f 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3459,6 +3459,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	return id;
 
 err_wqueue:
+	debugfs_remove_recursive(hdev->debugfs);
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-- 
2.34.1

