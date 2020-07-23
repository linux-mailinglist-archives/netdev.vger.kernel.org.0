Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8FB22B4EC
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgGWRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:31:52 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:3332 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgGWRbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 13:31:52 -0400
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 23 Jul 2020 10:31:51 -0700
Received: from subashab1-lnx.qualcomm.com ([10.239.80.20])
  by ironmsg04-sd.qualcomm.com with ESMTP; 23 Jul 2020 10:31:51 -0700
Received: by subashab1-lnx.qualcomm.com (Postfix, from userid 212624)
        id 24B8446B8; Thu, 23 Jul 2020 11:31:51 -0600 (MDT)
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     pabeni@redhat.com, davem@davemloft.net, stranche@codeaurora.org,
        netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net] dev: Defer free of skbs in flush_backlog
Date:   Thu, 23 Jul 2020 11:31:48 -0600
Message-Id: <1595525508-1675-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IRQs are disabled when freeing skbs in input queue.
Use the IRQ safe variant to free skbs here.

Fixes: 145dd5f9c88f ("net: flush the softnet backlog in process context")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 90b59fc..7a774eb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5601,7 +5601,7 @@ static void flush_backlog(struct work_struct *work)
 	skb_queue_walk_safe(&sd->input_pkt_queue, skb, tmp) {
 		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
 			__skb_unlink(skb, &sd->input_pkt_queue);
-			kfree_skb(skb);
+			dev_kfree_skb_irq(skb);
 			input_queue_head_incr(sd);
 		}
 	}
-- 
2.7.4

