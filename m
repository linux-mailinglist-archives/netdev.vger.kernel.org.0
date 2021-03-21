Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38216343064
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 01:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhCUAWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 20:22:22 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:49209 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCUAVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 20:21:46 -0400
X-Originating-IP: 95.232.69.74
Received: from enhorning.arpa1.net (host-95-232-69-74.retail.telecomitalia.it [95.232.69.74])
        (Authenticated sender: pbl@bestov.io)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 2B15B20002;
        Sun, 21 Mar 2021 00:21:40 +0000 (UTC)
From:   Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     Riccardo Paolo Bestetti <pbl@bestov.io>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipv4/raw: support binding to nonlocal addresses
Date:   Sun, 21 Mar 2021 01:20:45 +0100
Message-Id: <20210321002045.23700-1-pbl@bestov.io>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to inet raw sockets for binding to nonlocal addresses
through the IP_FREEBIND and IP_TRANSPARENT socket options, as well as
the ipv4.ip_nonlocal_bind kernel parameter.

Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>
---
 net/ipv4/raw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 50a73178d63a..734c0332b54b 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -717,6 +717,7 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+	struct net *net = sock_net(sk);
 	u32 tb_id = RT_TABLE_LOCAL;
 	int ret = -EINVAL;
 	int chk_addr_ret;
@@ -732,7 +733,8 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 					    tb_id);
 
 	ret = -EADDRNOTAVAIL;
-	if (addr->sin_addr.s_addr && chk_addr_ret != RTN_LOCAL &&
+	if (!inet_can_nonlocal_bind(net, inet) &&
+	    addr->sin_addr.s_addr && chk_addr_ret != RTN_LOCAL &&
 	    chk_addr_ret != RTN_MULTICAST && chk_addr_ret != RTN_BROADCAST)
 		goto out;
 	inet->inet_rcv_saddr = inet->inet_saddr = addr->sin_addr.s_addr;
-- 
2.31.0

