Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D1D2F71A8
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbhAOEmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbhAOEmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 23:42:18 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F74EC061575;
        Thu, 14 Jan 2021 20:41:38 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id w1so5639242pjc.0;
        Thu, 14 Jan 2021 20:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5IUJFfkhyOjUeQe/gYauu/2sKrd/DEbUds1gC+B5RU=;
        b=DpDvfQf3vyJbpzghRJ8Cew7bzqpKpLzkvro4EJtc49amvTSAelFioDvmVj1BFNrFcN
         vpotcO2IAcg8vzQ1dZqwVLHvDHERBOGOjZ/1eQLboSDqY+YHQ7ZLtNnkM0kXqHEU8sdy
         t+rgEfzXJ900nUH2ET41LCxgZ00KFeW33M0etBMG/M8ssVzO9BgybOlF8uobyQ4SnU3E
         189WhrVboNLOjebfz/Qf+s+xUQqcuCof5n7aGc8bnsNWK/HsU8LgYKnqyVV7YrHg5wnE
         LMcth4tbTxbGxECyb6GG/fA6LBkSeWHaiU6ssOfmQWLa7vu+ldc8M3rFpTOkZB03o4Nu
         YlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5IUJFfkhyOjUeQe/gYauu/2sKrd/DEbUds1gC+B5RU=;
        b=FGRJednIY5RB8d6ounWrzthaRl9o6MFZpge4VkM9w8eaxybTOn14ewpng7kKWiC888
         Uy0re1znEKnlQ1Ooj4K+qUJevoj7R6j35G6vxeJfvTG6ALGGDSrkp+nRpKCSCLGfCJ3P
         G4KwT4uUIKr04uzanNzXOn0kiHMHnOqidHYo8bDPPb/ZN1w4RsdNcNmLkkcANNjybu+R
         WaaaCRcULwFkEd0ZWxauw87hNUmQ4hFkAtAN5ZdsIhNQ15xnsmsL9mJsnZfsPvPTBw4Y
         inPp6Qu+gDR0MSc+bljlG9lbPbSxtEQDumHSbTydgWJhxuQg7WMyzIl4r9cKEl+rZBQ8
         9Z7g==
X-Gm-Message-State: AOAM532GsGNgVMRmSjra5OkQmpHVu3LL7gCs7ZLLPLlrGJBSlEG4tfuL
        RlXsjskUYX8Z62y/AG9tAwQ=
X-Google-Smtp-Source: ABdhPJzVhnD2uVEfIuermtvP0wV3QoRtfc7kohfEt+M9NsHkXTbBJQJGw/HgElaYrtHLps9wW83qgg==
X-Received: by 2002:a17:90a:ae02:: with SMTP id t2mr8458110pjq.169.1610685697862;
        Thu, 14 Jan 2021 20:41:37 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id r185sm6358600pfc.53.2021.01.14.20.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 20:41:37 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v3 net-next] net: bridge: check vlan with eth_type_vlan() method
Date:   Thu, 14 Jan 2021 20:41:31 -0800
Message-Id: <20210115044131.6039-1-dong.menglong@zte.com.cn>
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
v3:
- fix compile warning in br_vlan_set_proto() by casting 'val' to
  be16.

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
index 701cad646b20..bb2909738518 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -917,7 +917,7 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
 
 int br_vlan_set_proto(struct net_bridge *br, unsigned long val)
 {
-	if (val != ETH_P_8021Q && val != ETH_P_8021AD)
+	if (!eth_type_vlan(htons(val)))
 		return -EPROTONOSUPPORT;
 
 	return __br_vlan_set_proto(br, htons(val));
-- 
2.25.1

