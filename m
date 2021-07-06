Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0793BD5F5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbhGFM0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235281AbhGFLgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A32F61F2B;
        Tue,  6 Jul 2021 11:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570971;
        bh=FQQIFpnAiR23hT4T3lXEcnFdqObycTksY+X948lJ45A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtHgWLHbBCHhnpUxcJdT8Ap7pDscx8rRh9Q3pA1VHC2qjjkMgzRjZDTVM+B81Y1NJ
         qujX4ROy0CUo5hZPZQhkjpjFI3bxKVgL54kBbREjnNRYOFC5FDU8J2rfDSXh7RIdMZ
         Vy7eRIL5uLZkgIEk+BsXc7L6avki42W6kPcoKjBAXP0p0ROHs+7sHDypgreOQBGNuh
         5FbpNN9vo6aw9iR3T853jd6S0bLCujNC2A60sN5G+/15CUcJlxVDSma46s9p2/q7c6
         AslXxYcvj30bzJ1IjAoqkkoCZqYRfP4FBx5i5S7i32wYS17C/as65DHbNxYjy/hmB7
         IuwrGNOLXDkWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 35/35] sctp: add size validation when walking chunks
Date:   Tue,  6 Jul 2021 07:28:47 -0400
Message-Id: <20210706112848.2066036-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
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
index 12d821ea8a1f..8f4574c4aa6c 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1165,7 +1165,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 
 		ch = (sctp_chunkhdr_t *) ch_end;
 		chunk_num++;
-	} while (ch_end < skb_tail_pointer(skb));
+	} while (ch_end + sizeof(*ch) < skb_tail_pointer(skb));
 
 	return asoc;
 }
-- 
2.30.2

