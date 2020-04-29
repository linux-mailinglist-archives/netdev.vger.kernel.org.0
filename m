Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BC21BE39A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgD2QUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2QT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:19:59 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75236C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:19:59 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v8so5329678wma.0
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sslderKR2VnBe3vbWtKjxt2i8MRgj916M4Mgvk8OZR0=;
        b=DcoEu8TwsirMmJY1ujDyd/YDbLX3E35lTqumTv3D1wU5xQRTGw54MEIDx6xwud7JGr
         f/vbErxiE/8r2Rmbj/K9x6tZp9p2EUWR6eT/Avis6iFNQXfgT9T0oQHKG7de7jxQT9Kj
         KoW/0333jIvdmDYCy5RPfvPwlzsGD+9EVKhu9XAKJpe1W/RWmeajAXaO9c3wX5K+PPsx
         YZnAG92ErIWWgt+yrncTkvV92OFQ8Wmm9xuIiAnrtAqqDw/imj9lQTSWnH9SoTpVGiTZ
         WfBayjCQ3xvXoft8U8B5p+4NZOcVHCqQIso7flwUIy9q32o+7FiJ9GPjt8bPSdbXmXd3
         b/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sslderKR2VnBe3vbWtKjxt2i8MRgj916M4Mgvk8OZR0=;
        b=j3GBvJHizNK7msyo7H/Kuyxbbziz1eqla1c6vwrjsonvxp8zMqaxzWo8OHnu9uVNBF
         JVbI5Geh8MPSnfcskUzNCsBSNHem5KC57De5My4cw783cxNemr7OYWfbd89xslbXvdui
         nDqr+T5CynpGlTZdmW0tekJ4zbMXPJYn8XB8YkQ/ORZBtx93ueTx4gcc84yopd84xAWx
         S0QlKBFy1mPwEwEOzamqCoK2LzmNS7Oht8Sb7qVNxDRULaOZQTHJjN/xI4g8KtkhZJjn
         HQII1SvX6WvQHiwE6oxzZ2HR+Ef0sr2RgozqYDLNvWB++BPrMCpWR8dSfyv++VgObzWr
         sWMg==
X-Gm-Message-State: AGi0PuY2HX5yRUTE4vUPlUFCNosh8cJbfdjBaIDJYIC5JAyXw4LfTFB0
        4C7ku3owJ93yJmqhWqWsEx4=
X-Google-Smtp-Source: APiQypJJuUY/UEoG2j7KslBLNLCUWab8feTEw73uVtckG+jifWULQYVDGuH1I5gXP5qH19gDW6Vu9g==
X-Received: by 2002:a1c:c302:: with SMTP id t2mr4225330wmf.85.1588177198160;
        Wed, 29 Apr 2020 09:19:58 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r18sm28132609wrj.70.2020.04.29.09.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 09:19:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com
Subject: [PATCH net-next 1/4] bridge: Allow enslaving DSA master network devices
Date:   Wed, 29 Apr 2020 19:19:49 +0300
Message-Id: <20200429161952.17769-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429161952.17769-1-olteanv@gmail.com>
References: <20200429161952.17769-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

Commit 8db0a2ee2c63 ("net: bridge: reject DSA-enabled master netdevices
as bridge members") added a special check in br_if.c in order to check
for a DSA master network device with a tagging protocol configured. This
was done because back then, such devices, once enslaved in a bridge
would become inoperative and would not pass DSA tagged traffic anymore
due to br_handle_frame returning RX_HANDLER_CONSUMED.

But right now we have valid use cases which do require bridging of DSA
masters. One such example is when the DSA master ports are DSA switch
ports themselves (in a disjoint tree setup). This should be completely
equivalent, functionally speaking, from having multiple DSA switches
hanging off of the ports of a switchdev driver. So we should allow the
enslaving of DSA tagged master network devices.

Make br_handle_frame() return RX_HANDLER_PASS in order to call into the
DSA specific tagging protocol handlers, and lift the restriction from
br_add_if.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_if.c    | 4 +---
 net/bridge/br_input.c | 4 +++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index ca685c0cdf95..e0fbdb855664 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -18,7 +18,6 @@
 #include <linux/rtnetlink.h>
 #include <linux/if_ether.h>
 #include <linux/slab.h>
-#include <net/dsa.h>
 #include <net/sock.h>
 #include <linux/if_vlan.h>
 #include <net/switchdev.h>
@@ -571,8 +570,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	 */
 	if ((dev->flags & IFF_LOOPBACK) ||
 	    dev->type != ARPHRD_ETHER || dev->addr_len != ETH_ALEN ||
-	    !is_valid_ether_addr(dev->dev_addr) ||
-	    netdev_uses_dsa(dev))
+	    !is_valid_ether_addr(dev->dev_addr))
 		return -EINVAL;
 
 	/* No bridging of bridges */
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index d5c34f36f0f4..396bc0c18cb5 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -17,6 +17,7 @@
 #endif
 #include <linux/neighbour.h>
 #include <net/arp.h>
+#include <net/dsa.h>
 #include <linux/export.h>
 #include <linux/rculist.h>
 #include "br_private.h"
@@ -263,7 +264,8 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 	struct sk_buff *skb = *pskb;
 	const unsigned char *dest = eth_hdr(skb)->h_dest;
 
-	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
+	if (unlikely(skb->pkt_type == PACKET_LOOPBACK) ||
+	    netdev_uses_dsa(skb->dev))
 		return RX_HANDLER_PASS;
 
 	if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
-- 
2.17.1

