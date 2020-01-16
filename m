Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4FD13F962
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733025AbgAPTYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbgAPQwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03A4621582;
        Thu, 16 Jan 2020 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193563;
        bh=6L36wDLqi7f4RDjvHJuzkxVG81vOLAgZTMzqyjsy0yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXMQDTuIsaOvMdVYL9jvznZ9IYpNazq0OGgK+GAgyetwrTeAjtj24XnlBIa+5+A/f
         gBUqnWyu06Obg3+aRLXTJq4jj4ftRR3ii0PQlTRz3KTGwSDjut58tV/6dEbMC8jQR9
         xfswbuJsNj8erqsu0w6cj3oOJYDczSlLRBwAj9aY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 108/205] tipc: reduce sensitive to retransmit failures
Date:   Thu, 16 Jan 2020 11:41:23 -0500
Message-Id: <20200116164300.6705-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 426071f1f3995d7e9603246bffdcbf344cd31719 ]

With huge cluster (e.g >200nodes), the amount of that flow:
gap -> retransmit packet -> acked will take time in case of STATE_MSG
dropped/delayed because a lot of traffic. This lead to 1.5 sec tolerance
value criteria made link easy failure around 2nd, 3rd of failed
retransmission attempts.

Instead of re-introduced criteria of 99 faled retransmissions to fix the
issue, we increase failure detection timer to ten times tolerance value.

Fixes: 77cf8edbc0e7 ("tipc: simplify stale link failure criteria")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Jon
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 999eab592de8..a9d8a81e80cf 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1084,7 +1084,7 @@ static bool link_retransmit_failure(struct tipc_link *l, struct tipc_link *r,
 		return false;
 
 	if (!time_after(jiffies, TIPC_SKB_CB(skb)->retr_stamp +
-			msecs_to_jiffies(r->tolerance)))
+			msecs_to_jiffies(r->tolerance * 10)))
 		return false;
 
 	hdr = buf_msg(skb);
-- 
2.20.1

