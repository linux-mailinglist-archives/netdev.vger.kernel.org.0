Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4987F4251D9
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 13:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbhJGLTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 07:19:12 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33504
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhJGLTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 07:19:09 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 303683FFE4;
        Thu,  7 Oct 2021 11:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633605434;
        bh=avjKW1lulkmRLzQGJiNan2tRFayMsYMy4bdNSEG99Ds=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=GaMOJdxdCQFYwiz7lh3WZWOecf6ZSKndwxQKMwtsm16R4D4jqcCvmPjGX0jsqseVU
         kW3R1FwLVxz7JMxgWXB4cY12aoAsATU4D1V3sIEykqtXBOUiWSbiH0Swo1R3VzMbyD
         4CjoDRACB4g+if3xci9gNPS9K88sbxQzO5zrKiVyYf0OEAtuV8rq508/kzCP6U+ggy
         bYxVpX16vfOZPPm7dc61cPy07LVKf/PHbmBLyKSweGMkhr7Zw4qQ536wzHG8Eo1zt6
         ypMYa0tMA+h8F24FiKTkufrXVHLyoZ0nuYBc4ijC5B0RP7kg3PhKxfnlQSL29SfQD4
         gsxHLeK2/EAkg==
From:   Colin King <colin.king@canonical.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] Bluetooth: use bitmap_empty to check if a bitmap has any bits set
Date:   Thu,  7 Oct 2021 12:17:13 +0100
Message-Id: <20211007111713.12207-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check to see if any tasks are left checks if bitmap array is zero
rather than using the appropriate bitmap helper functions to check the
bits in the array. Fix this by using bitmap_empty on the bitmap.

Addresses-Coverity: (" Array compared against 0")
Fixes: 912730b52552 ("Bluetooth: Fix wake up suspend_wait_q prematurely")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/bluetooth/hci_request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 209f4fe17237..bad3b9c895ba 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1108,7 +1108,7 @@ static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 	clear_bit(SUSPEND_SET_ADV_FILTER, hdev->suspend_tasks);
 
 	/* Wake up only if there are no tasks left */
-	if (!hdev->suspend_tasks)
+	if (!bitmap_empty(hdev->suspend_tasks, __SUSPEND_NUM_TASKS))
 		wake_up(&hdev->suspend_wait_q);
 }
 
-- 
2.32.0

