Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC4811DFF2
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 09:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfLMIx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 03:53:27 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40216 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfLMIx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 03:53:27 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so957245plp.7;
        Fri, 13 Dec 2019 00:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=bmdEACMIBIFk+abrQ7LVRrwOMAr+I9j1zUZETfgRrXE=;
        b=nYlGKAy2EXOK3Ny8MZ6Cc/ioO/qdpZoF1ej2npsFXtWQ9gfxqdy1dJAbhm5oglH5Jg
         eYK03OVFrkTrAVTGTUDVENqm43szAlAmgF7liQT8PtwfGLE6GGWZirMF+TnFiyckiAnp
         qCjjftQm76UFvBQsv7yKtWK0231ibmkjqLR7ihblluyNdgP7+cVTIyYHFxGQy9xoSvCr
         LIDjn+lsv11yNEYClNerkKYCV+7oq+GasNISYtuiVLCcp9PLmw+8t6WMaFtxCf7b35Q8
         nLz7P0q+GwKa1NklpR8mLorjDAM6Irfe2KPQQQkgsJvSR8oWlMF5K0x4r2jthPPFDXQQ
         zs1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=bmdEACMIBIFk+abrQ7LVRrwOMAr+I9j1zUZETfgRrXE=;
        b=ppoLfRppB5LiDEEPfKPXaM7V2c3zfzWIyO3XAndnXxNujo70aztSUYjDZHUzupzCSF
         1erjAgTwCPcW/J8a6Dd593tKyQvt0mTLhckq0Gtb3B7tsXtrGcFEzEskk+3dEVnP30uQ
         v7eo+RFaOwowbB3f700GezYgaJ4iqu+ARuNullwhVXJZ6YNR740aXTw+BXJbOmIqGi7X
         ysGxPe58a+wyjxfSazvu7POssUjgcnnyA9vns9l4FfQdqWbJMDa+nwdJUx56GoOBAaN2
         UAdyRs6XOUGD09tGYH/VlGXf+PQvisYtPOehtj72rjZyCuGoqDlMNdg1/EBhJ2Eay1vp
         RkBQ==
X-Gm-Message-State: APjAAAWBsWWqv543EA0lA5h0UPwICjHj62kHc1lAqyaT6asnv7mljEK4
        rGK22tRDc5Xb+l/UU5a2fRD6bmyJ
X-Google-Smtp-Source: APXvYqzyEvb6eK9Epvdw//06VUM9e+BnT+whdY4PZAfHkEH1U/btMHZhg5R79888/PnJNv+RsGcVJQ==
X-Received: by 2002:a17:90a:26e1:: with SMTP id m88mr399275pje.101.1576227206166;
        Fri, 13 Dec 2019 00:53:26 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q21sm10219963pff.105.2019.12.13.00.53.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 00:53:25 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCHv2 nf-next 1/5] netfilter: nft_tunnel: no need to call htons() when dumping ports
Date:   Fri, 13 Dec 2019 16:53:05 +0800
Message-Id: <38e59ca61c8582cfc0bf1b90cccc53c4455f8357.1576226965.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1576226965.git.lucien.xin@gmail.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

info->key.tp_src and tp_dst are __be16, when using nla_put_be16()
to dump them, htons() is not needed, so remove it in this patch.

v1->v2:
  - add Fixes tag.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3d4c2ae..ef2065dd 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -501,8 +501,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 static int nft_tunnel_ports_dump(struct sk_buff *skb,
 				 struct ip_tunnel_info *info)
 {
-	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, htons(info->key.tp_src)) < 0 ||
-	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, htons(info->key.tp_dst)) < 0)
+	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, info->key.tp_src) < 0 ||
+	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, info->key.tp_dst) < 0)
 		return -1;
 
 	return 0;
-- 
2.1.0

