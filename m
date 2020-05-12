Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F62A1CFBE9
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgELRU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730570AbgELRUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:54 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A547BC061A0C;
        Tue, 12 May 2020 10:20:53 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id n5so9498726wmd.0;
        Tue, 12 May 2020 10:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fONFHa3KnL3LpjKnRv82Miz55EykB3jPB4QvYBL9/Ws=;
        b=Bg8JdCt9clpSdJZ7JwnFpyiX0FT1htRDpGMjEZ1uDX0cgHrH3JL3tpPI5okotbyuji
         WksaQb5wyicV8jshLHB6Bw8DVAXf0RNzfvPiaQ553D3uO3fkj5fb687Itl2DY4SQh0Uc
         2/CVvzYh0ROsN3xzI2dcGgD42MuGDXb3OtTyySLhR6wJ8rhgt34XyR8kD+d/XwF0HP8s
         zXyNuKRCJ8qwrYfF8kU+XZAGZjFYaa+3d+bezOoO1YBac7kXLfqW7G6Gx76Bvx8XmJKR
         ad86MdCcxQEdElgj7u99ymyBcOvzHPALO4yvwwfkezwjaBhMSwVnFvXNl03n30aF2GE3
         hmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fONFHa3KnL3LpjKnRv82Miz55EykB3jPB4QvYBL9/Ws=;
        b=Rs/DDAGOslXp51WtmFJXBRa8FYaNkuiTPY2u+kCRLgwdXmalARCTbc1o4nxZyxuSJ/
         NCcXJPiHCQKrhKZCetelOo7mATD11K2OJnDcqaSJrkzf13HARBhX3tzOJvKPIlAWOJ8x
         JYLx0IC8bvx6R7/h3X3e53PwQJLojTbOoVqZZ5Z1FU8ie1IL3jEZzcmpxPGguaj7yMFi
         fvqD8A/vQhx82zB4s+hO05D/XF1ivJMpYClrCqqWq9b0HGFRLb1w3X+3CyVBn1GgOsDx
         t/ceXV2Ptg0DmHzt8uNXvjKuYqSvPYdJQhvfpa0jyMzGudsSqmDvp0oPOUvspUPZGyTH
         cx6Q==
X-Gm-Message-State: AGi0Puagx6v5SPd145fMryqFf5xrqSwtp0TEnp5JkVbzNLSRxZum4glR
        FeJWwCfHk5LknVbyrJ+t2P4=
X-Google-Smtp-Source: APiQypIUbizSZ0VcKAjFfAJToRNrbvzEFAIs8jgOkMazP1+rvF9DfJxYIzw6IGWZ+0yjX/qcqb/8iw==
X-Received: by 2002:a05:600c:230e:: with SMTP id 14mr10689825wmo.45.1589304052280;
        Tue, 12 May 2020 10:20:52 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 07/15] net: dsa: sja1105: exit sja1105_vlan_filtering when called multiple times
Date:   Tue, 12 May 2020 20:20:31 +0300
Message-Id: <20200512172039.14136-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512172039.14136-1-olteanv@gmail.com>
References: <20200512172039.14136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

VLAN filtering is a global property for sja1105, and that means that we
rely on the DSA core to not call us more than once.

But we need to introduce some per-port state for the tagger, namely the
xmit_tpid, and the best place to do that is where the xmit_tpid changes,
namely in sja1105_vlan_filtering. So at the moment, exit early from the
function to avoid unnecessarily resetting the switch for each port call.
Then we'll change the xmit_tpid prior to the early exit in the next
patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ca5a9baa0b2f..7b9c3db98e1d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2158,6 +2158,9 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	else
 		state = SJA1105_VLAN_FILTERING_FULL;
 
+	if (priv->vlan_state == state)
+		return 0;
+
 	priv->vlan_state = state;
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
-- 
2.17.1

