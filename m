Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DB25B870B
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 13:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiINLLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 07:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiINLLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 07:11:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7543B5E643
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 04:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663153910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kX+pi/HvCDp+oQlA12cx7MP2R0GtvFwa5Le5qJ2HSwg=;
        b=Y9i1ua/44Z0uoNLPi5k3fMsAhgG2/US2gfx0HHclxIkdPN2l+CYD2WOHQSxPM0R2KdnWIW
        zZfNVd77oo5jABt8YgzLhXzF94WT7Zjo/eSymkrMVhq0KLPbV0u8cpMAg+F9W1mhHVIbJw
        KRmUVMR71AZSuO8kaUiNkc7kdDQ98QI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-LTLFTFDuMkmlSLn1A2rf2w-1; Wed, 14 Sep 2022 07:11:40 -0400
X-MC-Unique: LTLFTFDuMkmlSLn1A2rf2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9531A3C025C7;
        Wed, 14 Sep 2022 11:11:39 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E81791759E;
        Wed, 14 Sep 2022 11:11:37 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Subject: [PATCH net] sfc: fix null pointer dereference in efx_hard_start_xmit
Date:   Wed, 14 Sep 2022 13:11:35 +0200
Message-Id: <20220914111135.21038-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trying to get the channel from the tx_queue variable here is wrong
because we can only be here if tx_queue is NULL, so we shouldn't
dereference it. As the above comment in the code says, this is very
unlikely to happen, but it's wrong anyway so let's fix it.

I hit this issue because of a different bug that caused tx_queue to be
NULL. If that happens, this is the error message that we get here:
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
  [...]
  RIP: 0010:efx_hard_start_xmit+0x153/0x170 [sfc]

Fixes: 12804793b17c ("sfc: decouple TXQ type from label")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index d12474042c84..c5f88f7a7a04 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -549,7 +549,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 		 * previous packets out.
 		 */
 		if (!netdev_xmit_more())
-			efx_tx_send_pending(tx_queue->channel);
+			efx_tx_send_pending(efx_get_tx_channel(efx, index));
 		return NETDEV_TX_OK;
 	}
 
-- 
2.34.1

