Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265DF38E33D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhEXJ1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhEXJ1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:27:06 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8FCC061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:37 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id et19so33691186ejc.4
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dXdt+KKKz9LU9KAG5nwot0k8iUG/uKRaRkjTzG5fIyM=;
        b=n++zvDNw0imYM5zA/E0v+hJfiP2gs64UQMAjm763xmO+HgOjn73w0L0kJwZJGA1L10
         a5zxyKpxGbcePR5qc8spNoNQsgU8qqj7mG4bPGab9y0JVv23tA/Obf6+tSSJvCQDAMhz
         caUekjNXa09FCUXdbteG9iqzoqMvf6ZFB4Ujy+wQV4Pl8mNEuzcvdSAnYPyQUdbl9I2s
         qoRlrcXtsDLhcTnvh9GbDS+cUz4p571H8a52r9dFUV3RLOttlnygTmUOVQgWlWpAjh9S
         USL/NqwpWrmIGKpVRD40CfuCl9ogLXK2F5Oz8+3uKUxiOzWlpE4i5UQn8ibGU8oenS9/
         uvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dXdt+KKKz9LU9KAG5nwot0k8iUG/uKRaRkjTzG5fIyM=;
        b=tlnUNxIt0v8Vs8Mk0/PMs0ZlenVehB8xKuxlg7jG+xKxuzySjoiexPL5fPte/csqQN
         WNVm6q3GuzqcTdtN0NCGYhKU/5kQH2GaGyz9eh5fIKLVgRtWFQhneVdCgISprdvKZGUY
         g7TPWeJqH0F48xwdzHD69AfNQmUk0Nki+ptd66iK1YyOkKh8bJ71n/T8Jx3Fefgjf+k4
         PX/tH8QPzifbkomCy8GrSLExOkOelX4z0duxj9dc4iof1qzd7SR6ZwCd9QQx/q3Dl41U
         J30TyvRapROkMVkL7NL6v4y8vOPaQCniru7dkEvyXy9n7qWv4XejXK8POczQYQDbnYic
         qnUg==
X-Gm-Message-State: AOAM533OBXO0Oy73g5DREDiGMRvB/8xomhUZ33hK0nCKbnSxOlSoUXUf
        DFrvUwN1hdt/gEQsMUZJ8qM118P+JSk=
X-Google-Smtp-Source: ABdhPJwahzpBW5Cdas4VuQByTnyF27xcqAZQPT6m6uhjQf1ng5+6vI6iuF9WjJYLUZ8rI4/kNw9cNw==
X-Received: by 2002:a17:906:c1d2:: with SMTP id bw18mr22281800ejb.123.1621848336547;
        Mon, 24 May 2021 02:25:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id yw9sm7553007ejb.91.2021.05.24.02.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:25:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 3/6] net: dsa: sja1105: add error handling in sja1105_setup()
Date:   Mon, 24 May 2021 12:25:24 +0300
Message-Id: <20210524092527.874479-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524092527.874479-1-olteanv@gmail.com>
References: <20210524092527.874479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If any of sja1105_static_config_load(), sja1105_clocking_setup() or
sja1105_devlink_setup() fails, we can't just return in the middle of
sja1105_setup() or memory will leak. Add a cleanup path.

Fixes: 0a7bdbc23d8a ("net: dsa: sja1105: move devlink param code to sja1105_devlink.c")
Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2248152b4836..c7a1be8bbddf 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2976,13 +2976,13 @@ static int sja1105_setup(struct dsa_switch *ds)
 	rc = sja1105_static_config_load(priv, ports);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to load static config: %d\n", rc);
-		return rc;
+		goto out_ptp_clock_unregister;
 	}
 	/* Configure the CGU (PHY link modes and speeds) */
 	rc = sja1105_clocking_setup(priv);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to configure MII clocking: %d\n", rc);
-		return rc;
+		goto out_static_config_free;
 	}
 	/* On SJA1105, VLAN filtering per se is always enabled in hardware.
 	 * The only thing we can do to disable it is lie about what the 802.1Q
@@ -3003,7 +3003,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
-		return rc;
+		goto out_static_config_free;
 
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
@@ -3012,6 +3012,17 @@ static int sja1105_setup(struct dsa_switch *ds)
 	rtnl_lock();
 	rc = sja1105_setup_8021q_tagging(ds, true);
 	rtnl_unlock();
+	if (rc)
+		goto out_devlink_teardown;
+
+	return 0;
+
+out_devlink_teardown:
+	sja1105_devlink_teardown(ds);
+out_ptp_clock_unregister:
+	sja1105_ptp_clock_unregister(ds);
+out_static_config_free:
+	sja1105_static_config_free(&priv->static_config);
 
 	return rc;
 }
-- 
2.25.1

