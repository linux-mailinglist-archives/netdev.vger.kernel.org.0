Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE764803DB
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 20:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhL0TF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 14:05:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40856 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhL0TFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 14:05:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B76961165;
        Mon, 27 Dec 2021 19:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71252C36AEB;
        Mon, 27 Dec 2021 19:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631928;
        bh=CYdVvjbGInE4qRWQvLHHwpzbDV8VcCFQYPmgCsxNk7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BW21oPJM2SQphuTtXsfekNHrMXC7wctNUGlAax5g4/Ut0g6uVt0kn3nlsegAhweLi
         FYAFT4zgl7vQyatRlRnXkUAMqFieDoReroY7L3sH0FDyT30b2cShgJMas0DXoy/ua8
         UeLL1/FMekQAtokJ5+6ZSjo4h5juJEc97/uS8tWpTdwztSvFq7uwwrGg4yDDqAVYzU
         cKiKjRNRjeA5lesN4rKrVnCvdp4ccF9Tv6WoiFd7FdPuXoaG1z5aoFIxooAnpCj3yT
         AwHIqIk+AsB7GY7ZQO3goA+USZXu8LK/Ko74ftQ8UfnnP5WXWhUIdcT3EQaVJLaRg3
         EYBA6UxxzRJjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Hanjie Wu <nagi@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jreuter@yaina.de,
        kuba@kernel.org, linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/14] ax25: NPD bug when detaching AX25 device
Date:   Mon, 27 Dec 2021 14:04:48 -0500
Message-Id: <20211227190452.1042714-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190452.1042714-1-sashal@kernel.org>
References: <20211227190452.1042714-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 1ade48d0c27d5da1ccf4b583d8c5fc8b534a3ac8 ]

The existing cleanup routine implementation is not well synchronized
with the syscall routine. When a device is detaching, below race could
occur.

static int ax25_sendmsg(...) {
  ...
  lock_sock()
  ax25 = sk_to_ax25(sk);
  if (ax25->ax25_dev == NULL) // CHECK
  ...
  ax25_queue_xmit(skb, ax25->ax25_dev->dev); // USE
  ...
}

static void ax25_kill_by_device(...) {
  ...
  if (s->ax25_dev == ax25_dev) {
    s->ax25_dev = NULL;
    ...
}

Other syscall functions like ax25_getsockopt, ax25_getname,
ax25_info_show also suffer from similar races. To fix them, this patch
introduce lock_sock() into ax25_kill_by_device in order to guarantee
that the nullify action in cleanup routine cannot proceed when another
socket request is pending.

Signed-off-by: Hanjie Wu <nagi@zju.edu.cn>
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 269ee89d2c2be..22278807b3f36 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -85,8 +85,10 @@ static void ax25_kill_by_device(struct net_device *dev)
 again:
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
-			s->ax25_dev = NULL;
 			spin_unlock_bh(&ax25_list_lock);
+			lock_sock(s->sk);
+			s->ax25_dev = NULL;
+			release_sock(s->sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
 
-- 
2.34.1

