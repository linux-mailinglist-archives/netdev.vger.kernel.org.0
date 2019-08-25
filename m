Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAC69C510
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbfHYR0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:26:03 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46107 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728677AbfHYR0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:26:02 -0400
Received: by mail-qk1-f195.google.com with SMTP id p13so12331492qkg.13
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 10:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kVaKki6ux1xRm53Eihekl0W9/s6CnKLUCdT3K9sahc=;
        b=nT2GfZjNv5AC5zi9v4Bggf7xZRUpF7nDIsr9M7FrNI1PtuScIMvf7fVedjWkGEhOVR
         ii1xcsHv95l4viZ4+OizJwiKKQhOvUZxRtc2d/1IELFccP07KdNHddd400Aagi1amMpD
         /TbLAtx8tbU2r8eyIWDI5UgRXC2avRZN1U9vOdnbD+Ee1ZLe7dBMz8pkh+B7l0napfpk
         8i9qpFg0i7+ommdqNcnvt85ABd2ozUPJ0AvEhKLT8ZSKS1/8rdK+LQ5H6mNuKz6mNfPo
         98vWQeA8nBkT7SiaIvvW6jphOVPGMsg1dcbxPTIVtb92JC7JlR4d0U85kw1aUDnuFEw7
         vckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kVaKki6ux1xRm53Eihekl0W9/s6CnKLUCdT3K9sahc=;
        b=Fbw37JakIVsxbAY1EPf60CMDDfu99jxSSm9DT2jA/Bp87AqFYyrkN/hVGHyK4yktvd
         Vh2eaJtPAjE6Yf/V6Q7n27DZyXzubNp5d2nG0zTxaczk539kSP6cINwP8QbDpYH2ibyl
         N0151F4dbAG529Z14RFpD0hkC2edEBEYKVjHbhBfsckPBT9bXJbau8PLSPrvU9tdclzc
         NSByyZ58gPSNtk4uSq8LEBowxqxawT5exUOCb1+obdWsH0BCt9iUVCJoQP9mjweqMipC
         dHPQGiBtCLcnR2c2ZvjLjtBnPl5diWbqVv7NHUYeUecR9da8BeFhd59+vIU2M8129rRH
         5PFQ==
X-Gm-Message-State: APjAAAUzwtUWL4UYNy3cdgf2pvm/G+2aGpc/6hxG3TTv56kb3NNX2yeb
        YUY2FIT59iW5s4gHeipPzhtqoXpl
X-Google-Smtp-Source: APXvYqxQwqghF0D0iZ0iZCow2nrExE92hSt0DXLo4h94tBnoh6Jy0yPscA6hQ8JwpShUdN9YoqEhaQ==
X-Received: by 2002:a37:4a95:: with SMTP id x143mr13337170qka.357.1566753961160;
        Sun, 25 Aug 2019 10:26:01 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c15sm5017737qkm.32.2019.08.25.10.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 10:26:00 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 4/6] net: dsa: check bridge VLAN in slave operations
Date:   Sun, 25 Aug 2019 13:25:18 -0400
Message-Id: <20190825172520.22798-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190825172520.22798-1-vivien.didelot@gmail.com>
References: <20190825172520.22798-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge VLANs are not offloaded by dsa_port_vlan_* if the port is
not bridged or if its bridge is not VLAN aware.

This is a good thing but other corners of DSA, such as the tag_8021q
driver, may need to program VLANs regardless the bridge state.

And also because bridge_dev is specific to user ports anyway, move
these checks were it belongs, one layer up in the slave code.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/port.c  | 10 ++--------
 net/dsa/slave.c | 12 ++++++++++++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index ef28df7ecbde..9b54e5a76297 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -348,10 +348,7 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 
-	if (!dp->bridge_dev || br_vlan_enabled(dp->bridge_dev))
-		return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
-
-	return 0;
+	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
 }
 
 int dsa_port_vlan_del(struct dsa_port *dp,
@@ -363,10 +360,7 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 
-	if (!dp->bridge_dev || br_vlan_enabled(dp->bridge_dev))
-		return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
-
-	return 0;
+	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
 int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8f5126c41282..82e48d247b81 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -323,6 +323,9 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
+	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+		return 0;
+
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
 
 	err = dsa_port_vlan_add(dp, &vlan, trans);
@@ -377,6 +380,9 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
 
+	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
+		return 0;
+
 	return dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
 }
 
@@ -1099,6 +1105,9 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
+		if (!br_vlan_enabled(dp->bridge_dev))
+			return 0;
+
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
 		 * 0 means success, which is a failure for us here.
@@ -1126,6 +1135,9 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	 * need to emulate the switchdev prepare + commit phase.
 	 */
 	if (dp->bridge_dev) {
+		if (!br_vlan_enabled(dp->bridge_dev))
+			return 0;
+
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
 		 * 0 means success, which is a failure for us here.
-- 
2.23.0

