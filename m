Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981B968DFD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387663AbfGOOCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732787AbfGOOCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:02:32 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63D5A2083D;
        Mon, 15 Jul 2019 14:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199351;
        bh=zCNqmRsIrfkKLauR/xi8cjfB1cuIG0NmwcE6Nd8GDmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8DqZA50IkwbSOX6kbdOSkbNRoGRGa9r2+Y5ZW1MzXOXwk8vS0izgUJUxbkvaujwi
         wyDJHNZZzvmfZjT7ZJmoxaOf7jF9Vf3gVlg2i83oiBTAmqL6GeF9YGRPXluOA795PT
         xEiULhQkIBs5QBEdnjKEm1XVYI7oDibCWO5Sw0Co=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 241/249] Bluetooth: hidp: NUL terminate a string in the compat ioctl
Date:   Mon, 15 Jul 2019 09:46:46 -0400
Message-Id: <20190715134655.4076-241-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit dcae9052ebb0c5b2614de620323d615fcbfda7f8 ]

This change is similar to commit a1616a5ac99e ("Bluetooth: hidp: fix
buffer overflow") but for the compat ioctl.  We take a string from the
user and forgot to ensure that it's NUL terminated.

I have also changed the strncpy() in to strscpy() in hidp_setup_hid().
The difference is the strncpy() doesn't necessarily NUL terminate the
destination string.  Either change would fix the problem but it's nice
to take a belt and suspenders approach and do both.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hidp/core.c | 2 +-
 net/bluetooth/hidp/sock.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index a442e21f3894..5abd423b55fa 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -775,7 +775,7 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->version = req->version;
 	hid->country = req->country;
 
-	strncpy(hid->name, req->name, sizeof(hid->name));
+	strscpy(hid->name, req->name, sizeof(hid->name));
 
 	snprintf(hid->phys, sizeof(hid->phys), "%pMR",
 		 &l2cap_pi(session->ctrl_sock->sk)->chan->src);
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 2151913892ce..03be6a4baef3 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -192,6 +192,7 @@ static int hidp_sock_compat_ioctl(struct socket *sock, unsigned int cmd, unsigne
 		ca.version = ca32.version;
 		ca.flags = ca32.flags;
 		ca.idle_to = ca32.idle_to;
+		ca32.name[sizeof(ca32.name) - 1] = '\0';
 		memcpy(ca.name, ca32.name, 128);
 
 		csock = sockfd_lookup(ca.ctrl_sock, &err);
-- 
2.20.1

