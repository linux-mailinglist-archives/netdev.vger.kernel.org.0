Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F965B9CE5
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 16:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiIOOUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 10:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiIOOU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 10:20:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627BF2A707
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 07:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663251618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=O7ckoY8u55g/5adi3zaSh1bGNIosgP+nPdyN1mEO8sc=;
        b=RyRLrqQVWjuvYbZPUFjwRbjtLhjCOiQjE/CnCNrJfiTIuurlui2rb9zjZSoRcxQvs7bmKA
        D1j2/IKVhWmUvVhxuXpj1nn+B+8nCN/Wt1P1amhHHO2W82HxnyvoYITMBzGkKzo7VG0gha
        11uuo0ggBmujBAh1mTbf4gQbjpMC520=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-x29FrzjeOx-n-Lf_6gkGuw-1; Thu, 15 Sep 2022 10:20:12 -0400
X-MC-Unique: x29FrzjeOx-n-Lf_6gkGuw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58F90185A794;
        Thu, 15 Sep 2022 14:20:12 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC25F1121314;
        Thu, 15 Sep 2022 14:20:10 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Subject: [PATCH net] sfc/siena: fix null pointer dereference in efx_hard_start_xmit
Date:   Thu, 15 Sep 2022 16:19:58 +0200
Message-Id: <20220915141958.16458-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like in previous patch for sfc, prevent potential (but unlikely) NULL
pointer dereference.

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/siena/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index e166dcb9b99c..91e87594ed1e 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -336,7 +336,7 @@ netdev_tx_t efx_siena_hard_start_xmit(struct sk_buff *skb,
 		 * previous packets out.
 		 */
 		if (!netdev_xmit_more())
-			efx_tx_send_pending(tx_queue->channel);
+			efx_tx_send_pending(efx_get_tx_channel(efx, index));
 		return NETDEV_TX_OK;
 	}
 
-- 
2.34.1

