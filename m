Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69B139E219
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhFGQPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231671AbhFGQOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68DC3613C7;
        Mon,  7 Jun 2021 16:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082373;
        bh=EfJUgZAXEQ4e3/YoC+7oj97TJtaGz+HewvLUCRFRV0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOBgg0mHUeqGBpq+snako1S+RQepTOutnO5cpt2AyOgrGxjtEavY8z3oIwlz9YRcR
         Dr52U4kpaOoQrfjFQEAvqj3ZjxDGa8UMTL8ccbLr16WP3jbQjNoV2SCaf8d3Os6sMu
         dpryh0PEEaxBhwStT9C57VCXwbQxV8j5uoJOyWln4xhisO0ZAk5wHrzcObW/3qfoQA
         lanSZAnQgUP+wRF9vbGaz3jn4clBN/cRFKZO88+axMraBx2YNd8hCmSNXskdWemZfv
         oBq9E1SKiMtTk9obKU+GZ0NJ0NSSNqbHUSQRcLKv0cxMM87F2v4CvLlJmxrlId5PV/
         gpeEVCjjQuFpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 30/49] Bluetooth: use correct lock to prevent UAF of hdev object
Date:   Mon,  7 Jun 2021 12:11:56 -0400
Message-Id: <20210607161215.3583176-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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

