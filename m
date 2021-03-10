Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE6B3338E8
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhCJJgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:36:36 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:47098 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232598AbhCJJgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:36:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5086420270;
        Wed, 10 Mar 2021 10:36:19 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tuBbGV5kGhKy; Wed, 10 Mar 2021 10:36:18 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D2C2720080;
        Wed, 10 Mar 2021 10:36:18 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Mar 2021 10:36:18 +0100
Received: from moon.secunet.de (172.18.26.121) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 10 Mar
 2021 10:36:18 +0100
Date:   Wed, 10 Mar 2021 10:36:11 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Antony Antony <antony.antony@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Yossi Kuperman <yossiku@mellanox.com>,
        "Guy Shapiro" <guysh@mellanox.com>, <netdev@vger.kernel.org>,
        <antony@phenome.org>
Subject: [PATCH] xfrm: return error when esp offload is requested and not
 supported
Message-ID: <20210310093611.GA5406@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ESP offload is not supported by the device return an error,
-EINVAL, instead of silently ignoring it, creating a SA without offload,
and returning success.

with this fix ip x s a would return
RTNETLINK answers: Invalid argument

Also, return an error, -EINVAL, when CONFIG_XFRM_OFFLOAD is
not defined and the user is trying to create an SA with the offload.

Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 include/net/xfrm.h     | 2 +-
 net/xfrm/xfrm_device.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index bfbc7810df94..05d9f178093c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1914,7 +1914,7 @@ static inline struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_fea

 static inline int xfrm_dev_state_add(struct net *net, struct xfrm_state *x, struct xfrm_user_offload *xuo)
 {
-	return 0;
+	return -EINVAL;
 }

 static inline void xfrm_dev_state_delete(struct xfrm_state *x)
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index edf11893dbe8..1e1a9493c8db 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -250,7 +250,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	if (!dev->xfrmdev_ops || !dev->xfrmdev_ops->xdo_dev_state_add) {
 		xso->dev = NULL;
 		dev_put(dev);
-		return 0;
+		return -EINVAL;
 	}

 	if (x->props.flags & XFRM_STATE_ESN &&
--
2.20.1

