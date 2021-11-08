Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C2444A03B
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241477AbhKIBCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241453AbhKIBCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:02:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F12611BD;
        Tue,  9 Nov 2021 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419589;
        bh=avAAGN5EkykCH99Df14J6Rgv0P1Mu556HWaJrlB2Xhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reZJrJ0xwwv22gAv6HHRF5JIliyJ756/Lnesx+rDuoVbv8iGuPfWOGyzE4WdjFdmT
         QzN5VwyBCGzrWytjFRsf7SJB8/d+pyz6/7GFTRrvymIo9b+2ryqdYZUn7NLXKJagzw
         +BNFAnkYep5dq+5dqMCGQrzo1RjH3IWAK+bsMxfPbm9Z1cuh9L63OcVmsI9Yno3qnJ
         NfxA04GHWs9ugUKYTtCg9mUsNLZUGNg8HZWhUsKNvcpPP/iWOGXHsUEFgRqKZVGsnK
         s7Y60R97SF154xhQB36cmOKxdRkJbGhCKO3SKs7oHXP94ol5GBXHIHe0G0gdJgjkNl
         b4iY8By1ZFPqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 007/146] Bluetooth: call sock_hold earlier in sco_conn_del
Date:   Mon,  8 Nov 2021 12:42:34 -0500
Message-Id: <20211108174453.1187052-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit f4712fa993f688d0a48e0c28728fcdeb88c1ea58 ]

In sco_conn_del, conn->sk is read while holding on to the
sco_conn.lock to avoid races with a socket that could be released
concurrently.

However, in between unlocking sco_conn.lock and calling sock_hold,
it's possible for the socket to be freed, which would cause a
use-after-free write when sock_hold is finally called.

To fix this, the reference count of the socket should be increased
while the sco_conn.lock is still held.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index b62c91c627e2c..4a057f99b60aa 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -187,10 +187,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 	/* Kill socket */
 	sco_conn_lock(conn);
 	sk = conn->sk;
+	if (sk)
+		sock_hold(sk);
 	sco_conn_unlock(conn);
 
 	if (sk) {
-		sock_hold(sk);
 		lock_sock(sk);
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
-- 
2.33.0

