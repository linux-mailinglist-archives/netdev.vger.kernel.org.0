Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023A557B2F6
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240579AbiGTIac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240509AbiGTIa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:30:28 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91DB491EC;
        Wed, 20 Jul 2022 01:30:25 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ez10so31699111ejc.13;
        Wed, 20 Jul 2022 01:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=58zZ0dZk/I6ddTuNmOqxAUp0PHDAU1gxo0sDWGaX870=;
        b=Wf7zJJpO6QOfuHHzV921vPoBt1/gRWv5Y7cVmjHm3gOcJWiN2OJVUo2TdW6tMaEcgV
         uFcVQ4oJeB0Kr3G5IS7A1tPJd43DlTOHtKTGXN3yMvh0VrVfbKWdHEKVBomxVBAobG1h
         HT9uPqqMW0rxzV2WzczxKJFvL9TgBSmTYKUlq6D8BWRcM8AbrHXSdlkQYpamRwPsOYgk
         Ra1ODugRTWWBQjMkfpTOgRRdCqkBWnQu7+OzGfV5ihF+AN3EUa7V7+OybomdUrS7Szde
         CgbJsx8rkbNAMR/XcTI4dOIAMFRDR9QTU6rwXyr7qI1nf51QwqZJwgN/n7wG1C+MOc1t
         sVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=58zZ0dZk/I6ddTuNmOqxAUp0PHDAU1gxo0sDWGaX870=;
        b=hi7aS+LFOApm4c1ZKuitQGTl7KT93r0zL/m/S2r3cj0g2BjKDhvP6vDiIKzkS/MFhs
         mTjXBLc9MY4/iInlj807Ckk18UzmN2gxWArzLjPOGruX6udkCdTrqXzbD9p1B2uvH9ju
         HOt3Z05l/0EvNj4TvbKiM2Ko3D6Ml1mVqlIdyS8A0kiVSGRXHPlTzCfe6wCCCV2/sd1d
         7yBDlfd2nE48gHj2hZF0bVnlkZGAKDewgbAAyfeCokZfQgQcYRWXdTovHQMLNgR9Cxn2
         4VXHQrbtGQ85loGj3qacIZt9O2Q1v/L3jM1Qcz0hTXIdXI7TkfONxphPJqfqZby05hkA
         uiNw==
X-Gm-Message-State: AJIora8X8Jl3xroHQfM3bzmKfIsAeqHtHKSwQSLBzyStFu/5hxUV8DBo
        ooRc1tRk9U1CBMcJxSMryNE=
X-Google-Smtp-Source: AGRyM1sWsO3sS9m7YX3rzXOiTSeAwjg+z2TZ3hRPGND7I2KuUc+BplqHNa9Z/Zh9clQnKQrszHvxPg==
X-Received: by 2002:a17:906:93ef:b0:72b:3e88:a47 with SMTP id yl15-20020a17090693ef00b0072b3e880a47mr35179073ejb.706.1658305824326;
        Wed, 20 Jul 2022 01:30:24 -0700 (PDT)
Received: from debian ([138.199.38.49])
        by smtp.gmail.com with ESMTPSA id g21-20020a1709061e1500b00722f8d02928sm7775807ejj.174.2022.07.20.01.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 01:30:24 -0700 (PDT)
From:   Mathias Lark <mathiaslark@gmail.com>
X-Google-Original-From: Mathias Lark <mathias.lark@gmail.com>
Date:   Wed, 20 Jul 2022 10:28:34 +0200
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH v2] net-next: improve handling of ICMP_EXT_ECHO icmp type
Message-ID: <20220720082435.GA31932@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a helper for icmp type checking - icmp_is_valid_type.

There is a number of code paths handling ICMP packets. To check
icmp type validity, some of those code paths perform the check
`type <= NR_ICMP_TYPES`. Since the introduction of ICMP_EXT_ECHO
and ICMP_EXT_ECHOREPLY (RFC 8335), this check is no longer correct.

To fix this inconsistency and avoid further problems with future
ICMP types, the patch inserts the icmp_is_valid type helper
wherever it is required. The helper checks if the type is less than
NR_ICMP_TYPES or is equal to ICMP_EXT_ECHO/REPLY.

NR_ICMP_TYPES could theoretically be increased to ICMP_EXT_ECHOREPLY
(43), but that would not make sense as types 19-41 are not used.

Signed-off-by: Mathias Lark <mathias.lark@gmail.com>
---
 include/linux/icmp.h                    | 4 ++++
 net/ipv4/icmp.c                         | 8 +++-----
 net/netfilter/nf_conntrack_proto_icmp.c | 4 +---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/icmp.h b/include/linux/icmp.h
index 0af4d210ee31..e979c80696b0 100644
--- a/include/linux/icmp.h
+++ b/include/linux/icmp.h
@@ -36,6 +36,11 @@ static inline bool icmp_is_err(int type)
 	return false;
 }
 
+static inline bool icmp_is_valid_type(int type)
+{
+	return type <= NR_ICMP_TYPES || type == ICMP_EXT_ECHO || type == ICMP_EXT_ECHOREPLY;
+}
+
 void ip_icmp_error_rfc4884(const struct sk_buff *skb,
 			   struct sock_ee_data_rfc4884 *out,
 			   int thlen, int off);
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 236debd9fded..686f3133370f 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -273,7 +273,7 @@ EXPORT_SYMBOL(icmp_global_allow);
 
 static bool icmpv4_mask_allow(struct net *net, int type, int code)
 {
-	if (type > NR_ICMP_TYPES)
+	if (!icmp_is_valid_type(type))
 		return true;
 
 	/* Don't limit PMTU discovery. */
@@ -661,7 +661,7 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 			 *	Assume any unknown ICMP type is an error. This
 			 *	isn't specified by the RFC, but think about it..
 			 */
-			if (*itp > NR_ICMP_TYPES ||
+			if (!icmp_is_valid_type(*itp) ||
 			    icmp_pointers[*itp].error)
 				goto out;
 		}
@@ -1225,12 +1225,10 @@ int icmp_rcv(struct sk_buff *skb)
 	}
 
 	/*
-	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
-	 *
 	 *	RFC 1122: 3.2.2  Unknown ICMP messages types MUST be silently
 	 *		  discarded.
 	 */
-	if (icmph->type > NR_ICMP_TYPES) {
+	if (!icmp_is_valid_type(icmph->type)) {
 		reason = SKB_DROP_REASON_UNHANDLED_PROTO;
 		goto error;
 	}
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index b38b7164acd5..ba4462c393be 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -225,12 +225,10 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 	}
 
 	/*
-	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
-	 *
 	 *	RFC 1122: 3.2.2  Unknown ICMP messages types MUST be silently
 	 *		  discarded.
 	 */
-	if (icmph->type > NR_ICMP_TYPES) {
+	if (!icmp_is_valid_type(icmph->type)) {
 		icmp_error_log(skb, state, "invalid icmp type");
 		return -NF_ACCEPT;
 	}
-- 
2.36.1

