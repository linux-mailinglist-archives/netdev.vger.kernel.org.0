Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDEC33DC51
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbhCPSNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbhCPSNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:13:25 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD03C061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:13:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id p8so73719482ejb.10
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lv/KQKri9I42MI3Uya+n/ItNZ1IT5XUkk3FfUCTEpt8=;
        b=bLC7jaFz6o0o6UJ91KHFIgpXVVura5qk7t5JJc42mOVbt7sgmbyVRjRrGr6wPllJoE
         8lidjlq1cAkHV8WilzxYFmYbXnmt0jXxjkoHlahyKWp1sAqtZk97moxIjyi+JRmiz6vI
         fMQ0ZlHV3idomfRZyzXNevHfr95HuWUCgraRzBK0LXvkxjNES3pJsCbKEyQXZeGpaj6r
         eVX4FeXb8BSG46gsly/JfyLLN64H9LniVgq6XHsZXxPFA1e/UqocV0kBlZcLdkSQVFsS
         mFFhqthLfems4H4kl/jgH+rtaHLdd1JCaaffyKNrWunDXK7QiQ1QegR1xUttJXzGsbUD
         2ohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lv/KQKri9I42MI3Uya+n/ItNZ1IT5XUkk3FfUCTEpt8=;
        b=Uef5Ory6vUmpYN7WZN0QNnj5BUZ65PapSipaD3aY7HqHzm8qwmyXRQMfU2VQArw+uW
         vT5bue7ZnrHeu8wi0bSbnNYf+xHj59bnhU5jCMgyNdXv6e4E+pRmedpbeytj5bsNo/d/
         aahIxza8m5f2J3ZJTSb/d6JWvjs4Sqws0Xbxrqnftsckli/QFv04TxIg7k/HkrZVZ0jz
         CKId0dp02zRewDyNNcJCeUUKrIFkwSE2AXMsb+LqKijJVSmQbsG/8IOvvYtjjz6AzQ4B
         SvtVlAE27T4wGRe1GB/IJaETIJ6im7uJJ7y0yVOUm5+JmOrlE9/T3hdUkm6qUhvzbXNX
         RXXQ==
X-Gm-Message-State: AOAM533Saou9aNUbh0Utjjvly4DsmBd7/03EDfuhpbE+B82CYucnSoAn
        bpcy39muNCdKp1Jg8xclhJtRDA==
X-Google-Smtp-Source: ABdhPJxElDa/j782W4jVEFb8Box/0EglW8RbI7g7b7FD1nKhyt4HgS9L6ZBe5QMz38OgHWGJnSu5AA==
X-Received: by 2002:a17:906:c405:: with SMTP id u5mr31207500ejz.341.1615918403592;
        Tue, 16 Mar 2021 11:13:23 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id e26sm11537778edj.29.2021.03.16.11.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 11:13:22 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 1/3] nfp: flower: fix unsupported pre_tunnel flows
Date:   Tue, 16 Mar 2021 19:13:08 +0100
Message-Id: <20210316181310.12199-2-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210316181310.12199-1-simon.horman@netronome.com>
References: <20210316181310.12199-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

There are some pre_tunnel flows combinations which are incorrectly being
offloaded without proper support, fix these.

- Matching on MPLS is not supported for pre_tun.
- Match on IPv4/IPv6 layer must be present.
- Destination MAC address must match pre_tun.dev MAC

Fixes: 120ffd84a9ec ("nfp: flower: verify pre-tunnel rules")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../ethernet/netronome/nfp/flower/offload.c    | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 1c59aff2163c..d72225d64a75 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1142,6 +1142,12 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 		return -EOPNOTSUPP;
 	}
 
+	if (!(key_layer & NFP_FLOWER_LAYER_IPV4) &&
+	    !(key_layer & NFP_FLOWER_LAYER_IPV6)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: match on ipv4/ipv6 eth_type must be present");
+		return -EOPNOTSUPP;
+	}
+
 	/* Skip fields known to exist. */
 	mask += sizeof(struct nfp_flower_meta_tci);
 	ext += sizeof(struct nfp_flower_meta_tci);
@@ -1152,6 +1158,13 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 	mask += sizeof(struct nfp_flower_in_port);
 	ext += sizeof(struct nfp_flower_in_port);
 
+	/* Ensure destination MAC address matches pre_tun_dev. */
+	mac = (struct nfp_flower_mac_mpls *)ext;
+	if (memcmp(&mac->mac_dst[0], flow->pre_tun_rule.dev->dev_addr, 6)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: dest MAC must match output dev MAC");
+		return -EOPNOTSUPP;
+	}
+
 	/* Ensure destination MAC address is fully matched. */
 	mac = (struct nfp_flower_mac_mpls *)mask;
 	if (!is_broadcast_ether_addr(&mac->mac_dst[0])) {
@@ -1159,6 +1172,11 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 		return -EOPNOTSUPP;
 	}
 
+	if (mac->mpls_lse) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: MPLS not supported");
+		return -EOPNOTSUPP;
+	}
+
 	mask += sizeof(struct nfp_flower_mac_mpls);
 	ext += sizeof(struct nfp_flower_mac_mpls);
 	if (key_layer & NFP_FLOWER_LAYER_IPV4 ||
-- 
2.20.1

