Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E5A4C3F40
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 08:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbiBYHsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 02:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238239AbiBYHsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 02:48:14 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4321AA484
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 23:47:41 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 059122059C;
        Fri, 25 Feb 2022 08:47:40 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5eNGFlFF8PvL; Fri, 25 Feb 2022 08:47:39 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 36B6F20581;
        Fri, 25 Feb 2022 08:47:38 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 3190780004A;
        Fri, 25 Feb 2022 08:47:38 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Fri, 25 Feb 2022 08:47:38 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 25 Feb
 2022 08:47:37 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id BA67A3182F91; Fri, 25 Feb 2022 08:47:36 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 6/6] xfrm: enforce validity of offload input flags
Date:   Fri, 25 Feb 2022 08:47:33 +0100
Message-ID: <20220225074733.118664-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225074733.118664-1-steffen.klassert@secunet.com>
References: <20220225074733.118664-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

struct xfrm_user_offload has flags variable that received user input,
but kernel didn't check if valid bits were provided. It caused a situation
where not sanitized input was forwarded directly to the drivers.

For example, XFRM_OFFLOAD_IPV6 define that was exposed, was used by
strongswan, but not implemented in the kernel at all.

As a solution, check and sanitize input flags to forward
XFRM_OFFLOAD_INBOUND to the drivers.

Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/uapi/linux/xfrm.h | 6 ++++++
 net/xfrm/xfrm_device.c    | 6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 4e29d7851890..65e13a099b1a 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -511,6 +511,12 @@ struct xfrm_user_offload {
 	int				ifindex;
 	__u8				flags;
 };
+/* This flag was exposed without any kernel code that supporting it.
+ * Unfortunately, strongswan has the code that uses sets this flag,
+ * which makes impossible to reuse this bit.
+ *
+ * So leave it here to make sure that it won't be reused by mistake.
+ */
 #define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 3fa066419d37..39bce5d764de 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -223,6 +223,9 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	if (x->encap || x->tfcpad)
 		return -EINVAL;
 
+	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND))
+		return -EINVAL;
+
 	dev = dev_get_by_index(net, xuo->ifindex);
 	if (!dev) {
 		if (!(xuo->flags & XFRM_OFFLOAD_INBOUND)) {
@@ -262,7 +265,8 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	netdev_tracker_alloc(dev, &xso->dev_tracker, GFP_ATOMIC);
 	xso->real_dev = dev;
 	xso->num_exthdrs = 1;
-	xso->flags = xuo->flags;
+	/* Don't forward bit that is not implemented */
+	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
-- 
2.25.1

