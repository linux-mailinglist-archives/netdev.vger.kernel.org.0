Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3885039E309
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhFGQUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232859AbhFGQSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:18:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 493AD61447;
        Mon,  7 Jun 2021 16:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082470;
        bh=w+FWYyVwd9RSj+ZtsicAIXWoBJ04oNi5iYxYp0GNzmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dg1okwJ72S824Mp4Yh4JKkbKECwz0uo/l5zInAboLLs9hKjpWbhpJW2DuM4RgY3Sh
         f90PmYflkEVZQziaa/foYpi5yVPJJLpunEPBIwKtoVVrPunCf09Smu63RsHl7gj8LW
         W8/XmscwfKRVQVQKnMM24njoZtRpSOi9cJRhMK8tkIg9QjBYpOfYkvkVfPZ+LFifJm
         p/ZViSqQKY6Rats+cXQ1XkkpLyW6qaj6rcmYEZi82wrQNfDXRNG52i1oQgLVwpuV/e
         Tox+2ixnjispWJiHm0Oz99nXynJfBe3JxXnjaNR567rb5iHLpDeq5tExeiQQJC/oif
         r4LXABDcbxcBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/29] Bluetooth: use correct lock to prevent UAF of hdev object
Date:   Mon,  7 Jun 2021 12:13:56 -0400
Message-Id: <20210607161410.3584036-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
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
index 8159b344deef..8d2c26c4b6d3 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -755,7 +755,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
-			bh_lock_sock_nested(sk);
+			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -764,7 +764,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 
 				hci_dev_put(hdev);
 			}
-			bh_unlock_sock(sk);
+			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
-- 
2.30.2

