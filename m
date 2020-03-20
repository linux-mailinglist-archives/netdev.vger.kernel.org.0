Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5539518D354
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgCTPwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:52:14 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45844 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbgCTPwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:52:14 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jFJwS-0006al-MC; Fri, 20 Mar 2020 16:52:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tcp: also NULL skb->dev when copy was needed
Date:   Fri, 20 Mar 2020 16:52:02 +0100
Message-Id: <20200320155202.25719-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rare cases retransmit logic will make a full skb copy, which will not
trigger the zeroing added in recent change
b738a185beaa ("tcp: ensure skb->dev is NULL before leaving TCP stack").

Cc: Eric Dumazet <edumazet@google.com>
Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Fixes: 28f8bfd1ac94 ("netfilter: Support iif matches in POSTROUTING")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/tcp_output.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e8cf8fde3d37..2f45cde168c4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3041,8 +3041,12 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 
 		tcp_skb_tsorted_save(skb) {
 			nskb = __pskb_copy(skb, MAX_TCP_HEADER, GFP_ATOMIC);
-			err = nskb ? tcp_transmit_skb(sk, nskb, 0, GFP_ATOMIC) :
-				     -ENOBUFS;
+			if (nskb) {
+				nskb->dev = NULL;
+				err = tcp_transmit_skb(sk, nskb, 0, GFP_ATOMIC);
+			} else {
+				err = -ENOBUFS;
+			}
 		} tcp_skb_tsorted_restore(skb);
 
 		if (!err) {
-- 
2.24.1

