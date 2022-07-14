Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D01E575189
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 17:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbiGNPQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 11:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiGNPQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 11:16:04 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B850DE8E;
        Thu, 14 Jul 2022 08:16:03 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g1so2807267edb.12;
        Thu, 14 Jul 2022 08:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=oI7lmGca+toUm4ZWMa5XQfNQqVbbESkf3BrNPAtrMII=;
        b=Ejda51ia8PRknUgSAK7emz2//RircokgfWr+i6dRLVuO6FtI69rY1lqUC9Ta4Zho8x
         FYd+/tGA2zrm4U9Zuj8+FD5WD72oFXVhiuNy+JcT7ltlfjt5OO90tEL1hv4J2q5y73bI
         rL9A52+hPey36subBOjdFoB+f8dPaWXLtj8/tadtGy1W0gx6guwucxD5FNsCSS1eC8TP
         3/fyzUxyD67iymhl3k1zHPmON2HQZZt3W7T8vebsyvGLOI3kAxpDQn173VOEBPL93ftK
         DWPHmLNOpAbMKKbffhWV1+QN4enCmVbu1jn6azJeWM5uQhgBkcLVvX3S80a4GupmOWw1
         rgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=oI7lmGca+toUm4ZWMa5XQfNQqVbbESkf3BrNPAtrMII=;
        b=wlvyC8V0H68s+A8OfD09//dddS8lXODE29ex/08iCbXpAfIR79ICJWihBCkicT2LG5
         2luOjdD5n4IfHBcVrFp2ZtgsT1dHlyqdU+wYExxRP6lM93Zzts3WLnW0hySn7zvkE/4m
         jRySuTqRmG5roAMXnp49DhBjcdZ9cArmymUKap9mVUESOQ/QTbKySN9vioY0xILhk4Bq
         /6ktZwPtrgTzK6gfh25dzAKxkqEpsgFkXk0fssCnoSkx41NSv7fb2RuwbH9m9rkWPCoY
         qDWe3g4BarjzofwwuDthHOcvDXoszq7cbDYFOCUoGDWroqZwYaSc37QOSfxOKyEV+Zx1
         R55w==
X-Gm-Message-State: AJIora+DwySLPqOVHXG7KdiAMaYDKX03ZR6h/ydYXt/e5tikLBODtCNv
        4Fsg6Qp7zCIAHD0E7G1Kv3w=
X-Google-Smtp-Source: AGRyM1tSMIUGzFu5xvfDtbcr0unqUo7guIFXtL+nx/hK8ueisxLVKYPx4SyUH6gxSlI9Y00A2zBkiw==
X-Received: by 2002:aa7:db50:0:b0:43a:6319:e2bc with SMTP id n16-20020aa7db50000000b0043a6319e2bcmr12994540edt.237.1657811762092;
        Thu, 14 Jul 2022 08:16:02 -0700 (PDT)
Received: from debian ([156.146.33.241])
        by smtp.gmail.com with ESMTPSA id 6-20020a170906318600b006f3ef214e27sm812664ejy.141.2022.07.14.08.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 08:16:01 -0700 (PDT)
From:   Mathias Lark <mathiaslark@gmail.com>
X-Google-Original-From: Mathias Lark <mathias.lark@gmail.com>
Date:   Thu, 14 Jul 2022 17:13:58 +0200
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH net-next] improve handling of ICMP_EXT_ECHO icmp type
Message-ID: <20220714151358.GA16615@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
ICMP types, the patch inserts the icmp_is_valid_type helper
wherever it is required.

Signed-off-by: Mathias Lark <mathias.lark@gmail.com>
---
 include/uapi/linux/icmp.h               | 5 +++++
 net/ipv4/icmp.c                         | 8 +++-----
 net/netfilter/nf_conntrack_proto_icmp.c | 4 +---
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index 163c0998aec9..ad736a24f0c8 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -159,4 +159,9 @@ struct icmp_ext_echo_iio {
 		} addr;
 	} ident;
 };
+
+static inline bool icmp_is_valid_type(__u8 type)
+{
+	return type <= NR_ICMP_TYPES || type == ICMP_EXT_ECHO || type == ICMP_EXT_ECHOREPLY;
+}
 #endif /* _UAPI_LINUX_ICMP_H */
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

