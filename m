Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37564491400
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244355AbiARCTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:19:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34714 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244313AbiARCTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:19:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59059B811FF;
        Tue, 18 Jan 2022 02:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADC3C36AF3;
        Tue, 18 Jan 2022 02:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472385;
        bh=iO+OXfsCFcozzPXNy918Y42k2yHxjBIdnLWnVD3PJLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VV88apG+uAptvdWPY5yK4KKX3VTJ9PfARd9nK+vAWBePpBzIAHuVB6Q4wvozcDkHd
         BHz+oy53392UPezt5VRm2J3gDjBF/A4+8vpeA8H3jmribOJ6ghSFUL96VIY2Ff3ckD
         ekDPrWAmAnrFSQ75HhAKgleiTEv4ecGh1CjdwQUnos0353C+irtMjaWjvau3AxsN02
         218T5kt7rI3vuc4WsPTkr3tryk6Kl/1NwHNUeSWx8C4+FhXyroBlfvrUQHObslpCYS
         6mH+FWj4sJnqdm6MaMPTRC/NCc4LR15dQmsBs1mHQqvxuKJCO17E8LTxx/q6uOQ7tG
         lqCqtiwZzWySQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 002/217] Bluetooth: Fix debugfs entry leak in hci_register_dev()
Date:   Mon, 17 Jan 2022 21:16:05 -0500
Message-Id: <20220118021940.1942199-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 8d33aa64846b1..98533def61a3b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3882,6 +3882,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	return id;
 
 err_wqueue:
+	debugfs_remove_recursive(hdev->debugfs);
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-- 
2.34.1

