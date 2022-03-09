Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E564B4D2745
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiCIDlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 22:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiCIDlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 22:41:35 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D3615F346
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 19:40:37 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id e6so884876pgn.2
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 19:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8l82j1bqSchFMC8x0jswNZ2s7NeD3YuYOg0jV9p2Gxo=;
        b=IJO8wrPkAR2inzyvb+UP4Lsbi0/NKv9mVkQDCYQu4bLXywb787vBRIYxHKhhz43Ijr
         AZ/RjCkEQBMea+XzLyqPNrSqSinUUEFFGyUihRUdZC/88yLFe0aye8m/SDyiU4+JOyIH
         BfH4KbSkm5ENl2xn7HxyrlTn3tIXQ5gD6BgT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8l82j1bqSchFMC8x0jswNZ2s7NeD3YuYOg0jV9p2Gxo=;
        b=ZQcVKtMN3Jc2Yupb57C8k43Ft0ynN3x3M5GacFxZezogkZcViUo93ZMKxhy6HJbmKP
         4NrqYoe3g22P9j3SO8pb0KQWakyY94rmePD8df7vsyR+cZX1CqMKapi5y6x7Ss/BQGju
         +k4e4uvNU6vtP23dyd022tNwxlEJHwg5ns+03gtEzxLYNRJEcCY5M6+aIqsdnmcpORS8
         m2vilipNvJauAL9avAW4WV2hZNV67XnU6taK19Qb6qL44eq7yrDF88LpkLcqw9zcsCWM
         eUcr7Fe5G55TjLcHVmmpJ+cOaBI0raZG3HXynh4mG8orExUj5iZFg8uYWgpbbFraaE6P
         kBlg==
X-Gm-Message-State: AOAM533u8tKit5lYts1jMnCb6rxbLGTmEaK3SM43nPC9yXItHTKQ6Ntq
        1IhbsUNKsH6714nBMxOXAmz7EA==
X-Google-Smtp-Source: ABdhPJyZq5EwvJrtDRKEZNhYCFfYTaFFpN60qxcAoguXZdbOEF272zATqiFMaXYPsTQJGr5ZqLpE8g==
X-Received: by 2002:a05:6a00:10c9:b0:4ce:146e:6edf with SMTP id d9-20020a056a0010c900b004ce146e6edfmr21605078pfu.6.1646797237188;
        Tue, 08 Mar 2022 19:40:37 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b004c55d0dcbd1sm578631pfu.120.2022.03.08.19.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 19:40:36 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com, rdunlap@infradead.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [PATCH net-next 2/2] net/fungible: fix errors when CONFIG_TLS_DEVICE=n
Date:   Tue,  8 Mar 2022 19:40:32 -0800
Message-Id: <20220309034032.405212-3-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309034032.405212-1-dmichail@fungible.com>
References: <20220309034032.405212-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include the TLS headers unconditionally and define driver TLS symbols
used in code compiled also when CONFIG_TLS_DEVICE=n to fix the
following errors:

../drivers/net/ethernet/fungible/funeth/funeth_tx.c: In function ‘write_pkt_desc’:
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:244:13: error: implicit declaration of function ‘tls_driver_ctx’ [-Werror=implicit-function-declaration]
  244 |   tls_ctx = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
      |             ^~~~~~~~~~~~~~
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:244:37: error: ‘TLS_OFFLOAD_CTX_DIR_TX’ undeclared (first use in this function)
  244 |   tls_ctx = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
      |                                     ^~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:244:37: note: each undeclared identifier is reported only once for each function it appears in
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:245:23: error: dereferencing pointer to incomplete type ‘struct fun_ktls_tx_ctx’
  245 |   tls->tlsid = tls_ctx->tlsid;
      |                       ^~
../drivers/net/ethernet/fungible/funeth/funeth_tx.c: In function ‘fun_start_xmit’:
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:310:6: error: implicit declaration of function ‘tls_is_sk_tx_device_offloaded’ [-Werror=implicit-function-declaration]
  310 |      tls_is_sk_tx_device_offloaded(skb->sk)) {
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:311:9: error: implicit declaration of function ‘fun_tls_tx’; did you mean ‘fun_xdp_tx’? [-Werror=implicit-function-declaration]
  311 |   skb = fun_tls_tx(skb, q, &tls_len);
      |         ^~~~~~~~~~
      |         fun_xdp_tx
../drivers/net/ethernet/fungible/funeth/funeth_tx.c:311:7: warning: assignment to ‘struct sk_buff *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
  311 |   skb = fun_tls_tx(skb, q, &tls_len);
      |       ^

Fixes: db37bc177dae ("net/funeth: add the data path")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 drivers/net/ethernet/fungible/funeth/funeth_ktls.h | 7 +++----
 drivers/net/ethernet/fungible/funeth/funeth_tx.c   | 9 +++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ktls.h b/drivers/net/ethernet/fungible/funeth/funeth_ktls.h
index 1b21cccf1278..9d6f2141a959 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_ktls.h
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ktls.h
@@ -3,17 +3,16 @@
 #ifndef _FUN_KTLS_H
 #define _FUN_KTLS_H
 
-struct net_device;
-struct funeth_priv;
-
-#ifdef CONFIG_TLS_DEVICE
 #include <net/tls.h>
 
+struct funeth_priv;
+
 struct fun_ktls_tx_ctx {
 	__be64 tlsid;
 	u32 next_seq;
 };
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
 int fun_ktls_init(struct net_device *netdev);
 void fun_ktls_cleanup(struct funeth_priv *fp);
 
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index 46684afa97a0..ff6e29237253 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -7,6 +7,7 @@
 #include <linux/tcp.h>
 #include <uapi/linux/udp.h>
 #include "funeth.h"
+#include "funeth_ktls.h"
 #include "funeth_txrx.h"
 #include "funeth_trace.h"
 #include "fun_queue.h"
@@ -75,12 +76,10 @@ static __be16 tcp_hdr_doff_flags(const struct tcphdr *th)
 	return *(__be16 *)&tcp_flag_word(th);
 }
 
-#if IS_ENABLED(CONFIG_TLS_DEVICE)
-#include "funeth_ktls.h"
-
 static struct sk_buff *fun_tls_tx(struct sk_buff *skb, struct funeth_txq *q,
 				  unsigned int *tls_len)
 {
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
 	const struct fun_ktls_tx_ctx *tls_ctx;
 	u32 datalen, seq;
 
@@ -108,8 +107,10 @@ static struct sk_buff *fun_tls_tx(struct sk_buff *skb, struct funeth_txq *q,
 		FUN_QSTAT_INC(q, tx_tls_drops);
 
 	return skb;
-}
+#else
+	return NULL;
 #endif
+}
 
 /* Write as many descriptors as needed for the supplied skb starting at the
  * current producer location. The caller has made certain enough descriptors
-- 
2.25.1

