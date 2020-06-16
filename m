Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9011FC284
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgFPX71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgFPX7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:59:21 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE21C061755
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:59:21 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dr13so311425ejc.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IdnQapfFJwIQIEYGCutSV6oEBgKDcivS8DHzPJwo4mg=;
        b=LMPZG3drc8RNKOwhdufFj31jRAy2eYz7KmEbMjXcoJp+tjI3S1P5jncpepc8V98sQ3
         9QO6uuqENb/FkYKjAH9PePzuLNa0CXRgl6sX4PHrpv70BggSO8I1FNjMrs83T/tMnIOm
         o65D6tnih0ZNLvsSY15falx6el3N5vc6hl0rGxmKMTUQbIYW6Jd7ij/gNpiNh2jMSSGP
         j4T4Qi/5ihecATW7ti2fxl4iEYNragWMdWlNeLnwjlfxtYJlZqie8b+x6OnrGn2tUKJn
         IbnhAMkIy9CclLaUEI8TPbvVP56lbBhbtMoG5D7I48C9u/eDg9S1Yep+owcN8aYL1PSQ
         UEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IdnQapfFJwIQIEYGCutSV6oEBgKDcivS8DHzPJwo4mg=;
        b=QyK1zIBRJ6KwcxnNeZKgAramDdpfJAKinji17Tb5uUuYd59aCoYOEYWyFKUj1fZNsR
         Edz7eh00OJFO1+bky2syl7w+PPTjoNfe3Wn336hTFnhilMpLhmqtBNMZJaBprDgmIBMT
         6JkNqYfIHnRaWyipA7mk3N9zDM0E6LXQCzlRmN3LpJqQhAQQYzlvNPbhQwEOmY1EVEpS
         fC4gcmgdcljqb256noCa/cTFq2xIfguGkeEvWBni5yCZ1py97qZknm9wxc6goG2kJXFy
         msZJF6qFKZjlc5Q/TAf9KUrDyQH0IIF7ztydMO0t3zapyq8/j86Z5egt8AHaEu0mR6R4
         /bHA==
X-Gm-Message-State: AOAM530TnMW4E4lp79FMmDjkRwggj8ES5PTGMC04vOAHT1EyO9n2AAR9
        CW2mz5EovLX+UdvWvkKzDnI3+GHp
X-Google-Smtp-Source: ABdhPJz1Sn3Oq7799FTfEKdJgdDC8bsOMJStBdDbLJM0mIpRiBbO0uwyA8RFcvNvJWjfwUvf2IK6iA==
X-Received: by 2002:a17:906:5283:: with SMTP id c3mr4748295ejm.22.1592351959754;
        Tue, 16 Jun 2020 16:59:19 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o24sm11814123ejb.72.2020.06.16.16.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 16:59:19 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH net 2/3] net: dsa: sja1105: fix checks for VLAN state in redirect action
Date:   Wed, 17 Jun 2020 02:58:42 +0300
Message-Id: <20200616235843.756413-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616235843.756413-1-olteanv@gmail.com>
References: <20200616235843.756413-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This action requires the VLAN awareness state of the switch to be of the
same type as the key that's being added:

- If the switch is unaware of VLAN, then the tc filter key must only
  contain the destination MAC address.
- If the switch is VLAN-aware, the key must also contain the VLAN ID and
  PCP.

But this check doesn't work unless we verify the VLAN awareness state on
both the "if" and the "else" branches.

Fixes: dfacc5a23e22 ("net: dsa: sja1105: support flow-based redirection via virtual links")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index 32eca3e660e1..a176f39a052b 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -342,7 +342,9 @@ int sja1105_vl_redirect(struct sja1105_private *priv, int port,
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only redirect based on DMAC");
 		return -EOPNOTSUPP;
-	} else if (key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	} else if ((priv->vlan_state == SJA1105_VLAN_BEST_EFFORT ||
+		    priv->vlan_state == SJA1105_VLAN_FILTERING_FULL) &&
+		   key->type != SJA1105_KEY_VLAN_AWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only redirect based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
-- 
2.25.1

