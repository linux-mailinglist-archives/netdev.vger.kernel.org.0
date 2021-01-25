Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE12302EB3
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbhAYWKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733156AbhAYWGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:06:12 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9BBC061788
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:34 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b21so17393190edy.6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6LIw+XeErXv4IwY9a83U6YsuOtVgf/8xg9msZXrfbXU=;
        b=f7USBCEHf9K+asWgPDc8ivruWlifp44cZ1Pwa5nmwXIcCi8ZJYv1plHXN0JM35sT4l
         Yp2xFxR68W9nS5wGh4nkctdxy7rLMntlX7JIfq2oWuAGcs3ahSvXW3ETxA9nqE6mUmr4
         SWKRyVAmyntEkzlNLAxQWsW/UE/sZF8/B/XukkK3N4UfPm+nOjYecAQls35Jw6fUdswD
         1d0jbKMIsnkfp/ODEZDksZXw53wxI+65MgCrzIiAyvUQnhl0O7jp59OHhTpXIGS8oSgj
         4LhgRH5k1kT8MQzE2gGGV53lEJsIIj058qCFCIt+3ow7iIodCT00+nTxml5QHksGMs8m
         hc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6LIw+XeErXv4IwY9a83U6YsuOtVgf/8xg9msZXrfbXU=;
        b=UB7vXL84lmVO840vDmvSfw3DDIz9D10MZJPIZ8PbSrRzuCdmPocqRn6v04w4xewBA5
         VstuBUlcrRrlC+geCEMqy0s9rvRcXVOb8X6v0HHNrw0dyEk81RxFF2i0OFfAeqqg0m8i
         Npurjx2eCZe/rUX2zh7++6vBQ4dW3YiGipMRMWLHsL+ns8czOZ0ucoQJGlza5bDb49Tt
         z4jxtDTU8f5NYpnFww95CGhZKuvyWNCEBJRbkjNmGz1vy3MnAC6l1ylERK95CAYxQz7Y
         0ERcWAFse7N1m0olCkn7P/yn1JvB6YmeEX21iltZHxg56Y0qZ/V7buOfoIFaOY6QMH0D
         ZmTg==
X-Gm-Message-State: AOAM531KkxToIAXfUNbkQlXjrQVeSmb/uiI0W2CPVO61Ab1Lu5UzE+cc
        tMBx5TsTMbr0SEJvPBwyNeU=
X-Google-Smtp-Source: ABdhPJwfrQuTJb/VfNppk2RYQaVGr+tXTY3YL5MzgN6r5sm0K527KmSU8Vrl+YGqng9IAWanFkWHWg==
X-Received: by 2002:a05:6402:c9c:: with SMTP id cm28mr2247246edb.281.1611612273550;
        Mon, 25 Jan 2021 14:04:33 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm1760555edi.92.2021.01.25.14.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:04:32 -0800 (PST)
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
Subject: [PATCH v7 net-next 07/11] net: dsa: keep a copy of the tagging protocol in the DSA switch tree
Date:   Tue, 26 Jan 2021 00:03:29 +0200
Message-Id: <20210125220333.1004365-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125220333.1004365-1-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
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
to understand each other.

It's time to make this official and enforce it (yes, this also means we
won't have any "switch understands tag to some extent but is not able to
speak it" hardware oddities that we'll support in the future).

This is needed due to the imminent introduction of the dsa_switch_ops::
{set,del}_tag_protocol driver API. When that is introduced, we'll have
to notify switches of the tagging protocol that they're configured to
use, even at probe and remove time. Currently the tag_ops structure
pointer is held only for CPU ports. But there are switches which don't
have CPU ports and nonetheless still need to be configured. These would
be Marvell leaf switches whose upstream port is just a DSA link. How do
we inform these of their tagging protocol setup/deletion?

One answer to the above would be: iterate through the DSA switch tree's
ports once, list the CPU ports, get their tag_ops, then iterate again
now that we have it, and notify everybody of that tag_ops. But what to
do if conflicts appear between one cpu_dp->tag_ops and another? There's
no escaping the fact that it makes no sense to have multiple tag_ops in
the same dst.

Ease our work and just keep the master copy of the tag_ops inside the
struct dsa_switch_tree. Note that reference counting the tagger module
driver still happens for each CPU port that uses that tagging protocol.

There are many places in the data path that access master->dsa_ptr->tag_ops
and we would introduce unnecessary performance penalty going through yet
another indirection, so keep those right where they are.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v7:
Patch is new.

 include/net/dsa.h | 7 ++++++-
 net/dsa/dsa2.c    | 6 ++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

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
index 2953d0c1c7bc..42f22955e111 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1026,6 +1026,12 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 
 	dp->master = master;
 	dp->type = DSA_PORT_TYPE_CPU;
+	if (dst->tag_ops && dst->tag_ops != tag_ops) {
+		dev_err(ds->dev,
+			"A DSA switch tree can have only one tagging protocol\n");
+		return -EINVAL;
+	}
+	dst->tag_ops = tag_ops;
 	dp->filter = tag_ops->filter;
 	dp->rcv = tag_ops->rcv;
 	dp->tag_ops = tag_ops;
-- 
2.25.1

