Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A274FF546
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiDMK4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiDMK4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:56:51 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 46887344DF
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:54:24 -0700 (PDT)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app1 (Coremail) with SMTP id xjNnewCHODLeq1ZifvMKAA--.336S2;
        Wed, 13 Apr 2022 18:54:22 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net-next] tcp: ensure to use the most recently sent skb when filling the rate sample
Date:   Wed, 13 Apr 2022 18:54:04 +0800
Message-Id: <1649847244-5738-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: xjNnewCHODLeq1ZifvMKAA--.336S2
X-Coremail-Antispam: 1UD129KBjvdXoWruFW5KFy3JF48GrWxWr4rKrg_yoWkJFX_ur
        nrXa4rJayxJry8Cr1qkr98KrWSq34UAFZ5uw1rtryDKa48tay5CwsrX34v9r1ruay7CFZr
        trs5XryrA34rZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbI8Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VACjcxG62k0Y48FwI0_Cr0_Gr1UMcIj6x8ErcxFaVAv
        8VW8GwAv7VCY1x0262k0Y48FwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
        IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8twCF04k20xvY
        0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
        0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
        AVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
        CY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvj
        fU22YLDUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an ACK (s)acks multiple skbs, we favor the information
from the most recently sent skb by choosing the skb with
the highest prior_delivered count.
But prior_delivered may be equal, because tp->delivered only
changes when receiving, which requires further comparison of
skb timestamp.

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_rate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
index 617b818..ad893ad 100644
--- a/net/ipv4/tcp_rate.c
+++ b/net/ipv4/tcp_rate.c
@@ -86,7 +86,9 @@ void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
 		return;
 
 	if (!rs->prior_delivered ||
-	    after(scb->tx.delivered, rs->prior_delivered)) {
+	    after(scb->tx.delivered, rs->prior_delivered) ||
+	    (scb->tx.delivered == rs->prior_delivered &&
+	     tcp_skb_timestamp_us(skb) > tp->first_tx_mstamp)) {
 		rs->prior_delivered_ce  = scb->tx.delivered_ce;
 		rs->prior_delivered  = scb->tx.delivered;
 		rs->prior_mstamp     = scb->tx.delivered_mstamp;
-- 
1.8.3.1

