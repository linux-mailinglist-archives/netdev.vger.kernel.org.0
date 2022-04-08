Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752204F8D7C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbiDHDki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiDHDke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DB4DE083
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7D71B829BD
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F78CC385A6;
        Fri,  8 Apr 2022 03:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389109;
        bh=24/Hk3WfwXywM4ULhEh5e+IS/pYMev7VdZIg4QAL2d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVWewilZUgcOGj2Tpw77ahuRlu6DtHiCSPXzWdz7aHemwBGHVQd8GNHwWLXdyifEh
         SaG8aak4SOsMcSpsSoc7Nu/aY1wFWbCSKZqbmYUwmWon0R4mhdOl+coRdcWOT4DqxY
         WpApuvj3J6JnubgmomIY7x/SK91g2ds8cz/MhiWcNVboDQIJtBbl3DhbbvpcrMJrQw
         X+buGJFR2dx1ycu8rBFoLId6XaNyJRzgl9l6XsgKVIW73sVoNbjedIa8HOr0Qjuhwf
         RgYmlaAMniYF+9U+eG1JwABV0iLmD5kg1t6BqdBeNz0P8qLDv5jqq+n7ztNCOtD25F
         IXZcSsRptjV7A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/10] tls: rx: replace 'back' with 'offset'
Date:   Thu,  7 Apr 2022 20:38:20 -0700
Message-Id: <20220408033823.965896-8-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408033823.965896-1-kuba@kernel.org>
References: <20220408033823.965896-1-kuba@kernel.org>
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

The padding length TLS 1.3 logic is searching for content_type from
the end of text. IMHO the code is easier to parse if we calculate
offset and decrement it rather than try to maintain positive offset
from the end of the record called "back".

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 579ccfd011a1..9729244ce3fc 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -136,22 +136,21 @@ static int padding_length(struct tls_prot_info *prot, struct sk_buff *skb)
 
 	/* Determine zero-padding length */
 	if (prot->version == TLS_1_3_VERSION) {
-		int back = TLS_TAG_SIZE + 1;
+		int offset = rxm->full_len - TLS_TAG_SIZE - 1;
 		char content_type = 0;
 		int err;
 
 		while (content_type == 0) {
-			if (back > rxm->full_len - prot->prepend_size)
+			if (offset < prot->prepend_size)
 				return -EBADMSG;
-			err = skb_copy_bits(skb,
-					    rxm->offset + rxm->full_len - back,
+			err = skb_copy_bits(skb, rxm->offset + offset,
 					    &content_type, 1);
 			if (err)
 				return err;
 			if (content_type)
 				break;
 			sub++;
-			back++;
+			offset--;
 		}
 		tlm->control = content_type;
 	}
-- 
2.34.1

