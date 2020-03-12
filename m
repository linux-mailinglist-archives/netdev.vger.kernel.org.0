Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC0D182740
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 04:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387707AbgCLDEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 23:04:05 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41108 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387585AbgCLDED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 23:04:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id t14so2040307plr.8
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 20:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4cAARyNYJi7HEmAqDndtkgcM2xzN5ureUPUXbSYQH7c=;
        b=bH+zb93Os/MMZ6gp0Hedx2nFuQtt6T2xtCBVjSijFDSsY1aRQvWcZOTwnKTpXgsKLn
         aetdEw87qHd5H8F58oiCnldZL5fM01Upk+YaJWW2474JjjnSrw+Mk+Epa9CyjPeHG5WT
         7ZIgZpuPdG18bqfF4CccykoylcI/Q/t99I/BYChzT2YWDpyQCd78PtIs90PTPE6sCBEQ
         CZLA/r4NsUJjMCZE/61bjzsB90ZiJx1ZAxZaL8tY88j0qYQ+DoteUN7qLYZwNeCTq5DQ
         ytDJikhlfibdv27+PweCKC54ex0zhFZ/U3FinTlmEm6cK2ARJtF9uarcq+sIypkY9f2y
         MokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4cAARyNYJi7HEmAqDndtkgcM2xzN5ureUPUXbSYQH7c=;
        b=DFvWkzpvLeAGrIHqIQMhA7E+dRNitHNFZSE+DB/k6e507UDD2IjmIOWvOaCOeXeJvd
         2aCgsjXUZYLNoTq+NvyCoVkBqaaLFdY/rPo21Mff2qgyliB91MB+MYZ6TuVFVWgrBbLq
         Oj2Ab9bzjJWy36TmnekhhpxDrETWUUkrLK5bFpGbJ1sMLiKxo/xMrFvMKSwF26MpT65q
         zBjzGfwBqwZa+Oe3qZSS2JWJVftN6acnUw9CPOmzV5eB9D4TjwcBxTr8bqSakEJca5Wl
         J0/UHMAgmdn5vc6VprJgeubYKz/FA9QSs4nhC9J+JjYIIdc154yOUDqoVUtRaqqc5dec
         WkWQ==
X-Gm-Message-State: ANhLgQ12MFwxlMTdU+wMq7xbKvLb7rG4wCWSTEpTw7KC05A8nZnPjxMF
        4UoyQy9M/sdsAUpkuQBAtmRhkqGQp+c=
X-Google-Smtp-Source: ADFU+vvZed6/5PF3OaZ6RqDoofz+2dRsNBzCy/NEcpBf5kKLPdDXH4rbEmRXGFCN/bCCrMpDRRNctA==
X-Received: by 2002:a17:90a:730b:: with SMTP id m11mr1894596pjk.195.1583982242144;
        Wed, 11 Mar 2020 20:04:02 -0700 (PDT)
Received: from localhost.localdomain ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id d11sm10235160pfo.39.2020.03.11.20.04.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 11 Mar 2020 20:04:01 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, ap420073@gmail.com
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next v2] bareudp: Fixed bareudp receive handling
Date:   Thu, 12 Mar 2020 08:33:51 +0530
Message-Id: <1583982231-20060-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

Reverted commit "2baecda bareudp: remove unnecessary udp_encap_enable() in
bareudp_socket_create()"

An explicit call to udp_encap_enable is needed as the setup_udp_tunnel_sock
does not call udp_encap_enable if the if the socket is of type v6.

Bareudp device uses v6 socket to receive v4 & v6 traffic

CC: Taehee Yoo <ap420073@gmail.com>
Fixes: 2baecda37f4e ("bareudp: remove unnecessary udp_encap_enable() in bareudp_socket_create()")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
Changes in v2:
    - Add Comments in the code.

 drivers/net/bareudp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 71a2f48..cc0703c 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -250,6 +250,12 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
 	tunnel_cfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
 
+	/* As the setup_udp_tunnel_sock does not call udp_encap_enable if the
+	 * socket type is v6 an explicit call to udp_encap_enable is needed.
+	 */
+	if (sock->sk->sk_family == AF_INET6)
+		udp_encap_enable();
+
 	rcu_assign_pointer(bareudp->sock, sock);
 	return 0;
 }
-- 
1.8.3.1

