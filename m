Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968D71FC283
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgFPX71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgFPX7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:59:23 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79C6C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:59:21 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id m21so491448eds.13
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i4bz0Y4+LLeigFOq1QSp/IVRJ+VZnQF7hnDzeTu812w=;
        b=CmIelPMdHYzHNnUVfwm+S5LD6YaT4irHMHDpVuZBGDex7AH0Ff5Q/z3A2b6HEsx2dF
         laUQaQtyyd3yhZwhmKjwDfmLTGw/pwcfcTcsaWQ76uj6B0Q8uocp1q9XJmio6LLfOqAT
         8u94i6vbO4/AbLx8fs4NYlmbMtI3gR2N3Q1/M8yiLuCBjLUmM62w/jMU6SMQKRCnK6Lk
         NxGik3ak/z8mf5a1os3jkxUCWU6nHjXX5d78oWtAJFVPgDoSXH6ZKSrPdimDtMgnEEsh
         5JYOXmtXo1dY9+v6ozzOuobDVK6+UQczOvcbaP9RWu0INuVnBIkH0BaWWdHsUvsVmma8
         a0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i4bz0Y4+LLeigFOq1QSp/IVRJ+VZnQF7hnDzeTu812w=;
        b=dtE45nCEGdUOVHl3erGw+0pg6wKvvWy4cQr4YiRgYkT4RgIE2QTIHtTYW93zTLen2M
         v8ke2jB9Lfy2vPWP1aoBQ+CFs1SiXBeML9sGQzoqcjnf/k83zQ9QZrL5M1isIAwohMpB
         f2eaSqItXhBM1xIEt+fx7pwsd9mMCA8JiOqAJlrjjxEQpbKvRVYcNcgNd8qri8jj4laf
         Yy8xHSkj4dv232TFUml3xLpGlRUGTXoY+ZqPgtkLBHZMp1OMi0y4kIpuSLFKp2xNIiJP
         As5+zM+2a0v73a38q7QFVNBZ1dET1UH+eZTuoO9wl53hGGiEweXHMPnISodYJdW7CTDi
         2w+w==
X-Gm-Message-State: AOAM532kePkV6sHQRVHb+HG+nswRa97LlzUafcvkRW+0knekIdESe/4h
        +nAxR1giLaQIcTMjQgUtuARAw97/
X-Google-Smtp-Source: ABdhPJzLLfDdXD8SPUd/keH02ywdmyhsMk3CVtGVAmn6ps9tTEb1XS29Owih5SsSE75FvM6Yi9e1ZA==
X-Received: by 2002:a05:6402:642:: with SMTP id u2mr4837007edx.230.1592351960597;
        Tue, 16 Jun 2020 16:59:20 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o24sm11814123ejb.72.2020.06.16.16.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 16:59:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH net 3/3] net: dsa: sja1105: fix checks for VLAN state in gate action
Date:   Wed, 17 Jun 2020 02:58:43 +0300
Message-Id: <20200616235843.756413-4-olteanv@gmail.com>
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

Fixes: 834f8933d5dd ("net: dsa: sja1105: implement tc-gate using time-triggered virtual links")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index a176f39a052b..0056f9c1e471 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -593,7 +593,9 @@ int sja1105_vl_gate(struct sja1105_private *priv, int port,
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on DMAC");
 		return -EOPNOTSUPP;
-	} else if (key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	} else if ((priv->vlan_state == SJA1105_VLAN_BEST_EFFORT ||
+		    priv->vlan_state == SJA1105_VLAN_FILTERING_FULL) &&
+		   key->type != SJA1105_KEY_VLAN_AWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
-- 
2.25.1

