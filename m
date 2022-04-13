Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEA14FF284
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiDMIsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiDMIrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:47:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4124851E66
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649839490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JVdR/H9u0F9f7xRSiMpLk+sv3aibSn7XmuwAEZfNMiM=;
        b=LqbfR5gkIEFxycdLn7DmGCrt3fkt1qUvFIJ5iqQRzOR4JjFgpTjbsezSGoVmNVX6C7FRDs
        0L9XxN3AHJhqyaPkRh6bjrRV9HuZon4N3eNagpCFllrutM/9XCNj+BlhcOJ+QGilLsYu43
        5yZqocUGR3GqhCfCPpymoL1qU1zz3+g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-EU9o9IxjMHKS6625HnWSzg-1; Wed, 13 Apr 2022 04:44:48 -0400
X-MC-Unique: EU9o9IxjMHKS6625HnWSzg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 244282999B4E
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:44:48 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A889554AC8A
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:44:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next] geneve: avoid indirect calls in GRO path, when possible
Date:   Wed, 13 Apr 2022 10:44:40 +0200
Message-Id: <72bc10247a7f5fee36a3ce7da51dfd4c66a52b68.1649839351.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the most common setups, the geneve tunnels use an inner
ethernet encapsulation. In the GRO path, when such condition is
true, we can call directly the relevant GRO helper and avoid
a few indirect calls.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/geneve.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 7db6c135ac6c..2495a5719e1c 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -533,14 +533,16 @@ static struct sk_buff *geneve_gro_receive(struct sock *sk,
 		}
 	}
 
+	skb_gro_pull(skb, gh_len);
+	skb_gro_postpull_rcsum(skb, gh, gh_len);
 	type = gh->proto_type;
+	if (likely(type == htons(ETH_P_TEB)))
+		return call_gro_receive(eth_gro_receive, head, skb);
 
 	ptype = gro_find_receive_by_type(type);
 	if (!ptype)
 		goto out;
 
-	skb_gro_pull(skb, gh_len);
-	skb_gro_postpull_rcsum(skb, gh, gh_len);
 	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
 	flush = 0;
 
@@ -563,6 +565,10 @@ static int geneve_gro_complete(struct sock *sk, struct sk_buff *skb,
 	gh_len = geneve_hlen(gh);
 	type = gh->proto_type;
 
+	/* since skb->encapsulation is set, eth_gro_complete() sets the inner mac header */
+	if (likely(type == htons(ETH_P_TEB)))
+		return eth_gro_complete(skb, nhoff + gh_len);
+
 	ptype = gro_find_complete_by_type(type);
 	if (ptype)
 		err = ptype->callbacks.gro_complete(skb, nhoff + gh_len);
-- 
2.35.1

