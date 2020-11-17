Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E12B703F
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgKQUiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:38:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9042 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgKQUiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:38:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb434aa0000>; Tue, 17 Nov 2020 12:38:02 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:38:02 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [PATCH net 2/2] net: Call skb destructor on NAPI_GRO_FREE_STOLEN_HEAD
Date:   Tue, 17 Nov 2020 12:33:55 -0800
Message-ID: <20201117203355.389661-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117203355.389661-1-saeedm@nvidia.com>
References: <20201117203355.389661-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605645482; bh=n6upADOkEb84x8Lz5LHj4EtwzD79V71n+AkP7zRGTws=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=M4RN4hJExq5jFhWomTl6Exq2UodYfhFtzLfHgV3PIhES6kYrTOMftwdpGAZ6ZbUR5
         8FKRAnh7qx7xVBCsM4avBMnWqojkGr/cp/VF3zX+8QRmw2y82cjmLdgrrrxrNlhDok
         lAtRTk4ewQijmFYdxKO+V9IY7YX8iM0L/YUDUjSswQLivIA7zweOZ5v434amDnmfBV
         h7STQr7jntM39sRwx7bQo01PjuGZIZMPtge/yXtm5mc7bB/adRYOB4GhdWJU9+b1gX
         a1QR+g8gRhtSb0VSwRmNQQ7rkFzK54s+eKQSrhqqpUieBR+I16PuJZQoM3E4c8xegx
         87y/3mQsuJRvg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

All GRO flows except one call skb->destructor, however, GRO_MERGED_FREE
doesn't do it in case of NAPI_GRO_FREE_STOLEN_HEAD. For better
consistency and to add resiliency against the drivers that may pass SKBs
with a destructor, this patch changes napi_skb_free_stolen_head to use
skb_release_head_state, which should perform all the needed cleanups,
including a call to the destructor. This way the code of GRO_MERGED_FREE
becomes similar to kfree_skb_partial.

Fixes: e44699d2c280 ("net: handle NAPI_GRO_FREE_STOLEN_HEAD case also in na=
pi_frags_finish()")
Fixes: d7e8883cfcf4 ("net: make GRO aware of skb->head_frag")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
For -stable: 5.4

 net/core/dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 82dc6b48e45f..85dcc7f19902 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6048,8 +6048,7 @@ EXPORT_SYMBOL(gro_find_complete_by_type);
=20
 static void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
-	skb_dst_drop(skb);
-	skb_ext_put(skb);
+	skb_release_head_state(skb);
 	kmem_cache_free(skbuff_head_cache, skb);
 }
=20
--=20
2.26.2

