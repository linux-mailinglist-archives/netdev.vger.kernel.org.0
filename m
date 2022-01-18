Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCEF491E49
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346188AbiARDsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:48:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48952 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346905AbiARCkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:40:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AC35B81249;
        Tue, 18 Jan 2022 02:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61B6C36AE3;
        Tue, 18 Jan 2022 02:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473610;
        bh=Am4JlF+3LE3QNxnbCrz5BtyOYey+mHZ/4iNz2HgS+MY=;
        h=From:To:Cc:Subject:Date:From;
        b=OCaEpAVNKI7gdWm/RXd3AwrNXZeG+YICH5zPVU6R3gCfQJ6sP9FiwddJrcGfqoCeq
         mQo28gN0FPwKyXeo092BZRlm+KdFtCnQJFrKcC991yburB+XTbAa1K+yb+7PLIYq+I
         l4YbSVzINKNlveaq/71RHSvGOpgjaAJMBAgTIlMsay5cVwxoFI5BqEoPBXyCpsAbgk
         /2IgZeptpMSkfOjxifpukWueEZ2p5gNxLNByGddSs3Oa8oblFHF92Tf3FyLKb8M5Vp
         25gt4LvQdjYPpA0Np4aiJXo8w7Q2ULqnx/u5wgKxhv1BsJ5lHV3+/r8gYZY/of6z+f
         BRSttpaZ1MZPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 001/116] Bluetooth: Fix debugfs entry leak in hci_register_dev()
Date:   Mon, 17 Jan 2022 21:38:12 -0500
Message-Id: <20220118024007.1950576-1-sashal@kernel.org>
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
index 2ad66f64879f1..2e7998bad133b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3810,6 +3810,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	return id;
 
 err_wqueue:
+	debugfs_remove_recursive(hdev->debugfs);
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-- 
2.34.1

