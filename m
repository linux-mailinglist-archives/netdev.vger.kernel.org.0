Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF29B3410D4
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhCRXT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhCRXSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:18:54 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74895C06174A;
        Thu, 18 Mar 2021 16:18:53 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id bx7so8665006edb.12;
        Thu, 18 Mar 2021 16:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BoPB1I5VAmz/hSI4Hj78DSWtK0yGZqBJXSIT+fwOvzo=;
        b=MfSpmTuBI+7w1tsOV6d3xoTNTtzNYJg4YArpSAbO1e+zXzOg8gnQIMw2h8lccN4lFR
         Q4OPKE+CLLqfddEzNTQnZ9bdDo5cynUf2zkh2TMFAoiRpomBalU7vCEmPOOVyID9TXXk
         jywIbepAjXwT7JagdMu/aIdszMmrC/P+UWsJmm1Py4aSzQNoZOXQPG0NeyRO7cyvdKkz
         KokQ3G5JOxWCx+XRxhTnWIDNWkiFtAuDVMgiq/HsSmM3zCr76tauSD90lqRii0/venmE
         8Cfd1qlFaE3jp0l137jA4tjQHVQwH+uwL7F9QL8icwpx+eeBHjdxe4e5v4rDnudb95xC
         aS/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BoPB1I5VAmz/hSI4Hj78DSWtK0yGZqBJXSIT+fwOvzo=;
        b=acMe4x/6kBGsywwr2eAO8KZyrwS8gJcOLhq8JE9njNyjsu/71p3tri8FESGY//4dcx
         Bk1ZobG3eakVesYRsG4JH/AHm0Io043TSaqrcat7LvtBGAIS6hAqZkhmKfOwcQT0TCPj
         ScWFPr4Ei1u8U60LY5AmtCJN3C4qAGgYLL3D69LRGc59jhAUE7GQ6+Hb1tQffgH7huAk
         YLdRrOJnz4+hOC6KMdN4gBk0O5FMeYE7SCSZClFktuHjAF8vBwSTr0hrSkdBbNOxgrbo
         tWLOMB30XKCTaVDZRvle0S6nDV06Hu76uCoXzU1q7xUeSrpdorCyP9y19Z4cOjihwOTC
         nxwQ==
X-Gm-Message-State: AOAM533/A/J86q6OFIYvAJNfovBpJWQRmX/OTHfZO2L7H90h1rA4yurI
        xZ9PW2K0ih2xbMUwI/mYxec=
X-Google-Smtp-Source: ABdhPJyFZymuHLpxE3VhQ7TuWbagrLQEX6ygSW2Zi1n2IV5vZyXa0sHx6g0yKfAeNzvx1RJi972H8A==
X-Received: by 2002:a50:cdd1:: with SMTP id h17mr6526349edj.178.1616109532268;
        Thu, 18 Mar 2021 16:18:52 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 06/16] net: dsa: sync multicast router state when joining the bridge
Date:   Fri, 19 Mar 2021 01:18:19 +0200
Message-Id: <20210318231829.3892920-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Make sure that the multicast router setting of the bridge is picked up
correctly by DSA when joining, regardless of whether there are
sandwiched interfaces or not. The SWITCHDEV_ATTR_ID_BRIDGE_MROUTER port
attribute is only emitted from br_mc_router_state_change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index ac1afe182c3b..8380509ee47c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -189,6 +189,10 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	err = dsa_port_mrouter(dp->cpu_dp, br_multicast_router(br), extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
@@ -212,6 +216,12 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 
 	/* VLAN filtering is handled by dsa_switch_bridge_leave */
+
+	/* Some drivers treat the notification for having a local multicast
+	 * router by allowing multicast to be flooded to the CPU, so we should
+	 * allow this in standalone mode too.
+	 */
+	dsa_port_mrouter(dp->cpu_dp, true, NULL);
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
-- 
2.25.1

