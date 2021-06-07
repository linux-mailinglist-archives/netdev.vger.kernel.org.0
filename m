Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96A939E288
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhFGQRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231949AbhFGQQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF8DA61452;
        Mon,  7 Jun 2021 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082424;
        bh=EfJUgZAXEQ4e3/YoC+7oj97TJtaGz+HewvLUCRFRV0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwNcnHAPG0m0kCbZ7AX/4HEcqIEiY8nj4QLLj8sKq7hSgyrsS4i5+ZbU1dDnoG5TC
         GApskweTDmruIKnnkkXGeOBe6gUYtL9jKD9+/Ox60PWEkt/KGafcyaAkwGozxkTbqp
         Or97Tr6BXJMtr6ghaon8yUgwEiKNmD8V3DbHI64d/jZTX2cQ3sOJ9fagvfNYyJJAfh
         wxLhQwmo5sKbYPgbHG774vXoOJ5kSNsLoUqDm1NfxQFDBu06I772myjrjfxI/GVl6a
         prBTn0luqz2pN+8T1lfAUEM8OvCr4bP3V/5z8TFScgsREN2x+cNZP7yv4wiasya9TX
         wo0Gi9PowjQ8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/39] Bluetooth: use correct lock to prevent UAF of hdev object
Date:   Mon,  7 Jun 2021 12:12:59 -0400
Message-Id: <20210607161318.3583636-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit e305509e678b3a4af2b3cfd410f409f7cdaabb52 ]

The hci_sock_dev_event() function will cleanup the hdev object for
sockets even if this object may still be in used within the
hci_sock_bound_ioctl() function, result in UAF vulnerability.

This patch replace the BH context lock to serialize these affairs
and prevent the race condition.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 251b9128f530..eed0dd066e12 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -762,7 +762,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
-			bh_lock_sock_nested(sk);
+			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -771,7 +771,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 
 				hci_dev_put(hdev);
 			}
-			bh_unlock_sock(sk);
+			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
-- 
2.30.2

