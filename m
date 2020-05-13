Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7451D0393
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 02:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbgEMAYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 20:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgEMAYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 20:24:42 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3BFC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 17:24:42 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y3so18504565wrt.1
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 17:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wLIyd2NVoyTbrvrtIdA9w2RK6zix5/+zyHWtWjXv24Q=;
        b=II1sFF24HGarmJWNzhESbzRg2i9kbwwa6F1S+f9Msc+8UMCjJPh0mkXmrJlzXwtx0m
         A29pDCUtcy27jib+tGYQfiBf1LtbrS+zQC6EPqfGGP4Wcq755Fm1Z0CLak5HRgk68sUk
         KQHuR+Rw/gsFHVtGCopFZZWleu7xDcIya9p9ENTiAuoIxxcyib6IsWs00Alkj+jB21FB
         j5sEn9dZkU6tJcYXfWiL5ocVV8/EoLsD66kWQ3GLQLZLO9bETO8nwvbbCkiRaa4Vac1S
         hEbua2pj72lW2Ul7taubaMyQmJteouZWqTbdxpTKQjRNoqShRnw26mxmRk4zZIyPg6gZ
         xXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wLIyd2NVoyTbrvrtIdA9w2RK6zix5/+zyHWtWjXv24Q=;
        b=X/N9vgG9O1FT9YoY2nLnvwvUr8CzlzBfmFExSIrAhCLB0McrkO1onNZWFpH2mjf2qd
         6Rtw6Z+QqoN4w6/YNCdO/oszuLmgVyu4Nhl4Gpjv12vqs/KMPBN6hTuvAvPehn14rJiK
         avErpVS1wlB7n67l3otN2d8vznZmza4TJkWTqCukoG2x3Ybqh/rPZjF3YL0ENzZixLaB
         gqdbnRebCbrLAf1u1yCGSLjRjXoJzWMYXzcIMZa/FnnUIb+fGK+bQKPuD9G7HyhIlBnT
         Nw4DPE7ER9T6pGqsssWWf1raIvBcADc/dFMleMidblEsE7192PyqtfRpnWLJ0AlNBVbG
         Q1rA==
X-Gm-Message-State: AGi0PuZJYMmmd3yuRPqpvxiROy+OijtQQU/0uKp5NY0hxxS6VMzw0cOz
        LEFiviN4VD/AE4SYzaAGlLI=
X-Google-Smtp-Source: APiQypKBYMkrlBvoeqYvGZpiopHF+pyxcAFMWE01rYzMVW9Yp5sIBh6LgUoIX1CkZukiilW3ofOF9g==
X-Received: by 2002:a5d:4d05:: with SMTP id z5mr27305331wrt.130.1589329480962;
        Tue, 12 May 2020 17:24:40 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id y185sm4302814wmy.11.2020.05.12.17.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 17:24:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: tag_sja1105: appease sparse checks for ethertype accessors
Date:   Wed, 13 May 2020 03:23:27 +0300
Message-Id: <20200513002327.13637-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A comparison between a value from the packet and an integer constant
value needs to be done by converting the value from the packet from
net->host, or the constant from host->net. Not the other way around.
Even though it makes no practical difference, correct that.

Fixes: 38b5beeae7a4 ("net: dsa: sja1105: prepare tagger for handling DSA tags and VLAN simultaneously")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/tag_sja1105.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index ad105550b145..9b4a4d719291 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -73,10 +73,10 @@ static bool sja1105_can_use_vlan_as_tags(const struct sk_buff *skb)
 {
 	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
 
-	if (hdr->h_vlan_proto == ntohs(ETH_P_SJA1105))
+	if (hdr->h_vlan_proto == htons(ETH_P_SJA1105))
 		return true;
 
-	if (hdr->h_vlan_proto != ntohs(ETH_P_8021Q))
+	if (hdr->h_vlan_proto != htons(ETH_P_8021Q))
 		return false;
 
 	return vid_is_dsa_8021q(ntohs(hdr->h_vlan_TCI) & VLAN_VID_MASK);
-- 
2.17.1

