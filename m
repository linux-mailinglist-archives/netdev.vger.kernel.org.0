Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD4B35CFE0
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244048AbhDLR5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:57:12 -0400
Received: from mtel-bg02.venev.name ([77.70.28.44]:35298 "EHLO
        mtel-bg02.venev.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243494AbhDLR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 13:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=venev.name;
         s=default; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MEJWCdZumog7GpK6zkAyXmJLIgWRkjlSOA6p+vvTDZY=; b=O3MEzKjLkY0XaCzbPo8uMXYAZd
        OeTIyX7V0Ljkino9rPyn/zsu9CYuQxaZMVSPmPfxVIFgXS1phYWqF15Ys9Q5e5PBH0eqMBKXAXOHI
        Gda4pLZ9d/2F6YkWPMsp2R7peq6vTLfpRyPgy1Bm88RZcdfD7/7302bhbh348HMsB/Xy0lJNuU61g
        zb4R3W/Jc579ZoXcFEfxl+5c7QtS87Rw2eNJP6tkWr/lfNT0LaYXBRPUZd+gGEdR8iq4kwAT+84N7
        uKRMhps+02PaU/54Ni6AgaRYLz6Bz1ZXebu4fV0we9scyZ5/+816ZQGvUZDT0epEOV13b1OJKqvL5
        om/NJYOPx62uaPo7a2Tz46WxV19JsxxeGu8d5u+gmoVg5UPOA651sSF7NSwy6dnv2akBSFt/5Kext
        UNAftc/MZ73Ax7GOPvdvIaNyCbOc1/Zg3jQ+dcVnVkKRYJ2hkxBApt24k6ZxrNwxj9Cnt3gjaXGKM
        P1A4vBX8EthCfZHyLxgbg2R0mxxchsHGJ8LLJ8CHg96u2jW4QiHQMnPF33Ds+7+E5+QUOVa3HAxWc
        Gi5gDthNGEFLFIM70LjOEKN2zG3EXdVCzlGT/Slnj3o/9JEEz+5NH4sQ1xOe5vA4JqkuzVgA1v252
        MgXahkdsyeoIje2PUjZ35uc2VIAZc24qpuu5ZS9+U=;
X-Check-Malware: ok
Received: from mtel-bg02.venev.name ([77.70.28.44] helo=pmx1.venev.name)
        by mtel-bg02.venev.name with esmtps
        id 1lW0Z4-001FxJ-QN
        (TLS1.3:TLS_AES_256_GCM_SHA384:256)
        (envelope-from <hristo@venev.name>); Mon, 12 Apr 2021 17:41:34 +0000
Received: from venev.name ([77.70.28.44])
        by pmx1.venev.name with ESMTPSA
        id kKSLME6GdGCNkgQAdB6GMg
        (envelope-from <hristo@venev.name>); Mon, 12 Apr 2021 17:41:34 +0000
From:   Hristo Venev <hristo@venev.name>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Hristo Venev <hristo@venev.name>
Subject: [PATCH 2/2] net: ip6_tunnel: Unregister catch-all devices
Date:   Mon, 12 Apr 2021 20:41:17 +0300
Message-Id: <20210412174117.299570-2-hristo@venev.name>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412174117.299570-1-hristo@venev.name>
References: <20210412174117.299570-1-hristo@venev.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to the sit case, we need to remove the tunnels with no
addresses that have been moved to another network namespace.

Fixes: 0bd8762824e73 ("ip6tnl: add x-netns support")
Signed-off-by: Hristo Venev <hristo@venev.name>
---
 net/ipv6/ip6_tunnel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 3fa0eca5a06f..42fe7db6bbb3 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -2244,6 +2244,16 @@ static void __net_exit ip6_tnl_destroy_tunnels(struct net *net, struct list_head
 			t = rtnl_dereference(t->next);
 		}
 	}
+
+	t = rtnl_dereference(ip6n->tnls_wc[0]);
+	while (t) {
+		/* If dev is in the same netns, it has already
+		 * been added to the list by the previous loop.
+		 */
+		if (!net_eq(dev_net(t->dev), net))
+			unregister_netdevice_queue(t->dev, list);
+		t = rtnl_dereference(t->next);
+	}
 }
 
 static int __net_init ip6_tnl_init_net(struct net *net)
-- 
2.30.2

