Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E773082D3
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhA2BDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhA2BB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:01:56 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45CAC06178A
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:39 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id r12so10560338ejb.9
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GUn72YhyZLJlCljbKWf0cXF8ecR5PXWPiTADy9wGdn4=;
        b=ljdU52N6fKXtEDz+QbuLVxmob5ckvXMy8Wx39lek+DaRBgxGJdx9pTrqE8DtZ+hIZy
         OVYEYC7zMRuQ/IbYxBAQYoimUPtfYC8EDDXBHCuSFEAPpRcEvDOkezVgXlCi0l3x+dKw
         hU8MhVG8GuJVXx0QVRcjKVZN1jWZEf/lq7rCTRequPlgsm26Hs8UYRpCtaxBDZcO+Xy0
         gHxo2mN7ZK7VESSKF9P6zzv5gFFZIwqeY1uVqBCDD0AuLxKf01IoRH7wV84JpsMcXO+E
         fZRm91FJ0WiBLnDfNJF8aFq1tzV8xnIm7J0UjBG+lXl6Tq1r5vb/7D5w0dJMZgQOwotl
         a/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GUn72YhyZLJlCljbKWf0cXF8ecR5PXWPiTADy9wGdn4=;
        b=DIG20XSlAwtxrf/p6q4qiOKvD+MKQcmOQF4lcsS9lj7nBcXEuY3Q31D5XCf5c2ud4W
         8pWuHv1BpQLD5UPTSQJQaXIUqYoUoeG8fMpqkLA+ahITU5pZ9dJvIej7Ee5tkaZaYSHl
         NdpP8mv1wV9BDak4qmozpok8Wn43rIfc5Q+oYhDw6AQEYz4wgl2mPp8vvmUz/N3rtW2j
         NIEPgsrrCRUg4J48aK0mCxKzVYYgIiOQPRGsWPr6u6mtsmHgW2Dft6JGHcEAj5P/dMw7
         hHqa1x4RUer5XcPWPmjA8Z5sswmR9ZjpEu1Xm6MDDU41wAahR4z+/73/FI5mq8wShZnM
         a39w==
X-Gm-Message-State: AOAM531HwrVkIBsJgWjggusgL+1YoSiABcKZukVFoBDcOlhV9UqbwSJV
        5wWFYNJZlhPUnY998azSz/k=
X-Google-Smtp-Source: ABdhPJwW5CllPV4l7ogvGAWJBbwYNNlvpT5EMSFT9tTAqFA29RQyED4kFQSa5AeHQy9CAY44xEkgkQ==
X-Received: by 2002:a17:906:28d6:: with SMTP id p22mr2155398ejd.365.1611882038489;
        Thu, 28 Jan 2021 17:00:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v8 net-next 07/11] net: dsa: keep a copy of the tagging protocol in the DSA switch tree
Date:   Fri, 29 Jan 2021 03:00:05 +0200
Message-Id: <20210129010009.3959398-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
References: <20210129010009.3959398-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Cascading DSA switches can be done multiple ways. There is the brute
force approach / tag stacking, where one upstream switch, located
between leaf switches and the host Ethernet controller, will just
happily transport the DSA header of those leaf switches as payload.
For this kind of setups, DSA works without any special kind of treatment
compared to a single switch - they just aren't aware of each other.
Then there's the approach where the upstream switch understands the tags
it transports from its leaves below, as it doesn't push a tag of its own,
but it routes based on the source port & switch id information present
in that tag (as opposed to DMAC & VID) and it strips the tag when
egressing a front-facing port. Currently only Marvell implements the
latter, and Marvell DSA trees contain only Marvell switches.

So it is safe to say that DSA trees already have a single tag protocol
shared by all switches, and in fact this is what makes the switches able
to understand each other. This fact is also implied by the fact that
currently, the tagging protocol is reported as part of a sysfs installed
on the DSA master and not per port, so it must be the same for all the
ports connected to that DSA master regardless of the switch that they
belong to.

It's time to make this official and enforce it (yes, this also means we
won't have any "switch understands tag to some extent but is not able to
speak it" hardware oddities that we'll support in the future).

