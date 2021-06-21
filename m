Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514003AF306
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhFUR6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233104AbhFUR40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 441FB613AB;
        Mon, 21 Jun 2021 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298008;
        bh=xMbFFv5Ocj+okRzMU7IVyFe9akyULqkzGAexCMXgzLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gnv7n3L703utLyEhhNcNg97kkN6TPsvX92F/VCvUMtDleEw5X0gImXs+ADnzIWFoi
         fkiCdvsOV17ZOFIImd5gejrigxdbQ9mF/Ywqdf81RkCWQZ6dFWagG4djltsnH37cp5
         lNPrDzwqt7Cpoe05iULiicZUqdJ9bpkFaUXArOcQA7UqQIZTC5lg70akflP6sBlDNA
         ooxRJBvVoVZWv712tbEFlquA4bRLor2cutvMQEy4fRklnVuQpxDU9SLsarDb89oYMZ
         2bcRbjHU3DUpK42x8+gSG8sDX6lBQvPKTjB0RdwdwdDsHh6uY2J2j6Iv6+5imuIbV5
         Aqh0jQBMi4zkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/35] net/packet: annotate data race in packet_sendmsg()
Date:   Mon, 21 Jun 2021 13:52:44 -0400
Message-Id: <20210621175300.735437-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
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
index ddb68aa836f7..7892d7074847 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3033,10 +3033,13 @@ static int packet_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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

