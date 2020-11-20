Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDD42BB409
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbgKTSji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731210AbgKTSjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:39:36 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6284A21D91;
        Fri, 20 Nov 2020 18:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897576;
        bh=5svCnD8dYOs62Z22Rf5piIoCk//vVChoiXFqSXWMqZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xiOLkEgDDoqgwb4H+wUQb1GYDnCLWaHKyOMgicC3Axk4yQXPGnKQd+7Xup0AbX2Zv
         zGYyhsVNggflh9RhRll3xM0LAU86cOa0gBdWhiE17X055BdnXwha8GFK36udD5T9qV
         IzM9CyQYj+zwiqcRj3cNVCHY69+golImpMUwRCRg=
Date:   Fri, 20 Nov 2020 12:39:41 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 125/141] sctp: Fix fall-through warnings for Clang
Message-ID: <52452badc108eff85b34d4bb71b1f269e3c67448.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
of warnings by explicitly adding a break statement and replacing a
comment with a goto statement instead of letting the code fall through
to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sctp/input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 55d4fc6f371d..5944af035ba0 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -633,7 +633,7 @@ int sctp_v4_err(struct sk_buff *skb, __u32 info)
 		break;
 	case ICMP_REDIRECT:
 		sctp_icmp_redirect(sk, transport, skb);
-		/* Fall through to out_unlock. */
+		goto out_unlock;
 	default:
 		goto out_unlock;
 	}
@@ -1236,6 +1236,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 						net, ch, laddr,
 						sctp_hdr(skb)->source,
 						transportp);
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

