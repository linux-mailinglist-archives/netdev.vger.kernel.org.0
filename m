Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103D12D8A94
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408155AbgLLXJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:09:06 -0500
Received: from correo.us.es ([193.147.175.20]:46738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408150AbgLLXGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:06:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65936303D0B
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55482DA78D
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4A8ADDA78A; Sun, 13 Dec 2020 00:05:10 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D15BDA722;
        Sun, 13 Dec 2020 00:05:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 13 Dec 2020 00:05:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E82174265A5A;
        Sun, 13 Dec 2020 00:05:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/10] netfilter: nft_reject_bridge: fix build errors due to code movement
Date:   Sun, 13 Dec 2020 00:05:04 +0100
Message-Id: <20201212230513.3465-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201212230513.3465-1-pablo@netfilter.org>
References: <20201212230513.3465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors in net/bridge/netfilter/nft_reject_bridge.ko
by selecting NF_REJECT_IPV4, which provides the missing symbols.

ERROR: modpost: "nf_reject_skb_v4_tcp_reset" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!
ERROR: modpost: "nf_reject_skb_v4_unreach" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!

Fixes: fa538f7cf05a ("netfilter: nf_reject: add reject skbuff creation helpers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index e4d287afc2c9..ac5372121e60 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -18,6 +18,8 @@ config NFT_BRIDGE_META
 config NFT_BRIDGE_REJECT
 	tristate "Netfilter nf_tables bridge reject support"
 	depends on NFT_REJECT
+	depends on NF_REJECT_IPV4
+	depends on NF_REJECT_IPV6
 	help
 	  Add support to reject packets.
 
-- 
2.20.1

