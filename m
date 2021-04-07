Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AC43575B5
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356039AbhDGUPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356007AbhDGUPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:15:20 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6B5C061764
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 13:15:09 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r9so7213177ejj.3
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 13:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=au+A1lvEoXA2bUIVl7MRId97EuktINPHfrNJIRdysmE=;
        b=M3PzpoDQ9W48GX7CoTdCc0UYGdD0Sf/5O/Abc6SZmRQTCOuXuVitrEKf55kjwKn7bl
         VZRSUQ2nH/E8AaPiR5RKNtU1ckFeq+QDObigOh/Ayy9ukTnIeX5X1DDmH7oj/w7RmzAJ
         a8TFrKh/rFFrdJss0uNIw6ZvbmiTSRsBXcpq9yGj4ywxXXx8ybmDERlADEA1bKtYx8Qi
         5A1DZ/oV/1S0v2xM+rICL6xAWffS0lmibKnorA12leAq3G8TFE8qLa/OY7g5c0m1mgcC
         EcCh/Mnfar/fAZ2j6iEC72WyePMLvva1kCMkUSEjWjNSjhUwZBssx+wIgpRBro8x1zTs
         FbGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=au+A1lvEoXA2bUIVl7MRId97EuktINPHfrNJIRdysmE=;
        b=CDNmn7vGBEnG9hWAReNBG5pbMMjoFmmB4A+Nrzw0utHaPp+dtRtUqNDxtKYY+lrSXT
         ITDIciCNBqCmWPiH4zXHaparnQtZ+cgarPk2lgrh1lpAmfriKe14clIM4aobD4rDm5QY
         mrVILNoj61PsfFL6AA98HqU7hPNcK30b55/DLA9tFUT7WPlQq5f6QCn86LsMHmxCS9nw
         s5qefezmNUHwy9Qass3O2HxZSjSyuzsTkOWAucc55hHXdHFOc6bb01h3mNsilDj+O1ud
         Y+aL8II1BZCtsYzeW1b8FsvZFQ78KBxwMjO+k7vDNtsReAOAmyvMYl9nzVE4KuiMLnnD
         MFCQ==
X-Gm-Message-State: AOAM532GZOzQNTOKmp+TOlSOSgrDPOgCTXvfYDKhSQw3hwRdCsT09UI7
        odWnKfs+abxV9AqcrpdzjZ8=
X-Google-Smtp-Source: ABdhPJyd8zq6zO9vTgLyBeFoBALzOFZYgSUX0fMF5B6s/BNY8l3t+GTWpzlHBfgWX44YerUIDnnPmg==
X-Received: by 2002:a17:906:4b0e:: with SMTP id y14mr5699361eju.393.1617826507822;
        Wed, 07 Apr 2021 13:15:07 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r26sm4982892edc.43.2021.04.07.13.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 13:15:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 3/3] net: dsa: sja1105: update existing VLANs from the bridge VLAN list
Date:   Wed,  7 Apr 2021 23:14:52 +0300
Message-Id: <20210407201452.1703261-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210407201452.1703261-1-olteanv@gmail.com>
References: <20210407201452.1703261-1-olteanv@gmail.com>
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
index 61133098f588..5e40ee14030a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2829,11 +2829,22 @@ static int sja1105_vlan_add_one(struct dsa_switch *ds, int port, u16 vid,
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