This is needed due to the imminent introduction of the dsa_switch_ops::
change_tag_protocol driver API. When that is introduced, we'll have
to notify switches of the tagging protocol that they're configured to
use. Currently the tag_ops structure pointer is held only for CPU ports.
But there are switches which don't have CPU ports and nonetheless still
need to be configured. These would be Marvell leaf switches whose
upstream port is just a DSA link. How do we inform these of their
tagging protocol setup/deletion?

One answer to the above would be: iterate through the DSA switch tree's
ports once, list the CPU ports, get their tag_ops, then iterate again
now that we have it, and notify everybody of that tag_ops. But what to
do if conflicts appear between one cpu_dp->tag_ops and another? There's
no escaping the fact that conflict resolution needs to be done, so we
can be upfront about it.

Ease our work and just keep the master copy of the tag_ops inside the
struct dsa_switch_tree. Reference counting is now moved to be per-tree
too, instead of per-CPU port.

There are many places in the data path that access master->dsa_ptr->tag_ops
and we would introduce unnecessary performance penalty going through yet
another indirection, so keep those right where they are.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v8:
Make tagging driver module reference counting work per DSA switch tree
instead of per CPU port, to be compatible with the tag protocol changing
through sysfs.

Changes in v7:
Patch is new.

 include/net/dsa.h |  7 ++++++-
 net/dsa/dsa2.c    | 36 ++++++++++++++++++++++++------------
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2f5435d3d1db..b8af1d6c879a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -140,6 +140,9 @@ struct dsa_switch_tree {
 	/* Has this tree been applied to the hardware? */
 	bool setup;
 
+	/* Tagging protocol operations */
+	const struct dsa_device_ops *tag_ops;
+
 	/*
 	 * Configuration data for the platform device that owns
 	 * this dsa switch tree instance.
@@ -225,7 +228,9 @@ struct dsa_port {
 		struct net_device *slave;
 	};
 
-	/* CPU port tagging operations used by master or slave devices */
+	/* Copy of the tagging protocol operations, for quicker access
+	 * in the data path. Valid only for the CPU ports.
+	 */
 	const struct dsa_device_ops *tag_ops;
 
 	/* Copies for faster access in master receive hot path */
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 2953d0c1c7bc..63035a898ca8 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -179,6 +179,8 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 
 static void dsa_tree_free(struct dsa_switch_tree *dst)
 {
+	if (dst->tag_ops)
+		dsa_tag_driver_put(dst->tag_ops);
 	list_del(&dst->list);
 	kfree(dst);
 }
@@ -467,7 +469,6 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
-		dsa_tag_driver_put(dp->tag_ops);
 		dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
@@ -1011,24 +1012,35 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol tag_protocol;
 
 	tag_protocol = dsa_get_tag_protocol(dp, master);
-	tag_ops = dsa_tag_driver_get(tag_protocol);
-	if (IS_ERR(tag_ops)) {
-		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
-			return -EPROBE_DEFER;
-		dev_warn(ds->dev, "No tagger for this switch\n");
-		dp->master = NULL;
-		return PTR_ERR(tag_ops);
+	if (dst->tag_ops) {
+		if (dst->tag_ops->proto != tag_protocol) {
+			dev_err(ds->dev,
+				"A DSA switch tree can have only one tagging protocol\n");
+			return -EINVAL;
+		}
+		/* In the case of multiple CPU ports per switch, the tagging
+		 * protocol is still reference-counted only per switch tree, so
+		 * nothing to do here.
+		 */
+	} else {
+		dst->tag_ops = dsa_tag_driver_get(tag_protocol);
+		if (IS_ERR(dst->tag_ops)) {
+			if (PTR_ERR(dst->tag_ops) == -ENOPROTOOPT)
+				return -EPROBE_DEFER;
+			dev_warn(ds->dev, "No tagger for this switch\n");
+			dp->master = NULL;
+			return PTR_ERR(dst->tag_ops);
+		}
 	}
 
 	dp->master = master;
 	dp->type = DSA_PORT_TYPE_CPU;
-	dp->filter = tag_ops->filter;
-	dp->rcv = tag_ops->rcv;
-	dp->tag_ops = tag_ops;
+	dp->filter = dst->tag_ops->filter;
+	dp->rcv = dst->tag_ops->rcv;
+	dp->tag_ops = dst->tag_ops;
 	dp->dst = dst;
 
 	return 0;
-- 
2.25.1

