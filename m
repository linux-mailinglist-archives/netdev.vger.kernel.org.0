Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4221C60F5
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgEETVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEETVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:21:05 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB30C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 12:21:04 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x25so3515233wmc.0
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 12:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f1JAYIjc8v+imx1Rf4agxrDGytLLWSa+IUCQwWUCthU=;
        b=BaiEegqvzZUjYze6N0na0rWTCIrpKeDK71YAQUHmVFru+ja3cKwonqhxrSkO9As2jB
         7YkEkCmRXTVFxIqL4hv/aCUgjE+Jp/3MOTrRRGoakBxOi4NfCT0rzkkm2mtKKD1d01G9
         yAXhJ9FrgWU0Nkr2HR9gqlJ0S8/fPuGv7NlizoX1y9pwlvovOaVlwYJDlbaDYbLN4GCK
         HUcHGOlkPNax7KAEVwpMujef0fgnTEAaDMQfyoDMQvJvkK1SWTxbxqnHRLF0Nc215jJj
         dMeYh5pWd8dBe9IOKAFJGHPzLgGYln4DuxpQ8NwFvn/qvYNLXQaAaXGYJUlmmbMjxkeG
         UAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f1JAYIjc8v+imx1Rf4agxrDGytLLWSa+IUCQwWUCthU=;
        b=kqy0xbN1TzkITK+kFBg249L93q/hGM+vRx8h3sCHYRBNRX2oouzdkl0LJEZTEpw+ob
         czJRWi/v3A9oioKzvDgWlJr+2dDjMbKzLk4UjKd7vHyKyy2af9693wG9iM0pTfCXtgxR
         GI+GX32viSiadYIMuK4FKjImEdrlgSCv42WP2QGuZN95NnQanJ1x6XzYDzJSsk+f4qCD
         kla8KEz11MW97ZuDoil/eVKkVxTFgUTIfDrHrJEv2O+bFbUT0HDnTkMmmU4mtsSUZUzT
         M68MaM8hsiYLzTSse0qTkfI9MB67UaZl8rHDgtwx5DLQzIiWIBwBaLQp7psO+Nrq8kcR
         2a1A==
X-Gm-Message-State: AGi0PuYaDPeR/hliyjvR466aAd2XPa4l88BTCaeTVxyTZvVc5B0uzNwc
        Y3WMKDZDPhbEYtvV4UdiBa8Xiopn
X-Google-Smtp-Source: APiQypIuR+0wj6oVcKybOcQed36o/NaQMarVwkybRxFkxpwfNJDnoLQTj20Zl9kVLZbfZ0OFVJq5PQ==
X-Received: by 2002:a1c:f211:: with SMTP id s17mr293759wmc.168.1588706463463;
        Tue, 05 May 2020 12:21:03 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id z16sm5090681wrl.0.2020.05.05.12.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 12:21:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com
Subject: [PATCH v3 net-next 1/6] net: dsa: introduce a dsa_port_from_netdev public helper
Date:   Tue,  5 May 2020 22:20:52 +0300
Message-Id: <20200505192057.9086-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505192057.9086-1-olteanv@gmail.com>
References: <20200505192057.9086-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As its implementation shows, this is synonimous with calling
dsa_slave_dev_check followed by dsa_slave_to_port, so it is quite simple
already and provides functionality which is already there.

However there is now a need for these functions outside dsa_priv.h, for
example in drivers that perform mirroring and redirection through
tc-flower offloads (they are given raw access to the flow_cls_offload
structure), where they need to call this function on act->dev.

But simply exporting dsa_slave_to_port would make it non-inline and
would result in an extra function call in the hotpath, as can be seen
for example in sja1105:

Before:

000006dc <sja1105_xmit>:
{
 6dc:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
 6e0:	e1a04000 	mov	r4, r0
 6e4:	e591958c 	ldr	r9, [r1, #1420]	; 0x58c <- Inline dsa_slave_to_port
 6e8:	e1a05001 	mov	r5, r1
 6ec:	e24dd004 	sub	sp, sp, #4
	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 6f0:	e1c901d8 	ldrd	r0, [r9, #24]
 6f4:	ebfffffe 	bl	0 <dsa_8021q_tx_vid>
			6f4: R_ARM_CALL	dsa_8021q_tx_vid
	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
 6f8:	e1d416b0 	ldrh	r1, [r4, #96]	; 0x60
	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 6fc:	e1a08000 	mov	r8, r0

After:

000006e4 <sja1105_xmit>:
{
 6e4:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
 6e8:	e1a04000 	mov	r4, r0
 6ec:	e24dd004 	sub	sp, sp, #4
	struct dsa_port *dp = dsa_slave_to_port(netdev);
 6f0:	e1a00001 	mov	r0, r1
{
 6f4:	e1a05001 	mov	r5, r1
	struct dsa_port *dp = dsa_slave_to_port(netdev);
 6f8:	ebfffffe 	bl	0 <dsa_slave_to_port>
			6f8: R_ARM_CALL	dsa_slave_to_port
 6fc:	e1a09000 	mov	r9, r0
	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 700:	e1c001d8 	ldrd	r0, [r0, #24]
 704:	ebfffffe 	bl	0 <dsa_8021q_tx_vid>
			704: R_ARM_CALL	dsa_8021q_tx_vid

Because we want to avoid possible performance regressions, introduce
this new function which is designed to be public.

Suggested-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Previous patch "net: dsa: export dsa_slave_dev_check and
dsa_slave_to_port" was replaced with this one.

 include/net/dsa.h | 1 +
 net/dsa/dsa.c     | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fb3f9222f2a1..6dfc8c2f68b8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -637,6 +637,7 @@ void dsa_devlink_resource_occ_get_register(struct dsa_switch *ds,
 					   void *occ_get_priv);
 void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
 					     u64 resource_id);
+struct dsa_port *dsa_port_from_netdev(struct net_device *netdev);
 
 struct dsa_devlink_priv {
 	struct dsa_switch *ds;
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 0384a911779e..1ce9ba8cf545 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -412,6 +412,15 @@ void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
 }
 EXPORT_SYMBOL_GPL(dsa_devlink_resource_occ_get_unregister);
 
+struct dsa_port *dsa_port_from_netdev(struct net_device *netdev)
+{
+	if (!netdev || !dsa_slave_dev_check(netdev))
+		return ERR_PTR(-ENODEV);
+
+	return dsa_slave_to_port(netdev);
+}
+EXPORT_SYMBOL_GPL(dsa_port_from_netdev);
+
 static int __init dsa_init_module(void)
 {
 	int rc;
-- 
2.17.1

