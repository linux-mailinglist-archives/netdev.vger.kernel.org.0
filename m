Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C8843AB9C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 07:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhJZFR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 01:17:59 -0400
Received: from mailout1.hostsharing.net ([83.223.95.204]:33865 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbhJZFR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 01:17:58 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id AF80C101920D4;
        Tue, 26 Oct 2021 07:15:33 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 8642A6147FB8;
        Tue, 26 Oct 2021 07:15:33 +0200 (CEST)
X-Mailbox-Line: From c8b883e60f7b143ed438fd6b032a054572acee47 Mon Sep 17 00:00:00 2001
Message-Id: <c8b883e60f7b143ed438fd6b032a054572acee47.1635225091.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Tue, 26 Oct 2021 07:15:32 +0200
Subject: [PATCH net-next] ifb: Depend on netfilter alternatively to tc
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Willem de Bruijn" <willemb@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFB originally depended on NET_CLS_ACT for traffic redirection.
But since v4.5, that may be achieved with NFT_FWD_NETDEV as well.

Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.5+: bcfabee1afd9: netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress
Cc: <stable@vger.kernel.org> # v4.5+
---
 drivers/net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index f37b1c56f7c4..dd335ae1122b 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -150,7 +150,7 @@ config NET_FC
 
 config IFB
 	tristate "Intermediate Functional Block support"
-	depends on NET_CLS_ACT
+	depends on NET_ACT_MIRRED || NFT_FWD_NETDEV
 	select NET_REDIRECT
 	help
 	  This is an intermediate driver that allows sharing of
-- 
2.31.1

