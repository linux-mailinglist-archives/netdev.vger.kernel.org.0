Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF20E9672
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 07:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfJ3GhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 02:37:02 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:45144 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbfJ3GhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 02:37:02 -0400
Received: from localhost.localdomain ([93.22.133.151])
        by mwinf5d79 with ME
        id Kicw210073G8tn903icwwo; Wed, 30 Oct 2019 07:36:59 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 30 Oct 2019 07:36:59 +0100
X-ME-IP: 93.22.133.151
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, navid.emamdoost@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: qrtr: Simplify 'qrtr_tun_release()'
Date:   Wed, 30 Oct 2019 07:36:40 +0100
Message-Id: <20191030063640.25794-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'skb_queue_purge()' instead of re-implementing it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/qrtr/tun.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
index e35869e81766..15ce9b642b25 100644
--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -111,15 +111,11 @@ static __poll_t qrtr_tun_poll(struct file *filp, poll_table *wait)
 static int qrtr_tun_release(struct inode *inode, struct file *filp)
 {
 	struct qrtr_tun *tun = filp->private_data;
-	struct sk_buff *skb;
 
 	qrtr_endpoint_unregister(&tun->ep);
 
 	/* Discard all SKBs */
-	while (!skb_queue_empty(&tun->queue)) {
-		skb = skb_dequeue(&tun->queue);
-		kfree_skb(skb);
-	}
+	skb_queue_purge(&tun->queue);
 
 	kfree(tun);
 
-- 
2.20.1

