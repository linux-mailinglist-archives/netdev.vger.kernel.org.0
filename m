Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57374919FF
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350336AbiARC5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42956 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350160AbiARCvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:51:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43B1E612E8;
        Tue, 18 Jan 2022 02:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53A6C36AEB;
        Tue, 18 Jan 2022 02:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474278;
        bh=8HhqhLYUtzscszQjAX1dCUydahnbhPvnAe7pYo2zT+Y=;
        h=From:To:Cc:Subject:Date:From;
        b=tVKyNEnYdg5kKB2WyQxxJHE0smZvuRNvDJvMwLjGsKRdqTyJSkLFfGwXrfu5AVpqc
         bUt8zuYAENjpuTKgrMqrrjOdT921TrjOj/9zLXuSf33f+nOB0HRoOQPW7WhG9iGAbw
         8PbRF1AE3rtsxRWBsNxE26hwcyPA9MUvRKVWnW9qQlnq2S7cPrQA70yMRxrulLS5OA
         nxShJU6eE72113DZrAe6U4BP9EK6sjclj0cnQoMfdOztYUtwXCokU/WRMmGyMZnY40
         /tccl1T3d7Ljnug9EL4Hr6ByimanW4Ugi9ndBvYXK/wtr+P2ENcrGbPsel9h1ewxqY
         vpC3uQdpoSgYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/33] Bluetooth: Fix debugfs entry leak in hci_register_dev()
Date:   Mon, 17 Jan 2022 21:50:43 -0500
Message-Id: <20220118025116.1954375-1-sashal@kernel.org>
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
index b43f31203a430..40e6e5feb1e06 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3148,6 +3148,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	return id;
 
 err_wqueue:
+	debugfs_remove_recursive(hdev->debugfs);
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-- 
2.34.1

