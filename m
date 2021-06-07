Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F37739E3BA
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhFGQ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233764AbhFGQY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF37F61949;
        Mon,  7 Jun 2021 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082555;
        bh=QJbYxkmjGTiKMFT/ADimCcoSFQEo3WxH3FOOmcIHplA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBFyyEBgTHc0lRU6TBiOi+WTmdIdKJfzW2mRts+u8cf0eVYB5ptglhGo1SGHYm6ET
         anM7B82bG7Gm6pPvTlrfd+AysV2O7lkVTZJx+lV4+S6UaE6sHtjMNsXxo5b7s1l/Vt
         f4+GSmVfBVQ3YDYY4/MmUv+36prnUFi8D2Q5MJykq445YEWduyBgQ0nwPqFhCD76M5
         1Idvdnt+X7Y5a4Mw3q2vGWCL5qQGM+SDDZz7aB2qzPOWjczCvfFOqqw2hXZaWivwO8
         MelZI+0Qyp04xa76uAv67U1sDGOC+5ulV+xsJcl6G3DCGrRR49IyXth3rGAUV90bxS
         NoHx202WR95Zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/15] Bluetooth: use correct lock to prevent UAF of hdev object
Date:   Mon,  7 Jun 2021 12:15:36 -0400
Message-Id: <20210607161543.3584778-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161543.3584778-1-sashal@kernel.org>
References: <20210607161543.3584778-1-sashal@kernel.org>
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
index 44b3146c6117..35f5585188de 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -750,7 +750,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
-			bh_lock_sock_nested(sk);
+			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -759,7 +759,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 
 				hci_dev_put(hdev);
 			}
-			bh_unlock_sock(sk);
+			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
-- 
2.30.2

