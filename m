Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D3F2F5C86
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbhANIg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbhANIg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 03:36:57 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F831C061786
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:36:11 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id e18so6915408ejt.12
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 00:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fpbkw1/mO8jMuG8za1QNFcPos1MTHSCasjJ+BTbNExk=;
        b=J7mq5d8oIlMPvxa1yhQD3Sdc9Z810Cq29qTLSqZlKyK2cnQ6+k5nfhUJxYL47SM/r6
         nejTpmDy3CvJsqX9rY9Jw++xOoBU90r0Lgawhut0dyzGb5fvPR+O9M9PbTenssnh5mOj
         meWhyVB72R0zr1ZRucEqk6/EvxHsXl+5A3WFa/lxg5ritzjUhW3DGDaCoYagwgzB47yc
         rkf8MFJWgrwqJ3Nz2FuTVni8ge+kp2yU9q8w7WJke12AWosZUpS6d9rbSXmUNRtB0VHM
         g4K/IDqTz2WBMnIlmxzvTnPjc+RzdLZd3iBeu8n2LWZBPAZQOTw93Wx45O8MnreUJM39
         vvVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fpbkw1/mO8jMuG8za1QNFcPos1MTHSCasjJ+BTbNExk=;
        b=Z0nfHb7iK0PCVeot/nlUu9+LV4B9WrpXmAQf9CapkooQBUuLcjBkEOX9YzcKemnzlu
         +ZoL2/d7/aK7jf3ZRhqoH1xy0UvK6as34e/Hc3yv6E7hfzCxBzhWJ9XMnDV8n8VtA1L+
         KMNS3n/F1ms3HoNfRcRSvl9SEmMO7/cFuES6Xi0Ep5iZvWOcjhmZpaX5EofaI4WSVLSc
         KXeDZjThqQlYQ2l7VYTrNJvwipNfhpeTRSZ5c54tpH6iyAKv80KKo6dPgy9qY/hPxVqm
         epKGq5REapF8OeckwV0BTj9avxtUY3YSadYaZbTiBX1N2eQZWChgMAmMKQPtiyITAakB
         ilwQ==
X-Gm-Message-State: AOAM531/pQQwHquDHjQV9/md27dS4DfaRj4fzS7YBqbnB0vyCnEVDhwJ
        KY28UXjXGcPUZdaaUQrN1Zk=
X-Google-Smtp-Source: ABdhPJyrxJEcZ4allvQEUVohPvQZjcHay2GA0OidLWiWEh59pcQu/+BdYVSQER25GK4ADl+FsRFcmA==
X-Received: by 2002:a17:906:5618:: with SMTP id f24mr4484156ejq.517.1610613369886;
        Thu, 14 Jan 2021 00:36:09 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m24sm1680892ejo.52.2021.01.14.00.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 00:36:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        clang-built-linux@googlegroups.com, linux-mm@kvack.org,
        kbuild-all@lists.01.org
Subject: [PATCH net-next] net: marvell: prestera: fix uninitialized vid in prestera_port_vlans_add
Date:   Thu, 14 Jan 2021 10:35:56 +0200
Message-Id: <20210114083556.2274440-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

prestera_bridge_port_vlan_add should have been called with vlan->vid,
however this was masked by the presence of the local vid variable and I
did not notice the build warning.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: b7a9e0da2d1c ("net: switchdev: remove vid_begin -> vid_end range from VLAN objects")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index beb6447fbe40..8c2b03151736 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -1007,7 +1007,6 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 	struct prestera_bridge_port *br_port;
 	struct prestera_switch *sw = port->sw;
 	struct prestera_bridge *bridge;
-	u16 vid;
 
 	if (netif_is_bridge_master(dev))
 		return 0;
@@ -1021,7 +1020,7 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 		return 0;
 
 	return prestera_bridge_port_vlan_add(port, br_port,
-					     vid, flag_untagged,
+					     vlan->vid, flag_untagged,
 					     flag_pvid, extack);
 }
 
-- 
2.25.1

