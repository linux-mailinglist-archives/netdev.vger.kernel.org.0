Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FFD32E456
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhCEJHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhCEJHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:07:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4BDF64F44;
        Fri,  5 Mar 2021 09:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614935240;
        bh=ikzpr71mS+z2zxKgVFU67kaIOGEN5DRSzKmf5wpQ0/0=;
        h=Date:From:To:Cc:Subject:From;
        b=hF8wOGhhfZcgTpyJg8FQrwG4cd/T9gtCrHq0gVkhdt5FVk3h3dm8NfAP4LahvPFOA
         pJikgwz6fb7eeNLODtRvWHcQQuTwxeG0tpBfv+XIWX2f7XTPyuOuaUX8/izfB7En42
         xMLUZlAjHiEJmISQ3I0RWiahCJlDSM3gnUjIgzTFYF/qzVELUXkZDo7f9pUjUyaa1a
         jDzvF/VVS/bghoK4czQgjzTz1n84TlQQ7VxeYUBt2hLIxpdnXkM4azrSGh/vun7ora
         pxfJzT4wiTpRep3Zipkrwz2xY5GZyHfUEt7BzHiEktgfPxKHni624fxVHmEHmdft6K
         1XUajEkQtO3Hg==
Date:   Fri, 5 Mar 2021 03:07:17 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] sctp: Fix fall-through warnings for Clang
Message-ID: <20210305090717.GA139387@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
index d508f6f3dd08..5ceaf75105ba 100644
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

