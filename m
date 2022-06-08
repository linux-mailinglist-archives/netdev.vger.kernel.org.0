Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A2B54385A
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245121AbiFHQFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245096AbiFHQE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:04:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CA427CD47
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:04:51 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b135so18697987pfb.12
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z0Lo7KdcQV5V1+hy9GBEXahSN5MlosYjYm/RYugMrYw=;
        b=KI7WDV/w0e5o51062ZdbcFaTTBh9UGIi78wkqFmqNvBUY6KPF5U3ielo5OmZByfCsd
         02MHv1+ymnao8EHS19QpOlEFh82Az1ZB5nJdnVB1+FmHg1FBsVSurKAsqmleHtFxOIHX
         YmqnlsC//xeMApumcAKs0/syg/2tbJSsj7kw6XGfX3Fh2D41fiYc6sY+EUX9Q4UzQ9Vm
         lvFuQywvcyMc9quhVbha6PrpYhk3gzYcb3CK+XXKu/K0x2+d6VqcTmCVyIX6Mnw4+/n2
         LGmY425q7g+xZjR55uBYk6k01jheb0snW73FcoSTLzvTks6ou1zqysdGIgLpmO6Z8dYS
         FFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z0Lo7KdcQV5V1+hy9GBEXahSN5MlosYjYm/RYugMrYw=;
        b=7Ufwht1wZzNjpRBksHMm1Xo3CJ0cNSpXdVDPmkRk/0kfDrSMRgPG3ozrTpUFwwIsi7
         O+OOLWOO/p5RGi2RszfGg6K+BHbhTg40O8UwofKglXm1f4p9bU8377CRtxLwkl7vPySQ
         0gW50loJAdogfT+Xl6Yo2EUA7KR4JvH6sj+1/ctRogHgMGnclegK77EnDAn6oGgCNnms
         l4aq1kxEa+ElkfEAm4TJsUnuPziNXFlujpM2uPB0Bfx/iq70Qfz57Typ7vJreXXK6++b
         XsDpn1CMKgz63L011mfj7WS4O8FeFA+bj6R+614v5Jfa7F7FOT2Ii7a+srIhBTjZzAM7
         IZJg==
X-Gm-Message-State: AOAM531LCEqWYwSmFay+Sosf22Cyx65rmZqSRcs8E8BJHPFDYcgixap4
        UWfk58jUtrM7ZQwgT47eS3s=
X-Google-Smtp-Source: ABdhPJy8Xatn7GRhKTUAPY1AtBPXNRx44N0MSGi8vsuUG6MTzA2g5Z7zzZvyZwHPK1VvN+UjMbfl/A==
X-Received: by 2002:a62:544:0:b0:51b:a90d:64d3 with SMTP id 65-20020a620544000000b0051ba90d64d3mr35432462pff.40.1654704290936;
        Wed, 08 Jun 2022 09:04:50 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm18622019pjb.0.2022.06.08.09.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:04:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 7/8] net: add debug checks in napi_consume_skb and __napi_alloc_skb()
Date:   Wed,  8 Jun 2022 09:04:37 -0700
Message-Id: <20220608160438.1342569-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608160438.1342569-1-eric.dumazet@gmail.com>
References: <20220608160438.1342569-1-eric.dumazet@gmail.com>
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

