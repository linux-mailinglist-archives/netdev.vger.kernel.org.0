Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0A6227C6
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiKIJ6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiKIJ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:58:09 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CB92494D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:58:05 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id s201-20020a2577d2000000b006d5848a04e4so9374927ybc.23
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 01:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JaR1x3TV7IEME0+vrn3qCfsSMG7n2p/DQLvgRiOQHhg=;
        b=cWA+sKJK1AbU+JxFlZ4p7LpTEy0+pqk8JPvckZHmp/hVuCIpO2aTbnbHJFWwy1lQZd
         4KQgrO3LAzffLFL4Vf2rT4n9frYgEQjP1Ebv8g4gPaSz7IwZfjY++T+0e8hioaMaOfVb
         erBw1LosCuc4qAO7HiGMiHvdQdkFshqzX/S1X9zM/6OP79QojTgNPIKJy2RAheD2kXhA
         ejAuiTR/p/u749TwtrP/J/I3vvVTx/99VATCZG+Q42j6NbWLYhfMUWWJRShlifCFbhhh
         QtzQNRYsFsEAgZCFjrFnyaaMijKOI0ccV/vt3d6wsOwRwyR6hqhJnBzRgZ4oRTRiHsRc
         QPWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JaR1x3TV7IEME0+vrn3qCfsSMG7n2p/DQLvgRiOQHhg=;
        b=Faz26emCH01Zaq0AqUEUmzzBXArenYtZuR+XXivaXem4V5c6uXH5NUG+pfr53t5LHF
         dhH5dUY6Tv+2E80EbF61zJOw9eLM0gwVWPWkIjtrznkBGhCVFGvdSrLOstIbw4ULxos2
         Ya0qehL7XkSJ5HzSHE/UX9p3vmU2VBwkCyEbx6KQWHobh3OawMp0+t9Nu/9ZGIgJOGxu
         R4pBpP0B734UA3HCY65MGvOz2ROFIrZSrv37SQE1P1EKTRVnCqjXydyMRRhH2b6yr5Ds
         ifSGOCx6VP7PMEEh9yQJZdCm2DPSxKV8Li4At2WzDUD0DtLXXK/msqXf0pRWCcIkEn3J
         KPLA==
X-Gm-Message-State: ACrzQf09rhj3eGUGlvhCegNk9J8kvxH+D9HMMl1sbVKOzbwarFwRrrI6
        M1uVtMQMAOlcgkLi3mkQhuZ50DI1o/TRfA==
X-Google-Smtp-Source: AMsMyM7kfc60eo3TlV3cjkJqpRD6JGw1nzQmtZxyT3lvdfzxnsJMCrGpYTiKzm5lZgE0ve2Ze3fqtCXZlc0n2g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:789:0:b0:6c0:2fa7:7282 with SMTP id
 b9-20020a5b0789000000b006c02fa77282mr991155ybq.503.1667987884958; Wed, 09 Nov
 2022 01:58:04 -0800 (PST)
Date:   Wed,  9 Nov 2022 09:57:59 +0000
In-Reply-To: <20221109095759.1874969-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221109095759.1874969-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109095759.1874969-3-edumazet@google.com>
Subject: [PATCH net-next 2/2] net: gro: no longer use skb_vlan_tag_present()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can remove a conditional test in gro_list_prepare()
by comparing vlan_all fields of the two skbs.

Notes:

While comparing the vlan_proto is not strictly needed,
because part of the following compare_ether_header() call,
using 32bit word is actually faster than using 16bit values.

napi_reuse_skb() makes sure to clear skb->vlan_all,
as it already calls __vlan_hwaccel_clear_tag()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/gro.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index bc9451743307bc380cca96ae6995aa0a3b83d185..4a6925569bf313a0a8e1b22174470c2af3f9dae3 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -370,9 +370,7 @@ static void gro_list_prepare(const struct list_head *head,
 		}
 
 		diffs = (unsigned long)p->dev ^ (unsigned long)skb->dev;
-		diffs |= skb_vlan_tag_present(p) ^ skb_vlan_tag_present(skb);
-		if (skb_vlan_tag_present(p))
-			diffs |= skb_vlan_tag_get(p) ^ skb_vlan_tag_get(skb);
+		diffs |= p->vlan_all ^ skb->vlan_all;
 		diffs |= skb_metadata_differs(p, skb);
 		if (maclen == ETH_HLEN)
 			diffs |= compare_ether_header(skb_mac_header(p),
-- 
2.38.1.431.g37b22c650d-goog

