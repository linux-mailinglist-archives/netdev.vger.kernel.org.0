Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71995FDC3E
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJMORZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Oct 2022 10:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJMORU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:17:20 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013DEDFB4B
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:17:17 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-grIOuBmkPDyLGO9MU49A_g-1; Thu, 13 Oct 2022 10:17:13 -0400
X-MC-Unique: grIOuBmkPDyLGO9MU49A_g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 130198309DF;
        Thu, 13 Oct 2022 14:17:13 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1411811457CA;
        Thu, 13 Oct 2022 14:17:06 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 5/5] macsec: clear encryption keys from the stack after setting up offload
Date:   Thu, 13 Oct 2022 16:15:43 +0200
Message-Id: <a053cf1fcea946451017d446c3ced3756c47e712.1665416630.git.sd@queasysnail.net>
In-Reply-To: <cover.1665416630.git.sd@queasysnail.net>
References: <cover.1665416630.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

macsec_add_rxsa and macsec_add_txsa copy the key to an on-stack
offloading context to pass it to the drivers, but leaves it there when
it's done. Clear it with memzero_explicit as soon as it's not needed
anymore.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0ad6eba0a807..333e47b68e02 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1839,6 +1839,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_rxsa, &ctx);
+		memzero_explicit(ctx.sa.key, secy->key_len);
 		if (err)
 			goto cleanup;
 	}
@@ -2082,6 +2083,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_txsa, &ctx);
+		memzero_explicit(ctx.sa.key, secy->key_len);
 		if (err)
 			goto cleanup;
 	}
-- 
2.38.0

