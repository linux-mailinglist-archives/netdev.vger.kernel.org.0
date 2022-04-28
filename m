Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4D95135FF
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347887AbiD1OCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347910AbiD1OCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:18 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B999B53C7;
        Thu, 28 Apr 2022 06:59:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id m20so9717436ejj.10;
        Thu, 28 Apr 2022 06:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YHrgbwGuKsi0qBohJI6HWm6IXg77xQmft6cGgAr+KkM=;
        b=D/HtnO6Aq48sBMFVHSTn0tBOvJAS5dJDgM08hwx7/5YbiCOLqMka9aC35l1YEEEBAc
         AdvVf4YC6yaPDNKm0TndoQommkvI+axGOg+U8cq6/nHZvR1MiDjpVSmpOdqXgfaWG0Qm
         mQV81m14BxeKQyjtoutd/0XL2F9Cx+j3506jw6aI/uRhWpyYkwqi1ldfxQRgfVkpmotx
         TKQAIevVT84OeGwocHNI3aHsxz9E1ebWMMeshawlonpisRA0jfU/B6Zjjq+CdHcs6MEP
         LbGtzqtRjoC+rbkP1S6i5xTfLRRbmxj6Gy90AROgTZYbDyuYllzU3jnvbTJBiqywjUg9
         Maag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHrgbwGuKsi0qBohJI6HWm6IXg77xQmft6cGgAr+KkM=;
        b=Au1HzMf9hwN1r28YshtG6TNlrRHYP5MfyxpT/GftBus+oPtiOK3tDwDuqQaOeBOmz0
         kop9fx6RsD4b/9sNXkaH5fRQ6M6CjWxEepP6Es2MG/7VjldNCP55gKTigM7LPdDnbt0z
         sX32aN1E5IPikceBzzT1Gn1MSx2cVV+e8BpcALdorQtm0Ap01BG9NdwRZy+Ljjje3y4j
         4U4IR4M2C22iE5dJd+GpGN1Lnab+m8E0EBXmE2J7GrhxAMgXopBY1nFta6/ameGGWEGL
         mkyeLgkFZjAU5DWJZSq0l0iB58bvtIsk54KG+PuRfIzrIT38DrgmmZDQr57lcxjgUyul
         G16w==
X-Gm-Message-State: AOAM532CKHTYlZ7m8lhMYGBv+M4Nz5DsXDbG27ar1V6cRpc68uhir2A8
        DOpIL82jprxQuw27HkHxQepbqq2p3cs=
X-Google-Smtp-Source: ABdhPJzqaDZwQbXPQRg01MR4TeZZwO5015Um2IKY51lgJLpQa73xeqWoAZyG4Eq8glJMto3TJeg7Ow==
X-Received: by 2002:a17:907:160e:b0:6ef:ec95:f9e1 with SMTP id hb14-20020a170907160e00b006efec95f9e1mr32436049ejc.10.1651154339253;
        Thu, 28 Apr 2022 06:58:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 11/11] ipv6: clean up ip6_setup_cork
Date:   Thu, 28 Apr 2022 14:58:06 +0100
Message-Id: <683aab669ffa7db48416137c904a406a37e9a0c9.1651153920.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651153920.git.asml.silence@gmail.com>
References: <cover.1651153920.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do a bit of refactoring for ip6_setup_cork(). Cache a xfrm_dst_path()
result to not call it twice, reshuffle ifs to not repeat some parts
twice and so.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 416d14299242..a17b26d5f34d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1358,15 +1358,13 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	unsigned int mtu;
 	struct ipv6_txoptions *nopt, *opt = ipc6->opt;
+	struct dst_entry *xrfm_dst;
 
 	/* callers pass dst together with a reference, set it first so
 	 * ip6_cork_release() can put it down even in case of an error.
 	 */
 	cork->base.dst = &rt->dst;
 
-	/*
-	 * setup for corking
-	 */
 	if (opt) {
 		if (WARN_ON(v6_cork->opt))
 			return -EINVAL;
@@ -1399,28 +1397,26 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	}
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
-	if (rt->dst.flags & DST_XFRM_TUNNEL)
-		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
-		      READ_ONCE(rt->dst.dev->mtu) : dst_mtu(&rt->dst);
+
+	xrfm_dst = xfrm_dst_path(&rt->dst);
+	if (dst_allfrag(xrfm_dst))
+		cork->base.flags |= IPCORK_ALLFRAG;
+
+	if (np->pmtudisc < IPV6_PMTUDISC_PROBE)
+		mtu = dst_mtu(rt->dst.flags & DST_XFRM_TUNNEL ? &rt->dst : xrfm_dst);
 	else
-		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
-			READ_ONCE(rt->dst.dev->mtu) : dst_mtu(xfrm_dst_path(&rt->dst));
-	if (np->frag_size < mtu) {
-		if (np->frag_size)
-			mtu = np->frag_size;
-	}
+		mtu = READ_ONCE(rt->dst.dev->mtu);
+
+	if (np->frag_size < mtu && np->frag_size)
+		mtu = np->frag_size;
+
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
 	cork->base.mark = ipc6->sockc.mark;
 	sock_tx_timestamp(sk, ipc6->sockc.tsflags, &cork->base.tx_flags);
-
-	if (dst_allfrag(xfrm_dst_path(&rt->dst)))
-		cork->base.flags |= IPCORK_ALLFRAG;
 	cork->base.length = 0;
-
 	cork->base.transmit_time = ipc6->sockc.transmit_time;
-
 	return 0;
 }
 
-- 
2.36.0

