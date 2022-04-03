Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A544F09AE
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiDCNMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345979AbiDCNLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:11:21 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9059B27B22
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:46 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h16so4365004wmd.0
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qR0CNrwB97TJccmTjLshQeiDj/mDiBlEwPLgtdaERnc=;
        b=QBhYfWDNXisDdliMa3dC1Gc0AwJ0OphUWSNOmJWjKiLeA/Cn60VhLhttluNEsxLl8R
         Z03Co/2g9O4nUcU95357YVb6us75chYcaB+8EBGxB21kSWDLoWhe+Tqy1grrbpZo3PEU
         1N0IPpOO5uc3IVBlzR6lda/BogyJ6vh14WeXrCQm75LPb/jez2DfIMNmQwn1fNhN2U+X
         26C3EKENP9b/bwWLxb2iJLiCNzNFutcsIuefDsEns4Q1VlWXnD46fXI3ET4mOONiuBQQ
         q37v8JAWM346qNACuysbDH7uv2jhjXMF5EtKA4aPs5e+mtv1OI3mFbBxU3PrdEoLgHna
         IErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qR0CNrwB97TJccmTjLshQeiDj/mDiBlEwPLgtdaERnc=;
        b=MUqahmtPH1qGyf1ex6Aj0mwK1YfPc5zW8PJSaHwnu9k/RjQbHLt803HXZuezdlDtNz
         uX47XXbGdz96sXmsRqfIh/gz5xdSNp36w5ON88l29yAAJlhWFmyrqXDz9ANP5igyo5im
         9qwTmFXVV7r23G3D4K++s4bHSS1w3kD12vyS/eLrRwYJfxawYFDF3ohXWLUmBmID7+BG
         CWm7BqnICWCXGvOFiWS+jBigogUSNcaAWXnxsHQRBhi4mUcswXso7LztYJK/QunRR1fV
         ejuWyV5Yy7w3PlWh1lu9TTxX3BE1dcnR+Lk1BJz8Y3jo4+sEpE6tmWDHRFJTlcaJpna2
         WIVg==
X-Gm-Message-State: AOAM532KdVeo5AZrjyaq6OFiR1p+Uh6dFpUZb97VkkcXYb8SExxTF9+X
        wszST/lMwIsnOWzyPMrNDS+/60KYaPQ=
X-Google-Smtp-Source: ABdhPJyJIacOc7HZ9N39EFsW484ZnhMRBFvX24Zhz6pSISKfPa4MNmTsV6PEnhbBQYeqZsfrgfwjtg==
X-Received: by 2002:a7b:cb93:0:b0:38e:710e:8934 with SMTP id m19-20020a7bcb93000000b0038e710e8934mr660512wmi.83.1648991324858;
        Sun, 03 Apr 2022 06:08:44 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 27/27] ipv6: clean up ip6_setup_cork
Date:   Sun,  3 Apr 2022 14:06:39 +0100
Message-Id: <d0bcc4061f4ecb316b5c25758942bdcd162fd8d1.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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
index f7c092af64f5..e10b7f42e493 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1356,15 +1356,13 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
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
@@ -1397,28 +1395,26 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
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
2.35.1

