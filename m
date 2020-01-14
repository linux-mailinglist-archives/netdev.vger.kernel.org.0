Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0123313B18F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgANR6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:58:39 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35856 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgANR6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 12:58:38 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so15403354ljg.3
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 09:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mr/2MNCOIx0U4K+Pv+vAm/4J6d5/EukzrdHaRzf8ia0=;
        b=Vu8D4RL6/Waqf9k5QySzdYA8kN/YYdxNE6u5TyyBc96Hjee7hyf456xV2xTRY9m22Y
         wfz0bVNsBE1FQ8o3LN8L+cpKDvGjCsA5xQBT9qt3s0ZxZq6N0Z8rW0KnR9s7/5Jvqn+T
         au4rW07YhX9WcRcX9CXKtj7KbrNrcHs2Wh6Zk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mr/2MNCOIx0U4K+Pv+vAm/4J6d5/EukzrdHaRzf8ia0=;
        b=OjTTMHiqKkqdLCQfGolnmZOfW0e0Fgz0+IsVH5XP50Tm9K50EC0Qy2zHgbGrqt5zWz
         ylj6IlpuhWA4ipj9whuvUAyrJp0YmryMIOBQPuJzcTvS9TGsUByba9dRg/riQc7ZW3+w
         mFcoQgOvUvYxnTP0u8IjEUYeMX+eS2bY2hAH6NPAbcepdWPbSu+EKroWMW/Sjiefel+u
         oX4VwIj+/wq5AyUTAB+/xdpqWKrbc92hYtMukMfsmdwaj7pBcAS2iilwqHdlDLf4gFso
         d28DZ2aSLxUq0kxnv+/IGAMP29snPp7KKAGVTjs9eqxRftJcJO8eG3QZoU5QBDBSC/d5
         2x9w==
X-Gm-Message-State: APjAAAUd/YUWM6wrX7vEVNhYtWlFF49HUcu1n+BcBdtJy0oNfsCfH6Ab
        MwkP0oDtuVWakB9JqpnspPS3kYNIL+U=
X-Google-Smtp-Source: APXvYqwqISi5BeDV9j50traAdQe+aBO2Zh+s2xpanT8oNb1FJ8x8ZwAg01rwen2ob2lQSzoIR2YrmQ==
X-Received: by 2002:a2e:a486:: with SMTP id h6mr15127964lji.235.1579024716978;
        Tue, 14 Jan 2020 09:58:36 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a15sm7685655lfi.60.2020.01.14.09.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 09:58:36 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 5/8] net: bridge: vlan: add del rtm message support
Date:   Tue, 14 Jan 2020 19:56:11 +0200
Message-Id: <20200114175614.17543-6-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200114175614.17543-1-nikolay@cumulusnetworks.com>
References: <20200114175614.17543-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding RTM_DELVLAN support similar to RTM_NEWVLAN is simple, just need to
map DELVLAN to DELLINK and register the handler.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_vlan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6da0210b01eb..89d5fa75c575 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1697,6 +1697,9 @@ static int br_vlan_rtm_process_one(struct net_device *dev,
 	case RTM_NEWVLAN:
 		cmdmap = RTM_SETLINK;
 		break;
+	case RTM_DELVLAN:
+		cmdmap = RTM_DELLINK;
+		break;
 	}
 
 	err = br_process_vlan_info(br, p, cmdmap, vinfo, &vinfo_last, &changed,
@@ -1757,10 +1760,13 @@ void br_vlan_rtnl_init(void)
 			     br_vlan_rtm_dump, 0);
 	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_NEWVLAN,
 			     br_vlan_rtm_process, NULL, 0);
+	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_DELVLAN,
+			     br_vlan_rtm_process, NULL, 0);
 }
 
 void br_vlan_rtnl_uninit(void)
 {
 	rtnl_unregister(PF_BRIDGE, RTM_GETVLAN);
 	rtnl_unregister(PF_BRIDGE, RTM_NEWVLAN);
+	rtnl_unregister(PF_BRIDGE, RTM_DELVLAN);
 }
-- 
2.21.0

