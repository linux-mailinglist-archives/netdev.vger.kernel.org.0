Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8151C49F1
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgEDXAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728145AbgEDXAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:00:47 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42C6C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:00:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g13so429410wrb.8
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cc7rvlruE+hEtFwN8rl4iTLu96pyTqzjLBzLPVOtaag=;
        b=jgvXMqF4KWMQYv29SZuDeag0G+03yYoF9EP+DFqb2Ov3+ks+uEgYLUlvSSGBXi0SBw
         aEsYdVI4+DPjIkc7KLeChPN+f5eNSRfOnMwW2rfELTtVtNBSz3RQY01HG2c0ILaSao+t
         V/rCnIqhyS7MwKvAU7GsqdW5rzLwG6MjnHGzidynnG+I3MNxfWBnLKyUF9egTpH7tWKR
         IPsbaWP3FDwe91tjgyW6Qi5eneCMb6MH+ohRDf2vyD9/+PzrWxnJbZGbsGQujcMVSouG
         Ol6nj08lyoxhSj9qnLJ2Kvi0z+IShWuJJnb+DaAnmyWbI27GOl9F/riWWfsdTUbJAWpY
         SYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cc7rvlruE+hEtFwN8rl4iTLu96pyTqzjLBzLPVOtaag=;
        b=cbEuFe07/Buj+LToLWalNwBTIQtCnAsy6eUnooRMJ8BY2XXNeXTa5zbAN0/xO3hW6i
         oEWdJCBSHpHHcrmT87JMW6ivfk72lsCQIxE8gsHjffoL+nY7w6zO9TCBiagGmYnHmmYS
         QgrVegj1rETQjM85fbplJ64I9KDNkWpDBxinxA8cWd4NpB0g9MBxNG2pZQ+Re4L5MqLD
         7HIWOgss7LYowN5rjClNV1JoTb9OnS40X4tRticZQG8JzYEap3rY56fUswew8zRScTWR
         Ba4+6jcbzb8lrCE3slJ9QAnJtlK+bpyP5FkurKo7udsxe1N893wQ+PNksyMn9rbe/c57
         RsJg==
X-Gm-Message-State: AGi0PuYxzqyu+Cobh88kpMfJjnkIPTw10s9dp7r4XMi3OLAiOql1ul/R
        +KgTa22aqo5Sc83KtG/kqqh5DNfDEUU=
X-Google-Smtp-Source: APiQypKshQah5Yr/YdwZUkmFbkvyVOCSnf44RX9ZsIJcx7d+Tq+klsdvJiEYbHnQ/w1gkzhKPi5TOg==
X-Received: by 2002:a5d:4151:: with SMTP id c17mr158781wrq.111.1588633245285;
        Mon, 04 May 2020 16:00:45 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r23sm15322570wra.74.2020.05.04.16.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:00:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang_1@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vlad@buslov.dev, jiri@mellanox.com, idosch@mellanox.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 1/6] net: dsa: introduce a dsa_port_from_netdev public helper
Date:   Tue,  5 May 2020 02:00:29 +0300
Message-Id: <20200504230034.23958-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504230034.23958-1-olteanv@gmail.com>
References: <20200504230034.23958-1-olteanv@gmail.com>
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

