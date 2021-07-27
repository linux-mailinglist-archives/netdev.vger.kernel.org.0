Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A237E3D808E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhG0VG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbhG0VGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:06:52 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEAAC0613D3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:52 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id k1so17570102plt.12
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=leSZ4+6fTtz64GnNlapLSf4V7UaFGM0yCohcXILoKXc=;
        b=jd9XYMPnsO+0X0kRowZ86N9zacfPb8mbO0Mn11eVzxLjdNoE9ys47yWbs+jxtnOSfW
         fuHAIdDcVF88EwmnaD7IGAE5UOXEErobQB9V1J7X9Y9Cwvb1H6gIsxo5YFlkxZL7XwB5
         SoHqQezU4kIahHRz1ABzKHP3/DNG2Cq1Aor0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=leSZ4+6fTtz64GnNlapLSf4V7UaFGM0yCohcXILoKXc=;
        b=faEI8jBQlhI/ljicR4PcE9MnRg+Xq5myPAtX4zsNB91UzouFyd7lL9PZIB008rOjVe
         1hUdNqoSSgT3mwLSHb1e3F1DfK8V9rKn44wJgdWP0z8OxOay8uvv6nNXi8rDE2poUodb
         futDk5QA4eEr3ki8ARrwIunT64iuz/xb4I80P1WQfS5wB4Oc1O7QJ3DRMjp5glLpS6Y9
         UaOeaOIpSVdQTfCRYRh6YPgdiEOZxxBaCqwXOE1Nnlt+0VzvnspMngTd7woKuc+0/bCq
         AZapYpA/0W6puzt8i4MsI2tWl8xeWO4Em3+g4apLeiE2nT7dblDvWTOGo8+tKShYMSz2
         eI3Q==
X-Gm-Message-State: AOAM531+k6n61g0S0utDedSneaMqTjLX51+1ubJDNr6SJZYMlpy+LUHb
        8ek/rXNsUSISWyIgm1GSxPr/IOxmr4nUXma8
X-Google-Smtp-Source: ABdhPJwEVYSPNBSiESL402T+It80ZBI73Q1poC5hUVPNhWmUhVwPrv3z7S2LNSMZUqAote5dC8pGCg==
X-Received: by 2002:a17:90a:4417:: with SMTP id s23mr6057606pjg.228.1627420011821;
        Tue, 27 Jul 2021 14:06:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y23sm4655958pgf.38.2021.07.27.14.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:06:50 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 19/64] ip: Use struct_group() for memcpy() regions
Date:   Tue, 27 Jul 2021 13:58:10 -0700
Message-Id: <20210727205855.411487-20-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5544; h=from:subject; bh=EW2OlP80ZbFYA2et85VLFWinFxHDZ/JfYcx96uwve2A=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOE1QionXEAsnSiPxVw5wfkIt8+He7UKLQGrMmI c3kN8gqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhAAKCRCJcvTf3G3AJgwWD/ sH6JiJOlqMdZB/DaJUVswYUCsszxQOHKvFJps95qmqpJBMRDsH2lLBKm2a6gmCHlmLHrpZE35CObwM nj+RWt9ixoNH4L81O+98xW2w1VPy57Ri6Pf6Yvn44gHEPmKAxV7pdf/rNyEVZZ+t4EbwjFrLIOF9Cu cXpnowGMFNqPdKCrUf/0aeZoSOJ/IGRJtmxUClP9U/1zfg/R1in74Yi149wzVruBUBUSTvsQc4SA0s QQYq5W7ixXMQ8l0YTWGa8ymTzcKK7P60aP4vm7HBJJCHyQR/BwdRDvijeZ1qYLlddgvFs0UULN0oQe vVd8qbWGt4gKDPylfKfgz6uaNSz+jJ43ZF5fCDL1Jt0BrSc+Cx63VBDSBSytHoarJkaqTtC3GRNWES xTVy3dTnpag/Lj92bhpS2+EWrLsiDNWEeuOb1Er5+25XBNHz+Y8frHGoRemgsL3Qs1EVYOTdxlFHG3 V6rjjqoRPfWMWpN0e7jogaTYc3cRUXBSen9HIsPGXHu3xrGH+bvNJ3uQ1VOdugyYnP+7PFkJ7FwuPS RBc5nf5hj3ojUnMeyIYKt1IK14Do/EQKUtgRpkmkN7YhsN1/yquUdxgGZ8x/Zi1LZI/UZ6FLaxcXVK Fc7a3ewBBcn4SXZY0R5FI5JHXF0Ahz8hNwHzp01WiTwpznvQKOKE/eRBuuoQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct flowi4, struct ipv4hdr, and struct ipv6hdr
around members saddr and daddr, so they can be referenced together. This
will allow memcpy() and sizeof() to more easily reason about sizes,
improve readability, and avoid future warnings about writing beyond the
end of saddr.

"pahole" shows no size nor member offset changes to struct flowi4.
"objdump -d" shows no meaningful object code changes (i.e. only source
line number induced differences.)

