Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC832064C
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfEPLtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfEPLjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:39:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B418F20848;
        Thu, 16 May 2019 11:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006775;
        bh=3K/FjV1bSJVKX0ZHFJUpwhBItnqUc+nb/Ox3a5YrYR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNaDlDtkHJBmNZvkP40vB/eifLkXJxknsedY4tZ6qYnK25zT+drtxUcx3udVpMBUU
         CQDrdR7HhlXYuX080ySd1oiURulLtj+KV++vcUF00+PVnsfKxw/v7dCtnZi7jHCgig
         aXDR3/1oDzuj0kp22DGU4mK0/XgKNBxAFhzd4Mlo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Myungho Jung <mhjungk@gmail.com>,
        syzbot+b69368fd933c6c592f4c@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 02/34] xfrm: Reset secpath in xfrm failure
Date:   Thu, 16 May 2019 07:38:59 -0400
Message-Id: <20190516113932.8348-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Myungho Jung <mhjungk@gmail.com>

[ Upstream commit 6ed69184ed9c43873b8a1ee721e3bf3c08c2c6be ]

In esp4_gro_receive() and esp6_gro_receive(), secpath can be allocated
without adding xfrm state to xvec. Then, sp->xvec[sp->len - 1] would
fail and result in dereferencing invalid pointer in esp4_gso_segment()
and esp6_gso_segment(). Reset secpath if xfrm function returns error.

Fixes: 7785bba299a8 ("esp: Add a software GRO codepath")
Reported-by: syzbot+b69368fd933c6c592f4c@syzkaller.appspotmail.com
Signed-off-by: Myungho Jung <mhjungk@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 8 +++++---
 net/ipv6/esp6_offload.c | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8756e0e790d2a..d3170a8001b2a 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -52,13 +52,13 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 			goto out;
 
 		if (sp->len == XFRM_MAX_DEPTH)
-			goto out;
+			goto out_reset;
 
 		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
 				      (xfrm_address_t *)&ip_hdr(skb)->daddr,
 				      spi, IPPROTO_ESP, AF_INET);
 		if (!x)
-			goto out;
+			goto out_reset;
 
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
@@ -66,7 +66,7 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 		xo = xfrm_offload(skb);
 		if (!xo) {
 			xfrm_state_put(x);
-			goto out;
+			goto out_reset;
 		}
 	}
 
@@ -82,6 +82,8 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 	xfrm_input(skb, IPPROTO_ESP, spi, -2);
 
 	return ERR_PTR(-EINPROGRESS);
+out_reset:
+	secpath_reset(skb);
 out:
 	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->same_flow = 0;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index d46b4eb645c2e..cb99f6fb79b79 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -74,13 +74,13 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 			goto out;
 
 		if (sp->len == XFRM_MAX_DEPTH)
-			goto out;
+			goto out_reset;
 
 		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
 				      (xfrm_address_t *)&ipv6_hdr(skb)->daddr,
 				      spi, IPPROTO_ESP, AF_INET6);
 		if (!x)
-			goto out;
+			goto out_reset;
 
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
@@ -88,7 +88,7 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 		xo = xfrm_offload(skb);
 		if (!xo) {
 			xfrm_state_put(x);
-			goto out;
+			goto out_reset;
 		}
 	}
 
@@ -109,6 +109,8 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 	xfrm_input(skb, IPPROTO_ESP, spi, -2);
 
 	return ERR_PTR(-EINPROGRESS);
+out_reset:
+	secpath_reset(skb);
 out:
 	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->same_flow = 0;
-- 
2.20.1

