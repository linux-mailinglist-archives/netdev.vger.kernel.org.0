Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578DF1B118C
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgDTQ15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729526AbgDTQ1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:27:55 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E46C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:27:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id u13so12973506wrp.3
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0JRG0YANHlaDrsdL6zAtAcfGdVROdNU0WIv4cLW5emg=;
        b=hM0E8gJc4Q8Yno/fYAZ9st6WbUWg23oOeWIU7wAKm4drSezQLBZnNpBKM4X1Ji0aiM
         Y+X2y9nqyx0HXBljKQ54DrhtGemfCUYLXrLIM0Al0Dc9PY1Dlw9K4Nos3n3kv1Fm3MiN
         aQ9MpPqM3H/uKG+NthVF4wcY4xlavXyp6m9btFbFiFmG0zgUuRvX1Y8vtJk3V6gb5DfK
         rPbvhG9gk/oBvONz56WKOdx67lWtJ0iY6F0bzQvJUFwTRLOz7w7qiAOxBnh0GIMqJiPG
         o6TMsny8GHFD3iQv6nW4/XA/ihWRYY34pRASDe84LrhBoxpgzsL55JcKo+IE2pAEcFmX
         EdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0JRG0YANHlaDrsdL6zAtAcfGdVROdNU0WIv4cLW5emg=;
        b=MAxhRZ6QNHNWNYn4vxuRHyKks1dhPjwXxlKqBA9mQN4GL3ngpbaH6HdpvsoomJpgJz
         eACCXQCskl6Y3QdYjsx7kiWZN3a9Zw0LG29ZaZKduKJnO9sQqd1S+ka5jQGkrUP2Qkyn
         5hq6fX6oQc7vJ5sR3+8eFs8HR9s/OJvN+Tlrt7D9UxOO/jyyfpu15cTfgmnrFGpLUVdT
         yPE1mW1aOO58xePN5cIBkOPh0PRFBkWeVJPK/YT23ICOFjp6SqLKb4ZpKyX3VItsG3CR
         J6VBVEXANAUMvDY/4RV7cA5Wrt21JWHxScwtH24J2kHFLi5WMfDJgNqHzxUwNDmmQhEx
         sLxQ==
X-Gm-Message-State: AGi0PuZbq0tgSOkuv12qmHo50gx2q9oQYeJnd4bti1NMbVrN+Oc/8LlF
        nmEkJtZw6AsYFHpcASLXhwXtXgVUX8I=
X-Google-Smtp-Source: APiQypKH8xrYlvU8P62i4XC3yjztIFMbJ8tmhPee+gfkIaOt8rbff9BamAIdFAknYs6+NV351eVY3w==
X-Received: by 2002:adf:fe03:: with SMTP id n3mr18970198wrr.315.1587400072627;
        Mon, 20 Apr 2020 09:27:52 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id 185sm146245wmc.32.2020.04.20.09.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:27:52 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@idosch.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        kuba@kernel.org
Subject: [PATCH net-next 2/3] net: mscc: ocelot: refine the ocelot_ace_is_problematic_mac_etype function
Date:   Mon, 20 Apr 2020 19:27:42 +0300
Message-Id: <20200420162743.15847-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420162743.15847-1-olteanv@gmail.com>
References: <20200420162743.15847-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The commit mentioned below was a bit too harsh, and while it restricted
the invalid key combinations which are known to not work, such as:

tc filter add dev swp0 ingress proto ip \
      flower src_ip 192.0.2.1 action drop
tc filter add dev swp0 ingress proto all \
      flower src_mac 00:11:22:33:44:55 action drop

it also restricted some which still should work, such as:

tc filter add dev swp0 ingress proto ip \
      flower src_ip 192.0.2.1 action drop
tc filter add dev swp0 ingress proto 0x22f0 \
      flower src_mac 00:11:22:33:44:55 action drop

What actually does not match "sanely" is a MAC_ETYPE rule on frames
having an EtherType of ARP, IPv4, IPv6, in addition to SNAP and OAM
frames (which the ocelot tc-flower implementation does not parse yet, so
the function might need to be revisited again in the future).

So just make the function recognize the problematic MAC_ETYPE rules by
EtherType - thus the VCAP IS2 can be forced to match even on those
packets.

This patch makes it possible for IP rules to live on a port together
with MAC_ETYPE rules that are non-all, non-arp, non-ip and non-ipv6.

Fixes: d4d0cb741d7b ("net: mscc: ocelot: deal with problematic MAC_ETYPE VCAP IS2 rules")
Reported-by: Allan W. Nielsen <allan.nielsen@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 8a2f7d13ef6d..dfd82a3baab2 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -739,14 +739,24 @@ static void ocelot_match_all_as_mac_etype(struct ocelot *ocelot, int port,
 
 static bool ocelot_ace_is_problematic_mac_etype(struct ocelot_ace_rule *ace)
 {
+	u16 proto, mask;
+
 	if (ace->type != OCELOT_ACE_TYPE_ETYPE)
 		return false;
-	if (ether_addr_to_u64(ace->frame.etype.dmac.value) &
-	    ether_addr_to_u64(ace->frame.etype.dmac.mask))
+
+	proto = ntohs(*(u16 *)ace->frame.etype.etype.value);
+	mask = ntohs(*(u16 *)ace->frame.etype.etype.mask);
+
+	/* ETH_P_ALL match, so all protocols below are included */
+	if (mask == 0)
 		return true;
-	if (ether_addr_to_u64(ace->frame.etype.smac.value) &
-	    ether_addr_to_u64(ace->frame.etype.smac.mask))
+	if (proto == ETH_P_ARP)
 		return true;
+	if (proto == ETH_P_IP)
+		return true;
+	if (proto == ETH_P_IPV6)
+		return true;
+
 	return false;
 }
 
-- 
2.17.1

