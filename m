Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC543BD3BE
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239117AbhGFL73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238110AbhGFLjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00F6661FA1;
        Tue,  6 Jul 2021 11:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625571009;
        bh=WXq/Ij1/cKkAuJkhQc6Fzv5tex8hpFP0eYifhDzDPDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPzK4xkrWtz1BTWIW88/isGuw9l9pf+YB1l0WVKEYWHxfggMSjjeAGWNyi/TxdaxW
         bRbOGAWbEHR7GrmizyOCwCc44SN5oOg3NrI1b76si1cbIsqV1+GBnZhHq5wZfZ1ph/
         cpc3Ic7Sa/d+pPR7h4iK/g9MjmBC+53Urk3QFBVQHSHClLWcZx+k7AX0d5cz1rMKDd
         s40MD84Oy3571LUiWa28qelYImMYXX2uVN03ZkPgNYfQzS4Rg5KXutGk9RmLF01N55
         2TTC/Li90I3KD2UcrCDcDJNt6KdiRP6A1FttPvjV4uzkJo2u8VHZF0GXa7PoB73Q6a
         yFX3cSSJ8NPWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 31/31] sctp: add size validation when walking chunks
Date:   Tue,  6 Jul 2021 07:29:31 -0400
Message-Id: <20210706112931.2066397-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112931.2066397-1-sashal@kernel.org>
References: <20210706112931.2066397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 50619dbf8db77e98d821d615af4f634d08e22698 ]

The first chunk in a packet is ensured to be present at the beginning of
sctp_rcv(), as a packet needs to have at least 1 chunk. But the second
one, may not be completely available and ch->length can be over
uninitialized memory.

Fix here is by only trying to walk on the next chunk if there is enough to
hold at least the header, and then proceed with the ch->length validation
that is already there.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9fa89a35afcd..9dcc18db9918 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1086,7 +1086,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 
 		ch = (sctp_chunkhdr_t *) ch_end;
 		chunk_num++;
-	} while (ch_end < skb_tail_pointer(skb));
+	} while (ch_end + sizeof(*ch) < skb_tail_pointer(skb));
 
 	return asoc;
 }
-- 
2.30.2

