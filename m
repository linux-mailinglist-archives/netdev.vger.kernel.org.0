Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A4339E3DA
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhFGQ2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhFGQZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3B4B6194E;
        Mon,  7 Jun 2021 16:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082575;
        bh=qlNtbXXsxbTqME0oD0ejxjM506VL4BEuBGE9nSVv+J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozN7tCUp/MyXnayldHUOuxCrqyywb3ocX43/7TDMVi/RdEoU5Q7Yznt6nZmIKw57m
         pezFfycpLbghKkwI3MVSKiEMvQzFd438K69IEuQZIZs2//fRw/C+aKjxU4RFYOJ3kp
         b2Ep5ltFVaqwDh7MmdPmBFjv9AKRKg1QzPdafD3iDJok++JkHN0VQRcm27j9ErmcEk
         J0V+YAFTdNZoGrhwbcbqgigLf4D70z+B5bM+UZoR1eOAud3BOGn3evOigZCcJF1h6A
         H5O6+UZbdEfza+F2g1FxOOQvD+MdyuI//GkEU44Pp9wBwYAuiXN5UXx6niYmISdw4B
         uaIYyHXv+XThQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/14] Bluetooth: use correct lock to prevent UAF of hdev object
Date:   Mon,  7 Jun 2021 12:15:58 -0400
Message-Id: <20210607161605.3584954-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161605.3584954-1-sashal@kernel.org>
References: <20210607161605.3584954-1-sashal@kernel.org>
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
index ea1cd8b21708..4ab69f6e910f 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -483,7 +483,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
-			bh_lock_sock_nested(sk);
+			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -492,7 +492,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 
 				hci_dev_put(hdev);
 			}
-			bh_unlock_sock(sk);
+			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
-- 
2.30.2

