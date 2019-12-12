Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C3111D516
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbfLLSRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:17:14 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:40335 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730337AbfLLSRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:17:12 -0500
Received: by mail-wm1-f46.google.com with SMTP id t14so3630566wmi.5
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uzrmIQOAAmgSjh/b+R8Ao3rWPk++nLaEYfmGaTgSlFY=;
        b=OP7ZvgQ8Ibzh2BWCSOAcrvX2d98m5eE9MTKaUgYxHSDcn/QEpEKNKOLk75zMwqbyte
         i+eMZ95BnumMEdETLaZcIayHAK9E88cYT3eWEMKzeOJO0xxRJm6VgrdKtoqTAhhoo0Oo
         ztCdh/ja5y/AcmMQF6ZLwI6+Hvcx9wyW/U40mSc4nUVv5TJC1n10M61B0du2F5dn3smE
         lVZNv6let+4Hxp3z+Ss5xYKzx0SHL/2P+nITZXfOC3dIHNESQmcq1FhKVCsZXeq1Q8X4
         Tvb9osAxndLurDm23yqVuU1N2I+RoFZgm+PWHXeYbriTWnrnaCfnswsfjFPFJy+j+dEU
         G86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uzrmIQOAAmgSjh/b+R8Ao3rWPk++nLaEYfmGaTgSlFY=;
        b=e/car8f/+NecCIOzpZK8Yy4XPKX8em/SC+REkXhErXB0g3ZnejCij5UQEWhR7QfK64
         mwN5wxk0WNGJtBn/fP1IzkwN0N1fk4Qbu03Ng3DixGxK/jMDXHZ4DnwwXqSg4IjWpnZQ
         q0wNbZOCGhhIosk72Mq2QEtRWn/dL3/fBhOIauDwAmihcAmGZfvFXBvCVCzfdO/4qJzX
         0KNCtigprEUWY90toE7QzmqRGlN5fHYWHTmrytEbdKBPDzNYSoqEGiyOesvG3ZcTLyPO
         /0JvVq8hf4N/PuYsA5r9uhfqDoNIrlZtNhF8nbUjqzUHEfD2zbF35qR/ONSjlVIp1wnF
         xrfw==
X-Gm-Message-State: APjAAAUXOMJ8vi6jZ82TdIg7pmSAg1OM+KYY7dhszs0HHfUW7VKkTcUE
        Q2MV58bxtcQAtodhhIat72HywTymA1k5Ih4IEtdQZaMwcCanvAo3S9NQsHPYt4B5YNdrRmcF94J
        /34hi1aSGKsaYt0mf3XmPHJ8QMVpWqz1uW3xQogqNzIojyo7OrPd/hgstBh9r+znW5LdjQu7tqQ
        ==
X-Google-Smtp-Source: APXvYqwcu6vjMd9nBKBiKlKC3uAy031gxXrblmSK0jwftm5yWblCrm79tfpUj+Xy9J86HZHSh0CbuQ==
X-Received: by 2002:a1c:dc85:: with SMTP id t127mr7836637wmg.16.1576174629197;
        Thu, 12 Dec 2019 10:17:09 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id j21sm7928736wmj.39.2019.12.12.10.17.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 10:17:08 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 2/9] nfp: flower: move udp tunnel key match compilation to helper function
Date:   Thu, 12 Dec 2019 18:16:49 +0000
Message-Id: <1576174616-9738-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
References: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv4 UDP and GRE tunnel match rule compile helpers share functions for
compiling fields such as IP addresses. However, they handle fields such
tunnel IDs differently.

Create new helper functions for compiling GRE and UDP tunnel key data.
This is in preparation for supporting IPv6 tunnels where these new
functions can be reused.

This patch does not change functionality.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/match.c | 57 ++++++++++++++---------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 1079f37..1cf8eae 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -298,6 +298,38 @@ nfp_flower_compile_tun_ip_ext(struct nfp_flower_tun_ip_ext *ext,
 }
 
 static void
+nfp_flower_compile_tun_udp_key(__be32 *key, __be32 *key_msk,
+			       struct flow_rule *rule)
+{
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
+		u32 vni;
+
+		flow_rule_match_enc_keyid(rule, &match);
+		vni = be32_to_cpu(match.key->keyid) << NFP_FL_TUN_VNI_OFFSET;
+		*key = cpu_to_be32(vni);
+		vni = be32_to_cpu(match.mask->keyid) << NFP_FL_TUN_VNI_OFFSET;
+		*key_msk = cpu_to_be32(vni);
+	}
+}
+
+static void
+nfp_flower_compile_tun_gre_key(__be32 *key, __be32 *key_msk, __be16 *flags,
+			       __be16 *flags_msk, struct flow_rule *rule)
+{
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
+
+		flow_rule_match_enc_keyid(rule, &match);
+		*key = match.key->keyid;
+		*key_msk = match.mask->keyid;
+
+		*flags = cpu_to_be16(NFP_FL_GRE_FLAG_KEY);
+		*flags_msk = cpu_to_be16(NFP_FL_GRE_FLAG_KEY);
+	}
+}
+
+static void
 nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
 				struct nfp_flower_ipv4_gre_tun *msk,
 				struct flow_rule *rule)
@@ -309,19 +341,10 @@ nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
 	ext->ethertype = cpu_to_be16(ETH_P_TEB);
 	msk->ethertype = cpu_to_be16(~0);
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
-		struct flow_match_enc_keyid match;
-
-		flow_rule_match_enc_keyid(rule, &match);
-		ext->tun_key = match.key->keyid;
-		msk->tun_key = match.mask->keyid;
-
-		ext->tun_flags = cpu_to_be16(NFP_FL_GRE_FLAG_KEY);
-		msk->tun_flags = cpu_to_be16(NFP_FL_GRE_FLAG_KEY);
-	}
-
 	nfp_flower_compile_tun_ipv4_addrs(&ext->ipv4, &msk->ipv4, rule);
 	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
+	nfp_flower_compile_tun_gre_key(&ext->tun_key, &msk->tun_key,
+				       &ext->tun_flags, &msk->tun_flags, rule);
 }
 
 static void
@@ -332,19 +355,9 @@ nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 	memset(ext, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
 	memset(msk, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
-		struct flow_match_enc_keyid match;
-		u32 temp_vni;
-
-		flow_rule_match_enc_keyid(rule, &match);
-		temp_vni = be32_to_cpu(match.key->keyid) << NFP_FL_TUN_VNI_OFFSET;
-		ext->tun_id = cpu_to_be32(temp_vni);
-		temp_vni = be32_to_cpu(match.mask->keyid) << NFP_FL_TUN_VNI_OFFSET;
-		msk->tun_id = cpu_to_be32(temp_vni);
-	}
-
 	nfp_flower_compile_tun_ipv4_addrs(&ext->ipv4, &msk->ipv4, rule);
 	nfp_flower_compile_tun_ip_ext(&ext->ip_ext, &msk->ip_ext, rule);
+	nfp_flower_compile_tun_udp_key(&ext->tun_id, &msk->tun_id, rule);
 }
 
 int nfp_flower_compile_flow_match(struct nfp_app *app,
-- 
2.7.4

