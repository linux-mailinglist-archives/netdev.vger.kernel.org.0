Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452712F708E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbhAOCYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbhAOCYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:24:41 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD40C061575;
        Thu, 14 Jan 2021 18:24:01 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 15so5060963pgx.7;
        Thu, 14 Jan 2021 18:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0+CNzsPI08lc0FEN4jQWPjCrTyVyDSMDwF2TyVIOOB0=;
        b=W0HvD9T5SMroyQM1zDFU9Z+AoN9DEnCUXIuOY/TawBj4BB/GqU7nSgXjGnwYrQnye2
         Et7mJ2fjIxmbpSQEe6s/WMsLb3duB74xtdcW6dleS+yuAwOVEooii9h7S4NyweaO94N2
         jJcwHn1ALZjXAt1UxwIk3dq+jFqxPCFuiDn4p41riOdNAQQEcoz3PPkJbTuIEtNoImIS
         4H4xivrxtQFGRvGDM70dMlXLCKgSeQVeusJmzCUH/UGe3vIqYT9viDktBJsEqzg6asiR
         UhUVzk107+g8Ft2GAhfHrVOVF0NHy4JQj+WWyr/p6Ko2JdO5kGNGrtwbyM2yuvf3TrR8
         TCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0+CNzsPI08lc0FEN4jQWPjCrTyVyDSMDwF2TyVIOOB0=;
        b=kG5oCSmy+rmnhZG26MERA2f2a2bR+njXNt9Y9owbWQvrW/MnozJh38p9yfHHX9BQUL
         8mksNzEEl9BJ1uyRTefqd3nssoBsZUoutH0eDJ0viciHmJt6GLZXykh+VFkuM+tIr/Lu
         HNykuw17LhVt+GFWPZKT54f8veiJs7Xlw1PUHc99HhH9npNQ7KyHGwznu/RuGiWEKTrD
         eUccVahDk4C9L6auUSgyMoBzI1j0MazkQ+NxdrlRJs2ivQxMDDl9JhRu/mH0FyXOkper
         XJg/SICrjRqGvu6FTU5ut6TRl2ciCH6uCu+C+8EcTiNRPXlFl3Ynqooh2lVaVwqYsfcm
         apLQ==
X-Gm-Message-State: AOAM53353xIgcPRTklCTe2T2VHakc9yJ5fVaLdPbeo/SAWPEnFm8ai/1
        tS6bjJgO+fdBchH8AlKfWSw=
X-Google-Smtp-Source: ABdhPJynUIMXg3f4JrUG9f9WwCA8Xf8sVPFjK8cXa0E0voFwWHMsfzn9D3V+64BdEkHL+67AeVuKVA==
X-Received: by 2002:a63:5d7:: with SMTP id 206mr10647259pgf.384.1610677440765;
        Thu, 14 Jan 2021 18:24:00 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id b12sm6214127pft.114.2021.01.14.18.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 18:24:00 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     nikolay@nvidia.com
Cc:     roopa@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v2 net-next] net: bridge: check vlan with eth_type_vlan() method
Date:   Thu, 14 Jan 2021 18:23:44 -0800
Message-Id: <20210115022344.4407-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Replace some checks for ETH_P_8021Q and ETH_P_8021AD with
eth_type_vlan().

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
v2:
- use eth_type_vlan() in br_validate() and __br_vlan_set_proto()
  too.
---
 net/bridge/br_forward.c |  3 +--
 net/bridge/br_netlink.c | 11 +++--------
 net/bridge/br_vlan.c    |  2 +-
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index e28ffadd1371..6e9b049ae521 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -39,8 +39,7 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
 	br_drop_fake_rtable(skb);
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (skb->protocol == htons(ETH_P_8021Q) ||
-	     skb->protocol == htons(ETH_P_8021AD))) {
+	    eth_type_vlan(skb->protocol)) {
 		int depth;
 
 		if (!__vlan_get_protocol(skb, skb->protocol, &depth))
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 49700ce0e919..15cfcad846c5 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1096,14 +1096,9 @@ static int br_validate(struct nlattr *tb[], struct nlattr *data[],
 		return 0;
 
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
-	if (data[IFLA_BR_VLAN_PROTOCOL]) {
-		switch (nla_get_be16(data[IFLA_BR_VLAN_PROTOCOL])) {
-		case htons(ETH_P_8021Q):
-		case htons(ETH_P_8021AD):
-			break;
-		default:
-			return -EPROTONOSUPPORT;
-		}
+	if (data[IFLA_BR_VLAN_PROTOCOL] &&
+	    !eth_type_vlan(nla_get_be16(data[IFLA_BR_VLAN_PROTOCOL]))) {
+		return -EPROTONOSUPPORT;
 	}
 
 	if (data[IFLA_BR_VLAN_DEFAULT_PVID]) {
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 701cad646b20..24660fe33545 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -917,7 +917,7 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 
 int br_vlan_set_proto(struct net_bridge *br, unsigned long val)
 {
-	if (val != ETH_P_8021Q && val != ETH_P_8021AD)
+	if (!eth_type_vlan(val))
 		return -EPROTONOSUPPORT;
 
 	return __br_vlan_set_proto(br, htons(val));
-- 
2.25.1

