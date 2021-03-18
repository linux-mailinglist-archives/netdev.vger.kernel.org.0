Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1BB3407AB
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhCROQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhCROQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:19 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53468C06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:19 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m17so4833872lfg.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=QZ+BmjWfdM0TaLrjQBL3VVczhh71klPVNAd/B6Z/d/E=;
        b=gKg87iw5euuHYFfZPzktTVbW0SbOwNwJzt22HScVEopfckkDpPddTCQMM0mQq8zqi+
         CFpXI3CrfNPb4k1gV7wXgFd8mSR0RaNUvN6yILKeppFMEfFVPQyUpX4zSNpbX2bDjXte
         kLuJYVfhOdOHMG/Ily/sJ2VeX4Eh6tj6r4RzJBzt5XXnbu6IL8T2d07C2g/fL4EXWByF
         0QNY+nJ9GmHUlgEl8hMI4vD0l1Rtb11kWI34tyQTX9GwCywsDnb3QLs+otkDGgnzXcS+
         q1XpKllBfiZaRIYOTHw02dP7Q3GqnkHQn9zOotARMD+nJFD6V9SIsv+/dgX738ltw9Qj
         r+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=QZ+BmjWfdM0TaLrjQBL3VVczhh71klPVNAd/B6Z/d/E=;
        b=gW59SvOFLZNgVqjBkx4azp/sZEV6Za/10HZvEWFX9ZBEOH9wTV+r9fQiKOWOovenUa
         P3SYLW8XEmKQ1HyjYuVP5YEzzEZ5eRbeGeVQ8LdWGlJZMrQj2xe6za69+0R6P0iS4ha9
         YwrNvEbl4ErpiNvIXIwnZGpUfkjZUl/n+70DQMoaKIcQ4zXzwNWFAOvBhyATU/tFb7xc
         EWVlIzz6fMYp1mz4Xa0dMOMIvA0reJfd1qkvV1RsO8LG1WDY+Fnu1YFoIpDPP9p1ToPu
         ysU3X83AbgHNBXnmuOfE6F9rOybyUyuSY37fq3fOKOxIIDCMZ0s7MVJO8CnefOJ3kD/7
         7Pwg==
X-Gm-Message-State: AOAM533uASKQiFO7SP0XOUSemRx83Li24yamMaTaIf3hHOzTjvp3UwXM
        GvwKDEixsn/+ox2runyAvpNbLQ==
X-Google-Smtp-Source: ABdhPJzSIAuiJCLen/D7VIMJpnJA3GzauNfZQmF9Bpa29iX25EOOfj68bTtHUTuk6NtnJ7+H8+3kuA==
X-Received: by 2002:a05:6512:6c4:: with SMTP id u4mr5378868lff.289.1616076976344;
        Thu, 18 Mar 2021 07:16:16 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w26sm237382lfr.186.2021.03.18.07.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:16:15 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 6/8] net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
Date:   Thu, 18 Mar 2021 15:15:48 +0100
Message-Id: <20210318141550.646383-7-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318141550.646383-1-tobias@waldekranz.com>
References: <20210318141550.646383-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In accordance with the comment in dsa_port_bridge_leave, standalone
ports shall be configured to flood all types of traffic. This change
aligns the mv88e6xxx driver with that policy.

Previously a standalone port would initially not egress any unknown
traffic, but after joining and then leaving a bridge, it would.

This does not matter that much since we only ever send FROM_CPUs on
standalone ports, but it seems prudent to make sure that the initial
values match those that are applied after a bridging/unbridging cycle.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 17578f774683..587959b78c7f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2489,19 +2489,15 @@ static int mv88e6xxx_setup_message_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 {
-	struct dsa_switch *ds = chip->ds;
-	bool flood;
 	int err;
 
-	/* Upstream ports flood frames with unknown unicast or multicast DA */
-	flood = dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port);
 	if (chip->info->ops->port_set_ucast_flood) {
-		err = chip->info->ops->port_set_ucast_flood(chip, port, flood);
+		err = chip->info->ops->port_set_ucast_flood(chip, port, true);
 		if (err)
 			return err;
 	}
 	if (chip->info->ops->port_set_mcast_flood) {
-		err = chip->info->ops->port_set_mcast_flood(chip, port, flood);
+		err = chip->info->ops->port_set_mcast_flood(chip, port, true);
 		if (err)
 			return err;
 	}
-- 
2.25.1

