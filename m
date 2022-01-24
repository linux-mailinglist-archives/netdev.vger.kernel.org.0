Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CB149A492
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 03:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2375176AbiAYATc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 19:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356401AbiAXWz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 17:55:59 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAB4C0680BC
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 13:10:05 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id y15so44326430lfa.9
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 13:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=1xnQF9bLGcpqpvgeBQWxaXO0sby0WkycSwLqzj4kn+w=;
        b=Ng7RNB8+owqz2sMnqb+D3YKugbGxUS2d4ZMSn0kKJiuCLTY/mLNqhonMbkCvT6pNgx
         S/YOAAiZ3S6M7RER960DQBd6IePRtB12JLMvyDgw9mdahFFJtw39naV20if2MpmNfdty
         ykJax6Ty3jejql0vgStXaZ0v7OQt9AsAXmwQTpjqm+DaWnlGLgzy678Jx4GVmUjIyraB
         +OOuO+azoZgnKz3dcfra6lXZqv1CYnQMe1vqnYyUVkx63qwr/XOWC+qA3Nh6OfNxQOd2
         1yRH3w+IqhQRnN4I1WqY+9if/oFhxhoqzybaP25gLt0Z7iWoNybnkENrFj+BNumSkhOg
         l5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=1xnQF9bLGcpqpvgeBQWxaXO0sby0WkycSwLqzj4kn+w=;
        b=0YvMX9wr84+FBE8LoGJRe6NNBEOV9A6MYV+YtzLLGSFiXXdUQTn19bCmQObTU0TKuT
         tPCCiC/dj+aMkG5KF8OKt4L14QB/A37hWz8zh5ck/n86X783QmFUqhIiSdwECuM7phxb
         dmmCgyAc7KFolMdMy8CcIhtLqa3oa4M6E1KsNscdCosqK2k9D8P7grZmqM35+LsPVUW1
         g7I+e0rL0DDEViYT2w+lsGZCg82NwLE7xHOPtFM7p0sKwyaooSeFGqNU4fdvZ7QSPvbb
         hx0SgtgAFfNpuxfouOE6hMPRM4xI3l2kWq13YJhWptQYn0ybNlMV5RcG91AAJ8W2md7i
         j++w==
X-Gm-Message-State: AOAM533RltIkt2SFwPYQt4q+/EpG4UywtfDJ1KII1S5YulyhI2IbnBv0
        3rhYNJ46rvCpqRqQR07iIw/yaFhs/Swuuw==
X-Google-Smtp-Source: ABdhPJwfE3A4W4S/oUX8Zs78yXqD+R3+6wSR9G234+TTwq7Sz7sfOUAV7oAU3AhIfLvwjpCjsmWiqQ==
X-Received: by 2002:a19:ae05:: with SMTP id f5mr435716lfc.496.1643058603513;
        Mon, 24 Jan 2022 13:10:03 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id t12sm1009115ljj.118.2022.01.24.13.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 13:10:03 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: dsa: Avoid cross-chip syncing of VLAN filtering
Date:   Mon, 24 Jan 2022 22:09:44 +0100
Message-Id: <20220124210944.3749235-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124210944.3749235-1-tobias@waldekranz.com>
References: <20220124210944.3749235-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes to VLAN filtering are not applicable to cross-chip
notifications.

On a system like this:

.-----.   .-----.   .-----.
| sw1 +---+ sw2 +---+ sw3 |
'-1-2-'   '-1-2-'   '-1-2-'

Before this change, upon sw1p1 leaving a bridge, a call to
dsa_port_vlan_filtering would also be made to sw2p1 and sw3p1.

In this scenario:

.---------.   .-----.   .-----.
|   sw1   +---+ sw2 +---+ sw3 |
'-1-2-3-4-'   '-1-2-'   '-1-2-'

When sw1p4 would leave a bridge, dsa_port_vlan_filtering would be
called for sw2 and sw3 with a non-existing port - leading to array
out-of-bounds accesses and crashes on mv88e6xxx.

Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/switch.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9f9b70d6070a..517cc83d13cc 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -180,9 +180,11 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 						info->sw_index, info->port,
 						info->bridge);
 
-	err = dsa_switch_sync_vlan_filtering(ds, info);
-	if (err)
-		return err;
+	if (ds->dst->index == info->tree_index && ds->index == info->sw_index) {
+		err = dsa_switch_sync_vlan_filtering(ds, info);
+		if (err)
+			return err;
+	}
 
 	return dsa_tag_8021q_bridge_leave(ds, info);
 }
-- 
2.25.1

