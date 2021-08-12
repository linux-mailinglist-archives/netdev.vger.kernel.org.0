Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C43B3EA6DB
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 16:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238187AbhHLOxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 10:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbhHLOxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 10:53:43 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22888C061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 07:53:18 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q18so1841885wrm.6
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 07:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8vHH3dRPZUOley7Ar+nsperH168aY8khP+KjovRza6M=;
        b=jpC4xEr3Ft6umUAUC2q9jFumOcSWa8U9u03hewojhj87pX8wOaLkOHuacmOpqN5Mpq
         SD1y3wN538pNMUV7xdgom+3w9Vp/CXz7p78OV00ATr6I7hkYJ3BSg8fQLSf7P1TUJy9i
         4F+4jAz13YZQd6V9nqN9IShuJxJF7C2MZJjAHExthP0eDwWmEkaGBtHPEeThWmrJfRUB
         soV+Y/oCMxnGC88SN38hU83bQ4/2qIYvLWJAXcsZNyMbWt75T5PnH1nxX0n8bt2z7a/l
         W8u7q16IlCQWBMN+fUrOJvjeNT8UxcenWInjZxJfUPRK+TOKAz0ajuLs8qBWaLVT2u4n
         Si0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8vHH3dRPZUOley7Ar+nsperH168aY8khP+KjovRza6M=;
        b=dRE/km7TxHGzix2R8Ok497BvNmeTHJkVDaSDW/D0WqVUMD+9iQq5c4+Zyv82Qr1UX0
         XCzxW5FVObAOptyMJ69NaYzOOo9LVgRrZ8ukNF4Sm7PT4exRBxu752Sxni6X9TVUFCt1
         fdEIjf0k06uWB3rJ0nUfBXgZDTbsWPnU6YYk/M3VhyvN4QXxIdSEjim0uUJTn8/HMWQu
         5NU/YenAaPtAIpFtPir1rmMiCY9O/MXrDbvOpG1iS15zJSGXqGjZ8wQZDSsDmMWuIkrW
         YU9PyrGMVJJds3J9LxdgzXd5TmXY2vcb/U6O5ZSsspfUtEPxAreIhBt4sBfYiZwBWRB5
         TdLw==
X-Gm-Message-State: AOAM531sqL1EC57P921+GFAw4N2WOpxMKqmeKcwWmnGQTLhs0QsmUrok
        YCyp97SF6O9CPoEZTGa6SL7sG1XCEsHG3V4=
X-Google-Smtp-Source: ABdhPJynDMaUEnYrTRObD6Lm+3HY93cn7aYOEVV7Z0FflRGM/OmCAuA5JV8VViq1A/iLcIUwppq8zA==
X-Received: by 2002:a5d:6552:: with SMTP id z18mr4608379wrv.380.1628779996368;
        Thu, 12 Aug 2021 07:53:16 -0700 (PDT)
Received: from localhost.localdomain (mob-194-230-159-88.cgn.sunrise.net. [194.230.159.88])
        by smtp.gmail.com with ESMTPSA id e10sm3149272wrt.82.2021.08.12.07.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 07:53:15 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jtoppins@redhat.com, Jussi Maki <joamaki@gmail.com>
Subject: [PATCH net-next] net, bonding: Disallow vlan+srcmac with XDP
Date:   Thu, 12 Aug 2021 14:52:41 +0000
Message-Id: <20210812145241.12449-1-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new vlan+srcmac xmit policy is not implementable with XDP since
in many cases the 802.1Q payload is not present in the packet. This
can be for example due to hardware offload or in the case of veth
due to use of skbuffs internally.

This also fixes the NULL deref with the vlan+srcmac xmit policy
reported by Jonathan Toppins by additionally checking the skb
pointer.

Fixes: a815bde56b15 ("net, bonding: Refactor bond_xmit_hash for use with xdp_buff")
Reported-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 drivers/net/bonding/bond_main.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c0db4e2b2462..04158a8368e4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -322,9 +322,15 @@ static bool bond_xdp_check(struct bonding *bond)
 	switch (BOND_MODE(bond)) {
 	case BOND_MODE_ROUNDROBIN:
 	case BOND_MODE_ACTIVEBACKUP:
+		return true;
 	case BOND_MODE_8023AD:
 	case BOND_MODE_XOR:
-		return true;
+		/* vlan+srcmac is not supported with XDP as in most cases the 802.1q
+		 * payload is not in the packet due to hardware offload.
+		 */
+		if (bond->params.xmit_policy != BOND_XMIT_POLICY_VLAN_SRCMAC)
+			return true;
+		fallthrough;
 	default:
 		return false;
 	}
@@ -3744,9 +3750,9 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk, const void *
 
 static u32 bond_vlan_srcmac_hash(struct sk_buff *skb, const void *data, int mhoff, int hlen)
 {
-	struct ethhdr *mac_hdr;
 	u32 srcmac_vendor = 0, srcmac_dev = 0;
-	u16 vlan;
+	struct ethhdr *mac_hdr;
+	u16 vlan = 0;
 	int i;
 
 	data = bond_pull_data(skb, data, hlen, mhoff + sizeof(struct ethhdr));
@@ -3760,10 +3766,8 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb, const void *data, int mhof
 	for (i = 3; i < ETH_ALEN; i++)
 		srcmac_dev = (srcmac_dev << 8) | mac_hdr->h_source[i];
 
-	if (!skb_vlan_tag_present(skb))
-		return srcmac_vendor ^ srcmac_dev;
-
-	vlan = skb_vlan_tag_get(skb);
+	if (skb && skb_vlan_tag_present(skb))
+		vlan = skb_vlan_tag_get(skb);
 
 	return vlan ^ srcmac_vendor ^ srcmac_dev;
 }
-- 
2.17.1

