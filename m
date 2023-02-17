Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BA769A889
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjBQJqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBQJqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:46:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE4F3A9A
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 01:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676627147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=J7JYXyzu7HeaLauJruraDYc3KfnEEgDfWko7tD975N0=;
        b=TtrXii/B4Jvs+EsckC/nGRVfnUM96FDwMxZYWzvwskkG/wGzyXyp5i+D3tc/OAVmRjra52
        fGTUJ+VCGZTkBZZmqVVTvVK7e8upelizCC9Zix+vjCtt3pweAgOJH49ls3YoZHNlIosSf+
        tFkjG+CucokUQZ2IWVrTT7Q8RDEt+tg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-xTLq94TZMyaxh9fkygDAXA-1; Fri, 17 Feb 2023 04:45:46 -0500
X-MC-Unique: xTLq94TZMyaxh9fkygDAXA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B86A886462;
        Fri, 17 Feb 2023 09:45:45 +0000 (UTC)
Received: from TPP1.redhat.com (ovpn-193-244.brq.redhat.com [10.40.193.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75EF5492C18;
        Fri, 17 Feb 2023 09:45:43 +0000 (UTC)
From:   Josef Oskera <joskera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Josef Oskera <joskera@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        linux-rdma@vger.kernel.org (open list:MELLANOX MLX4 core VPI driver),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] mlx4: supress fortify for inlined xmit
Date:   Fri, 17 Feb 2023 10:45:41 +0100
Message-Id: <20230217094541.2362873-1-joskera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This call "skb_copy_from_linear_data(skb, inl + 1, spc)" triggers FORTIFY memcpy()
warning on ppc64 platform.

In function ‘fortify_memcpy_chk’,
    inlined from ‘skb_copy_from_linear_data’ at ./include/linux/skbuff.h:4029:2,
    inlined from ‘build_inline_wqe’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:722:4,
    inlined from ‘mlx4_en_xmit’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:1066:3:
./include/linux/fortify-string.h:513:25: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  513 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Same behaviour on x86 you can get if you use "__always_inline" instead of
"inline" for skb_copy_from_linear_data() in skbuff.h

The call here copies data into inlined tx destricptor, which has 104 bytes
(MAX_INLINE) space for data payload. In this case "spc" is known in compile-time
but the destination is used with hidden knowledge (real structure of destination
is different from that the compiler can see). That cause the fortify warning
because compiler can check bounds, but the real bounds are different.
"spc" can't be bigger than 64 bytes (MLX4_INLINE_ALIGN), so the data can always
fit into inlined tx descriptor.
The fact that "inl" points into inlined tx descriptor is determined earlier
in mlx4_en_xmit().

Fixes: f68f2ff91512c1 fortify: Detect struct member overflows in memcpy() at compile-time
Signed-off-by: Josef Oskera <joskera@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index c5758637b7bed6..f30ca9fe90e5b4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -719,7 +719,16 @@ static void build_inline_wqe(struct mlx4_en_tx_desc *tx_desc,
 			inl = (void *) (inl + 1) + spc;
 			memcpy(((void *)(inl + 1)), fragptr, skb->len - spc);
 		} else {
-			skb_copy_from_linear_data(skb, inl + 1, spc);
+			unsafe_memcpy(inl + 1, skb->data, spc,
+					/* This copies data into inlined tx descriptor, which has
+					 * 104 bytes (MAX_INLINE) space for data.
+					 * Real structure of destination is in this case hidden for
+					 * the compiler
+					 * "spc" is compile-time known variable and can't be bigger
+					 * than 64 (MLX4_INLINE_ALIGN).
+					 * Bounds and other conditions are checked in current
+					 * function and earlier in mlx4_en_xmit()
+					 */);
 			inl = (void *) (inl + 1) + spc;
 			skb_copy_from_linear_data_offset(skb, spc, inl + 1,
 							 hlen - spc);
-- 
2.39.0

