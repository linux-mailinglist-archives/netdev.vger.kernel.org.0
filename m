Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47BBB8C0C7
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfHMSiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:38:17 -0400
Received: from correo.us.es ([193.147.175.20]:58992 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbfHMSiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:38:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6110BB6323
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 520975C023
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 47DAC519E5; Tue, 13 Aug 2019 20:38:14 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F2FDDA7B9;
        Tue, 13 Aug 2019 20:38:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:38:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EE9214265A2F;
        Tue, 13 Aug 2019 20:38:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/17] netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.
Date:   Tue, 13 Aug 2019 20:38:02 +0200
Message-Id: <20190813183809.4081-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

nf_tables.h defines an API comprising several inline functions and
macros that depend on the nft member of struct net.  However, this is
only defined is CONFIG_NF_TABLES is enabled.  Added preprocessor checks
to ensure that nf_tables.h will compile if CONFIG_NF_TABLES is disabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0


