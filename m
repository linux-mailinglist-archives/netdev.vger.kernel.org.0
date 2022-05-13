Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3888526614
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382013AbiEMP1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382002AbiEMP1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:27:10 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D81248E1;
        Fri, 13 May 2022 08:26:58 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id dk23so16912568ejb.8;
        Fri, 13 May 2022 08:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D3zbuxrZpd+reD5tDBCOEJ+DWKYB665DXVybKfumiKM=;
        b=a2aR40sJG6BWUFVttOS4UgRwO+TWZAJbA06M13tI3yoNRxU2vLx43aOBEvbwt7hwGR
         pu6EI2wDTGdXYyxKEXXMJufvEQx/4gWk7dUikNKsdETYDlE40QUmPugKPCuCU1JHCe9U
         iNQPf35K0W9S46ty3/utcnzrJDAdyTC4QSwlKSupe0KMxQqE55JbaTiz5cVS3MNgB4fH
         kKPx1Iu/Ar6U40MGrbO3KSE358F6E6gaKXBiY/Q646g1GV2g4Q11vgodj885RS+JxkQF
         GroY6Mto11rjK0gZS7RBbsCJjNAb5IpfUaRLxczWazGwEqtFjaTkPv3EpnVjHLANV4QD
         U/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3zbuxrZpd+reD5tDBCOEJ+DWKYB665DXVybKfumiKM=;
        b=ULTG4cE1Rb5diP37CLUe5XeOAlmpl+SSmdkVz3Ukj//9/o2B7dO3yJgtLojojNvT3y
         6hTjUMktx379O0DN6ANx6zCkpHEjKVnVZ0hQ43vTraYYD8Ycwyv08PTZbr6pahv5VvZ/
         bB4apWSMKvBfzgrjK50kTkftXWIkljAoqTfiv5DTQoplbmjcj+TjBRc/xKmCrgyPZ/h9
         d9+h9Ngegx5WIe2uDa8kP9IkPLgNPnsvVc4Ix3iomUqlT6VDvkRXcxFIRnulriOHTd3p
         yH2qWQav8pcLNK3LYLLRCtml29CDWyMBWWP+og0RbF9OdkyPtQzfOWg+5lxT2qbV9FPH
         GPgQ==
X-Gm-Message-State: AOAM5329jW1YVR+doD3xdDwOHDxKzkc60+3/dFPvrPX3QRgAOYwhyaGa
        7FyjkZ0EbWf/SH8FhO1o8PZiMU7BZOA=
X-Google-Smtp-Source: ABdhPJznqoQK/z/eWLpGyAc6/miENx/pfikUFEFO5W0CiflFf/EkNvJETpsr8MqzRt5M/XtGrJMA6w==
X-Received: by 2002:a17:907:6e88:b0:6fa:888d:74a7 with SMTP id sh8-20020a1709076e8800b006fa888d74a7mr4774036ejc.335.1652455616628;
        Fri, 13 May 2022 08:26:56 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 09/10] ipv6: improve opt-less __ip6_make_skb()
Date:   Fri, 13 May 2022 16:26:14 +0100
Message-Id: <84e2968f7783e478e60f74fa712485d83c904de8.1652368648.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
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

We do a bit of a network header pointer shuffling in __ip6_make_skb()
expecting that ipv6_push_*frag_opts() might change the layout. Avoid it
with associated overhead when there are no opts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e2a6b9bdf79c..6ee44c509485 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1881,22 +1881,20 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
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

