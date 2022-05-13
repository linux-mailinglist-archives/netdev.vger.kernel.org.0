Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1377526617
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382064AbiEMP1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382012AbiEMP1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:27:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44666248DD;
        Fri, 13 May 2022 08:26:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id z2so16958770ejj.3;
        Fri, 13 May 2022 08:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ojlGOBCpkisLhdBLZc5xu5fbD3iLbV6lB886LLnQg1w=;
        b=FxnvipMwHXfyVVeiBLqbMdLNV5U4F0yr5igQCC7dsfDdEcL35Nh+CKGbHkSA2RRujI
         qRtj6fP0onfppiUtnZFstFQyer4u9ERWj8xeNVoyiRQr4kOhm8FRiv2uo4rxrBv/eT3W
         WyrDkp5sddZ+j4YnzAWpV7Yoo9XgnO+vIHqAik5b03AtuSM36WxAnnalkp+W2Uot+61/
         gh+cqGZoYUFujdSW4ZN3DzbNUK4BLV7hOVZRStVIe9MkXNtnUhAcIPeEIYeshloz5bwu
         IANF26vuHPdCB+o/XARjfVwKTAHTvrvmcH41BfbW7ZdV68InWVMq68x5z3mls5qKHjaa
         YlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojlGOBCpkisLhdBLZc5xu5fbD3iLbV6lB886LLnQg1w=;
        b=Tj/v412+JPjDGboqsIb0odOZzmi07O8F+WKSNVQe3v1UcCKN3/Gi2rP6NW2IL0FUJ7
         59oMRoiWUCX1dTGdlXjjn18wsnVDuSJgm+RZsbjPWXaiSAjETDasfazIfICiT2u6nCMP
         qavYfFPYs7VzdyJDIbXxpEwhorGqBD2uVrGXUO0hn0sGaW5LEmX53mjJHkAwEAlV+BHt
         lWqsgsFHs1otjHDnstSXnykxz6Z+nRPZf0bdu/k0nifDv0Ro95yStAWRSybiOVkk8PKA
         C+ZJq743X4bcfOe0Tu7ZHFax5dmC5nj2MuzxSrbC2hCH29CxPXJ0LP6WajmY705449CW
         58BA==
X-Gm-Message-State: AOAM532Fc6PJtldvPIXkeexZMCPnUFsNo8ijToyO57Wrlmp5C/5WEQOU
        BbYa2FqdqS3R5asX5H746B/EHwh5hSs=
X-Google-Smtp-Source: ABdhPJwwrP/iB1n7B9SUctoDqawFOEMzLHfDXlG7K8RA7Xk3mMBBmsfD0iJsfYwuW2CGYhvrNWG+xA==
X-Received: by 2002:a17:906:24db:b0:6f3:a29f:95dc with SMTP id f27-20020a17090624db00b006f3a29f95dcmr4979024ejb.520.1652455617555;
        Fri, 13 May 2022 08:26:57 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 10/10] ipv6: clean up ip6_setup_cork
Date:   Fri, 13 May 2022 16:26:15 +0100
Message-Id: <b1847becb141a0c57ca9d8267fab88a41895273b.1652368648.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 6ee44c509485..61dfe3eca773 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1359,15 +1359,13 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
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
@@ -1400,28 +1398,26 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
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

