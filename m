Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97521A971D
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894831AbgDOIli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:41:38 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:40292 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2894815AbgDOIlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 04:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=KbpadeDFNg4SgmRur5Q+dKI46anMvpvksoJzR8MUc88=; b=T
        GHwz66M9qfqATC3rMo2eVMSBFsFXjk+fwharndUua8bhylUtr2pbEeT3VTXl+z9I
        Oqc7HMWp0lyHDOalokkB07DrjGzlFxfVxFe337hc8M96SIi7WjG/DXsgdjo92kY2
        7msulLNMKAn6UC0eB3yMtFSTanfDy9Er1lHTSJGapI=
Received: from localhost.localdomain (unknown [120.229.255.108])
        by app2 (Coremail) with SMTP id XQUFCgAnL4OoyJZevFxZAA--.884S3;
        Wed, 15 Apr 2020 16:41:13 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] tipc: Fix potential tipc_node refcnt leak in tipc_rcv
Date:   Wed, 15 Apr 2020 16:40:28 +0800
Message-Id: <1586940029-69994-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgAnL4OoyJZevFxZAA--.884S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WF15uFyDZr4DZF13XF4kXrb_yoW8AFyUpF
        47K39ayrs8Wr4UKr4ktrW5G34Fg348JrWfGFZ5ZF43Zrsaq34rCr1jqrW7Zr1rCrZ5u3yD
        Zr12qrya9w1DCrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8ZwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAv
        wI8IcIk0rVW8JVW3JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUePfQDUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tipc_rcv() invokes tipc_node_find() twice, which returns a reference of
the specified tipc_node object to "n" with increased refcnt.

When tipc_rcv() returns or a new object is assigned to "n", the original
local reference of "n" becomes invalid, so the refcount should be
decreased to keep refcount balanced.

The issue happens in some paths of tipc_rcv(), which forget to decrease
the refcnt increased by tipc_node_find() and will cause a refcnt leak.

Fix this issue by calling tipc_node_put() before the original object
pointed by "n" becomes invalid.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/tipc/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 0c88778c88b5..d50be9a3d479 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2037,6 +2037,7 @@ void tipc_rcv(struct net *net, struct sk_buff *skb, struct tipc_bearer *b)
 		n = tipc_node_find_by_id(net, ehdr->id);
 	}
 	tipc_crypto_rcv(net, (n) ? n->crypto_rx : NULL, &skb, b);
+	tipc_node_put(n);
 	if (!skb)
 		return;
 
@@ -2089,7 +2090,7 @@ void tipc_rcv(struct net *net, struct sk_buff *skb, struct tipc_bearer *b)
 	/* Check/update node state before receiving */
 	if (unlikely(skb)) {
 		if (unlikely(skb_linearize(skb)))
-			goto discard;
+			goto out_node_put;
 		tipc_node_write_lock(n);
 		if (tipc_node_check_state(n, skb, bearer_id, &xmitq)) {
 			if (le->link) {
@@ -2118,6 +2119,7 @@ void tipc_rcv(struct net *net, struct sk_buff *skb, struct tipc_bearer *b)
 	if (!skb_queue_empty(&xmitq))
 		tipc_bearer_xmit(net, bearer_id, &xmitq, &le->maddr, n);
 
+out_node_put:
 	tipc_node_put(n);
 discard:
 	kfree_skb(skb);
-- 
2.7.4

