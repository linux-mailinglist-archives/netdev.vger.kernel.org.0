Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87EC3AF294
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhFURzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232109AbhFURyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D6426134F;
        Mon, 21 Jun 2021 17:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297950;
        bh=gdwqziYej5UQV+KrdT1l+V7grfC5iPSlLrDqLs8FbAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgMH0AyxXw2MXGTQ4+VAOV/5JQn81co8jdg4fp7uAE6CK4JiJdwFPmP+7WaheEfaL
         35QRQQ1bo1XAQtmOEGVxgJJ34DEKUe5R1t/cpjDU2LZt/M1rDZA/vOZpCOrNBqTSzm
         NAUror4KdbODYbe0pzRUYEjaEsKONuv02BmiV3yggJhpIZgd7Efhr+cmnW4Hh6XivY
         skUH9u7S7hmkEdI4e0Hy2M9M+gaVv2C7AZ8vC/H5PLzybHvsgMqykBbpQ6gskgpklX
         AmrdtUaSNJKUFlIn29esLkr4v6Ns32ZMz3sX1MCnvbi49LQjZ0sTYFGEsaZzwFvdOF
         zf9jMsHK49aRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 20/39] net/packet: annotate data race in packet_sendmsg()
Date:   Mon, 21 Jun 2021 13:51:36 -0400
Message-Id: <20210621175156.735062-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d1b5bee4c8be01585033be9b3a8878789285285f ]

There is a known race in packet_sendmsg(), addressed
in commit 32d3182cd2cd ("net/packet: fix race in tpacket_snd()")

Now we have data_race(), we can use it to avoid a future KCSAN warning,
as syzbot loves stressing af_packet sockets :)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c52557ec7fb3..84d8921391c3 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3034,10 +3034,13 @@ static int packet_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
 
-	if (po->tx_ring.pg_vec)
+	/* Reading tx_ring.pg_vec without holding pg_vec_lock is racy.
+	 * tpacket_snd() will redo the check safely.
+	 */
+	if (data_race(po->tx_ring.pg_vec))
 		return tpacket_snd(po, msg);
-	else
-		return packet_snd(sock, msg, len);
+
+	return packet_snd(sock, msg, len);
 }
 
 /*
-- 
2.30.2

