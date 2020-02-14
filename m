Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC115FA09
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 23:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgBNW5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 17:57:41 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:36023 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbgBNW5k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 17:57:40 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 46632ae4;
        Fri, 14 Feb 2020 22:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=NyvKafbAeLBnRgEa+4ksCm66N
        Yc=; b=vqhwfFaMqD0316yxs1rpoimlqNUkR/VyOW72Rh25nK7gw9IAKsbwbcysz
        Suly5rK1fTTgzqGR0aoh+9VGPeoz/QT1GHCYuUCpsr41foEbzU+f2yXtqhTjVp2U
        eLMG42Wvt1kOwx1jZ3gjfamgKlERWuu9g02jJKsZLEzXIfuQBcVdOrdjWKMMkRIU
        26APrVftTYPY7R8h0AOgBjAunUJt4F3rvUNQkGmmayh4NvcyNUTu9wRHu1/GNf5r
        Et42FIw/82Zsv4xwBw0SZjAeb2WWx0lGdrfjv4GnkHKjgnkPk4YUf1ySN5YuC8+V
        CS53OEkTV9h8JFQKaFFMYBa3l/TRQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5de6430b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 14 Feb 2020 22:55:28 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net 4/4] wireguard: socket: remove extra call to synchronize_net
Date:   Fri, 14 Feb 2020 23:57:23 +0100
Message-Id: <20200214225723.63646-5-Jason@zx2c4.com>
In-Reply-To: <20200214225723.63646-1-Jason@zx2c4.com>
References: <20200214225723.63646-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

synchronize_net() is a wrapper around synchronize_rcu(), so there's no
point in having synchronize_net and synchronize_rcu back to back,
despite the documentation comment suggesting maybe it's somewhat useful,
"Wait for packets currently being received to be done." This commit
removes the extra call.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/net/wireguard/socket.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index 262f3b5c819d..b0d6541582d3 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -432,7 +432,6 @@ void wg_socket_reinit(struct wg_device *wg, struct sock *new4,
 		wg->incoming_port = ntohs(inet_sk(new4)->inet_sport);
 	mutex_unlock(&wg->socket_update_lock);
 	synchronize_rcu();
-	synchronize_net();
 	sock_free(old4);
 	sock_free(old6);
 }
-- 
2.25.0

