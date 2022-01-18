Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE7449299B
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345373AbiARPZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 10:25:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235669AbiARPZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 10:25:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642519516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EIjAmUx69A5OyubPPVEtpS/29f9h1we0607QgH7kyVM=;
        b=KPosYiwAJZk7w5QJ5NqVPFuZm/avx3BnJX1pqUA0bqpL4oVFW3jkpWtIfYNyz/rTmwxTc2
        w03G/WhbZRo2zSWm22KLLgem36kqA8+gXrpvdMsg/MriUxbuzpEs3M/eJ+gZnAk3jP+xLH
        U8btMx1wpD9DNLufNHDxiROfAkNyTPQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-4pUvArwaNhGRta5MsxOwzg-1; Tue, 18 Jan 2022 10:25:14 -0500
X-MC-Unique: 4pUvArwaNhGRta5MsxOwzg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDD6410151E7;
        Tue, 18 Jan 2022 15:25:12 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 214BF106C06F;
        Tue, 18 Jan 2022 15:25:11 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH 1/3] net: gro: avoid re-computing truesize twice on recycle
Date:   Tue, 18 Jan 2022 16:24:18 +0100
Message-Id: <e311f77a9ddb739e3c583201fb99b9945942f68a.1642519257.git.pabeni@redhat.com>
In-Reply-To: <cover.1642519257.git.pabeni@redhat.com>
References: <cover.1642519257.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb
carring sock reference") and commit af352460b465 ("net: fix GRO
skb truesize update") the truesize of freed skb is properly updated
by the GRO engine, we don't need anymore resetting it at recycle time.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/gro.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index a11b286d1495..d43d42215bdb 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -634,7 +634,6 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 
 	skb->encapsulation = 0;
 	skb_shinfo(skb)->gso_type = 0;
-	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 	if (unlikely(skb->slow_gro)) {
 		skb_orphan(skb);
 		skb_ext_reset(skb);
-- 
2.34.1

