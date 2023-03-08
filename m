Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238686AFB2D
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjCHAcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCHAcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:32:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6382514217;
        Tue,  7 Mar 2023 16:32:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C689B81B36;
        Wed,  8 Mar 2023 00:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0041C433A4;
        Wed,  8 Mar 2023 00:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678235532;
        bh=Cpe3IwaTPIm57U9ZW8gikDgGSEjmXWqVx7Irs4uJeJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZaRPpDLLSwuk3VEbmoT+fug1W53gpMn39p/LvpRjvMNk9XFsDEZVKgpw4rmlhiYO
         1aVTe5XeEutm1HDbuwOIH2+aHL+AXoMUvmyfLOhrRdiVJVh68aFxBeEanZrsgff5su
         v6hFFiU7C27WHkFz6E0sJnxqwsJAyLvHYDWQXBt+XZPXr+aE1/tpDk8Ra6uC+sBwjZ
         amTMJpRoIrodqy/GQTbs5QVTi37z8yyC/kEQ3W/BHnkM6DYpwqdJRawSgj23wwM5QW
         1EzoNU+7pLC119KT7vvSymXdnJ/3TlRM7jiP0yHGOxn31fDo3XKDMj3oBwKNkbr++0
         TpPvJOU3uDNNA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 3/3] net: skbuff: move the fields BPF cares about directly next to the offset marker
Date:   Tue,  7 Mar 2023 16:31:59 -0800
Message-Id: <20230308003159.441580-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308003159.441580-1-kuba@kernel.org>
References: <20230308003159.441580-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid more possible BPF dependencies with moving bitfields
around keep the fields BPF cares about right next to the offset
marker.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c4122797d465..3716818b804d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -948,15 +948,15 @@ struct sk_buff {
 	/* private: */
 	__u8			__mono_tc_offset[0];
 	/* public: */
-	__u8			remcsum_offload:1;
-	__u8			csum_complete_sw:1;
-	__u8			csum_level:2;
-	__u8			dst_pending_confirm:1;
 	__u8			mono_delivery_time:1;	/* See SKB_MONO_DELIVERY_TIME_MASK */
 #ifdef CONFIG_NET_CLS_ACT
-	__u8			tc_skip_classify:1;
 	__u8			tc_at_ingress:1;	/* See TC_AT_INGRESS_MASK */
+	__u8			tc_skip_classify:1;
 #endif
+	__u8			remcsum_offload:1;
+	__u8			csum_complete_sw:1;
+	__u8			csum_level:2;
+	__u8			dst_pending_confirm:1;
 
 	__u8			l4_hash:1;
 	__u8			sw_hash:1;
@@ -1074,11 +1074,11 @@ struct sk_buff {
  * around, you also must adapt these constants.
  */
 #ifdef __BIG_ENDIAN_BITFIELD
-#define TC_AT_INGRESS_MASK		(1 << 0)
-#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 2)
+#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 7)
+#define TC_AT_INGRESS_MASK		(1 << 6)
 #else
-#define TC_AT_INGRESS_MASK		(1 << 7)
-#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
+#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 0)
+#define TC_AT_INGRESS_MASK		(1 << 1)
 #endif
 #define SKB_BF_MONO_TC_OFFSET		offsetof(struct sk_buff, __mono_tc_offset)
 
-- 
2.39.2

