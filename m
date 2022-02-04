Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EEC4A9867
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 12:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358404AbiBDL32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 06:29:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242738AbiBDL31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 06:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643974167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pFgKGvURpIWEIjp6myIeti75CaYgkAGSwuBhxQ8KquM=;
        b=AqHPYa5HNrsxTloeiqUrfsy+ewe/JQfPKFiRNEZrFF7tocWHaopF7I/IpVw0uWeRu/xBr7
        mUG3LyR6DonLQaI3Tfd/Wmh/NfvDc5M4oi+o/PWtCTMPBYoJxEBpLoTF2R8OTmwyN2dF+k
        bMLF2rrBL8OAr9W4b6/KxjaLLNGuVKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-NU3Z5NWuOb2PSjaROo1QWw-1; Fri, 04 Feb 2022 06:29:24 -0500
X-MC-Unique: NU3Z5NWuOb2PSjaROo1QWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B577B1923B80;
        Fri,  4 Feb 2022 11:29:22 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ED2B1073037;
        Fri,  4 Feb 2022 11:29:20 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander H Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 1/2] net: gro: avoid re-computing truesize twice on recycle
Date:   Fri,  4 Feb 2022 12:28:36 +0100
Message-Id: <9903ebc67ba39368d7a1e93681c65305d868232c.1643972527.git.pabeni@redhat.com>
In-Reply-To: <cover.1643972527.git.pabeni@redhat.com>
References: <cover.1643972527.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb
carring sock reference") and commit af352460b465 ("net: fix GRO
skb truesize update") the truesize of the skb with stolen head is
properly updated by the GRO engine, we don't need anymore resetting
it at recycle time.

v1 -> v2:
 - clarify the commit message (Alexander)

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

