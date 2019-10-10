Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B459CD2CF9
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfJJOxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:53:15 -0400
Received: from fd.dlink.ru ([178.170.168.18]:52200 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfJJOxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 10:53:15 -0400
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id A62161B210B7; Thu, 10 Oct 2019 17:43:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru A62161B210B7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1570718631; bh=GvqeVN9ysGFiOtylE0GYxEuqYzgBWNb6Nz0VozKTHgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jS4ZsgceNBUX5CdBQ9Ye5azBcsI4jUHZj8rrmNwF5MOXUmE56olo30Xy5/bcaSA0t
         xjwbOwfMGOkdHuxP0N6abQSZvagh27e8gtSaHUulxq+2UiKx9Oeg6xv9IXGqPKBDsd
         FJT+pcK9I58cNyHFK1jTWJV4XwNo8a7i9A0Sr0hU=
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 216C01B219DF;
        Thu, 10 Oct 2019 17:43:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 216C01B219DF
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 2EE0D1B202D0;
        Thu, 10 Oct 2019 17:43:39 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Thu, 10 Oct 2019 17:43:39 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Lobakin <alobakin@dlink.ru>
Subject: [PATCH net-next 2/2] net: core: increase the default size of GRO_NORMAL skb lists to flush
Date:   Thu, 10 Oct 2019 17:42:26 +0300
Message-Id: <20191010144226.4115-3-alobakin@dlink.ru>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010144226.4115-1-alobakin@dlink.ru>
References: <20191010144226.4115-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL
skbs") have introduced a sysctl variable gro_normal_batch for defining
a limit for listified Rx of GRO_NORMAL skbs. The initial value of 8 is
purely arbitrary and has been chosen, I believe, as a minimal safe
default.
However, several tests show that it's rather suboptimal and doesn't
allow to take a full advantage of listified processing. The best and
the most balanced results have been achieved with a batches of 16 skbs
per flush.
So double the default value to give a yet another boost for Rx path.
It remains configurable via sysctl anyway, so may be fine-tuned for
each hardware.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a33f56b439ce..4f60444bb766 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4189,7 +4189,7 @@ int dev_weight_tx_bias __read_mostly = 1;  /* bias for output_queue quota */
 int dev_rx_weight __read_mostly = 64;
 int dev_tx_weight __read_mostly = 64;
 /* Maximum number of GRO_NORMAL skbs to batch up for list-RX */
-int gro_normal_batch __read_mostly = 8;
+int gro_normal_batch __read_mostly = 16;
 
 /* Called with irq disabled */
 static inline void ____napi_schedule(struct softnet_data *sd,
-- 
2.23.0

