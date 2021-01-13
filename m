Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B8B2F46C2
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 09:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbhAMIoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 03:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbhAMIoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 03:44:25 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA7BC061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:44 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id m12so1555705lfo.7
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=FpmH3OQSzKdKZaCU+6So/vZiiUWEH/c2PXgnQCyuHeg=;
        b=HXAuv4TiBoZOsPWwfV+rA6q36YVE3O3J6vgQvaVbk1tM6IXk6Me+9yx83PKOEkyTI5
         5RCyNlgDBIDBD4J7j6CzQdaZNlp/9fXqOaXzU1O2cZsnWSleczBnzmdHZRlQobTdY3HD
         3XVdwnszjqwEF2onh4wCiwVqCUVAonPKnwcEfk9aBx1Xz7PpOx/3vSqbIjQaQfhBMLkK
         xzDlyJBwTu3p8VI4oPtHLlQUFMaHflE8/V/jWyBkRTlrFVkYiDEc+FNCQdObaoSeXGcJ
         OUJM9m5oRf2QdNQQ2uAyT3V0FJ4lsLCqgD3Py0JPhfJ2zkswtvNL6OeSm2Epluhq8XPx
         iNSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=FpmH3OQSzKdKZaCU+6So/vZiiUWEH/c2PXgnQCyuHeg=;
        b=BRtzskT81jFMqdHFmqiPIyXPZqzjkENw9KH3ZtMcjBJK/KDiXfXA3ZDDBkbkoaYhzr
         +kwCFo3WjcxJlfViiWs8d8+G55nWtZKdNN/adCSBg8kUXTmYQjD/D8yUmKDfGfN5X6Jr
         oJKhHcSjsrCA6JRPYEHmpZnL9kJl0HnEpk28V0MYUi955dyq7x3zjGCtmYs6GuIy3s2z
         0GVZEU4xKrcgYop6HDv4ilaZFUDyAIETBD7lllmnxkEVlnhqPI7muH2bHXfGwXAX5sr/
         3434em1Y8AbgNKGZ8jpVH0ytDulxahIgUsrAi6XBCeFp8raXseHI6Ah0PKd3Hc2D5ZqM
         2Jhg==
X-Gm-Message-State: AOAM5326evPDxS4lzYCFs+sDvCuLGQks27N7eRQ1EGFRhGnnmagpB08R
        jYqOmOZR5mpPibNS3e38KHUieawLocpwSnaW
X-Google-Smtp-Source: ABdhPJzVY0OI781dEtbUL4/lp9p95VZYcrajNJC7O6x8OlDoFHjWyN3NTbqsCAqdta6+B7jf1j+6VA==
X-Received: by 2002:a05:6512:368d:: with SMTP id d13mr395033lfs.414.1610527423263;
        Wed, 13 Jan 2021 00:43:43 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u14sm137027lfk.108.2021.01.13.00.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 00:43:42 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v5 net-next 2/5] net: dsa: Don't offload port attributes on standalone ports
Date:   Wed, 13 Jan 2021 09:42:52 +0100
Message-Id: <20210113084255.22675-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210113084255.22675-1-tobias@waldekranz.com>
References: <20210113084255.22675-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a situation where a standalone port is indirectly attached to a
bridge (e.g. via a LAG) which is not offloaded, do not offload any
port attributes either. The port should behave as a standard NIC.

Previously, on mv88e6xxx, this meant that in the following setup:

     br0
     /
  team0
   / \
swp0 swp1

If vlan filtering was enabled on br0, swp0's and swp1's QMode was set
to "secure". This caused all untagged packets to be dropped, as their
default VID (0) was not loaded into the VTU.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5a1769602e65..e53c8ca6eb66 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -273,6 +273,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
+	if (attr->orig_dev != dev)
+		return -EOPNOTSUPP;
+
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
 		ret = dsa_port_set_state(dp, attr->u.stp_state);
-- 
2.17.1

