Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475AE6E4DB9
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjDQPyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjDQPx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:53:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CB092
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 08:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3615621BD
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 15:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4052C433D2;
        Mon, 17 Apr 2023 15:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681746834;
        bh=vKD+OrHq0MVGBGHiTRL9vtD3xEFJm9HcGlvM+rUHjy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKaBrz2WQ+iPO9nOhrqho9EupMLAzo1eBqmhyK5lqdb1QBuklZrgWFe17QpR9a3Zo
         OJ8tKXEX5+QQ5y/OCq/dtR9CBqd8MxoHVJ8XqFZLf+mMiVMiNDvXz24Dy5thj8tPra
         kRK+hyW6PAwuRVjI0d6B1icwwCCnqs9xOo02gyTRpS6DcoxfY0IvJq+f7wm3jU6cdU
         7D4mznOr9DGLTzV48YR+4z1Yj1iGkHXaCKb6f64YLYIqSCGeloYksfX5MLA3IyT/DJ
         vCvYRHbR87fbtZKaABIcUOghpAvhjkfK+VpI73gDX9/gFc+sN0Kpo6tiAYD8xVtepX
         yvW0bPdMqGZWQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Simon Horman <horms@kernel.org>, pablo@netfilter.org
Subject: [PATCH net-next v2 5/5] net: skbuff: hide nf_trace and ipvs_property
Date:   Mon, 17 Apr 2023 08:53:50 -0700
Message-Id: <20230417155350.337873-6-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417155350.337873-1-kuba@kernel.org>
References: <20230417155350.337873-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

Acked-by: Florian Westphal <fw@strlen.de>
Acked-by: Simon Horman <horms@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2:
 - use IS_ENABLED()
v1: https://lore.kernel.org/all/20230414160105.172125-1-kuba@kernel.org/

CC: pablo@netfilter.org
CC: fw@strlen.de
---
 include/linux/skbuff.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3ae9e8868afa..5f120bbab9da 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -966,8 +966,12 @@ struct sk_buff {
 	__u8			ndisc_nodetype:2;
 #endif
 
+#if IS_ENABLED(CONFIG_IP_VS)
 	__u8			ipvs_property:1;
+#endif
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	__u8			nf_trace:1;
+#endif
 #ifdef CONFIG_NET_SWITCHDEV
 	__u8			offload_fwd_mark:1;
 	__u8			offload_l3_fwd_mark:1;
-- 
2.39.2

