Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7004A1A03E6
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgDGAyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:54:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40466 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgDGAyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 20:54:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id s8so1863303wrt.7;
        Mon, 06 Apr 2020 17:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f9/NbIgNdnQIK+P1jaZ1EvtyelbjfTXJfL5WDuMOA0U=;
        b=NVQZHEJMxzxjmz22HV/sWwxN+ocAVOoaF4cKwwkqm6oc/YyLfl3BntEiYdR2eBkvUm
         XPDNr+Xaam85Uw8cjJsIjj0/trxwWmT8teMcokDv6SeGeUGREF+TO3i/DSBdQD+6h8eM
         xN/jJHUPLMaSNEe4unkFRY/s3/CSW51YP1jvP+0o23BoXflk2cX7Ersic512kXJH4QoM
         xbwsHe+5I0t2ta1oWMNhC8x6mUYl7w84kht2Ixw9W0hlayw6UyedqhjPoaRu7o0bmu2q
         7lZLBBl4sWcM5PAeweT3FWb59/qFSJXuL0zFkif/CsJlhy95Ff0S8mAiov1jhkyISN89
         k4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f9/NbIgNdnQIK+P1jaZ1EvtyelbjfTXJfL5WDuMOA0U=;
        b=HBx4TvzV0VKe3EfgGjQff8VyPHJBn/fews81ncfrJb2YHjA6H0UkP+3TlNfACKTskx
         yoVnd+bH11r8WsxO6AIk7cICQvmveqwhRICLf5+EF7p+EWNw2zcdwq5dMMWvw34nwN8f
         Y39yRk7FzQLRbVng6Yg0+ze6aB6X80YJBWGhjb3oQAC/XEXdvIFI7oT2I4YdYvtddeAV
         g/tBYwOYoQBMKv4dHmna5oYOSJrRB1yD5hTNGugLTOwubgLwQHdNSVXp/NE/bKXHdRQS
         o62HVeAjG64qwXlHp/pA3h0GPz68VXkLtetT6YMlssPxUgYlslzZx61jS4eBTU7O/m9t
         W/kA==
X-Gm-Message-State: AGi0PubAZ3MToeI+noOOarMaWCXebymy70sSAbenfMUSOlTfmnd6/0uz
        WPaDCN4ZejJ5+Ig+01takOGIkI/J
X-Google-Smtp-Source: APiQypIPVHIP9fjB4kiUFE3+ZRRnl+/t+T2AowygVGQZ/IboLf+SRubDjmK8pg1+8yWt0sCHbWkSRg==
X-Received: by 2002:adf:f5d0:: with SMTP id k16mr1972339wrp.227.1586220858093;
        Mon, 06 Apr 2020 17:54:18 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p10sm28244775wrm.6.2020.04.06.17.54.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 06 Apr 2020 17:54:17 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH stable-4.9.y]] net: dsa: tag_brcm: Fix skb->fwd_offload_mark location
Date:   Mon,  6 Apr 2020 17:54:12 -0700
Message-Id: <1586220853-34769-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the backport of upstream commit
0e62f543bed03a64495bd2651d4fe1aa4bcb7fe5 ("net: dsa: Fix duplicate
frames flooded by learning") was done the assignment of
skb->fwd_offload_mark would land in brcm_tag_xmit() which is incorrect,
it should have been in brcm_tag_rcv().

Fixes: 5e845dc62f38 ("net: dsa: Fix duplicate frames flooded by learning")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_brcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 76d55a80f3b9..98074338cd83 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -84,8 +84,6 @@ static struct sk_buff *brcm_tag_xmit(struct sk_buff *skb, struct net_device *dev
 		brcm_tag[2] = BRCM_IG_DSTMAP2_MASK;
 	brcm_tag[3] = (1 << p->port) & BRCM_IG_DSTMAP1_MASK;
 
-	skb->offload_fwd_mark = 1;
-
 	return skb;
 
 out_free:
@@ -148,6 +146,8 @@ static int brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb->dev->stats.rx_packets++;
 	skb->dev->stats.rx_bytes += skb->len;
 
+	skb->offload_fwd_mark = 1;
+
 	netif_receive_skb(skb);
 
 	return 0;
-- 
2.7.4

