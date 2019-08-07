Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8558C84E6C
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388094AbfHGORK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:17:10 -0400
Received: from kadath.azazel.net ([81.187.231.250]:45986 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729960AbfHGORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O8mjk/fjt5SofqCRbHQvqlx7xv4kN4qGVz8pQ/rWAuU=; b=ZSeD1Sz8Gqa0epyZEwGjCF39rd
        zyOyRDcrA2HKMqIGyNfkqvZlrAFnVDpIrGjQqubfXpSP4wKlgwRKWRdxz096MheHp+d2jBnardkeQ
        fdWhTmoosc6kWD89pnrtnykrar1au6EzSBJV/CDFYBgKaZEX1O0EmMGSrqwZ+CUqSQmXIbppKRd5o
        TCz0hSLhLKFoBp09lt9ICB0g8QAbVbpz4xbl8767S7AdA+4MEpYsLhgDSSA0zV7Un29s71oEYfVXe
        ziKUTt4DGWcVB2UvoPREEahcU+dV8RtbRYgU49Qyg4hKQmYRb0VZ7ugFMTWOKlEmBr2U5rOqPqAzK
        LOikGP/Q==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvMkU-0001Wc-NZ; Wed, 07 Aug 2019 15:17:06 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net-next v1 4/8] netfilter: added missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.
Date:   Wed,  7 Aug 2019 15:17:01 +0100
Message-Id: <20190807141705.4864-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807141705.4864-1-jeremy@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nf_tables.h defines an API comprising several inline functions and
macros that depend on the nft member of struct net.  However, this is
only defined is CONFIG_NF_TABLES is enabled.  Added preprocessor checks
to ensure that nf_tables.h will compile if CONFIG_NF_TABLES is disabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_tables.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9b624566b82d..66edf76301d3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1207,6 +1207,8 @@ void nft_trace_notify(struct nft_traceinfo *info);
 #define MODULE_ALIAS_NFT_OBJ(type) \
 	MODULE_ALIAS("nft-obj-" __stringify(type))
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+
 /*
  * The gencursor defines two generations, the currently active and the
  * next one. Objects contain a bitmask of 2 bits specifying the generations
@@ -1280,6 +1282,8 @@ static inline void nft_set_elem_change_active(const struct net *net,
 	ext->genmask ^= nft_genmask_next(net);
 }
 
+#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
+
 /*
  * We use a free bit in the genmask field to indicate the element
  * is busy, meaning it is currently being processed either by
-- 
2.20.1

