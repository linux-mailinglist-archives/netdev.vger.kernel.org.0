Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A54D46DD96
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhLHV2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:28:41 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:55686 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234732AbhLHV2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 16:28:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0FA4F2049A;
        Wed,  8 Dec 2021 22:25:06 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CG7zuaS0F1iI; Wed,  8 Dec 2021 22:25:05 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 73FC62035C;
        Wed,  8 Dec 2021 22:25:05 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 6763680004A;
        Wed,  8 Dec 2021 22:25:05 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 8 Dec 2021 22:25:05 +0100
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Wed, 8 Dec
 2021 22:25:04 +0100
Date:   Wed, 8 Dec 2021 22:24:41 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Antony Antony <antony.antony@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Tobias Brunner <tobias@strongswan.org>
Subject: [PATCH RFC ipsec-next] xfrm: update SA curlft.use_time
Message-ID: <804cfcc194d3ae3d4a871d42f749cc2356da5881.1638998514.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <YanYgmJwrC3REnKc@AntonyAntony.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YanYgmJwrC3REnKc@AntonyAntony.local>
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SA use_time was only updated once, for the first packet.
with this fix update the use_time for every packet.

Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_input.c  | 1 +
 net/xfrm/xfrm_output.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 70a8c36f0ba6..144238a50f3d 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -669,6 +669,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)

 		x->curlft.bytes += skb->len;
 		x->curlft.packets++;
+		x->curlft.use_time = ktime_get_real_seconds();

 		spin_unlock(&x->lock);

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index f165ffc77078..38f62f5c69d8 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -536,6 +536,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)

 		x->curlft.bytes += skb->len;
 		x->curlft.packets++;
+		x->curlft.use_time = ktime_get_real_seconds();

 		spin_unlock_bh(&x->lock);

--
2.30.2

