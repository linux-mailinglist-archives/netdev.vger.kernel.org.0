Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001DB273BF0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgIVHa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbgIVHa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:30:56 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C82C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:55 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c18so15855278wrm.9
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l5JzLPMeSD4caZ4wHfPPZr4JygseWiJe8yzApZMnhOA=;
        b=FHJ5o9QNENRX/vsvOtojGOaoVX/ooBOjoqHqry4nKpc7kq8ydzuc59EmVnd1OHR4wi
         x5hYswDm8A0SLY4X+0OpVCP2UEUQLzUTe8e3826LbFKlhKvmBbbb/ciywIh2rgioRl+D
         OorDlqKIPRIe4Umj8lHlExCUBRviKjiW6CuM7O6lAT7PEjB/lIyfVbh+Vm4KVVGdxjhN
         b0O5ZsCIGbSos+H1Pv3J1dwFTNzxqXd25hE84u2X7kc0LUcQFcAaWMGPdqXDpWgz6J8a
         LVy24MhNeqksjawhhhBo++6cS/SeDfmPLXGJ/jhWdt03/L8vgAw0d4YsFEYEvGUO/Wtt
         VYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l5JzLPMeSD4caZ4wHfPPZr4JygseWiJe8yzApZMnhOA=;
        b=LqD8U1xqR+wwyXQC6SIqSa0teIClbmx8vf1Z1+IGR/BEFHnPH2cufAbZ2crZJBqJqi
         C1R8l15Gj98hhrRUvVb0kmjXEAY8oB8JCL3lXCKQ9rkS7Dn/TcOkz7xPMJgFpwlvvNHL
         yyq0BEKidbo/toqeFoL70I93zIFWU9ZZSxXOjiAyUKXr4nFzT6wJYVV7G4medL2+Sono
         C1lcOa3McpruRuW3/xAzTxQKOVKFBda6kZueetgbs8asUY3E1mVGMiUWHmkhQlP0nDxa
         Ioa58KSh40yLxUUoWNrj5Ijoe+03KVEMUwUS2x06pvYsFSkW3TE/isVKKChiPnqyQ8iW
         KaOA==
X-Gm-Message-State: AOAM533wxnK0jsEEtgWyFtX95Lm1gEkQaY+SFyK0G7D5JBnbaPpDtUlN
        9y/7qnBCGrthxIO/pU7tzP8w/0XRAV/rUR0dADslcQ==
X-Google-Smtp-Source: ABdhPJxv8SwaPRlCqrTezQR9JsY948BSdSXuDIrm+dTnB5kIdZ0xtp/SV7eY5AlSa08hDMsuXEcNOA==
X-Received: by 2002:a5d:52ca:: with SMTP id r10mr3510001wrv.195.1600759854467;
        Tue, 22 Sep 2020 00:30:54 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s26sm3258287wmh.44.2020.09.22.00.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 00:30:54 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 09/16] net: bridge: mcast: when igmpv3/mldv2 are enabled lookup (S,G) first, then (*,G)
Date:   Tue, 22 Sep 2020 10:30:20 +0300
Message-Id: <20200922073027.1196992-10-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200922073027.1196992-1-razor@blackwall.org>
References: <20200922073027.1196992-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

If (S,G) entries are enabled (igmpv3/mldv2) then look them up first. If
there isn't a present (S,G) entry then try to find (*,G).

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index e1fb822b9ddb..4fd690bc848f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -127,10 +127,28 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		ip.dst.ip4 = ip_hdr(skb)->daddr;
+		if (br->multicast_igmp_version == 3) {
+			struct net_bridge_mdb_entry *mdb;
+
+			ip.src.ip4 = ip_hdr(skb)->saddr;
+			mdb = br_mdb_ip_get_rcu(br, &ip);
+			if (mdb)
+				return mdb;
+			ip.src.ip4 = 0;
+		}
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
 		ip.dst.ip6 = ipv6_hdr(skb)->daddr;
+		if (br->multicast_mld_version == 2) {
+			struct net_bridge_mdb_entry *mdb;
+
+			ip.src.ip6 = ipv6_hdr(skb)->saddr;
+			mdb = br_mdb_ip_get_rcu(br, &ip);
+			if (mdb)
+				return mdb;
+			memset(&ip.src.ip6, 0, sizeof(ip.src.ip6));
+		}
 		break;
 #endif
 	default:
-- 
2.25.4

