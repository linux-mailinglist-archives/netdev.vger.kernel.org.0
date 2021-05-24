Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010D338F4FB
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhEXVfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:35:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54590 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233869AbhEXVfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RkFsi9eMCUiB30yNLMnCHAZOBrMwGA0B0YzGmZfisS4=; b=lPwxN5C23wkBgst7w/+Sc7yC1p
        5R50VUhdfwiGAImuPhGsdqJ62xp8uSbTTAsO548XCft/MJI+HtutGGvNxo9kajlfHLpBLRQuuDdJS
        7Kdsoi0LinmfO6Ehd2e72PnDVcit+1zkCgn1199Yh7QwQFD/mw99Tq1cvMBP64V8ka/k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llICb-006250-HA; Mon, 24 May 2021 23:33:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>, cao88yu@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 3/3] net: dsa: Include tagger overhead when setting MTU for DSA and CPU ports
Date:   Mon, 24 May 2021 23:33:13 +0200
Message-Id: <20210524213313.1437891-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524213313.1437891-1-andrew@lunn.ch>
References: <20210524213313.1437891-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same members of the Marvell Ethernet switches impose MTU restrictions
on ports used for connecting to the CPU or DSA. If the MTU is set too
low, tagged frames will be discarded. Ensure the tagger overhead is
included in setting the MTU for DSA and CPU ports.

Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
Reported by: 曹煜 <cao88yu@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/switch.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9bf8e20ecdf3..48c737b0b802 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -67,14 +67,26 @@ static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
 static int dsa_switch_mtu(struct dsa_switch *ds,
 			  struct dsa_notifier_mtu_info *info)
 {
-	int port, ret;
+	struct dsa_port *cpu_dp;
+	int port, ret, overhead;
 
 	if (!ds->ops->port_change_mtu)
 		return -EOPNOTSUPP;
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_switch_mtu_match(ds, port, info)) {
-			ret = ds->ops->port_change_mtu(ds, port, info->mtu);
+			overhead = 0;
+			if (dsa_is_cpu_port(ds, port)) {
+				cpu_dp = dsa_to_port(ds, port);
+				overhead = cpu_dp->tag_ops->overhead;
+			}
+			if (dsa_is_dsa_port(ds, port)) {
+					cpu_dp = dsa_to_port(ds, port)->cpu_dp;
+					overhead = cpu_dp->tag_ops->overhead;
+			}
+
+			ret = ds->ops->port_change_mtu(ds, port,
+						       info->mtu + overhead);
 			if (ret)
 				return ret;
 		}
-- 
2.31.1

