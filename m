Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981F52F8A6F
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbhAPB0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbhAPB0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:26:32 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678B9C061794
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:52 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id f11so12325731ljm.8
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=2xklk+27VAAFpVpQgpop1ZiuvGBkQ/u8wQJHoD1ON9U=;
        b=1euKXar5RHqzp2K5q4LATijjO+bJkp7TqSoAlb2DoA/oP/S1NP5kMUw5y7O441F5fP
         ofdcyhMzhW6p3nom3IWSmRGH+TDuuEtGr7fTS8Pm+3I9620WkZpO8Jmq5YlxRk8bDDww
         gnRpG0QIGd9TeVAVfHF544eowOxZ6/yCksMaw9fKmFeAA6TkbjmKjv11uoqYNZgxKrAC
         eFLd1kDZ5gjBOfR+aJPmK/QGZtnb4r/9B4GJ05wMryxZTZZehpwVQiys/MZhfGvVvmkd
         dS3ZoMFxO/G17dK0eNPP/3XYksDQ21GZat/9uyPe6m8iY6X0g9hw4BNBV7KLQIDJyQS3
         v1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=2xklk+27VAAFpVpQgpop1ZiuvGBkQ/u8wQJHoD1ON9U=;
        b=D9gGPHFJGEZ8oIIF4yn29Vu6tasRXpeqSAODyP1RMMkESlqhTv8XlKKBF2ZwPxmH9T
         icnWgXMM/U7IkP9WvBp0gm0Ci8uSAMlej2iaJAhM9UnCoitlXmPNdmZHwyUgCTKaQ2ht
         9D4hIYo+bz2prcqBL5kS36+tmm3qEYAL8+jlIimIBkGQOZwhwms6mbyOr+Iw6hRLBns5
         0lNIDbBsZfEKQRt+4aImzADlWXitKYfQSsrvWB/BwWeQrTWqwMfm7iatVzBSeQk8FtLj
         qjKRq3d4FqIaCkaNL/DuJN8Pcwwj8m9KV+9m1+IOqdECwAx17IA6KHXN+ZDZiJ/Sku8y
         VJpQ==
X-Gm-Message-State: AOAM533u4WjOZ6kAk6sScsoNQyzhzfcdNzW6Uycbq/EBfb6Bft/hh3J5
        ewcByV4BaG0FMSiDK4KDjWd3Zw==
X-Google-Smtp-Source: ABdhPJwF0zl66EmQ37uEkXc0LBNwp6N71nHZbIVEn71igezqOhtyIKPAl1eabZSwP/bnoq656P5RAA==
X-Received: by 2002:a2e:8557:: with SMTP id u23mr6259825ljj.287.1610760349961;
        Fri, 15 Jan 2021 17:25:49 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 198sm1085686lfn.51.2021.01.15.17.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:25:49 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org
Subject: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in FDB notifications
Date:   Sat, 16 Jan 2021 02:25:10 +0100
Message-Id: <20210116012515.3152-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210116012515.3152-1-tobias@waldekranz.com>
References: <20210116012515.3152-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some switchdev drivers, notably DSA, ignore all dynamically learned
address notifications (!added_by_user) as these are autonomously added
by the switch. Previously, such a notification was indistinguishable
from a local address notification. Include a local bit in the
notification so that the two classes can be discriminated.

This allows DSA-like devices to add local addresses to the hardware
FDB (with the CPU as the destination), thereby avoiding flows towards
the CPU being flooded by the switch as unknown unicast.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/switchdev.h   | 1 +
 net/bridge/br_switchdev.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 88fcac140966..43e4469a17b1 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -213,6 +213,7 @@ struct switchdev_notifier_fdb_info {
 	const unsigned char *addr;
 	u16 vid;
 	u8 added_by_user:1,
+	   local:1,
 	   offloaded:1;
 };
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index ff470add8e52..1090bb3d4ee0 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -109,6 +109,7 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		.addr = fdb->key.addr.addr,
 		.vid = fdb->key.vlan_id,
 		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
+		.local = test_bit(BR_FDB_LOCAL, &fdb->flags),
 		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
 	};
 
-- 
2.17.1

