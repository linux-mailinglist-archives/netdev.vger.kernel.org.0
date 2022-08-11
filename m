Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA81B5900FD
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbiHKPr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbiHKPqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:46:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AC28E9A0;
        Thu, 11 Aug 2022 08:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B63361634;
        Thu, 11 Aug 2022 15:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75040C433C1;
        Thu, 11 Aug 2022 15:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232466;
        bh=i8R9VijbNzVWBx/aqyo9yN5DjOdpVElqOOBOgB7dA8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ebao8mUQ7NmEDjjrBaH1BicoSCfP/hqj6SUGWGBjRtgiWS5UFKvcX1ooF2sBRc0Sz
         VdQUz5v1QvQX8R/bsEUgTiU0PLYqhpPZgBSQt1LEIdJwHARmj3Z5E2ofv4pCY63X7m
         EiL7nU3gDlgbgBb04qK/zTlt1fElPVp/6xxeyeMgNgdRY+ralldCCEpNAr73ZZ5OSt
         d0UgmZzaCjiZAWtIhGVFp7j8M/Qi3hhx5gOcJVFLdmTXh/r1zf/0knJ7Vtdt0n8CdP
         G5wupniwm7rkdI0kjZS+Y4oZJVKBuWkVhTsn0mkMhXSgXJQPUk2jBu1Q9IHpc+owpQ
         QhbbWDdWmde6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 089/105] Bluetooth: mgmt: Fix using hci_conn_abort
Date:   Thu, 11 Aug 2022 11:28:13 -0400
Message-Id: <20220811152851.1520029-89-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1f7435c8f6558a94f75b408a74140bdcbd0f6dd1 ]

This fixes using hci_conn_abort instead of using hci_conn_abort_sync.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h |  2 ++
 net/bluetooth/hci_sync.c         |  3 +--
 net/bluetooth/mgmt.c             | 38 +++++++++++++++++++++++++++++---
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 2492e3b46a8f..544e949b5dbf 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -105,4 +105,6 @@ int hci_resume_sync(struct hci_dev *hdev);
 
 struct hci_conn;
 
+int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn, u8 reason);
+
 int hci_le_create_conn_sync(struct hci_dev *hdev, struct hci_conn *conn);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9a3a7cc01345..ce7573182e81 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4432,8 +4432,7 @@ static int hci_reject_conn_sync(struct hci_dev *hdev, struct hci_conn *conn,
 				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
 }
 
-static int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn,
-			       u8 reason)
+int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn, u8 reason)
 {
 	int err;
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 2f91a8c2b678..c003a17d8814 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2528,6 +2528,37 @@ static int device_unpaired(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			  skip_sk);
 }
 
+static void unpair_device_complete(struct hci_dev *hdev, void *data, int err)
+{
+	struct mgmt_pending_cmd *cmd = data;
+	struct mgmt_cp_unpair_device *cp = cmd->param;
+
+	if (!err)
+		device_unpaired(hdev, &cp->addr.bdaddr, cp->addr.type, cmd->sk);
+
+	cmd->cmd_complete(cmd, err);
+	mgmt_pending_free(cmd);
+}
+
+static int unpair_device_sync(struct hci_dev *hdev, void *data)
+{
+	struct mgmt_pending_cmd *cmd = data;
+	struct mgmt_cp_unpair_device *cp = cmd->param;
+	struct hci_conn *conn;
+
+	if (cp->addr.type == BDADDR_BREDR)
+		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK,
+					       &cp->addr.bdaddr);
+	else
+		conn = hci_conn_hash_lookup_le(hdev, &cp->addr.bdaddr,
+					       le_addr_type(cp->addr.type));
+
+	if (!conn)
+		return 0;
+
+	return hci_abort_conn_sync(hdev, conn, HCI_ERROR_REMOTE_USER_TERM);
+}
+
 static int unpair_device(struct sock *sk, struct hci_dev *hdev, void *data,
 			 u16 len)
 {
@@ -2638,7 +2669,7 @@ static int unpair_device(struct sock *sk, struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
-	cmd = mgmt_pending_add(sk, MGMT_OP_UNPAIR_DEVICE, hdev, cp,
+	cmd = mgmt_pending_new(sk, MGMT_OP_UNPAIR_DEVICE, hdev, cp,
 			       sizeof(*cp));
 	if (!cmd) {
 		err = -ENOMEM;
@@ -2647,9 +2678,10 @@ static int unpair_device(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	cmd->cmd_complete = addr_cmd_complete;
 
-	err = hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+	err = hci_cmd_sync_queue(hdev, unpair_device_sync, cmd,
+				 unpair_device_complete);
 	if (err < 0)
-		mgmt_pending_remove(cmd);
+		mgmt_pending_free(cmd);
 
 unlock:
 	hci_dev_unlock(hdev);
-- 
2.35.1

