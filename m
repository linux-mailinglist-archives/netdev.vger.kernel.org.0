Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307DF6AFB2E
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCHAcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCHAcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:32:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00415A2C2B;
        Tue,  7 Mar 2023 16:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B175FB81B2E;
        Wed,  8 Mar 2023 00:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5BCC433A0;
        Wed,  8 Mar 2023 00:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678235532;
        bh=HGrQV3iWHk640Kwljal+Hx0tJUKqtywL687InMRuoOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ie2CK0UHChxVHNaV6xeaZba/kog/lEuwdb9/N0Oai/kQBADXFd6P8BTdVuJ3RCRsn
         5u4y3O+IZxgPEjcf+7m4gLnh1/am/Vkb/1RT/mg9zHeaLQ1gzMKM5nb3ZUv8r0rqQF
         7SxKKwE+wthj2T2b9Zz+ZeNYrv7mdpNwVnxtopNqQZWdKCbCy2Pp8L35pYiTo1OIHv
         NWDHRSwB5o4nNKmgoLBa3pinNGecrYFGdes243jNSUkOTkrwNS1QiT9QWshMm03oMS
         G+BWUD22wqn7o7D/pFpelInIT5xyBeZhQSUc8+/RyZbX11cJIIe1iu97Y599O5+UKD
         mR7Slc2e/h/qg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 2/3] net: skbuff: reorder bytes 2 and 3 of the bitfield
Date:   Tue,  7 Mar 2023 16:31:58 -0800
Message-Id: <20230308003159.441580-3-kuba@kernel.org>
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
index 004009b3930f..c4122797d465 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -945,16 +945,6 @@ struct sk_buff {
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
@@ -967,6 +957,16 @@ struct sk_buff {
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

