Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1D567D510
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjAZTHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjAZTHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:07:08 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E34526F;
        Thu, 26 Jan 2023 11:07:01 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id k13so2776421plg.0;
        Thu, 26 Jan 2023 11:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uCv4gRxFA6EVdh6HH0URpLxFamW9QobkbMQUcrragFA=;
        b=d7zk+ziM5pl3fshYkdFnHqJelj/bCdpeh61z0rKS3HyiBOxqqSaSrpmOOjue+oFzkA
         tiXUtVosjqMu4+mh3INRd10ByCUaavhnwKIzlEMvnLp5j/HmIC4r/1ag9aLrea7cEhn1
         lqaWCPflpEsHOHnuDKlsFlFhSwNtQymZ9qNJxw8L3ydnUSV4xQUJCK9or+zPVB7z66fD
         sPApZtNqFXZacMd1MHJny2jBYh1w843FZSMeHa6M5UqTQsL80av6VqgHXS1ev5rU5ATh
         Oa9uxUgTplrbNV09S3P/iiWdBWBVqn0g+XlLnFQ5dQqzGQm7iw5rRCou6VnaM6it6Hg2
         t0yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uCv4gRxFA6EVdh6HH0URpLxFamW9QobkbMQUcrragFA=;
        b=Bx/owZFQZ4eAdH2LA06yalxsjUJ6uZ+WWMAFsIPDV4XfLAzfXQEU+U/OqJYbm5f9ay
         uIJiCFoYqSGzUtNzLRSGrQi3evvAKXYiYriiKFz2pw9Sii/j3XstHJqouRjMy50sHVDU
         vu2NsCCCGV5zuuXIYhCi8NwjEZGvqDBcTOUHedjkLT9i+72o0ejPfvaDt3vmfrLh+ypk
         zFPniaPhLwyWYiUDUr7fEhShinIfePeK8zeojC7yP65aeIM7kb58mWNmd9hbBcSdfYBq
         0fxaAu7LT/fEyqgd4n7zCwQEotT02yYMhbIX5UC4FMMxgfsU5dtMxFZHBLOWmWwr2y6R
         HtZQ==
X-Gm-Message-State: AO0yUKVmzeKSPWxToYF75IuxT+pGIrpvXbJn//i3hyJnG7OVPa8WHTlv
        8UsKpCmHWkwJM4qQDmTVBW8=
X-Google-Smtp-Source: AK7set/OLpLWySmoIoTSIuSxTXA7Mlwa8/JW/hSOI/oQhinkbOnkQxACuK0hnP5jEQ99H5J9ABEIaA==
X-Received: by 2002:a17:90b:4d81:b0:22c:1e60:dc04 with SMTP id oj1-20020a17090b4d8100b0022c1e60dc04mr3291871pjb.16.1674760020927;
        Thu, 26 Jan 2023 11:07:00 -0800 (PST)
Received: from localhost.localdomain ([98.97.119.47])
        by smtp.gmail.com with ESMTPSA id e11-20020a17090a728b00b00229094aabd0sm3632313pjg.35.2023.01.26.11.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 11:07:00 -0800 (PST)
Subject: [net PATCH] skb: Do mix page pool and page referenced frags in GRO
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nbd@nbd.name
Cc:     alexander.duyck@gmail.com, davem@davemloft.net,
        edumazet@google.com, hawk@kernel.org, ilias.apalodimas@linaro.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linyunsheng@huawei.com, lorenzo@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Date:   Thu, 26 Jan 2023 11:06:59 -0800
Message-ID: <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
In-Reply-To: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

GSO should not merge page pool recycled frames with standard reference
counted frames. Traditionally this didn't occur, at least not often.
However as we start looking at adding support for wireless adapters there
becomes the potential to mix the two due to A-MSDU repartitioning frames in
the receive path. There are possibly other places where this may have
occurred however I suspect they must be few and far between as we have not
seen this issue until now.

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
Reported-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/core/gro.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/gro.c b/net/core/gro.c
index 506f83d715f8..4bac7ea6e025 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -162,6 +162,15 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	struct sk_buff *lp;
 	int segs;
 
+	/* Do not splice page pool based packets w/ non-page pool
+	 * packets. This can result in reference count issues as page
+	 * pool pages will not decrement the reference count and will
+	 * instead be immediately returned to the pool or have frag
+	 * count decremented.
+	 */
+	if (p->pp_recycle != skb->pp_recycle)
+		return -ETOOMANYREFS;
+
 	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
 	gro_max_size = READ_ONCE(p->dev->gro_max_size);
 


