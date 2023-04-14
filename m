Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1A56E27F1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjDNQET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjDNQEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:04:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6E8B74B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:04:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B00D86467D
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 16:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC297C4339E;
        Fri, 14 Apr 2023 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681488244;
        bh=+4Kl5Re+p+XjgOGcpq36+t+IBsyYnnhsuMnx7DxbgSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otgK/LDRoFd+mgAdEkO6/lh59tQdqqpjZQO94BK564brxKl4wPlXpvy26k12AXpWA
         rEm67EfHvvBhwG4EnvmD141PstFnoii+JHSqhR8eXGyclWKBDoLPjG26SKSP4Q8Ilw
         i7bB6hQfAl65lO5ThV4MoE5OP0VtnwgQgWUZsA808BCgh1XgWT5aqykwnMQhzwmiJd
         CrzUK6nXcKP3knhwMPksOlQsi3wxEf/9kzX/uXwwye5fENgn9ldWL/6FERdX+nL/oG
         sP36XGp8HNcXn6MH+0PWdCYbeHO0o6dfBGz95KtdlfZChYdF1Bvnm3sugH2AxuuO3J
         81tSxJzUapi0g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, pablo@netfilter.org,
        fw@strlen.de
Subject: [PATCH net-next 5/5] net: skbuff: hide nf_trace and ipvs_property
Date:   Fri, 14 Apr 2023 09:01:05 -0700
Message-Id: <20230414160105.172125-6-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414160105.172125-1-kuba@kernel.org>
References: <20230414160105.172125-1-kuba@kernel.org>
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

Accesses to nf_trace and ipvs_property are already wrapped
by ifdefs where necessary. Don't allocate the bits for those
fields at all if possible.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: pablo@netfilter.org
CC: fw@strlen.de
---
 include/linux/skbuff.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 543f7ae9f09f..7b43d5a03613 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -966,8 +966,12 @@ struct sk_buff {
 	__u8			ndisc_nodetype:2;
 #endif
 
+#if IS_ENABLED(CONFIG_IP_VS)
 	__u8			ipvs_property:1;
+#endif
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
 	__u8			nf_trace:1;
+#endif
 #ifdef CONFIG_NET_SWITCHDEV
 	__u8			offload_fwd_mark:1;
 	__u8			offload_l3_fwd_mark:1;
-- 
2.39.2

