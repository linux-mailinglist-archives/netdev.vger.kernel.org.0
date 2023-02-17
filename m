Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2164D69B66A
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 00:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjBQXXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 18:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjBQXXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 18:23:02 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116E818B24;
        Fri, 17 Feb 2023 15:23:00 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id m11so2184799qtp.7;
        Fri, 17 Feb 2023 15:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fvUHsndISEQnet/qxZllyajUv6FP+N5eaDWiXpbgdqg=;
        b=U3iZt0wMKKG7mFw6t99jthbzHC0WZne3iysViRiFZpyd/WF8zzXyAy68MvmzyAccqi
         L8+xaWLqgai6C3nIEs0fRxOl9YVv532EYPUfjblQA9WMpiAXiy8rWAvuLqESCU1ptu9n
         8mhdAj3Pd7GVcVpnohXf+BMe2xkoWw729AYYXgEYdKhpjIctBVPL70S37nGdRE2Quy96
         8FFs85fGIH6vTrXxQShiYASbbFmNmjC5cASR+KTHADuoRVBUUwUUgpC4GHiQNtEkJ/uu
         21utwgVtEJWAGXrF7oCVopKJtfnoAiAUtFq4iz17HPe8y8IcBf4sRestjNBLqBvws/hY
         WivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fvUHsndISEQnet/qxZllyajUv6FP+N5eaDWiXpbgdqg=;
        b=3dHb34min0hQhrineASIjLsma9GGpEp+zL9kMTSgJ2/3u9LgS4Y81+UWoEnp8yFm4m
         ihRfUIYdEpxFUeAEfgXLVkLOGQ0bpfRNWJoAcxrGn1mMdBakpNEC16/Q3SdVXOZJw+3b
         mwj1DIqsxgR3V3U4Od2aNlEsgdEH2P2qDlXVA9b/WyNjI5dCocHowO0B2R0L48srNKLi
         Gjvs3br5HY6Ca7Q8GtTT1e+GzfMJtZlE1aiQImo7veK66qi747GAurso1Ej24QGwvghx
         DbEZUBdIWOFLYJeDblNFENehJGQYNDlgLFcmKRQvcSScuNSTGUiNnF4ug/pidM0TWPrG
         oD0g==
X-Gm-Message-State: AO0yUKWPSXtu/n5Stm/w0DMWe2Gn0NPDSiuVQbyt76NVEIcPZ7q+kC8n
        ZwyzhpKFgwPMIx52Xj/xcI9qoJLMlRHbmg==
X-Google-Smtp-Source: AK7set8kzLO3u15x41jDyC9VnMj2ffuKezPy5pB48RGfvPx0QuF39vDAtphFzwyvWyn6VbvJQ57YPA==
X-Received: by 2002:a05:622a:b:b0:3bc:fa90:e8bb with SMTP id x11-20020a05622a000b00b003bcfa90e8bbmr4720151qtw.30.1676676178943;
        Fri, 17 Feb 2023 15:22:58 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id g1-20020ac80701000000b003b6325dfc4esm4075617qth.67.2023.02.17.15.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 15:22:58 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH nf] netfilter: use skb len to match in length_mt6
Date:   Fri, 17 Feb 2023 18:22:57 -0500
Message-Id: <361acd69270a8c2746da5774644dda9147b407a1.1676676177.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
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

For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
length for the jumbo packets, it may mismatch.

To fix this, we can just use skb->len instead of parsing exthdrs, as
the hbh exthdr parsing has been done before coming to length_mt6 in
ip6_rcv_core() and br_validate_ipv6() and also the packet has been
trimmed according to the correct IPv6 (ext)hdr length there, and skb
len is trustable in length_mt6().

Note that this patch is especially needed after the IPv6 BIG TCP was
supported in kernel, which is using IPv6 Jumbo packets. Besides, to
match the packets greater than 65535 more properly, a v1 revision of
xt_length may be needed to extend "min, max" to u32 in the future,
and for now the IPv6 Jumbo packets can be matched by:

  # ip6tables -m length ! --length 0:65535

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/xt_length.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 1873da3a945a..9fbfad13176f 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -30,8 +30,7 @@ static bool
 length_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_length_info *info = par->matchinfo;
-	const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
-				 sizeof(struct ipv6hdr);
+	u32 pktlen = skb->len;
 
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
-- 
2.39.1

