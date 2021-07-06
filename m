Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1403BD2B7
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbhGFLow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237618AbhGFLgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6D4361F56;
        Tue,  6 Jul 2021 11:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570926;
        bh=XUwDBV44ClTF8/YLsdYrF24Rh0dJD/re0h0QpAYYk6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z53i9vVXDPNlPWAG5mkJHykcRa1VJqaE5AvVUtuX/RLoAfyI0dZmnOUojygfmXN0G
         dtY08TqG+yjrI9Z6uGB1lbaLm0FjNrHKaUcDmusdeCswGGMJ7ERuEXyZtWBrr2tnAo
         l0yz+4W998W81RMPbZRirWJ2jllamqqOWoTQqEkIPnCWjG6ufrBTQNXiolmOAhbfij
         itWAF0p2qbkciMVBrRAU28h71qzy/mSB1AlSQZys3380MK26NVFDLYZ0qpLg/R3R5M
         ji/FaPMFDXry3SOSEfimFObG+EmeImTkSTUowH76WOnpydRQ15ZKXUiUnOfUbhQ155
         F5TMUEOL/CyrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 45/45] sctp: add size validation when walking chunks
Date:   Tue,  6 Jul 2021 07:27:49 -0400
Message-Id: <20210706112749.2065541-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
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
index 7380f0a5949b..1af35b69e99e 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1197,7 +1197,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 
 		ch = (struct sctp_chunkhdr *)ch_end;
 		chunk_num++;
-	} while (ch_end < skb_tail_pointer(skb));
+	} while (ch_end + sizeof(*ch) < skb_tail_pointer(skb));
 
 	return asoc;
 }
-- 
2.30.2

