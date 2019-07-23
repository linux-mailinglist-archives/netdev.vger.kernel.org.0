Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4930A71F89
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391507AbfGWSqI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Jul 2019 14:46:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbfGWSqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 14:46:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66719153B91E1;
        Tue, 23 Jul 2019 11:46:07 -0700 (PDT)
Date:   Tue, 23 Jul 2019 11:46:06 -0700 (PDT)
Message-Id: <20190723.114606.735859038834281358.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     willy@infradead.org, kbuild-all@01.org, netdev@vger.kernel.org
Subject: Re: [net-next:master 13/14]
 drivers/net/ethernet/faraday/ftgmac100.c:777:13: error: 'skb_frag_t {aka
 struct bio_vec}' has no member named 'size'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723085844.Horde.ehPsGFdWI2BCQdl_UyzJxlS@www.vdorst.com>
References: <201907231400.Q5QaKepi%lkp@intel.com>
        <20190723085844.Horde.ehPsGFdWI2BCQdl_UyzJxlS@www.vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 11:46:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes as follows:

====================
From 084323f62b0b976c9fd931d86c5d2553af5eb9f7 Mon Sep 17 00:00:00 2001
From: "David S. Miller" <davem@davemloft.net>
Date: Tue, 23 Jul 2019 11:45:44 -0700
Subject: [PATCH] ftgmac100: Fix build.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

drivers/net/ethernet/faraday/ftgmac100.c:777:13: error: 'skb_frag_t {aka struct bio_vec}' has no member named 'size'

Fallout from the skb_frag_t conversion to bio_vec, simply
use skb_frag_size().

Fixes: b8b576a16f79 ("net: Rename skb_frag_t size to bv_len")
Reported-by: René van Dorst <opensource@vdorst.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 030fed65393e..dc8d3e726e75 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -774,7 +774,7 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
 	for (i = 0; i < nfrags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		len = frag->size;
+		len = skb_frag_size(frag);
 
 		/* Map it */
 		map = skb_frag_dma_map(priv->dev, frag, 0, len,
-- 
2.20.1

