Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFC5FF0A3
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbfKPQG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730009AbfKPPun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:43 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3353820729;
        Sat, 16 Nov 2019 15:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919442;
        bh=5dEbdlruILwkWbOUiIwYdpi3k5zAZe2wyIRORJgY8cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmSIDmoYRnkTnrIpK7G8EIU5TUuQEKPqlK2iVaNIoV2Xf3qZUexqno4FjrIFclF7q
         S82c4mlr2WnP4UGF3t/1kzWbUYbevqK549qUxd4lHAKkMcd1VBzO3AYHSWHWF1pLwh
         jELPB9HqWNp8ckiIfWfpv+FYg7W7WHiPTBks5Td0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Barmann <david.barmann@stackpath.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 139/150] sock: Reset dst when changing sk_mark via setsockopt
Date:   Sat, 16 Nov 2019 10:47:17 -0500
Message-Id: <20191116154729.9573-139-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Barmann <david.barmann@stackpath.com>

[ Upstream commit 50254256f382c56bde87d970f3d0d02fdb76ec70 ]

When setting the SO_MARK socket option, if the mark changes, the dst
needs to be reset so that a new route lookup is performed.

This fixes the case where an application wants to change routing by
setting a new sk_mark.  If this is done after some packets have already
been sent, the dst is cached and has no effect.

Signed-off-by: David Barmann <david.barmann@stackpath.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 7ccbcd853cbce..78c9aa310ce6b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -985,10 +985,12 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			clear_bit(SOCK_PASSSEC, &sock->flags);
 		break;
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
 			ret = -EPERM;
-		else
+		} else if (val != sk->sk_mark) {
 			sk->sk_mark = val;
+			sk_dst_reset(sk);
+		}
 		break;
 
 	case SO_RXQ_OVFL:
-- 
2.20.1

