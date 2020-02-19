Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9BB163D29
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 07:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgBSGp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 01:45:26 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:40809 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgBSGp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 01:45:26 -0500
Received: by mail-pf1-f201.google.com with SMTP id d127so14822555pfa.7
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 22:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JFI3+kM1LWruGVLKeVPFO/XZwyOSYT/vDPiEnVdBj2U=;
        b=PnuQ7SvkJrwFsCkOr3rvHKfrDrwUoHQwrQQitEv/ezWelIifCVoD7E3e/i+/2TbM+X
         IwDtLxTnUEfVdwcl86OnwvXOLU70wOEw5HjL0v/xxm5717Pb45kjxTcUhUMbrmdsyP+C
         SBKE6mym4PF3P72mIY7hikh8i3a0aESWh+EGXRwooJhSJ8OYdGDoz+hXpRSaw0axM8Ex
         lC+0iV0uJuKu1tSimojwsqaUaYK/Ci5C2h9tZDxNlL3m1P3aB2xekQ91IYnZXgMP5WR2
         +0hlJJr0F5xYVtjxQjNN5VJvD2bkr1IH8Z41iOCRcsbF8sY6i5hUm+rC3ZHfqAgUC51h
         Ua+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JFI3+kM1LWruGVLKeVPFO/XZwyOSYT/vDPiEnVdBj2U=;
        b=mtVE/X059i2Y6haJ4z0Y7NXm0kFsxpZNNOT387qMfvyZXVOfQ+jojY0FLT/UGfpROy
         M4acePb8TC9bvCk4J6Ub4jjZmZlx5VkaNWCZDoKp0kfK+9yVNBe1cC4ErQw6kwppTcO1
         L5JdYxEVoNA1NXuuboAsWWjLvbHOs9YrnNjxZjO/uFk8uGKCbTHxYXsJyqYwqPzfg1vh
         D1V6zhB4rVgzNy8r+JeOkDCoAkSynExzer0jqZ2hUdpld7fXbxHqGcql6sm2m4O7pFue
         QYJULesAuc/lBIvRR4cBqmcNplyv1G6MuEjVS4QuWCve5PZ04Ca5bw3f87EhH8UWRhtK
         jjig==
X-Gm-Message-State: APjAAAWcRw7ezLiqa4VfTWL70F0196elX519JQuafoxjzFnMnyI25Em+
        77vC1Mh/4xq/Z4DIu0mox4Ks4Xs7alIDn9fEwA==
X-Google-Smtp-Source: APXvYqz+J/xwCfFRMD1shS+tndghawrwzI7Yd0VrboY//9yoBvjkbC42tNq4IbmZInjyjU6RkwV+tCIPByJGmiAtag==
X-Received: by 2002:a63:5443:: with SMTP id e3mr20602878pgm.245.1582094725566;
 Tue, 18 Feb 2020 22:45:25 -0800 (PST)
Date:   Wed, 19 Feb 2020 14:45:19 +0800
Message-Id: <20200219144442.Bluez.v2.1.I145f6c5bbf2437a6f6afc28d3db2b876c034c2d8@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [Bluez PATCH v2] bluetooth: fix passkey uninitialized when used
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Howard Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This issue cause a warning here
https://groups.google.com/forum/#!topic/clang-built-linux/kyRKCjRsGoU

Signed-off-by: Howard Chung <howardchung@google.com>

---

Changes in v2:
- refactor code

 net/bluetooth/smp.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 50e0ac692ec4..929e0bebaf80 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2115,7 +2115,7 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 	struct l2cap_chan *chan = conn->smp;
 	struct smp_chan *smp = chan->data;
 	struct hci_conn *hcon = conn->hcon;
-	u8 *pkax, *pkbx, *na, *nb;
+	u8 *pkax, *pkbx, *na, *nb, confirm_hint;
 	u32 passkey;
 	int err;
 
@@ -2179,13 +2179,12 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 		 */
 		if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
 				 hcon->role)) {
-			err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
-							hcon->type,
-							hcon->dst_type,
-							passkey, 1);
-			if (err)
-				return SMP_UNSPECIFIED;
-			set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
+			/* Set passkey to 0. The value can be any number since
+			 * it'll be ignored anyway.
+			 */
+			passkey = 0;
+			confirm_hint = 1;
+			goto confirm;
 		}
 	}
 
@@ -2206,9 +2205,11 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 	err = smp_g2(smp->tfm_cmac, pkax, pkbx, na, nb, &passkey);
 	if (err)
 		return SMP_UNSPECIFIED;
+	confirm_hint = 0;
 
+confirm:
 	err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst, hcon->type,
-					hcon->dst_type, passkey, 0);
+					hcon->dst_type, passkey, confirm_hint);
 	if (err)
 		return SMP_UNSPECIFIED;
 
-- 
2.25.0.265.gbab2e86ba0-goog

