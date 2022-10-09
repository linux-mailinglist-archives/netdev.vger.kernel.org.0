Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F595F9028
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiJIWVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiJIWTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:19:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D711A3BF;
        Sun,  9 Oct 2022 15:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA23260CEE;
        Sun,  9 Oct 2022 22:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17EFC433C1;
        Sun,  9 Oct 2022 22:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353542;
        bh=2S3ECd09/UKaqYMGqX00MlN5mRFwbCKTt0QD76JLyVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ln7JSo5Rm5HTaQIampmEiDWWsXxuNqScrd4CGUmRQ8xMaMt2J5Qvtp3YW1kVyzQTk
         AYnL/Kn3zOXx8/d4jWEV5qHi/6S5ErFcQMlZMxs149LDcPl36KCOC4nV0H99lK48rz
         Ekw6HFPqHHVxI62rS41Fh9f2A3dN1L7Wz2uzg9isKnICL4RunPefDYp4W+HLMQlv+P
         ZRqlWhi09jVU4ASzwDL+diOtFb0sW9NlgHfwQVnGYGXRy3pZB8rj12BsKPpj/iBhLD
         9IPRsBNL6NQEKKFHNt8AykYsYS5Z4eDpE78giZ7spFpX0AySI7WZnS7jXaCkHhkdlQ
         1vKqrQAvHdXSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 57/77] Bluetooth: hci_event: Make sure ISO events don't affect non-ISO connections
Date:   Sun,  9 Oct 2022 18:07:34 -0400
Message-Id: <20221009220754.1214186-57-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ed680f925aea76ac666f34d9923cb40558f4e97b ]

ISO events (CIS/BIS) shall only be relevant for connection with link
type of ISO_LINK, otherwise the controller is probably buggy or it is
the result of fuzzer tools such as syzkaller.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6643c9c20fa4..28456d3265be 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6776,6 +6776,13 @@ static void hci_le_cis_estabilished_evt(struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
+	if (conn->type != ISO_LINK) {
+		bt_dev_err(hdev,
+			   "Invalid connection link type handle 0x%4.4x",
+			   handle);
+		goto unlock;
+	}
+
 	if (conn->role == HCI_ROLE_SLAVE) {
 		__le32 interval;
 
@@ -6896,6 +6903,13 @@ static void hci_le_create_big_complete_evt(struct hci_dev *hdev, void *data,
 	if (!conn)
 		goto unlock;
 
+	if (conn->type != ISO_LINK) {
+		bt_dev_err(hdev,
+			   "Invalid connection link type handle 0x%2.2x",
+			   ev->handle);
+		goto unlock;
+	}
+
 	if (ev->num_bis)
 		conn->handle = __le16_to_cpu(ev->bis_handle[0]);
 
-- 
2.35.1

