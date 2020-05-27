Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E221E4AB5
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389851AbgE0Qpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387619AbgE0Qpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:45:45 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F379C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:45:45 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a2so28839919ejb.10
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IVZ5Nzup20IGQNZUIHLCP//EXDx76XAsVDlWpxZckeI=;
        b=LENqWQFraJqGxSsL4QiFVBkumNeuWCzCsj92xL+n1c1pYQjc//EG+snI54a31wSr4k
         WUOKzK4pbCONFXcabxnCe4iVX3kYzMvu6kSCrUUQsKgfkSHFu4Lkuc3vZm09yfR1ls4U
         wIhInWyLiwxZe60AUSa/uINXiF1xeeYWSYRrXHNmq574/lJdMMisRvHjh/WOaxSmDrkB
         w/I7LX+4Rc5OFUc89xboF/qPsh5tiiPGtTtvUonSlDEIsScx0QZzyD/vBdV4ORunXycc
         y1MAJ5be5JFfy5hlt3eJVjeviDejt9QfEZy7k0JE23o8olf36JQb+BOSVPx1G5H3bVFj
         vt3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IVZ5Nzup20IGQNZUIHLCP//EXDx76XAsVDlWpxZckeI=;
        b=I2TDNVRXV02lWwa3Y7hGMQur0JwBSFpbkfYyviu1sf7vi3qLaSzhTBuY44QSL1iF+k
         OVPSC3AJ2etgVBVbK1ZwslCZi/vcrpGJeubS5UjGOiB6ChBHi1vnfeL2xHH0YJWQ0dkf
         I3/RyyYNAY9U2uvvQE+h1LPPQWGNP0Cs6HXb26nIMY5fyREqcheWLbNvTzTd9u0/4ejs
         S1vMEr1izRoj/7aN8OBYOdq1IBA3FNzRVO1hpb6fNPvnTJV0ihrf44MGsN1qrcQzPOaQ
         rBLbZA18+z22guDh+UvYZxcdqaNIkTas08FTgxDDk7QivJb7WISNJebKGqbnS7LYCQsb
         kVgw==
X-Gm-Message-State: AOAM532eRytPQdhlih81gI3TzxY21bnLvfajXOlK9uESyfhKOvY2B/u5
        0yGVbvjtv0UOhMwdcZlUax0=
X-Google-Smtp-Source: ABdhPJyOrcUajpL48sCtvBsnrdLiZiR9hNiSUPScwW/QsKwyWet6pn41qivGuE6ZEkBZyVdmnpgURg==
X-Received: by 2002:a17:906:8608:: with SMTP id o8mr6634289ejx.274.1590597944036;
        Wed, 27 May 2020 09:45:44 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id r9sm2681397edg.13.2020.05.27.09.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 09:45:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        rmk+kernel@armlinux.org.uk, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: felix: accept VLAN config regardless of bridge VLAN awareness state
Date:   Wed, 27 May 2020 19:45:38 +0300
Message-Id: <20200527164538.1082478-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot core library is written with the idea in mind that the VLAN
table is populated by the bridge. Otherwise, not even a sane default
pvid is provided: in standalone mode, the default pvid is 0, and the
core expects the bridge layer to change it to 1.

So without this patch, the VLAN table is completely empty at the end of
the commands below, and traffic is broken as a result:

ip link add dev br0 type bridge vlan_filtering 0 && ip link set dev br0 up
for eth in $(ls /sys/bus/pci/devices/0000\:00\:00.5/net/); do
	ip link set dev $eth master br0
	ip link set dev $eth up
done
ip link set dev br0 type bridge vlan_filtering 1

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 18c23ffd6b40..a6e272d2110d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -594,6 +594,7 @@ static int felix_setup(struct dsa_switch *ds)
 				 ANA_FLOODING, tc);
 
 	ds->mtu_enforcement_ingress = true;
+	ds->configure_vlan_while_not_filtering = true;
 	/* It looks like the MAC/PCS interrupt register - PM0_IEVENT (0x8040)
 	 * isn't instantiated for the Felix PF.
 	 * In-band AN may take a few ms to complete, so we need to poll.
-- 
2.25.1

