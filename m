Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8F6195392
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgC0JIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:08:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35874 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0JIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:08:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id 31so10466662wrs.3
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Snj2BIbKkwj49qCuxxW4YZLt9bOMLryMmD+pl5MDGn0=;
        b=TuXWdK7FGacyfRbJfiQTksszhIeQnG8d9CesHPr1gimz6iVnx1Fp2o1OVpfzqK3d/C
         wtVB2u8A/olEpXw6iIJ7PV10zhyf34cl1MfNMML3MReT9xReAzcdy4G4AcsNIA2y8LV2
         EICn5niDAGastQkATCF8krQaajRmQCWat61ENJFPvmIAmmtfqaRavE+RDsjMe5Ix39xd
         6VNRBRLXVN/5DaKZjn9eHw01dEcz+8yYsGdnER+ZRgcyjClAixc0ERsMA0qe1uRE9uJJ
         FUx9u+356IvdqcQZd28JnVoDCPO4T7sqn64z4n3tD/Zhzpr7gosf64K2QL016Lzyuumq
         7dFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Snj2BIbKkwj49qCuxxW4YZLt9bOMLryMmD+pl5MDGn0=;
        b=Wui1SC06rVWIivxrXfOAtfj98LcexGi93apN4ycE9KzntehIgWV/GgZx72mEd3pxwl
         dejnMQcT71pjmL2vLjKSa0gNeoPQqJZlk8ru1wpi5N8/AtkHQ7ySCIC9BNIhfqppS7/k
         e3oO7WB0/Zi6+ebPhtiXSpNnLHQol/M8+ue3LzfnGxWHk75B3iCWNgYN8LseAioAIaFj
         x3lHG9+6zEoa2WG7UmKdHy2djF7WIpisVdXOjIjgHfSKVO8gCflKt9x9RV1Ql6YxRAqC
         m4FxpzJDtlUdf+MEvVFlx0lCG3xcCTcE3fUeHS46aqkQCKYN9RWcmMdlKIuUmqhesr8j
         djaA==
X-Gm-Message-State: ANhLgQ3GLqFdgMg0LdfnrcjZMJNjb+unhIMeeXWMcVqdZddvxAzYUwIp
        VmjjMDb6CqxcB7l8iHNtl6etkp8A6Cs=
X-Google-Smtp-Source: ADFU+vsrYSZPDNgkhXSwI63QOClXQmFSXk5q+GBLVVSQthQP5JU4NlhV71C82ARpIjdBL7KESsrZfg==
X-Received: by 2002:adf:ed42:: with SMTP id u2mr14816538wro.175.1585300090593;
        Fri, 27 Mar 2020 02:08:10 -0700 (PDT)
Received: from localhost (2a01cb00017f7f00eb65350dcb7f23a3.ipv6.abo.wanadoo.fr. [2a01:cb00:17f:7f00:eb65:350d:cb7f:23a3])
        by smtp.gmail.com with ESMTPSA id v11sm7639706wrm.43.2020.03.27.02.08.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:08:10 -0700 (PDT)
From:   Charles Daymand <charles.daymand@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Charles Daymand <charles.daymand@wifirst.fr>
Subject: [PATCH net] r8169: fix multicast tx issue with macvlan interface
Date:   Fri, 27 Mar 2020 10:08:00 +0100
Message-Id: <20200327090800.27810-1-charles.daymand@wifirst.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During kernel upgrade testing on our hardware, we found that macvlan
interface were no longer able to send valid multicast packet.

tcpdump run on our hardware was correctly showing our multicast
packet but when connecting a laptop to our hardware we didn't see any
packets.

Bisecting turned up commit 93681cd7d94f
"r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_CSUM
which is responsible for the drop of packet in case of macvlan
interface. Note that revision RTL_GIGA_MAC_VER_34 was already a specific
case since TSO was keep disabled.

Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multicast
issue, but we believe that this hardware issue is important enough to
keep tx checksum off by default on this revision.

The change is deactivating the default value of NETIF_F_IP_CSUM for this
specific revision.

Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr>
---
 net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/drivers/net/ethernet/realtek/r8169_main.c
index a9bdafd15a35..3b69135fc500 100644
--- a/net/drivers/net/ethernet/realtek/r8169_main.c
+++ b/net/drivers/net/ethernet/realtek/r8169_main.c
@@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
 		dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
 		dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
+		if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
+			dev->features &= ~NETIF_F_IP_CSUM;
+		}
 	}
 
 	dev->hw_features |= NETIF_F_RXALL;
-- 
2.20.1

