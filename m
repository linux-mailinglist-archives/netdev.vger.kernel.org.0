Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9D8126445
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfLSOIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:08:10 -0500
Received: from mail-wr1-f73.google.com ([209.85.221.73]:34586 "EHLO
        mail-wr1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfLSOIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 09:08:10 -0500
Received: by mail-wr1-f73.google.com with SMTP id i9so2423482wru.1
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 06:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:cc;
        bh=rR0DY8YnbpCQ+AdSGxlAPQN0c1LYEmMe5uvVF0GxO7w=;
        b=edqJauAnv9l2Db/OdW4Nzcy/PoIy6m7rq0UBbWvju2X6CFnWDoBeUl9K3E5nkW+o/p
         y8VDw4SJQ7XWWHzIrbpNoCovNAkUagOHXNdORCAMPd6MHzvGXSIaE0bYdYwA/k+o1kLb
         OthNTjppH0IyA+vS1d+ParF1KyYV7SCachTjWXEGBOPjgmWIyfRiC23O50DgLBtokTtu
         EKpqTp/xb352x5Z7ZxQBtpYVPpWnbolYLFPkDficge+P6SYrRa7oUm3kTURQObFlan0d
         oeDJ/ry3rk/OlCFfnJOYTzZqzL4q/H3qTD98eMJBo7wVKMBDduxEJyiPvIJV2Qw61Qva
         WUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
        bh=rR0DY8YnbpCQ+AdSGxlAPQN0c1LYEmMe5uvVF0GxO7w=;
        b=E/qzEW3hxQ55etyRbpi11FQcANShGIIR8oOlYHF2D9eenktcakbD5z9++yOIj+up1v
         Kp68jsBG4hrgKWcOMy6hZpqRJMzoqZzp7nV3eZbG2KWV8KsXC0CfMdMYUIuL0O9xuqJA
         NKkqrc5Vptbh3e+8antJ2Ktpcqx1aX4FrFyJy2qKDAFu+oHd/1lkAx5r9I6fvxSIvAub
         FAF4EcdslWS2T2rw5OVlrg3Yo8/hQ5YMfBH1haNC2qcrJWoUCuTZNKg3RIbf0ljCNFBk
         K6unx4aU1KiwiAe/imXq6wtE6nCmtb0fCN8w6/cmP1zz2eoqP7+o3JJWrBrDoxw8VLPn
         wfTA==
X-Gm-Message-State: APjAAAVExbn5+qv8s8TEB0J7ywiQeKhHfUJGo9Rc7EnXQumQXOzNb4MX
        rKSC8ihkpw2/+MiRdQe29wDxa+sW/FYztA==
X-Google-Smtp-Source: APXvYqzQ1ljy0dFAUTLAmimiTU8+k3XguxQSkPO9FbsMtWJfxd2XpH7U3B6t3Eb9chW6NYvHc4xBCjjqUfjSlg==
X-Received: by 2002:a5d:5267:: with SMTP id l7mr10383766wrc.84.1576764488183;
 Thu, 19 Dec 2019 06:08:08 -0800 (PST)
Date:   Thu, 19 Dec 2019 15:08:03 +0100
Message-Id: <20191219140803.135164-1-amessina@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH] udp: fix integer overflow while computing available space in sk_rcvbuf
From:   Antonio Messina <amessina@google.com>
Cc:     amessina@google.com, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the size of the receive buffer for a socket is close to 2^31 when
computing if we have enough space in the buffer to copy a packet from
the queue to the buffer we might hit an integer overflow.

When an user set net.core.rmem_default to a value close to 2^31 UDP
packets are dropped because of this overflow. This can be visible, for
instance, with failure to resolve hostnames.

This can be fixed by casting sk_rcvbuf (which is an int) to unsigned
int, similarly to how it is done in TCP.

Signed-off-by: Antonio Messina <amessina@google.com>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4da5758cc718..93a355b6b092 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1475,7 +1475,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 	 * queue contains some other skb
 	 */
 	rmem = atomic_add_return(size, &sk->sk_rmem_alloc);
-	if (rmem > (size + sk->sk_rcvbuf))
+	if (rmem > (size + (unsigned int)sk->sk_rcvbuf))
 		goto uncharge_drop;
 
 	spin_lock(&list->lock);
-- 
2.24.1.735.g03f4e72817-goog

