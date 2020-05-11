Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA27A1CDC2A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgEKNx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730343AbgEKNxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:53:55 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F200C061A0E;
        Mon, 11 May 2020 06:53:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y3so11088677wrt.1;
        Mon, 11 May 2020 06:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cd5koMG9eldRdjbJB7fjr40b3dz8LafdTW7A67SELwA=;
        b=pUys3Iwp9JFHH2gNyNiEXx8WTnnwX2mCSqT24DesXjTc4IVoGNGX9m76YAnqP9rU1c
         JBd32O8RN2p4+GRi5YXnEo0RaOmvKwo/dm09uYL/lwFy6Y8etLe4bhvJLpSN4vv2pAZY
         4UkuGDMVtU4QDiXt2slBbbiKXMWyk9mMlf+6dOjMz87Gdif4Bu3fkEwV65BRmtrDXxm3
         WIkFwb3dfc8k6f9wzUbNVSi8g0I8V0knuiTWY+EGvBDDqhe1LXj8rAtWuLzYpuP9j0A8
         zAn1Zd0cqCbOBF0io4BETYWJljMM+15xtApMSWxtoku/8mtnQOt2Wo3UOFrh3FEUyCqQ
         ZLuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cd5koMG9eldRdjbJB7fjr40b3dz8LafdTW7A67SELwA=;
        b=HXYcdwSxNwaTswvDeQR5wdt9nNTaHJWhyWMur2MD597gYhqS7CtfWsBA3Uq/5YrTvV
         1Z2DbvUVmQrz27xWwOSYUHXuWviNHF9jVYW3G7a//fqrEw488/Ukvrbk1HlZyZPAAI9l
         onzn4wtpxYHLoSXjhILIpeBbKopCX8gqchUSQaYxNW4ZkNhsgZgKqpQ6gCHVdRasVhKs
         UJy6faz46rCys32+rVQqYloeMfdx9XVi3vaWvwJkN6ZIShR+jRDR+VjDAAsZY9aQy08Q
         w1tndjSfP8bbpXCwa4T1mUe6T9aZq1utF4Vj+miLlE59ZJSgjO9bt0wetFsPm+4dCuLA
         NIzw==
X-Gm-Message-State: AGi0PuZP5usuL7w5Ll83/ez0XES2AjfHPkkLPP4lwkcQiEM38zzFCQ5X
        lgfRhhcZxmGHuHpneOlVlJw=
X-Google-Smtp-Source: APiQypLe/9BL2rBR/PKF+Kej64J53N6v15GX0xnav1aT3N4TjoRFtRwK3N9QZ3qtHouIbu2kHZILgA==
X-Received: by 2002:adf:dc81:: with SMTP id r1mr20828523wrj.0.1589205232259;
        Mon, 11 May 2020 06:53:52 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 2sm17596413wre.25.2020.05.11.06.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:53:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 06/15] net: dsa: sja1105: allow VLAN configuration from the bridge in all states
Date:   Mon, 11 May 2020 16:53:29 +0300
Message-Id: <20200511135338.20263-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511135338.20263-1-olteanv@gmail.com>
References: <20200511135338.20263-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Let the DSA core call our .port_vlan_add methods every time the bridge
layer requests so. We will deal internally with saving/restoring VLANs
depending on our VLAN awareness state.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Adapt to variable name change.

 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c0f11a185f31..d2755ab2853d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2358,6 +2358,8 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 
+	ds->configure_vlans_while_disabled = true;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
-- 
2.17.1