Note that since this is a UAPI header, struct_group() has been open
coded.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/flow.h            |  6 ++++--
 include/uapi/linux/if_ether.h | 12 ++++++++++--
 include/uapi/linux/ip.h       | 12 ++++++++++--
 include/uapi/linux/ipv6.h     | 12 ++++++++++--
 net/core/flow_dissector.c     | 10 ++++++----
 net/ipv4/ip_output.c          |  6 ++----
 6 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index 6f5e70240071..f1a3b6c8eae2 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -81,8 +81,10 @@ struct flowi4 {
 #define flowi4_multipath_hash	__fl_common.flowic_multipath_hash
 
 	/* (saddr,daddr) must be grouped, same order as in IP header */
-	__be32			saddr;
-	__be32			daddr;
+	struct_group(addrs,
+		__be32			saddr;
+		__be32			daddr;
+	);
 
 	union flowi_uli		uli;
 #define fl4_sport		uli.ports.sport
diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index a0b637911d3c..8f5667b2ea92 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -163,8 +163,16 @@
 
 #if __UAPI_DEF_ETHHDR
 struct ethhdr {
-	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
-	unsigned char	h_source[ETH_ALEN];	/* source ether addr	*/
+	union {
+		struct {
+			unsigned char h_dest[ETH_ALEN];	  /* destination eth addr */
+			unsigned char h_source[ETH_ALEN]; /* source ether addr	  */
+		};
+		struct {
+			unsigned char h_dest[ETH_ALEN];	  /* destination eth addr */
+			unsigned char h_source[ETH_ALEN]; /* source ether addr	  */
+		} addrs;
+	};
 	__be16		h_proto;		/* packet type ID field	*/
 } __attribute__((packed));
 #endif
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..33647a37e56b 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -100,8 +100,16 @@ struct iphdr {
 	__u8	ttl;
 	__u8	protocol;
 	__sum16	check;
-	__be32	saddr;
-	__be32	daddr;
+	union {
+		struct {
+			__be32	saddr;
+			__be32	daddr;
+		} addrs;
+		struct {
+			__be32	saddr;
+			__be32	daddr;
+		};
+	};
 	/*The options start here. */
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index b243a53fa985..1c26d32e733b 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -130,8 +130,16 @@ struct ipv6hdr {
 	__u8			nexthdr;
 	__u8			hop_limit;
 
-	struct	in6_addr	saddr;
-	struct	in6_addr	daddr;
+	union {
+		struct {
+			struct	in6_addr	saddr;
+			struct	in6_addr	daddr;
+		} addrs;
+		struct {
+			struct	in6_addr	saddr;
+			struct	in6_addr	daddr;
+		};
+	};
 };
 
 
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2aadbfc5193b..87655a2ac200 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1029,7 +1029,8 @@ bool __skb_flow_dissect(const struct net *net,
 		key_eth_addrs = skb_flow_dissector_target(flow_dissector,
 							  FLOW_DISSECTOR_KEY_ETH_ADDRS,
 							  target_container);
-		memcpy(key_eth_addrs, &eth->h_dest, sizeof(*key_eth_addrs));
+		BUILD_BUG_ON(sizeof(*key_eth_addrs) != sizeof(eth->addrs));
+		memcpy(key_eth_addrs, &eth->addrs, sizeof(*key_eth_addrs));
 	}
 
 proto_again:
@@ -1056,8 +1057,8 @@ bool __skb_flow_dissect(const struct net *net,
 							      FLOW_DISSECTOR_KEY_IPV4_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v4addrs, &iph->saddr,
-			       sizeof(key_addrs->v4addrs));
+			BUILD_BUG_ON(sizeof(key_addrs->v4addrs) != sizeof(iph->addrs));
+			memcpy(&key_addrs->v4addrs, &iph->addrs, sizeof(iph->addrs));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		}
 
@@ -1101,7 +1102,8 @@ bool __skb_flow_dissect(const struct net *net,
 							      FLOW_DISSECTOR_KEY_IPV6_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v6addrs, &iph->saddr,
+			BUILD_BUG_ON(sizeof(iph->addrs) != sizeof(key_addrs->v6addrs));
+			memcpy(&key_addrs->v6addrs, &iph->addrs,
 			       sizeof(key_addrs->v6addrs));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 		}
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8d8a8da3ae7e..58603995d889 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -444,10 +444,8 @@ EXPORT_SYMBOL(ip_output);
  */
 static void ip_copy_addrs(struct iphdr *iph, const struct flowi4 *fl4)
 {
-	BUILD_BUG_ON(offsetof(typeof(*fl4), daddr) !=
-		     offsetof(typeof(*fl4), saddr) + sizeof(fl4->saddr));
-	memcpy(&iph->saddr, &fl4->saddr,
-	       sizeof(fl4->saddr) + sizeof(fl4->daddr));
+	BUILD_BUG_ON(sizeof(iph->addrs) != sizeof(fl4->addrs));
+	memcpy(&iph->addrs, &fl4->addrs, sizeof(fl4->addrs));
 }
 
 /* Note: skb->sk can be different from sk, in case of tunnels */
-- 
2.30.2

