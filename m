Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC0D6C278B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjCUBlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjCUBl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D6A86B5;
        Mon, 20 Mar 2023 18:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C0C9618FE;
        Tue, 21 Mar 2023 01:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A943C4339E;
        Tue, 21 Mar 2023 01:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679362887;
        bh=tWAIojZpjGGbaO423zpALQIIGm8tko+lnDShgphvki4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BrkJex5eJHUvEgAOVnxyq1Nuhg+tRUHOMmcaQTKp7hFrNaYlwuvBRfiMykAhOAMHX
         uBhIdElgzOwNMtPUhTpCKao4QnpbZQ7jqZpJbiVQyCU2d7d/UxftcfGbfCMlPv5HPU
         Znq+NRrw1wJMzpxYj6bpJj+vwikgpUNZ1K4spJO4M/zvN8gLEgWcytexPBx4VM8V8s
         taRz6luk9QhdlHdoa2t9bLgVuLtZC+4eE/ICIFvPWKxSRpIYztAPnH1GdvNRnpmGe4
         ZkJZjmztVZePWkHMAX2CqvNR4vgSpAEKsX2YhoVtnze1sE+KWv0Tn4P+WxbXmai3lO
         V4sl6btRyTdcw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     martin.lau@linux.dev
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v2 2/3] net: skbuff: reorder bytes 2 and 3 of the bitfield
Date:   Mon, 20 Mar 2023 18:41:14 -0700
Message-Id: <20230321014115.997841-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321014115.997841-1-kuba@kernel.org>
References: <20230321014115.997841-1-kuba@kernel.org>
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

BPF needs to know the offsets of fields it tries to access.
Zero-length fields are added to make offsetof() work.
This unfortunately partitions the bitfield (fields across
the zero-length members can't be coalesced).

Reorder bytes 2 and 3, BPF needs to know the offset of fields
previously in byte 3 and some fields in byte 2 should really
be optional.

The two bytes are always in the same cacheline so it should
not matter.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5a63878a4550..36d31e74db37 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -944,16 +944,6 @@ struct sk_buff {
 	__u8			ip_summed:2;
 	__u8			ooo_okay:1;
 
-	__u8			l4_hash:1;
-	__u8			sw_hash:1;
-	__u8			wifi_acked_valid:1;
-	__u8			wifi_acked:1;
-	__u8			no_fcs:1;
-	/* Indicates the inner headers are valid in the skbuff. */
-	__u8			encapsulation:1;
-	__u8			encap_hdr_csum:1;
-	__u8			csum_valid:1;
-
 	/* private: */
 	__u8			__mono_tc_offset[0];
 	/* public: */
@@ -966,6 +956,16 @@ struct sk_buff {
 	__u8			tc_skip_classify:1;
 	__u8			tc_at_ingress:1;	/* See TC_AT_INGRESS_MASK */
 #endif
+
+	__u8			l4_hash:1;
+	__u8			sw_hash:1;
+	__u8			wifi_acked_valid:1;
+	__u8			wifi_acked:1;
+	__u8			no_fcs:1;
+	/* Indicates the inner headers are valid in the skbuff. */
+	__u8			encapsulation:1;
+	__u8			encap_hdr_csum:1;
+	__u8			csum_valid:1;
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
 #endif
-- 
2.39.2

