Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0CB6E27EE
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjDNQEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjDNQEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E7AA276
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5522B648DB
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 16:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCBCC4339E;
        Fri, 14 Apr 2023 16:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681488242;
        bh=SZs/CEFa5lHZZH4Y9Rfez7jmILSbsNIxYNSirHu+BKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX0t8s0i/2u1VyTPZiCleh+iAnPw7sWVqNXTcg3+csnZYqgyCDEuw2z4zeJLAZwzr
         IYcCAE3EO51F03TQMSbRbc9uTLq485m/L7nFEH+YwjpXOEFKPLLicllLKC0dTTamZu
         sgfvAw30NbuMEzQEKICa1ErsWTWwxMKu4jvktfRj+xqIVwXesVYAvI6CN6VgTlHUPT
         zSni06WSvHeK6n+PE4kLLNczMqvKN0WwlO/DEZcYElGqav0/eCrRM7ceXW6vYb2g6F
         x4zaj/SYQTke0Ndi6UwvmLCZE9xBHokJAnaE46AJaPuSm6Ufz+vSXZwetOnJzuwKCz
         WorCWxSbPhxWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/5] net: skbuff: hide csum_not_inet when CONFIG_IP_SCTP not set
Date:   Fri, 14 Apr 2023 09:01:02 -0700
Message-Id: <20230414160105.172125-3-kuba@kernel.org>
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

SCTP is not universally deployed, allow hiding its bit
from the skb.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h | 14 ++++++++++++++
 net/core/dev.c         |  3 +--
 net/sched/act_csum.c   |  3 +--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7160101edc8a..45c3044e8123 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -983,7 +983,9 @@ struct sk_buff {
 	__u8			decrypted:1;
 #endif
 	__u8			slow_gro:1;
+#if IS_ENABLED(CONFIG_IP_SCTP)
 	__u8			csum_not_inet:1;
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -5054,7 +5056,19 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
 
 static inline bool skb_csum_is_sctp(struct sk_buff *skb)
 {
+#if IS_ENABLED(CONFIG_IP_SCTP)
 	return skb->csum_not_inet;
+#else
+	return 0;
+#endif
+}
+
+static inline void skb_reset_csum_not_inet(struct sk_buff *skb)
+{
+	skb->ip_summed = CHECKSUM_NONE;
+#if IS_ENABLED(CONFIG_IP_SCTP)
+	skb->csum_not_inet = 0;
+#endif
 }
 
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index c7f13742b56c..177e91819850 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3315,8 +3315,7 @@ int skb_crc32c_csum_help(struct sk_buff *skb)
 						  skb->len - start, ~(__u32)0,
 						  crc32c_csum_stub));
 	*(__le32 *)(skb->data + offset) = crc32c_csum;
-	skb->ip_summed = CHECKSUM_NONE;
-	skb->csum_not_inet = 0;
+	skb_reset_csum_not_inet(skb);
 out:
 	return ret;
 }
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 95e9304024b7..8ed285023a40 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -376,8 +376,7 @@ static int tcf_csum_sctp(struct sk_buff *skb, unsigned int ihl,
 
 	sctph->checksum = sctp_compute_cksum(skb,
 					     skb_network_offset(skb) + ihl);
-	skb->ip_summed = CHECKSUM_NONE;
-	skb->csum_not_inet = 0;
+	skb_reset_csum_not_inet(skb);
 
 	return 1;
 }
-- 
2.39.2

