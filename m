Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14C54CDFA6
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 22:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiCDVQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 16:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiCDVQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 16:16:14 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF2DED94F
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 13:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=0+eRzW8QoNchUXarIdgq+gIdcDvhXLJtgK/7yf0SH9o=; b=HO1nQeeXy03hGWD3SoUGuPih2P
        nNQ5lxr23XboaumwTtY1gWZnA5BjzcFpCy1Vc2mAj3HcXf+WS+A+zg0p/DsXrdwGKWzHfPrntZbQl
        SsUeN2ObKCD9/tMJj0ntvGbB66iHpe14QlTxhVmC1LIUWv+44h2VMvins8V2Fr/fumbZfpEkfcX/O
        8z8+3HqVe9W6Ao9/iyyl/05yhEVI3z/CVFnAhbEBSzb3XIQ8J639IqHT/7yx2HZAein6BvGQn/z1O
        ZuDRYuP+JxrJMBGdZVq7UbTYY/iCYfzKAuMJmSAkt9dR23uKypZjAFXAn5ya2i6fdOIzR3UXCeVib
        5trCx7AA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQFGn-00C698-BM; Fri, 04 Mar 2022 21:15:25 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Dimitris Michailidis <dmichail@fungible.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next?] net: fungible: fix multiple build problems
Date:   Fri,  4 Mar 2022 13:15:24 -0800
Message-Id: <20220304211524.10706-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is currently possible to have CONFIG_FUN_ETH=y and CONFIG_TLS=m.
This causes build errors. Therefore FUN_ETH should
	depend on TLS || TLS=n

TLS_DEVICE is a bool symbol, so there is no need to test it as
	depends on TLS && TLS_DEVICE || TLS_DEVICE=n

And due to rules of precedence, the above means
	depends on (TLS && TLS_DEVICE) || TLS_DEVICE=n
but that's probably not what was meant here. More likely it
should have been
	depends on TLS && (TLS_DEVICE || TLS_DEVICE=n)

That no longer matters.

Also, gcc 7.5 does not handle the "C language" vs. #ifdef preprocessor
usage of IS_ENABLED() very well -- it is causing compile errors.

$ gcc --version
gcc (SUSE Linux) 7.5.0

And then funeth uses sbitmap, so it should select SBITMAP in order
to prevent build errors.

Fixes these build errors:

../drivers/net/ethernet/fungible/funeth/funeth_tx.c: In function ‘write_pkt_desc’:
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:244:13: error: implicit declaration of function ‘tls_driver_ctx’ [-Werror=implicit-function-declaration]
   tls_ctx = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
             ^~~~~~~~~~~~~~
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:244:37: error: ‘TLS_OFFLOAD_CTX_DIR_TX’ undeclared (first use in this function); did you mean ‘BPF_OFFLOAD_MAP_FREE’?
   tls_ctx = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
                                     ^~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:244:37: note: each undeclared identifier is reported only once for each function it appears in
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:245:23: error: dereferencing pointer to incomplete type ‘struct fun_ktls_tx_ctx’
   tls->tlsid = tls_ctx->tlsid;
                       ^~
../drivers/net/ethernet/fungible/funeth/funeth_tx.c: In function ‘fun_start_xmit’:
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:310:6: error: implicit declaration of function ‘tls_is_sk_tx_device_offloaded’ [-Werror=implicit-function-declaration]
      tls_is_sk_tx_device_offloaded(skb->sk)) {
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:311:9: error: implicit declaration of function ‘fun_tls_tx’; did you mean ‘fun_xdp_tx’? [-Werror=implicit-function-declaration]
   skb = fun_tls_tx(skb, q, &tls_len);
         ^~~~~~~~~~
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:311:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
   skb = fun_tls_tx(skb, q, &tls_len);
       ^

and

ERROR: modpost: "__sbitmap_queue_get" [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_finish_wait" [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_queue_clear" [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_prepare_to_wait" [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_queue_init_node" [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_queue_wake_all" [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!

#Fixes: not-merged-yet ("X")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dimitris Michailidis <dmichail@fungible.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/fungible/funeth/Kconfig     |    3 ++-
 drivers/net/ethernet/fungible/funeth/funeth_tx.c |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

--- mmotm-2022-0303-2124.orig/drivers/net/ethernet/fungible/funeth/Kconfig
+++ mmotm-2022-0303-2124/drivers/net/ethernet/fungible/funeth/Kconfig
@@ -6,9 +6,10 @@
 config FUN_ETH
 	tristate "Fungible Ethernet device driver"
 	depends on PCI && PCI_MSI
-	depends on TLS && TLS_DEVICE || TLS_DEVICE=n
+	depends on TLS || TLS=n
 	select NET_DEVLINK
 	select FUN_CORE
+	select SBITMAP
 	help
 	  This driver supports the Ethernet functionality of Fungible adapters.
 	  It works with both physical and virtual functions.
--- mmotm-2022-0303-2124.orig/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ mmotm-2022-0303-2124/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -234,7 +234,8 @@ static unsigned int write_pkt_desc(struc
 			fun_dataop_gl_init(gle, 0, 0, lens[i], addrs[i]);
 	}
 
-	if (IS_ENABLED(CONFIG_TLS_DEVICE) && unlikely(tls_len)) {
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if (unlikely(tls_len)) {
 		struct fun_eth_tls *tls = (struct fun_eth_tls *)gle;
 		struct fun_ktls_tx_ctx *tls_ctx;
 
@@ -250,6 +251,7 @@ static unsigned int write_pkt_desc(struc
 		q->stats.tx_tls_pkts += 1 + extra_pkts;
 		u64_stats_update_end(&q->syncp);
 	}
+#endif
 
 	u64_stats_update_begin(&q->syncp);
 	q->stats.tx_bytes += skb->len + extra_bytes;
@@ -306,12 +308,13 @@ netdev_tx_t fun_start_xmit(struct sk_buf
 	unsigned int tls_len = 0;
 	unsigned int ndesc;
 
-	if (IS_ENABLED(CONFIG_TLS_DEVICE) && skb->sk &&
-	    tls_is_sk_tx_device_offloaded(skb->sk)) {
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if (skb->sk && tls_is_sk_tx_device_offloaded(skb->sk)) {
 		skb = fun_tls_tx(skb, q, &tls_len);
 		if (unlikely(!skb))
 			goto dropped;
 	}
+#endif
 
 	ndesc = write_pkt_desc(skb, q, tls_len);
 	if (unlikely(!ndesc)) {
