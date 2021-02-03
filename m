Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F26C30DF43
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhBCQJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbhBCQJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 11:09:24 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CAEC0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 08:08:43 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id i8so20186648ejc.7
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 08:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3h1HvVXUe44/bCSp1i3L8ntFtq89XkBSubKh6RThU44=;
        b=K9VdfFebuoBpuPsCyMvpRurxxEMq5Fj2aVvjfQFWS5RPneVCr3jrEEc2lioAwuiU6s
         N2E42oxrSctbEoEf5OhlRYqGqkWWzzKnpdpaA59Ww3Nf3giqzicVYNRx3A9AtvP/yHMR
         QgqegdlhDWvwvvQFltCqEYilnh70fQLWFa89Ni+RlhHI+3onO4h78UaR/nOkGj/skXIH
         h7BJ2fTFfu5yB2vxyMEepqJUvVF6EyPcy0179LZxa1UWOWw8dX9H+SaoSgoS/bEYMV6Z
         iloN6TOvvI9cEwesVqKa/DjeAkDiUiq8LWxhIpM8RpQyeQOIKOOzyT8nDyHnUEvHWXxW
         gJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3h1HvVXUe44/bCSp1i3L8ntFtq89XkBSubKh6RThU44=;
        b=eJndPxGQQrttrOTdpLCJuxwkGmsNGAlFpFKS7sD8oPueMIVbd5cLQ5e8z1QhB5GgpR
         xM4ZA+/6vc4+hgRkonEAu2wrwEa+DhvsKtSX2jfvaFi+FksNLRtTVDU+t8O/G0rIuXPC
         e5iiY/Jt0Q4R7otmp2qBTfAfBouaEG167yDnUivsMaqWYJo/IcRL1GHe61JkdeitKNL0
         qhRmHtbJXy4YxCpOUOYwGGm3f0ZuOiRLZCDNNWK1QQR14CFVrgKChhDN+Fp5Bfe/Y7jY
         KbO8Yb4qXWO/m5H8ZvByRFOVlrlneS3APLJ58jD0BWJDYud7uGTMCRN4tvJL4FYJ7WFd
         c50g==
X-Gm-Message-State: AOAM532elnepzFNI6a4i8Dd4QSOUvsWG77CAlN8Zm1e6GRGnw3UQUo04
        qproZ3OL6SUMvcDYB9vjAw0=
X-Google-Smtp-Source: ABdhPJzFpoqRBUoC+K5MEiTOxz0PFbfYXqcwdkkD79YlQIebi6kvRLlnW0/9kdqWoLELGeT7V88nqA==
X-Received: by 2002:a17:906:80b:: with SMTP id e11mr3856802ejd.269.1612368522680;
        Wed, 03 Feb 2021 08:08:42 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u16sm1085589eds.71.2021.02.03.08.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 08:08:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v2 net-next 2/4] net: dsa: automatically bring user ports down when master goes down
Date:   Wed,  3 Feb 2021 18:08:21 +0200
Message-Id: <20210203160823.2163194-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203160823.2163194-1-olteanv@gmail.com>
References: <20210203160823.2163194-1-olteanv@gmail.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
Fix typo: !dsa_is_user_port -> dsa_is_user_port.

 net/dsa/slave.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4616bd7c8684..aa7bd223073c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2084,6 +2084,36 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
+			if (dsa_is_user_port(dp->ds, dp->index)) {
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

