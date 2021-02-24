Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D4B323B71
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbhBXLrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbhBXLpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:45:30 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8194C0617AA
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:13 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id u20so2517456ejb.7
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m0fpouldJeND9lqkQ7yYVxufj/CE6mHLIjl16R1I05k=;
        b=LUcjNezqDKxSUESHF2E/d4ky7Q2fQFgcafUAaEnSCnilwTESpokIOWphmZaseFwgPy
         WjGGxGSIaLYXGeKD8gRHKE8epbysUvOOn7d2wCtDoIVThsSEw1G/xWGZoSZinlyelvlr
         Qkoleyb6RefnrPV5q65H71a3TT68iTHWi+7ZhTSDk2GpXa+FWm2XEpiO0bvmbcvkdS1O
         lpLIECv8ZNBJYsoXQ7T3cqAPLOyZVHx2zr5tfc8COtKs3GGJljCwJKDe6Io4wUS50JFQ
         1ZwSasfcUUNkKWNJ+FPvviasn09goN80mfmMWDxL6iAwb2dNRKjqqWgzTrb6zxMtDn7i
         ILlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m0fpouldJeND9lqkQ7yYVxufj/CE6mHLIjl16R1I05k=;
        b=YX/kMkBg/umdzF+msXHJ93njp/lCMYoq8+fX8WbCK8q+MIMzDoqOAG4kO2oi7X/4wU
         NsyezECvO5Nd077Uej58nQj4BT7A9GFJ7pJ4VCsicSELFDdfGjAIKkToChd4XD9TtXpI
         ghAZmzjuhsx0fvAH1YmSf6KTWWfbLmcJ7aZk2gya2XZOHDRz7JcQaDrAf1hEoQfHUIVm
         F98SSmhuSSsxiVf5liSRtio4aLsJSYXKGOwstWYJt9Zsm2WGmp+/IIvqxsig/etYdSo/
         WZRwd7Zz0WeDSj9ayv9fAA34bAOpAOfX6XzcDBDCNw7Rxbp/2vBdBg5B+kL8/VSfK8sM
         Ksrg==
X-Gm-Message-State: AOAM532d87x3C4J5ofg97gQZZeM6LdEJ/Px6xNAPiJKCIcl3KY3+DnG9
        aQX0OaAger0uuCAspWd92VLzfs2PmJY=
X-Google-Smtp-Source: ABdhPJzt/TKsw75cO8Ibfs4kNuMHWepHCS5/Y7GBg91qaT4Jvgo2RBXMEb0xT15WYrVS2GFWjazb6Q==
X-Received: by 2002:a17:906:511:: with SMTP id j17mr19100579eja.143.1614167052191;
        Wed, 24 Feb 2021 03:44:12 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 10/17] net: dsa: include bridge addresses which are local in the host fdb list
Date:   Wed, 24 Feb 2021 13:43:43 +0200
Message-Id: <20210224114350.2791260-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
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
 net/dsa/slave.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c4db870b48e5..8d4cd27cc79f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2549,10 +2549,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
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
 			/* Snoop addresses learnt on foreign interfaces
 			 * bridged with us, for switches that don't
-- 
2.25.1

