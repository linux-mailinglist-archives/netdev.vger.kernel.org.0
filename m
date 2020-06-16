Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF3C1FBD27
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbgFPRhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgFPRhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:37:52 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5794C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:51 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b5so9823893pfp.9
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=/2x+x6/EXHMosj9/XKEHqgqlxb+0TqzXOMFNfOMaTKM=;
        b=PRnqeBJKkFgmAy6ULHFEuhQ6NjqK6SVp4YreqzkEWy7ZfWdC3AN5LoXtmUhF8G7sqY
         /zn2Bm/DDZ3Cc2VD/X3Z+lqnS8TJwLZjhOG7+4fzXoCgPdaAY6yvnW2Vbz1gwYYFmnJR
         t0AEZFVAm+Zjb//x+hl54yqgOtGh5JeeVo39v2nvqukaYsOTdKSQdGfYmNHjl5xHU5Ey
         7Fsnkds3WsoV87BlflaAcFzHbCaOiP9ootWKnCN2KXOf2kh39vBSqVo2dy58KpN3cFD0
         4iWW57zwFtns0poOp925RYajG7QRXxTgXDCm1yc4mfPzTUR58hNdkcq2WjzXldbkLCFT
         qnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=/2x+x6/EXHMosj9/XKEHqgqlxb+0TqzXOMFNfOMaTKM=;
        b=VuCCb2cKg9xplDpdaSZiKV6BfJTBE3Yvo/UORNlqw6C4Gcp5Ux180RaLoH7HFhZk2Z
         Js0jkNNBhFC1SZsiNgbGqbBeCCi02lMtcud36hk6TKngP5iGQ8kExwJGy72qv7JFuHiU
         IF4hAKcOzI2H66n3kqg7N2b9X5XspVSa1y4oZPJsVBfjI/m750pAN/5skoQjFufwSxZ8
         dRku0fZGyFfXSyPijTZpwNDlXoe/kETwF10gBB8FT46l3veG2l7POnGK8mHSi1k/m0VV
         HKEx/NB65Mr+S7xeN1QvqWUXrSihBgFQ0fu3v9vYiobInDkzU4dv4ACm/KkD8Z4u72HU
         7ArQ==
X-Gm-Message-State: AOAM5322ozUcC/aIFcSnxx9rKj9nKsC8LwhNDxCNGoF5tvux8xVpMOB0
        wzvCjlkp1GtapXw3oK6t2oS9NcInOJQ=
X-Google-Smtp-Source: ABdhPJxoOEK+kPBSh34UQ2otGpcdchzXQgGbxOEcIHdIFhc3PbiY7RfpwCWg2xBQDXyTxcOfxjD0zQ==
X-Received: by 2002:aa7:96e9:: with SMTP id i9mr3157263pfq.232.1592329071226;
        Tue, 16 Jun 2020 10:37:51 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t76sm15809803pfc.220.2020.06.16.10.37.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:37:50 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 08/10] ipcomp: assign if_id to child tunnel from parent tunnel
Date:   Wed, 17 Jun 2020 01:36:33 +0800
Message-Id: <8edff44e79a29474a82406d2f2f395c1229f0993.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <870c43283bd6bd6c3b583c05ebc757879676edcd.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
 <4ad2ff7658148645d2e1947d659d11061013c336.1592328814.git.lucien.xin@gmail.com>
 <cf734a0499457870c5d0fe493a83760aa1bf76c1.1592328814.git.lucien.xin@gmail.com>
 <af54ae84fe9a806e40050e815c975a36cf8e2db9.1592328814.git.lucien.xin@gmail.com>
 <870c43283bd6bd6c3b583c05ebc757879676edcd.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The child tunnel if_id will be used for xfrm interface's lookup
when processing the IP(6)IP(6) packets in the next patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ipcomp.c  | 1 +
 net/ipv6/ipcomp6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 59bfa38..b426832 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -72,6 +72,7 @@ static struct xfrm_state *ipcomp_tunnel_create(struct xfrm_state *x)
 	t->props.flags = x->props.flags;
 	t->props.extra_flags = x->props.extra_flags;
 	memcpy(&t->mark, &x->mark, sizeof(t->mark));
+	t->if_id = x->if_id;
 
 	if (xfrm_init_state(t))
 		goto error;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 99668bf..daef890 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -91,6 +91,7 @@ static struct xfrm_state *ipcomp6_tunnel_create(struct xfrm_state *x)
 	t->props.mode = x->props.mode;
 	memcpy(t->props.saddr.a6, x->props.saddr.a6, sizeof(struct in6_addr));
 	memcpy(&t->mark, &x->mark, sizeof(t->mark));
+	t->if_id = x->if_id;
 
 	if (xfrm_init_state(t))
 		goto error;
-- 
2.1.0

