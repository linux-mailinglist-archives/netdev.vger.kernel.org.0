Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B90690320
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBIJQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjBIJQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:16:57 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C315FC1
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:16:54 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d2so1488952pjd.5
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 01:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rx8xgWCTMGFUO/QdF9ZJt6tiVllLpmSz6C8gWpJ1GsQ=;
        b=GGpEqV5ZYmdifveWfBL6biU3V2yhXIBSJouoZ/iYD52eaiUVgCl3VE2dGg7Kczut2a
         ltsPiPvJazrvTTdXgHireqE0bbrmv8fEwc2LSDmFWCY85b5Cci+OvMERChYJ7ySj/SY2
         YLL5p+OHKYOOIfzab0R9YRPVgKBp8xVHTvTs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rx8xgWCTMGFUO/QdF9ZJt6tiVllLpmSz6C8gWpJ1GsQ=;
        b=3MejjcJYO+jIqurgNGTmP9rR8keqinOY/BvUZEHMITxKm67dYWgAiRo0SDSgVokWvh
         GdisQJU4jyW6f6YRPbmyZGSUsiq9Lirlhx1LlmDxqfqD301pMiEP0NjEpIrPm1YFNbWR
         EoNgP7ESE/PY2AgMZlhnFcVE/9QTFaX7jt1RXovlBUYOmoprLe3G/UkQ9GX2GpJjNgvC
         /kVI0jpkMx2c0xa7Rfd//9btsQbpIgWQuYzzyGKyIYC4J7Lw4oUyGozNl8VQVMI9jPd7
         YTgSNK5AbXu4sYGbacCLViluC4xKIxEtytJx6YEvwnhU76NK5TVzmr+pNiyKVqiSkCAQ
         xq1g==
X-Gm-Message-State: AO0yUKXsjYEy/pS4cPBwcFsctTDAAl1dmmcCDEertyJZSzUqRPr+Tl25
        n0jNAhf94vg32LiHp5dVpmmoow==
X-Google-Smtp-Source: AK7set9JtP/nnZGC0hsN7IS5u3A18r1Hpn1J1PlNKj/1k8VC/4uB0hxsmQWYxnc4FHomfrfI+QyrnQ==
X-Received: by 2002:a17:903:246:b0:198:ff11:2600 with SMTP id j6-20020a170903024600b00198ff112600mr12273089plh.2.1675934214145;
        Thu, 09 Feb 2023 01:16:54 -0800 (PST)
Received: from ubuntu ([106.101.2.46])
        by smtp.gmail.com with ESMTPSA id v12-20020a1709029a0c00b0019339f3368asm981340plp.3.2023.02.09.01.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 01:16:53 -0800 (PST)
Date:   Thu, 9 Feb 2023 01:16:48 -0800
From:   Hyunwoo Kim <v4bel@theori.io>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sabrina Dubroca <sd@queasysnail.net>,
        steffen.klassert@secunet.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     v4bel@theori.io, imv4bel@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2] af_key: Fix heap information leak
Message-ID: <20230209091648.GA5858@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since x->encap of pfkey_msg2xfrm_state() is not
initialized to 0, kernel heap data can be leaked.

Fix with kzalloc() to prevent this.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 net/key/af_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 2bdbcec781cd..a815f5ab4c49 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1261,7 +1261,7 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
 		const struct sadb_x_nat_t_type* n_type;
 		struct xfrm_encap_tmpl *natt;
 
-		x->encap = kmalloc(sizeof(*x->encap), GFP_KERNEL);
+		x->encap = kzalloc(sizeof(*x->encap), GFP_KERNEL);
 		if (!x->encap) {
 			err = -ENOMEM;
 			goto out;
-- 
2.25.1

