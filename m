Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F906E27EF
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjDNQET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjDNQEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52841B453
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF4D664661
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 16:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552D3C4339B;
        Fri, 14 Apr 2023 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681488243;
        bh=lAjgKhI9A7oecn+N74tarXwXl1jobwMigUyzJ5oan1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+pOXApYcpbpsUaEYwEARrVhlYrmYZgluYGUYqMILZPJCMdLXXJHYELcyZgan6neS
         VQ68ERPFSRMQh3FXEFwMPy/tQlg84FsbzQLeBYuTw0lrdO/umaFftjn7SZvjbtuGfS
         s8Ce9whz9KZoD3Fd0iAUK1U23uFiKXI9fii6Khzghyd3lOO5W7u88f1BeJnRcaE1B9
         XLqzLTcfr77rQSTiB/sk4fMFtW6hSByK9AzL4nDo/9CL3O3Yzoz9eje4c+NpF2oIjS
         mnklf9wkUJwRTtBEG+putxbz17EZbszxdToYyUE9jg5mu0iInLJnGQ//nA28jvitWT
         lnrcg/v9ZFvbA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, pablo@netfilter.org,
        fw@strlen.de
Subject: [PATCH net-next 4/5] net: skbuff: push nf_trace down the bitfield
Date:   Fri, 14 Apr 2023 09:01:04 -0700
Message-Id: <20230414160105.172125-5-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414160105.172125-1-kuba@kernel.org>
References: <20230414160105.172125-1-kuba@kernel.org>
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

nf_trace is a debug feature, AFAIU, and yet it sits oddly
high in the sk_buff bitfield. Move it down, pushing up
dst_pending_confirm and inner_protocol_type.

Next change will make nf_trace optional (under Kconfig)
and all optional fields should be placed after 2b fields
to avoid 2b fields straddling bytes.

dst_pending_confirm is L3, so it makes sense next to ignore_df.
inner_protocol_type goes up just to keep the balance.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: pablo@netfilter.org
CC: fw@strlen.de
---
 include/linux/skbuff.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fd6344aca94a..543f7ae9f09f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -934,7 +934,7 @@ struct sk_buff {
 	/* public: */
 	__u8			pkt_type:3; /* see PKT_TYPE_MAX */
 	__u8			ignore_df:1;
-	__u8			nf_trace:1;
+	__u8			dst_pending_confirm:1;
 	__u8			ip_summed:2;
 	__u8			ooo_okay:1;
 
@@ -949,7 +949,7 @@ struct sk_buff {
 	__u8			remcsum_offload:1;
 	__u8			csum_complete_sw:1;
 	__u8			csum_level:2;
-	__u8			dst_pending_confirm:1;
+	__u8			inner_protocol_type:1;
 
 	__u8			l4_hash:1;
 	__u8			sw_hash:1;
@@ -967,7 +967,7 @@ struct sk_buff {
 #endif
 
 	__u8			ipvs_property:1;
-	__u8			inner_protocol_type:1;
+	__u8			nf_trace:1;
 #ifdef CONFIG_NET_SWITCHDEV
 	__u8			offload_fwd_mark:1;
 	__u8			offload_l3_fwd_mark:1;
-- 
2.39.2

