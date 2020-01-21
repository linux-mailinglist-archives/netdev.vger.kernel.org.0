Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03A8143777
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 08:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgAUHQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 02:16:41 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:35772 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgAUHQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 02:16:41 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id ED116204EF;
        Tue, 21 Jan 2020 08:16:39 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eiJ9GGA0q-ET; Tue, 21 Jan 2020 08:16:39 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A401B20523;
        Tue, 21 Jan 2020 08:16:38 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 08:16:38 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5DC0C31802EA;
 Tue, 21 Jan 2020 08:16:38 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/4] xfrm: support output_mark for offload ESP packets
Date:   Tue, 21 Jan 2020 08:16:31 +0100
Message-ID: <20200121071631.25188-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121071631.25188-1-steffen.klassert@secunet.com>
References: <20200121071631.25188-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ulrich Weber <ulrich.weber@gmail.com>

Commit 9b42c1f179a6 ("xfrm: Extend the output_mark") added output_mark
support but missed ESP offload support.

xfrm_smark_get() is not called within xfrm_input() for packets coming
from esp4_gro_receive() or esp6_gro_receive(). Therefore call
xfrm_smark_get() directly within these functions.

Fixes: 9b42c1f179a6 ("xfrm: Extend the output_mark to support input direction and masking.")
Signed-off-by: Ulrich Weber <ulrich.weber@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 2 ++
 net/ipv6/esp6_offload.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 0e4a7cf6bc87..e2e219c7854a 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -57,6 +57,8 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 		if (!x)
 			goto out_reset;
 
+		skb->mark = xfrm_smark_get(skb->mark, x);
+
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index e31626ffccd1..fd535053245b 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -79,6 +79,8 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 		if (!x)
 			goto out_reset;
 
+		skb->mark = xfrm_smark_get(skb->mark, x);
+
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
 
-- 
2.17.1

