Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D3E38E33F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhEXJ1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhEXJ1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:27:08 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2DCC06138A
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:40 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lg14so40690727ejb.9
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Ey66oyG3NLGwflZVAOjkSfU7hIbefDDtCAF1NvM2ck=;
        b=d17aT1kqJ5Wpa76U4u/5AmjIzEfOg136c6j2GVeD6BAjhXpmhxt/vzEqU2oxsTgDlX
         g38yhPJKG5vnxvh9OU04AiVe5vWyYNWYP7qNyHW7bWtw535Umtz8mrlYqViw3A7kR14d
         c+HiTxxRR4hEUV7iv3e8Pbom++3AA/atDNKT+y3aCxpRsZ9SVDjUAngKnx/461aIUZX4
         OpYyhxhQ3muEbE+DF1rNvfhY7X9ui4Qi5lc3iRx1IQC+ADGGYRW2Mt8VQbvuu6XQ5CLh
         50WCJg69H5eb8Hu0XMTg00k9FeYTpdUYiOF5SHqYBi2DnulujibnjjFX1IEdCAPNxM2I
         QD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Ey66oyG3NLGwflZVAOjkSfU7hIbefDDtCAF1NvM2ck=;
        b=jlhnthspWQlhArrLpa8ScGcanOxVrHASglGRMVwjyE1jna5Qk/MaThshtVpMo318Ba
         HlQXzh/RsnLqJmUFNoL3uXMuDLz+xrOGLkeOu9agMp0UHG7YUn3U3RQ+tAWHHv0PA/vj
         R87kriagk+3v4hdpzTc1Eozpc3AxHZ0JgIW1KGTSsH/Zmu/idnhrssE2p1IPZ8i1Osr2
         3hSm8rrbt12ILOb+TJtqxPOQyEHzRgP8VvWJvN7gOd9y4TMN16tShQPPguKD0U4lCl3h
         dazT7muUX/um0cNa3rTaxPBDyS7RWOoIZp8YTjtX1JXlvVlYPHbFdjSNtVgbRrACND55
         lbSg==
X-Gm-Message-State: AOAM531Ga8eQPWUo0mUHYNvXJa1zdIvP6sOShasABr0XQBIQvG8CMwuh
        NEZRXltdPG+LK8mPChVUd8E=
X-Google-Smtp-Source: ABdhPJxi3fdQctA7c6g9mPXWilbOYvisuRGg952N33yDS7mp57IIWHyn8TbVNIH+7SOi+qbU4cL/ig==
X-Received: by 2002:a17:907:161f:: with SMTP id hb31mr5622521ejc.278.1621848338991;
        Mon, 24 May 2021 02:25:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id yw9sm7553007ejb.91.2021.05.24.02.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:25:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 6/6] net: dsa: sja1105: update existing VLANs from the bridge VLAN list
Date:   Mon, 24 May 2021 12:25:27 +0300
Message-Id: <20210524092527.874479-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524092527.874479-1-olteanv@gmail.com>
References: <20210524092527.874479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When running this sequence of operations:

ip link add br0 type bridge vlan_filtering 1
ip link set swp4 master br0
bridge vlan add dev swp4 vid 1

We observe the traffic sent on swp4 is still untagged, even though the
bridge has overwritten the existing VLAN entry:

port    vlan ids
swp4     1 PVID

br0      1 PVID Egress Untagged

This happens because we didn't consider that the 'bridge vlan add'
command just overwrites VLANs like it's nothing. We treat the 'vid 1
pvid untagged' and the 'vid 1' as two separate VLANs, and the first
still has precedence when calling sja1105_build_vlan_table. Obviously
there is a disagreement regarding semantics, and we end up doing
something unexpected from the PoV of the bridge.

Let's actually consider an "existing VLAN" to be one which is on the
same port, and has the same VLAN ID, as one we already have, and update
it if it has different flags than we do.

The first blamed commit is the one introducing the bug, the second one
is the latest on top of which the bugfix still applies.

Fixes: ec5ae61076d0 ("net: dsa: sja1105: save/restore VLANs using a delta commit method")
Fixes: 5899ee367ab3 ("net: dsa: tag_8021q: add a context structure")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index dffa7dd83877..b88d9ef45a1f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2816,11 +2816,22 @@ static int sja1105_vlan_add_one(struct dsa_switch *ds, int port, u16 vid,
 	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
 	struct sja1105_bridge_vlan *v;
 
-	list_for_each_entry(v, vlan_list, list)
-		if (v->port == port && v->vid == vid &&
-		    v->untagged == untagged && v->pvid == pvid)
+	list_for_each_entry(v, vlan_list, list) {
+		if (v->port == port && v->vid == vid) {
 			/* Already added */
-			return 0;
+			if (v->untagged == untagged && v->pvid == pvid)
+				/* Nothing changed */
+				return 0;
+
+			/* It's the same VLAN, but some of the flags changed
+			 * and the user did not bother to delete it first.
+			 * Update it and trigger sja1105_build_vlan_table.
+			 */
+			v->untagged = untagged;
+			v->pvid = pvid;
+			return 1;
+		}
+	}
 
 	v = kzalloc(sizeof(*v), GFP_KERNEL);
 	if (!v) {
-- 
2.25.1

