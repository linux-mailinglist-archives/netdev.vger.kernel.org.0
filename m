Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E921981AA
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgC3Qvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:51:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55626 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgC3Qvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:51:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jIxdR-0005H2-De; Mon, 30 Mar 2020 18:51:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Xiumei Mu <xmu@redhat.com>, Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 1/1] net: fix fraglist segmentation reference count leak
Date:   Mon, 30 Mar 2020 18:51:29 +0200
Message-Id: <20200330165129.5200-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long says:
 On udp rx path udp_rcv_segment() may do segment where the frag skbs
 will get the header copied from the head skb in skb_segment_list()
 by calling __copy_skb_header(), which could overwrite the frag skbs'
 extensions by __skb_ext_copy() and cause a leak.

 This issue was found after loading esp_offload where a sec path ext
 is set in the skb.

Fix this by discarding head state of the fraglist skb before replacing
its contents.

Fixes: 3a1296a38d0cf62 ("net: Support GRO/GSO fraglist chaining.")
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reported-by: Xiumei Mu <xmu@redhat.com>
Tested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e1101a4f90a6..bea447f38dcc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3668,6 +3668,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 
+		skb_release_head_state(nskb);
 		 __copy_skb_header(nskb, skb);
 
 		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
-- 
2.24.1

