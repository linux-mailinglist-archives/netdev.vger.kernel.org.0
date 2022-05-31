Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFF7538FEA
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343783AbiEaLdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiEaLdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:33:50 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099D324F03;
        Tue, 31 May 2022 04:33:49 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b5so12566518plx.10;
        Tue, 31 May 2022 04:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ig4+wp1fU7yx4LD+qy8MKiDUweklCo6s3UZGAjYIIS8=;
        b=RWzKcNEkS3clgbIP82SZJEJdnbGJhs0sn9XFVF6BbZQvEIk4hTdEiiiYg7/JTSR1E7
         5o5CHwZTvI0iE1LP/i4ghUpIPz2iKcY8XHhGhG9AQx2nDW2Nju8R39c1zxaiajS/1pef
         04g6lZRHJMNSHqMuV5k/hUbHuB1FMci/qu3z3xDczQ0RpuVAMcD8kX88V3HwMbTsa7vg
         9u/FPJlW/MpkZCaVTEWh53Ml5+KkoDCLuoi5EERonshpaAC9yLlPZlhhoTYT3QnpTuJt
         VohT7BmVuRP/7iaZySYs1wsYRUefmGMbhKrYtJ5giFGWVBDA8B2DIq8HKbi5aXDnJLms
         HCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ig4+wp1fU7yx4LD+qy8MKiDUweklCo6s3UZGAjYIIS8=;
        b=S11IRYrW6oh2k2w6jc+BtR8iyA3NiWwWAK4qNb0xIi/qzzLn4kAptojlYV6dOhaNi0
         lR2EMeIBUwUFr0L7ubeh+xreD214uyIX+hjSEPcUNv6mfO4UV3Cd8ofbkUKxQLPrc+BD
         89lD1vFAJJSoENI6+I1gDW9y6xA0DPmkSu+VF0Q9xf+7xE28BpMvDpgbc8PhzQMmQRXp
         W4tVivWtu+HgvKFfUe8GVgSPmTG6iKQOTGuLeTrJRMetqln23qZ6bvIjNXkihXkAYmxF
         OJUyJD43YFBo9jttUy9xiv6DBh3ejKNFn/7Fl6QBPmCOvVhJcrI3Qf3yvrhQvZk1D5Z1
         qTMg==
X-Gm-Message-State: AOAM531qcPgDdrhLy+3rD+HU6W8dDaO1VwWZP1IpxWmakP8Eaz7qq381
        7DMi473lNwbv7Wr3xDO+ckN3Ix2bVgY=
X-Google-Smtp-Source: ABdhPJwWFRTavQ4dRo5PjvXLGKZNWFYG0YlKr7SDOWhTaEbiUeczjYya5hL7yfVPX68IneiXgMj0lA==
X-Received: by 2002:a17:90b:380f:b0:1e3:3de5:d60e with SMTP id mq15-20020a17090b380f00b001e33de5d60emr2734565pjb.211.1653996828544;
        Tue, 31 May 2022 04:33:48 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id b11-20020aa7810b000000b0050dc762814bsm10531759pfi.37.2022.05.31.04.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 04:33:48 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, timo.teras@iki.fi
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()
Date:   Tue, 31 May 2022 19:33:36 +0800
Message-Id: <20220531113336.31993-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
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

xfrm_policy_lookup() will call xfrm_pol_hold_rcu() to get a refcount of
pols[0]. This refcount can be dropped in xfrm_expand_policies() when
xfrm_expand_policies() return error. pols[0]'s refcount is balanced in
here. But xfrm_bundle_lookup() will also call xfrm_pols_put() with
num_pols == 1 to drop this refcount when xfrm_expand_policies() return
error.

Fix this by setting num_pols = 0 in xfrm_expand_policies()'s error path.

Fixes: 80c802f3073e ("xfrm: cache bundles instead of policies for outgoing flows")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/xfrm/xfrm_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1876ea61fdc..a511875ef523 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2694,6 +2694,7 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				xfrm_pols_put(pols, *num_pols);
+				*num_pols = 0;
 				return PTR_ERR(pols[1]);
 			}
 			(*num_pols)++;
-- 
2.25.1

