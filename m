Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEEA058E5E
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfF0XNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:13:10 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:41549 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfF0XNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 19:13:09 -0400
Received: by mail-qk1-f171.google.com with SMTP id c11so3264226qkk.8
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yh7o+jb2AbbAIQcEq1YagrhIIh9lV1bAKzIjREcu7xE=;
        b=CVPejltA5opJ+64Q35v1KvXhvSOuSy9pL7U7rcn8HYcYv/h0aC898HixCPdEcFfHBf
         47qMb9ut2NRUXz7iJwT3mP+iYz8ymrnbSqjerLsJZ0FWQwkZkgXWQ6zgg4o9bm8ZYSqD
         CFBeVCN3uI+FZalsrXdCHSZI8IUk77aeawu/cs6QMKPSlcB21bc+N/4c6BhYlq0bJQaB
         NVBkrXaGIIx0r/dcd1bg0Jmd26+4dPqXKPsUbQfGhE5Rkg10N0zmTvvKI/yftHtEUpCf
         dhWepG2zX8ZQ36KaRDMwu8bJqwQeCCB3C7lXsrHMsOxhtEMDYb8QgWRK8y63IRSUMGFN
         aiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yh7o+jb2AbbAIQcEq1YagrhIIh9lV1bAKzIjREcu7xE=;
        b=I89xrQdHXQGO4iOpQXVchGc/nt5VFQEG1JM4knYJp2IYD+vCO8G5uHEbgZiHyV66OY
         EJixhjVHzpsrBsJsmfVTfFuHA3gjBJM9G4c2API44IlOqyXFk4v06j9R7yolKQRB0ZVG
         sCNQpZ2411pneRCMqonLWONvsiIQ5gZEnHgxSu67VvtREPX4BWQgoBGCa5XrCESnaxeK
         LqsH8ZLjFOWGiVMoTAPkyHHPQr3WhDNu63TUbUJyALc7n+hoX+I01Ky9xa0tSUaqLtg3
         KOq87v8iaW94CURAcyzGIpGoJ7j0pwAFtIwprqv54EcnGPXVZ+SR6TILPzZ7ppLnK6gS
         EOuw==
X-Gm-Message-State: APjAAAW4gbVaoHVBiAeXplV5sYJGypbXU94+uQoR8c6McGP+s2AgpOk7
        fchIiZeXAaw8wRWcaJaVDccDPO8IvDg=
X-Google-Smtp-Source: APXvYqy61cWSGQ7gRvX/kTVtaeGRtm1oPac1ufA2RCsEkSRL38ouc+y9wQ4mfBLL1gpOmcTE0JVunA==
X-Received: by 2002:a05:620a:13b9:: with SMTP id m25mr6082943qki.246.1561677188228;
        Thu, 27 Jun 2019 16:13:08 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o33sm253518qtk.67.2019.06.27.16.13.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 16:13:07 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 2/5] nfp: flower: add helper functions for tunnel classification
Date:   Thu, 27 Jun 2019 16:12:40 -0700
Message-Id: <20190627231243.8323-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627231243.8323-1-jakub.kicinski@netronome.com>
References: <20190627231243.8323-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Adds IPv4 address and TTL/TOS helper functions, which is done in
preparation for compiling new tunnel types.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/cmsg.h  | 16 +++--
 .../net/ethernet/netronome/nfp/flower/match.c | 59 ++++++++++++-------
 2 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 537f7fc19584..0d3d1b68232c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -354,6 +354,16 @@ struct nfp_flower_ipv6 {
 	struct in6_addr ipv6_dst;
 };
 
+struct nfp_flower_tun_ipv4 {
+	__be32 src;
+	__be32 dst;
+};
+
+struct nfp_flower_tun_ip_ext {
+	u8 tos;
+	u8 ttl;
+};
+
 /* Flow Frame IPv4 UDP TUNNEL --> Tunnel details (4W/16B)
  * -----------------------------------------------------------------
  *    3                   2                   1
@@ -371,11 +381,9 @@ struct nfp_flower_ipv6 {
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  */
 struct nfp_flower_ipv4_udp_tun {
-	__be32 ip_src;
-	__be32 ip_dst;
+	struct nfp_flower_tun_ipv4 ipv4;
 	__be16 reserved1;
-	u8 tos;
-	u8 ttl;
+	struct nfp_flower_tun_ip_ext ip_ext;
 	__be32 reserved2;
 	__be32 tun_id;
 };
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 371b5be33dc7..9181611087c2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -280,6 +280,42 @@ nfp_flower_compile_geneve_opt(void *ext, void *msk,
 	return 0;
 }
 
+static void
+nfp_flower_compile_tun_ipv4_addrs(struct nfp_flower_tun_ipv4 *ext,
+				  struct nfp_flower_tun_ipv4 *msk,
+				  struct tc_cls_flower_offload *flow)
+{
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_enc_ipv4_addrs(rule, &match);
+		ext->src = match.key->src;
+		ext->dst = match.key->dst;
+		msk->src = match.mask->src;
+		msk->dst = match.mask->dst;
+	}
+}
+
+static void
+nfp_flower_compile_tun_ip_ext(struct nfp_flower_tun_ip_ext *ext,
+			      struct nfp_flower_tun_ip_ext *msk,
+			      struct tc_cls_flower_offload *flow)
+{
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
+		struct flow_match_ip match;
+
+		flow_rule_match_enc_ip(rule, &match);
+		ext->tos = match.key->tos;
+		ext->ttl = match.key->ttl;
+		msk->tos = match.mask->tos;
+		msk->ttl = match.mask->ttl;
+	}
+}
+
 static void
 nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 				struct nfp_flower_ipv4_udp_tun *msk,
@@ -301,25 +337,8 @@ nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 		msk->tun_id = cpu_to_be32(temp_vni);
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
-		struct flow_match_ipv4_addrs match;
-
-		flow_rule_match_enc_ipv4_addrs(rule, &match);
-		ext->ip_src = match.key->src;
-		ext->ip_dst = match.key->dst;
-		msk->ip_src = match.mask->src;
-		msk->ip_dst = match.mask->dst;
-	}
-
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
-		struct flow_match_ip match;
-
-		flow_rule_match_enc_ip(rule, &match);
-		ext->tos = match.key->tos;
-		ext->ttl = match.key->ttl;
-		msk->tos = match.mask->tos;
-		msk->ttl = match.mask->ttl;
-	}
+	nfp_flower_compile_tun_ipv4_addrs(&ext->ipv4, &msk->ipv4, flow);
+	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, flow);
 }
 
 int nfp_flower_compile_flow_match(struct nfp_app *app,
@@ -411,7 +430,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		__be32 tun_dst;
 
 		nfp_flower_compile_ipv4_udp_tun((void *)ext, (void *)msk, flow);
-		tun_dst = ((struct nfp_flower_ipv4_udp_tun *)ext)->ip_dst;
+		tun_dst = ((struct nfp_flower_ipv4_udp_tun *)ext)->ipv4.dst;
 		ext += sizeof(struct nfp_flower_ipv4_udp_tun);
 		msk += sizeof(struct nfp_flower_ipv4_udp_tun);
 
-- 
2.21.0

