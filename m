Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9890A49D6CA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbiA0Agk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbiA0Agk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:40 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DA4C06173B;
        Wed, 26 Jan 2022 16:36:39 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id n10so1444550edv.2;
        Wed, 26 Jan 2022 16:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZekbOX/mBkxJ3VLK+5yn7uRMRqRi36JXBTZy8Qw+hU=;
        b=aRARrOuufabe73tJxz7WsJYCFwSCAb0ziKrgi23PM7QAo7XrZCEecBr3jEc1RB4fkN
         BL/twvydFqXcFIhS23ShhtTuMDmKGL2oei08Ld5C/2r/uib/H3/OSVzZhBm1/u8te4L+
         VTPLM6tHwfdDvNVlEWNOKK9i9J8fo+LRDXSZqqySUPoHq8PLipA4F1miP4AP6SlLUmIU
         GgNnXKdXXGiRAN734tNuO5tXiqcglbDZbICEsfZCFjF8yhfsxrtjvOuwJslsO+6vk3TB
         iUh4jwO9iLpgLVD7JtfV2vy2UgFQkx3JY9wHyeNCflJozVCFR9eHATje8JBpsCKP1Bzt
         DpuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZekbOX/mBkxJ3VLK+5yn7uRMRqRi36JXBTZy8Qw+hU=;
        b=znz6VmydKrZShzBIvD1rZ+w/e71Uk9NJkl4obWTQPlWh0JOOfjCgwyAE9EzAaafgsW
         JjU2EQjY/wczYmBnIFORy/SyTh/8NOmD0fkHnAw0GcbbwAtCqM2JsplLiSXNTLgZ0Hp6
         NvN7gFmcF84yoS0gF9owzQiPQBRXDC+JQwy/uyxsKB7hxX6Ba9Ae9UAj1sNUy6nSQ9TQ
         1j9kcnNAkCzfs6TR9KKaaj39uHAHlUc8aMx9/psvlS9nYAUTQHSisXzfKV6kYUudgkNp
         F5QaJEk7WFPpw6/33Yyh0xKZ2ZkwhpBfnATImoK9RNqUJc5IPJzcPHIyf+JgPJH76vQp
         GH1A==
X-Gm-Message-State: AOAM531QZVK+hqNT8jPXWkxdRb36AjPU2PEtDdvPb4R12PRZfj3bcQJC
        EXzmPXglCbWONFWOcxi84DiasnX+kQA=
X-Google-Smtp-Source: ABdhPJz2DXu1wNwL31EPFWgvtRsZOMbsQKZRPkeiVPVq9FFjHYRhTDKCaan0+jb9U6gUdfOsthDKgg==
X-Received: by 2002:a50:e616:: with SMTP id y22mr1353944edm.277.1643243798103;
        Wed, 26 Jan 2022 16:36:38 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 01/10] ipv6: optimise dst refcounting on skb init
Date:   Thu, 27 Jan 2022 00:36:22 +0000
Message-Id: <647e136457fb586846933244448652547dd306f9.1643243772.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__ip6_make_skb() gets a cork->dst ref, hands it over to skb and shortly
after puts cork->dst. Save two atomics by stealing it without extra
referencing, ip6_cork_release() handles NULL cork->dst.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2995f8d89e7e..14d607ccfeea 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1807,6 +1807,15 @@ int ip6_append_data(struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(ip6_append_data);
 
+static void ip6_cork_steal_dst(struct sk_buff *skb, struct inet_cork_full *cork)
+{
+	struct dst_entry *dst = cork->base.dst;
+
+	cork->base.dst = NULL;
+	cork->base.flags &= ~IPCORK_ALLFRAG;
+	skb_dst_set(skb, dst);
+}
+
 static void ip6_cork_release(struct inet_cork_full *cork,
 			     struct inet6_cork *v6_cork)
 {
@@ -1889,7 +1898,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
 	skb->tstamp = cork->base.transmit_time;
 
-	skb_dst_set(skb, dst_clone(&rt->dst));
+	ip6_cork_steal_dst(skb, cork);
 	IP6_UPD_PO_STATS(net, rt->rt6i_idev, IPSTATS_MIB_OUT, skb->len);
 	if (proto == IPPROTO_ICMPV6) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
-- 
2.34.1

