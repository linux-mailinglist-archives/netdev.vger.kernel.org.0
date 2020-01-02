Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C3912E8E9
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgABQsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:48:02 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:39917 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728873AbgABQsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 11:48:01 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 1109f8c7;
        Thu, 2 Jan 2020 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=BATYiML4GhOdQnrYLFcV86CqX
        rA=; b=eDRjNkF2CsuODsnnh5WQkEODelKVdv5rkUMWzqRIIVh+VDz9yzaizK8Rk
        bob7uqSZt3v9u5FTSJton+3tl32FQWkvuARnkVaiMNz6Pb3YsnCl4H4JvB41xVUE
        SSBD/Q8FFDGnfgP8MS/U+au5sgHZBiJINFJTV/bAl00Jb9RdQL9/A3nQ8UBI2/W1
        NSz1AFM15Plr3e/MrP++jn7MH3TtAis47uj4tWcYc2whbDbUx0SZ//b32P8+zyUw
        RoviiBO1pV7UAJ/0NY5srQKdbNpKKoEesBInyYY1OuegnZGnLyM4dTmazNcnd9U1
        KrFvpG8qTJqH9XAwUpn2ohp6YARyQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e564623e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 2 Jan 2020 15:49:28 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 3/3] wireguard: socket: mark skbs as not on list when receiving via gro
Date:   Thu,  2 Jan 2020 17:47:51 +0100
Message-Id: <20200102164751.416922-4-Jason@zx2c4.com>
In-Reply-To: <20200102164751.416922-1-Jason@zx2c4.com>
References: <20200102164751.416922-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain drivers will pass gro skbs to udp, at which point the udp driver
simply iterates through them and passes them off to encap_rcv, which is
where we pick up. At the moment, we're not attempting to coalesce these
into bundles, but we also don't want to wind up having cascaded lists of
skbs treated separately. The right behavior here, then, is to just mark
each incoming one as not on a list. This can be seen in practice, for
example, with Qualcomm's rmnet_perf driver.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Yaroslav Furman <yaro330@gmail.com>
---
 drivers/net/wireguard/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index c46256d0d81c..262f3b5c819d 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -333,6 +333,7 @@ static int wg_receive(struct sock *sk, struct sk_buff *skb)
 	wg = sk->sk_user_data;
 	if (unlikely(!wg))
 		goto err;
+	skb_mark_not_on_list(skb);
 	wg_packet_receive(wg, skb);
 	return 0;
 
-- 
2.24.1

