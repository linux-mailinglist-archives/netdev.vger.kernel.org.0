Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539DD4F6CE8
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbiDFVjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238641AbiDFVjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:39:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2612307
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC0E4B82527
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 21:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D51C385A1;
        Wed,  6 Apr 2022 21:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649279726;
        bh=3EwI1KMIRAi+Zefe9JeuMWH6xu97BTnZFoYnPYuKIuQ=;
        h=From:To:Cc:Subject:Date:From;
        b=c5rbjw8h2QjiqUQ6sfGF/XeFtGnPK+TLwVRxc9NnviCE6Ltd5hXl24mIDVzqZEk32
         55rBg910Emb3zeMncoPTtkCusAvB2kdDej+fsYwXhV5PCgMVsS0d2aURo9B076vm7x
         WUoy7BevCKEX1DnLgrfgOuKszpBXSDawaugzi1/XH3lANxNvbsQbCOo0AB1x21DX/7
         1Q+MbQ7to4XgPdDzcr5abrVZcjJiJOviXE/WjUaaC2oZRKqAeeJ69+A9eX1qVz8Idk
         SDCwrr3nYoHDdQEGiI5IjWd9QTF/od3f9xZR1iEOuP3Ub0n/gt6Z/sRqOLXPWFIQdG
         D/hBwn3IBitZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     pabeni@redhat.com, netdev@vger.kernel.org, gustavoars@kernel.org,
        kurt@linutronix.de, keescook@chromium.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] flow_dissector: fix false-positive __read_overflow2_field() warning
Date:   Wed,  6 Apr 2022 14:15:21 -0700
Message-Id: <20220406211521.723357-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bounds checking is unhappy that we try to copy both Ethernet
addresses but pass pointer to the first one. Luckily destination
address is the first field so pass the pointer to the entire header,
whatever.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
I feel like we talked about this one.
I wonder if my position now is consistent with what I said
in the past :)

 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 03b6e649c428..912bda212db2 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1032,7 +1032,7 @@ bool __skb_flow_dissect(const struct net *net,
 		key_eth_addrs = skb_flow_dissector_target(flow_dissector,
 							  FLOW_DISSECTOR_KEY_ETH_ADDRS,
 							  target_container);
-		memcpy(key_eth_addrs, &eth->h_dest, sizeof(*key_eth_addrs));
+		memcpy(key_eth_addrs, eth, sizeof(*key_eth_addrs));
 	}
 
 proto_again:
-- 
2.34.1

