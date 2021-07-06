Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B883BCEAF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhGFL1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234284AbhGFLYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A4B561CA2;
        Tue,  6 Jul 2021 11:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570298;
        bh=tMnwuOqsKetrJOZHCxfof29wQdNfyrd0hr/fLSioJSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKnlnZwUoFwGLGe8Rj9Kcx5MfuupaJMBe5KE5CcHxAprqTCZRxKqoEcjTZM6c10YT
         P34KXgOzkarY3j/7l+htYhgYm68MuIrh6dnTbY6VIneiJ26kqDhgBueTKH/glrgwMC
         X7xplJvOD5bgaWFS3X2ar4bJDYheOX60KefNSY3GPALQWi3Kry6svgtr5/was3nKDm
         EkDzBozNKzMudWLU2vkKxGWFIxGPBshSH9S72V1ElFF6EBjBJAAAt/HNgkRbu3Q7CZ
         qULH58zUvBjeLC5G/QjL3i9oszSGbcp/MkQHqbR6/vVOtVVRgKBZNwX6x/uDc9T9aH
         Wpa08tc/kYVRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 186/189] sctp: add size validation when walking chunks
Date:   Tue,  6 Jul 2021 07:14:06 -0400
Message-Id: <20210706111409.2058071-186-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 8924e2e142c8..f72bff93745c 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1247,7 +1247,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 
 		ch = (struct sctp_chunkhdr *)ch_end;
 		chunk_num++;
-	} while (ch_end < skb_tail_pointer(skb));
+	} while (ch_end + sizeof(*ch) < skb_tail_pointer(skb));
 
 	return asoc;
 }
-- 
2.30.2

