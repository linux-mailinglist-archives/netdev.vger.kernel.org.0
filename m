Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8BC1238F8
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfLQV5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:57:40 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:34119 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLQV5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:57:38 -0500
Received: by mail-wm1-f46.google.com with SMTP id f4so3194334wmj.1
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uzrmIQOAAmgSjh/b+R8Ao3rWPk++nLaEYfmGaTgSlFY=;
        b=h/rnSl103+RFGSHgtNVh4J0WFeVZywdagaAfb8OeHpD4fAfxmpzxdl1QbazS76wu0b
         sF7LxLBCMWdtkaG6qz0kVbMNcMFuR+WT/lbB75J13CU2FiOz5QYWA7or1hLutJti0hdD
         IrDDn/E1duVN+WJJm7biNaUnHHNQctLj6u0zgOl+XuXdatR9pm6ejuuQ2vEVI+J/VblU
         /gPOd2UQgI1WsY9UuzDN7MAfQzBgfNa6o6v1QDPb03l0OCGRqa3yNXtk1lCy97r0K1rZ
         cdm26XfiZjmTpDvAvmJHwvw7vc7RxfxF446dzrDW6Yqarm9wS3ZbgM8pUXxgZ/Ullx4V
         qIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uzrmIQOAAmgSjh/b+R8Ao3rWPk++nLaEYfmGaTgSlFY=;
        b=PoNFn8Tb5r7234w8SkI0JoZm9+MCHgdiWoAagkgaRbAweFQl2OC9CzObVF978p/Ftb
         jglzqEfQ/xY/LH7o+9HsgDkgF5Dn2QXknUMgs+WbEYu6kiHOlxnXXVEP8QYubC8FTAuh
         n0y7bp+51U9jZKXVHaFQbyDRdsyI6eEANoyh8IgQLlEUVbOGqZ5e0TXI+qyehdWFLJdY
         4VdET/mGXnl6ultLFuvt+H8PVKb+Mctj/IcI+pSlEVMlxLEi+3V5zPjqTn0Wdbduze2Q
         ARxr0ACDHwkFOoiaCWe6ET1VUquqJi7YFwaN2ShPQ/Is1unDrqp/rnQ7sd0nRYZig18M
         xGEQ==
X-Gm-Message-State: APjAAAUmY8wwCWSD7kxDufnKtM69lx1v4qDGcgj5td+iRAEauS43r9zT
        LjX0tji6qYQL3aHbkmOz1dawdYAYHXEsEODLVLwgU4FKzy9jGcL89LU16pX8glnVYJTwlct1mDZ
        K3QQIVG0wPW4un72hGO9AkTXKUIQJU0usozDhyzwGv+jwCJrZofEPjQVV4ueP+BN1SLjo5pwQvg
        ==
X-Google-Smtp-Source: APXvYqyKlVGIJFRBG5sWx6Q7mEMtiAi+/LNS1FRnguj52y+IkF3blZpIZzVEFVuuy6X0FDDrPFAHAQ==
X-Received: by 2002:a7b:cf39:: with SMTP id m25mr8068104wmg.146.1576619855357;
        Tue, 17 Dec 2019 13:57:35 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u22sm157109wru.30.2019.12.17.13.57.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:57:34 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v2 2/9] nfp: flower: move udp tunnel key match compilation to helper function
Date:   Tue, 17 Dec 2019 21:57:17 +0000
Message-Id: <1576619844-25413-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
References: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
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

