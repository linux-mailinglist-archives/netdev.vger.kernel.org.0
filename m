Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567563B53A4
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhF0ONJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbhF0ONB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:13:01 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9BCC061768
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:36 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s15so21168975edt.13
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r/q9TNcG0vBQwziqLjQHLZZKEegjoonhtgdvGDYDkWc=;
        b=HN9LiGuja8GW2RCwZEctAy4g5X/xAdNw570oDG/L9ab2lPlK1Yix6gSVXdebQ6EB5y
         0ZWch9qymI0MY/qFPJCuCkcj4HLSmJTlvaqMHDqvSn3sF0gFNoRQdRtX0KDsaIYgAV5B
         BtNt+bCv2E7XNwgmEpEevd0ja3QInluxWRoSrrJlhmmaWbp1ZL+WPlZO3rlWeAOjDoSY
         zs4jmKMl7fKkiO8GHhJ4RqxUzs2rdM4zc5Gom3cYWXG7v8spsG7OKkZTjbam7fyTFaIC
         xKgCA6IqdyBn8UtfPT7CVa5/1Ygxa/6h7EoZ9jPeRKYSP4Je0ShZQDl6ITvR/X7EC3m9
         BsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r/q9TNcG0vBQwziqLjQHLZZKEegjoonhtgdvGDYDkWc=;
        b=U4SGKDGoyyT7/74z6Nh0XiotsCCjcj0Ay//ZI8K96+TVQJbY4OLY4cEhY6xpso0ZIj
         tPfX+03gLi7ubqjCZsInUpjILYIx+NSien6yYHFCs394KIkc6V1dmPOslIFEhdFp2JHJ
         ZQCK2bAwg8M4QZyTVD+A1v9JW1O1U0LHlij9/YwO8/vQXO/ZMlvmo0ZCp9ZQ+F1ktiuE
         jTrIttUuMh++/W0WPk3wg9vhlSPbZnUtTXEq4Z9dshcDl5pW7EwKL+s+BRJA9/VvxeKG
         zSdPWxejVghrSi/Vlb8urj9UYUmMpSgPJXsDkpeyfccmmlDZsxtWIeffVh2Jd0MOYFJs
         wCaQ==
X-Gm-Message-State: AOAM531npqE+qAyhpLsJFdnQGzcEbPCTLYakWZVaMiQiEdUONEY5anhi
        61WYNqpB2hIj905uLZJkQI4hc0NdvAo=
X-Google-Smtp-Source: ABdhPJw46GS09Z7VanIJ3mq8gRTmjL1XurmwW/M0UpAq3FJ4SYj/tut/jEqWZJ2IBIBBv4Em5V3GUg==
X-Received: by 2002:a05:6402:1d11:: with SMTP id dg17mr27944116edb.30.1624803034993;
        Sun, 27 Jun 2021 07:10:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v3 net-next 12/15] net: dsa: include bridge addresses which are local in the host fdb list
Date:   Sun, 27 Jun 2021 17:10:10 +0300
Message-Id: <20210627141013.1273942-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

The bridge automatically creates local (not forwarded) fdb entries
pointing towards physical ports with their interface MAC addresses.
For switchdev, the significance of these fdb entries is the exact
opposite of that of non-local entries: instead of sending these frame
outwards, we must send them inwards (towards the host).

NOTE: The bridge's own MAC address is also "local". If that address is
not shared with any port, the bridge's MAC is not be added by this
functionality - but the following commit takes care of that case.

NOTE 2: We mark these addresses as host-filtered regardless of the value
of ds->assisted_learning_on_cpu_port. This is because, as opposed to the
speculative logic done for dynamic address learning on foreign
interfaces, the local FDB entries are rather fixed, so there isn't any
risk of them migrating from one bridge port to another.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ea9a7c1ce83e..d006bd04f84a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2398,10 +2398,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		fdb_info = ptr;
 
 		if (dsa_slave_dev_check(dev)) {
-			if (!fdb_info->added_by_user || fdb_info->is_local)
-				return NOTIFY_OK;
-
 			dp = dsa_slave_to_port(dev);
+
+			if (fdb_info->is_local)
+				host_addr = true;
+			else if (!fdb_info->added_by_user)
+				return NOTIFY_OK;
 		} else {
 			/* Snoop addresses added to foreign interfaces
 			 * bridged with us, or the bridge
@@ -2425,9 +2427,15 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				return NOTIFY_DONE;
 
 			dp = p->dp;
-			host_addr = true;
+			host_addr = fdb_info->is_local;
 
-			if (!fdb_info->added_by_user &&
+			/* FDB entries learned by the software bridge should
+			 * be installed as host addresses only if the driver
+			 * requests assisted learning.
+			 * On the other hand, FDB entries for local termination
+			 * should always be installed.
+			 */
+			if (!fdb_info->added_by_user && !fdb_info->is_local &&
 			    !dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
 
-- 
2.25.1

