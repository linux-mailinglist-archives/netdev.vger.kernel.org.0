Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314A31D1F56
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390723AbgEMTgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390708AbgEMTgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:36:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88481C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=bTtei1g8gIWl3b0JvQwMFYwaxtaOu/adxLfWGsVrghU=; b=uWwp57x5JtP7WBtNHBa+IdiAfL
        6XhkwGzYrH9+YUmRi/qpWQBKYLI6e0e6oH7Y1b6d5NsalK/d/ZeHPrBL2DesmtwKmGdJbp+4YzNI9
        YZ+uMmqe8AZxqM7aBvwszdVlS39H6/n6JGl0So1mr0ihVgvKWDV0En84U2YMsi7dIEbo8fcZCpY0d
        /UlsmsMS2xUuOJF3/UQwPcBh0ISkft5VkoevF7NPlQVwjLOsffD6Xu8iSKYu9fip9KljZLL8C6TuI
        kN1cjos4MVjiAN3mKl2vsn2cWx+r/RcxbvRJHU6QrFN+cUoj1ogoBZ24pJARwgJrJ1IGrnRC/7RuX
        +AiS/exw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYxBM-0002Ee-9O; Wed, 13 May 2020 19:36:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] ipv6: set msg_control_is_user in do_ipv6_getsockopt
Date:   Wed, 13 May 2020 21:36:41 +0200
Message-Id: <20200513193641.2703043-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While do_ipv6_getsockopt does not call the high-level recvmsg helper,
the msghdr eventually ends up being passed to put_cmsg anyway, and thus
needs msg_control_is_user set to the proper value.

Fixes: 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for ->msg_control")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/ipv6_sockglue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 18d05403d3b52..a0e50cc57e545 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1075,6 +1075,7 @@ static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		msg.msg_control = optval;
 		msg.msg_controllen = len;
 		msg.msg_flags = flags;
+		msg.msg_control_is_user = true;
 
 		lock_sock(sk);
 		skb = np->pktoptions;
-- 
2.26.2

