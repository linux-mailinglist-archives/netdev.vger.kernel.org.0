Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A805154049E
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345506AbiFGRSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345503AbiFGRR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:17:58 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B082077F02
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:17:54 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id e11so16073517pfj.5
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z0Lo7KdcQV5V1+hy9GBEXahSN5MlosYjYm/RYugMrYw=;
        b=AtO3vumNPd4lBLaz8y0mGRuQhOsZwkUZEx6Oj/7d6Hmf4ylQuBnL9dBgmiloaYDZKA
         lIoyLy173ln0AfIHY/UtarmMXKYtY/Wc+JFW0+iJUor5wDYGw/R8DBUao3kwuj4sNHUg
         8pRcjWYPN/m2xUKpVOS845jPJSJpynC2tRbRVSwzfnKkDSxo9oYADyMCmOSbru5/fhiH
         yP9mnM1QPqAT2M+uQ6Y9lUMU1SBy2RSsEaZ6ddps1VGyyVjILT33uQ/QQEGAR+XoA3H2
         AWMV/i3fwmJox2HV0EFNDyScCpdfcFkxm6zsGxD/3RouBya0VX4M8cKO91M5WU1bec8y
         iUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z0Lo7KdcQV5V1+hy9GBEXahSN5MlosYjYm/RYugMrYw=;
        b=HgkNbaSgj9QlWgHrlxI4NbEVm7bVVSwAJ1JmeBa61SkSgS0GmGg4m9GEdLJ8gP6Dvi
         Qr2lV9YGB+NQLauwGfCV0CD/WCopJtnTXHXx0ePrE4v3ODIE0xH20IXQPILVNNovTAKl
         0EpHqnnDdgBBwO/v+/S9ROTZRSU4X9s1UDpNf8xhZ+pfq58tMlX0EwHYDw2A81cdfjGC
         m+y3h3J5FeE8oDdV4+X7Oydfo4QdqBgh3wwve5OMDxD2Iq2E3UCagJMRmPvqCbU6llKQ
         00gN4zjw6e8bvnRSAPKHZ6M92pJatxnigjnBwCIkrNDRhRx6PPlCtreRII28S2rUEc6/
         M65g==
X-Gm-Message-State: AOAM530VC9vAlQ0x1x0ayyhCoNUXwaulCk6jOnJO1BF1QZsTBm9V8+a6
        HArTmIlCjgub/S6NcK36BGR2e127ScY=
X-Google-Smtp-Source: ABdhPJxkQk8/rY7wZmFH7Q50mXwOUhh5kkyXRGtcZBOn1th9Nz1oP7lM8VVnLqenuzvQQ5jr7BEl4Q==
X-Received: by 2002:a65:618e:0:b0:3fb:177f:d365 with SMTP id c14-20020a65618e000000b003fb177fd365mr26229532pgv.265.1654622274252;
        Tue, 07 Jun 2022 10:17:54 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm13001616pfd.135.2022.06.07.10.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:17:52 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 7/8] net: add debug checks in napi_consume_skb and __napi_alloc_skb()
Date:   Tue,  7 Jun 2022 10:17:31 -0700
Message-Id: <20220607171732.21191-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607171732.21191-1-eric.dumazet@gmail.com>
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Commit 6454eca81eae ("net: Use lockdep_assert_in_softirq()
in napi_consume_skb()") added a check in napi_consume_skb()
which is a bit weak.

napi_consume_skb() and __napi_alloc_skb() should only
be used from BH context, not from hard irq or nmi context,
otherwise we could have races.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index cf83d9b8f41dc28ae11391f2651e5abee3dcde8f..fec75f8bf1f416f05c14f76009a15412b2559b6e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -560,6 +560,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 	struct sk_buff *skb;
 	void *data;
 
+	DEBUG_NET_WARN_ON_ONCE(!in_softirq());
 	len += NET_SKB_PAD + NET_IP_ALIGN;
 
 	/* If requested length is either too small or too big,
@@ -981,7 +982,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 		return;
 	}
 
-	lockdep_assert_in_softirq();
+	DEBUG_NET_WARN_ON_ONCE(!in_softirq());
 
 	if (!skb_unref(skb))
 		return;
-- 
2.36.1.255.ge46751e96f-goog

