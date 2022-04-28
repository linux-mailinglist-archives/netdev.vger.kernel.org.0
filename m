Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B41C5131DB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344964AbiD1LBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344898AbiD1LBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:01:08 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9954972AE;
        Thu, 28 Apr 2022 03:57:51 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d5so6239479wrb.6;
        Thu, 28 Apr 2022 03:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e3JOSUJWrUPvCHFoWua5pWRqSGO0w+9yuqoonKqU/u4=;
        b=mDPURFRvtz4PhFAu8qIo7xONGmKaaJ1VGF+XLc5rVeQIHkiBZuUPMnoszpQdhGP/nm
         6uA259+15VmUzF2PQ1Ud9xR1KFONke8O5UHSoKnSWiSYkErJMjn/9os2HW5rwEZX4PEl
         lIa36VWGJB/ee4bHEA0Y4T/ahYTPKrm9sI786Mxjl6uKbOOE9gS0bm4Ml8ltPesCcglf
         cSqGflL/7ovyqBOWK3abyM+ISleVto4aQamSG0YKAU1+cz5WzwtM5NXNsn1xUVpiCn6r
         M78WjKgJ/WoEYpNP85d/AV4DiB98sYf7Dt1rbYMfehProszzmyUBWfadbYlPUzEXxbZa
         MHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e3JOSUJWrUPvCHFoWua5pWRqSGO0w+9yuqoonKqU/u4=;
        b=EKuMH/rjUmbbiT6oNDcKIYYTuGvOvidf4h6HK+0a9nHrufllQFeT+38oBw3ortSSVL
         IHAZ++gq1PpaoDxh2VOsjHpOTKQq2vsEkcg/mtcI+jokuIjfQPeMFTeqI1SS2imH1q9d
         PKoD9NN+8EJOD6qdr/aHtaLPrBGZ0lfpmoMUz0HEd1giG2eXKLyBiu8dHED31vZkF5R2
         QHeLydX7mgW5eZHQnTy00kyrLmZQtuQGJ4bhWwEOsjuFPiBeUOD+EMhUi8rOIqDikVfS
         haGKHlFkldrBCPwoQ6zHUikZ4DGhe7VFWbwivjcFGWUFLKZz8M4Bm0N+XlCZHladstbn
         py1w==
X-Gm-Message-State: AOAM533myago58mHItelo09zu02xc8/Gweb8l0TeZKbSAehz/5rAKzdm
        ZYVGwCWPuv83FbExEOxvluK4nrGb4HU=
X-Google-Smtp-Source: ABdhPJyBxMBcN7NdsSZPEmmbOLX0TGQiHoWZnbi0R19eR69wcusMSUZG/1ypQUyMJ9K8Rgn5jl+9sQ==
X-Received: by 2002:a05:6000:18c9:b0:203:fb67:debe with SMTP id w9-20020a05600018c900b00203fb67debemr25692423wrq.494.1651143470257;
        Thu, 28 Apr 2022 03:57:50 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 10/11] ipv6: improve opt-less __ip6_make_skb()
Date:   Thu, 28 Apr 2022 11:56:44 +0100
Message-Id: <2313cc1d1cdf89c58f327c1be02bd04834824551.1651071843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651071843.git.asml.silence@gmail.com>
References: <cover.1651071843.git.asml.silence@gmail.com>
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

We do a bit of a network header pointer shuffling in __ip6_make_skb()
expecting that ipv6_push_*frag_opts() might change the layout. Avoid it
with associated overhead when there are no opts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 43a541bbcf5f..416d14299242 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1880,22 +1880,20 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
 	/* Allow local fragmentation. */
 	skb->ignore_df = ip6_sk_ignore_df(sk);
-	__skb_pull(skb, skb_network_header_len(skb));
-
 	final_dst = &fl6->daddr;
 	if (v6_cork->opt) {
 		struct ipv6_txoptions *opt = v6_cork->opt;
 
+		__skb_pull(skb, skb_network_header_len(skb));
 		if (opt->opt_flen)
 			ipv6_push_frag_opts(skb, opt, &proto);
 		if (opt->opt_nflen)
 			ipv6_push_nfrag_opts(skb, opt, &proto, &final_dst, &fl6->saddr);
+		skb_push(skb, sizeof(struct ipv6hdr));
+		skb_reset_network_header(skb);
 	}
 
-	skb_push(skb, sizeof(struct ipv6hdr));
-	skb_reset_network_header(skb);
 	hdr = ipv6_hdr(skb);
-
 	ip6_flow_hdr(hdr, v6_cork->tclass,
 		     ip6_make_flowlabel(net, skb, fl6->flowlabel,
 					ip6_autoflowlabel(net, np), fl6));
-- 
2.36.0

