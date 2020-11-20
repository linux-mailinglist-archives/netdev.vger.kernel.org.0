Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847CB2BB3C3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbgKTSiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:38:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730987AbgKTSiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:38:10 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46A42415A;
        Fri, 20 Nov 2020 18:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897489;
        bh=w43+w0NhHj4tUm5QZvfc5WScxWGZOtkmawFdJQ+rDlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ib59Iv5qY0KYe8OzGs2E/Fk/VwyqqT+cWBbgcDjWtI9jjxm9EfoDwCk/iXzgc9nwc
         cAJ9pfm+EOhRYbXnL8ZHTXDPBbnWnIvF4iFMY4kZ83Hl9t9ISQb+TpTa6xX7o8CyKj
         ci+CT6nh4SNFLJi1fU33ki22LmmY7rTPcbytCJL0=
Date:   Fri, 20 Nov 2020 12:38:15 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 109/141] net: netrom: Fix fall-through warnings for Clang
Message-ID: <c9a262ebaebd704e66c264fb68462bd8b9664d38.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/netrom/nr_route.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 78da5eab252a..de0456073dc0 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -266,6 +266,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		fallthrough;
 	case 2:
 		re_sort_routes(nr_node, 0, 1);
+		break;
 	case 1:
 		break;
 	}
@@ -359,6 +360,7 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
 					fallthrough;
 				case 1:
 					nr_node->routes[1] = nr_node->routes[2];
+					fallthrough;
 				case 2:
 					break;
 				}
@@ -482,6 +484,7 @@ static int nr_dec_obs(void)
 					fallthrough;
 				case 1:
 					s->routes[1] = s->routes[2];
+					break;
 				case 2:
 					break;
 				}
@@ -529,6 +532,7 @@ void nr_rt_device_down(struct net_device *dev)
 							fallthrough;
 						case 1:
 							t->routes[1] = t->routes[2];
+							break;
 						case 2:
 							break;
 						}
-- 
2.27.0

