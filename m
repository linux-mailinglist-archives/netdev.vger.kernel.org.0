Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D223053DB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhA0HB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S316521AbhA0BBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 20:01:25 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875A7C06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:00:45 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ox12so327766ejb.2
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iQWVmXkvm0fkYg8H3/g3PhO4iUSVaG1NDc0ObhDfgzE=;
        b=c8aR/EcMc3dHLNuIiJuwkbxXx2LfW6+YCJUyeUdD5zVaXRnnhCMlt1WPrT06LFPS8m
         81zpFHS/WLJgECadSyU2uxkSdVgV/tolzwseStaPo0e2nehEGrsXaDsnbMvqYa5F+m1a
         +52GtfvBYvIJg1JSbARxRTIsYR4bSEf7Q6H3o9SKRdK/FWWef2Us7guzxVo3HnPmyNSQ
         KD/vut9klgy1cKuE+8RdBspwv0uP3Ru1LQ1EoMNJ8PYcuCfDNHVHc0R7FrpP54tllfh5
         h6RkUMMSUNcdGT2m5uTBx2hLUaiD3kC4Hc1Nsdeb6fVJWR3jWozcoqgVom7PIOYh6RuR
         +p0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iQWVmXkvm0fkYg8H3/g3PhO4iUSVaG1NDc0ObhDfgzE=;
        b=jdUpa24Az004pJkqK8EffDQbTskShNA7+sOZYYJmf9OLv5b5JU8wZpdsmIiyorwLYO
         M+vpR+HqhY9n03aNwR48uEhFLqnrlg+i9LsFdyQ2wYaXdEaVINFW2jwgxNxBwMcI5KCr
         NvVLfo3e135p0+wHrSthcDHpnLOKlbwmc7nU/eao5cuEatLA+QMpNZKzJyvNRF3FQoqd
         /qN1MIt0E5oEDCSSO8uQwTtW6W67tL6J75oVzltH4HfhXxN8ZJDXm3iBe5wFWkUpiCJ2
         88eOyekJ+DSY85eUJuRvyolm5KshvYiRMy//gS6MvoI54olcW+xS8hg4O+rd4Il82zc/
         +k8Q==
X-Gm-Message-State: AOAM531VwJXVWhH87Y/RRbQu+eXZG8t2yt9UHxTi5dJ1zF9BR99x+Upe
        GNu1MpDK4GaDlMAG3AVIXS8eEV5knUk=
X-Google-Smtp-Source: ABdhPJzP7onk6tkTATpteRXbFAzMbP6t6zbYXwUgk4VjgPFQ5CulXngYDIQjSWVtH2T3J0sO3V4Anw==
X-Received: by 2002:a17:906:d98:: with SMTP id m24mr4927869eji.428.1611709244316;
        Tue, 26 Jan 2021 17:00:44 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ko23sm115897ejc.35.2021.01.26.17.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:00:43 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net-next 2/4] net: dsa: automatically bring user ports down when master goes down
Date:   Wed, 27 Jan 2021 03:00:26 +0200
Message-Id: <20210127010028.1619443-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127010028.1619443-1-olteanv@gmail.com>
References: <20210127010028.1619443-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is not fixing any actual bug that I know of, but having a DSA
interface that is up even when its lower (master) interface is down is
one of those things that just do not sound right.

Yes, DSA checks if the master is up before actually bringing the
user interface up, but nobody prevents bringing the master interface
down immediately afterwards... Then the user ports would attempt
dev_queue_xmit on an interface that is down, and wonder what's wrong.

This patch prevents that from happening. NETDEV_GOING_DOWN is the
notification emitted _before_ the master actually goes down, and we are
protected by the rtnl_mutex, so all is well.

$ ip link set eno2 down
[  763.672211] mscc_felix 0000:00:00.5 swp0: Link is Down
[  763.880137] mscc_felix 0000:00:00.5 swp1: Link is Down
[  764.078773] mscc_felix 0000:00:00.5 swp2: Link is Down
[  764.197106] mscc_felix 0000:00:00.5 swp3: Link is Down
[  764.299384] fsl_enetc 0000:00:00.2 eno2: Link is Down

For those of you reading this because you were doing switch testing
such as latency measurements for autonomously forwarded traffic, and you
needed a controlled environment with no extra packets sent by the
network stack, this patch breaks that, because now the user ports go
down too, which may shut down the PHY etc. But please don't do it like
that, just do instead:

tc qdisc add dev eno2 clsact
tc filter add dev eno2 egress flower action drop

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 393294a53834..5e5798b46f34 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2073,6 +2073,36 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		err = dsa_port_lag_change(dp, info->lower_state_info);
 		return notifier_from_errno(err);
 	}
+	case NETDEV_GOING_DOWN: {
+		struct dsa_port *dp, *cpu_dp;
+		struct dsa_switch_tree *dst;
+		int err = 0;
+
+		if (!netdev_uses_dsa(dev))
+			return NOTIFY_DONE;
+
+		cpu_dp = dev->dsa_ptr;
+		dst = cpu_dp->ds->dst;
+
+		list_for_each_entry(dp, &dst->ports, list) {
+			if (!dsa_is_user_port(dp->ds, dp->index)) {
+				struct net_device *slave = dp->slave;
+
+				if (!(slave->flags & IFF_UP))
+					continue;
+
+				err = dev_change_flags(slave,
+						       slave->flags & ~IFF_UP,
+						       NULL);
+				if (err)
+					break;
+			}
+		}
+
+		return notifier_from_errno(err);
+	}
+	default:
+		break;
 	}
 
 	return NOTIFY_DONE;
-- 
2.25.1

