Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EBD302256
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbhAYHBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:01:04 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:34704 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727114AbhAYGmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 01:42:36 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UMkwmB0_1611556907;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMkwmB0_1611556907)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 14:41:52 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH v2] net: Simplify the calculation of variables
Date:   Mon, 25 Jan 2021 14:41:46 +0800
Message-Id: <1611556906-72262-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

 ./net/ipv4/esp4_offload.c:288:32-34: WARNING !A || A && B is
equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
Changes in v2:
  -Drop the parenthesis around !skb_is_gso(skb) now.

 net/ipv4/esp4_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 5bda5ae..601f5fb 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -285,7 +285,7 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	esp.esph = ip_esp_hdr(skb);
 
 
-	if (!hw_offload || (hw_offload && !skb_is_gso(skb))) {
+	if (!hw_offload || !skb_is_gso(skb)) {
 		esp.nfrags = esp_output_head(x, skb, &esp);
 		if (esp.nfrags < 0)
 			return esp.nfrags;
-- 
1.8.3.1

