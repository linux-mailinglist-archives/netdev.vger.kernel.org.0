Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9C81C6294
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgEEVDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEEVDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:03:03 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD13C061A0F;
        Tue,  5 May 2020 14:03:03 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 18so1516282pfx.6;
        Tue, 05 May 2020 14:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I0mJ2TcquxeD51nWsq3E4nLfZAHxaYExvmCD1KmEor4=;
        b=sCFTVHBEXnXfa1xp6uvtRZEwgsGiCG2yXlzboVYMIi9rGcWn8do+UM6d9a3dAmwkns
         3bsgfETPukuOY6/+/YdOSBsXNbhJxoaQK3pZC9C3iDbF3eAX1Pm/8TbTtku1PFE0x6gq
         O2rK7lV7kHPsgotN/VmJ2xhTWCu0lFjdK0rhJKPv+4DHilTAH6wHVJkCxB1FJlBZd1OF
         /kkSTU2JUMAwR3+yJx3ZTBt4Qnq4LXiz7qj0hkJAhlAKKF9K0BHvm2Ttlc/Fio4nqxsu
         qCGQw0yskh9H/m8rJ/bc9dGbUfRLnaxZ0Fa1jZ6KPjTqvr9at+IPe1uVcjJafSgHUpO2
         IkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I0mJ2TcquxeD51nWsq3E4nLfZAHxaYExvmCD1KmEor4=;
        b=AoGIdy4TwLbPtdcIFHNBOjPR++MtS7KZnOi6/AFbdhtEolLz1hniihAbq9nC1Vcb4+
         StjE/0fCTM5JKvvVdHYoZSOjhUNKlTnRJf1niv76KkscJH/+pcvKLmyjxJeoR4Mrynfh
         c39zo0S0E6AZMaWwjBifRF/FJPY5sbd1p9Y58aHnaXVzuMUZ4gbxiSrEX8hh5/8GigAg
         v+hTqamPTBPpLEUvYQuMuMXhfWrIDuErx11Yk913V+860Jbg2YgkZxUYMqCfqyKF+mtn
         ifFLBCxuNKj8wFIgTQi033SoodVFv3wSGcxyUHM5zLhJqkfbA0vREbQ3uCXcf6ggIPX2
         pEQg==
X-Gm-Message-State: AGi0PuZzFak2jAYO/RycAzguvdFIMH7vudK831uidzcMguzmF4GmnP0C
        OgkhVG8XBwGbBr9ZlGiRI3UqkRF+
X-Google-Smtp-Source: APiQypK1bTzKL4DMFCMy93hdHrWtgQuj+/O3stBdm+tz5wtvb683MA4JT2c7GwWBvUzkV4twPhaHvg==
X-Received: by 2002:a63:5542:: with SMTP id f2mr4186377pgm.384.1588712581832;
        Tue, 05 May 2020 14:03:01 -0700 (PDT)
Received: from bender.lan (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s199sm2873249pfs.124.2020.05.05.14.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 14:03:01 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC net] net: dsa: Add missing reference counting
Date:   Tue,  5 May 2020 14:02:53 -0700
Message-Id: <20200505210253.20311-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we are probed through platform_data we would be intentionally
dropping the reference count on master after dev_to_net_device()
incremented it. If we are probed through Device Tree,
of_find_net_device() does not do a dev_hold() at all.

Ensure that the DSA master device is properly reference counted by
holding it as soon as the CPU port is successfully initialized and later
released during dsa_switch_release_ports(). dsa_get_tag_protocol() does
a short de-reference, so we hold and release the master at that time,
too.

Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index d90665b465b8..875231252ada 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -626,6 +626,7 @@ static enum dsa_tag_protocol dsa_get_tag_protocol(struct dsa_port *dp,
 	 * happens the switch driver may want to know if its tagging protocol
 	 * is going to work in such a configuration.
 	 */
+	dev_hold(master);
 	if (dsa_slave_dev_check(master)) {
 		mdp = dsa_slave_to_port(master);
 		mds = mdp->ds;
@@ -633,6 +634,7 @@ static enum dsa_tag_protocol dsa_get_tag_protocol(struct dsa_port *dp,
 		tag_protocol = mds->ops->get_tag_protocol(mds, mdp_upstream,
 							  DSA_TAG_PROTO_NONE);
 	}
+	dev_put(master);
 
 	/* If the master device is not itself a DSA slave in a disjoint DSA
 	 * tree, then return immediately.
@@ -657,6 +659,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 		return PTR_ERR(tag_ops);
 	}
 
+	dev_hold(master);
 	dp->master = master;
 	dp->type = DSA_PORT_TYPE_CPU;
 	dp->filter = tag_ops->filter;
@@ -858,6 +861,8 @@ static void dsa_switch_release_ports(struct dsa_switch *ds)
 		if (dp->ds != ds)
 			continue;
 		list_del(&dp->list);
+		if (dsa_port_is_cpu(dp))
+			dev_put(dp->master);
 		kfree(dp);
 	}
 }
-- 
2.20.1

