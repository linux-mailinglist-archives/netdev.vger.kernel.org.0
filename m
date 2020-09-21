Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4871272190
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIUK4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgIUK4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:21 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC10CC0613D4
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s12so12221756wrw.11
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l5JzLPMeSD4caZ4wHfPPZr4JygseWiJe8yzApZMnhOA=;
        b=IO/2p5RcCNDAhlli9hKfGjfbtZuFnkT8KgLMs3Zi0sBS+7izwyFFKIaVLhXo2jDavO
         aoEEYw2QyNqWDGe/x7OPnD/9QBJfvvPFiXxf15E+zuXwDFWJwE4lrtDVWOkguhbDLiUd
         BuRkNDq2SCnQME1WJ59jlFoFsljjh3mNyRkNr5g5GduGropZaZJgTC56+NQgLt/8mnw8
         RohYNHKi6oyrwG3iTpwxSDTnd3gE9+zyyHWqIKjkp1ihPvqglXAxQgvTziuzRVW56YRf
         JsDt3q5DNNijbMoCDXAGy5/W/cwfA7Hyhw9R2zXd/rkefuyZ/BHP3vIN8yCXBNqixoiF
         OEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l5JzLPMeSD4caZ4wHfPPZr4JygseWiJe8yzApZMnhOA=;
        b=HVlTUPrcT7P4TkSy7CR7IbG6jUY36mBPMKl37gqZma9ftE5V7iJd1u2D3vbiLk5HSd
         U17yUagFsmc7GN0YvsF454ZmYKz/au8jL3n+wg1yUGaqPN1LSp0eRWaWCqxw8l9mYSkN
         DZHCWzDpD9wLON0JHgAqdNMm86Hw5+hChR9B2w8mx84LKTiuj4pQGBoENboFqUleGQPP
         Km1tTLxtYBtTWWdZadR7SZwX1RF8Jy+7537v2I7h/qJDbkhnbtGIyjDCciqJiIrqZBtS
         rBmlflr3UgxFb6pTzD+Fu/q6XXYM3NARotzybuSNhndrbJvl90vxXg6FNu5nThee8TYb
         Wicw==
X-Gm-Message-State: AOAM532Qxuaz9CSkwp044D0WCJmZNNe+4zf3+1Fzj3F+yNOSVCpo9AaZ
        QmXnSHNPF/DJU3YQX/dFgpjPQ1T3yyfqkff8a32HLg==
X-Google-Smtp-Source: ABdhPJysfH2xxkm4oCX4D6v/GyVAd55+R4mSt8TWxZIp/k7yyMuGN3xJOPu2C76NZipN5eJBHJ2r4Q==
X-Received: by 2002:adf:ec47:: with SMTP id w7mr55435821wrn.175.1600685779388;
        Mon, 21 Sep 2020 03:56:19 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:18 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 09/16] net: bridge: mcast: when igmpv3/mldv2 are enabled lookup (S,G) first, then (*,G)
Date:   Mon, 21 Sep 2020 13:55:19 +0300
Message-Id: <20200921105526.1056983-10-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
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

