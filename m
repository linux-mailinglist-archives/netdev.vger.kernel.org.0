Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDB23C3B65
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 11:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhGKKAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 06:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGKKAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 06:00:50 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6406C0613E5
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 02:58:03 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u8-20020a7bcb080000b02901e44e9caa2aso9247455wmj.4
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 02:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pLzFV9bVvdr4KYBirs5X2mj4DUo8QQJaXp8K6ahEWRc=;
        b=Y2HnxZE9uISH43M340AOZ5mIqJD9tWGUhE68UhwL5YsyErc23G25PBlgG2ZDFdrqO+
         zQvXelHcRrwzaMKgoRQTYrOe/Zbgc5xWWOtjitlCxiVXQTV9mR9PhLvkpznLLte/hZ7t
         aGeMcAUvRjXnP552wFKcFI4hkyoR/0AicsmPs4nOLZ9mSwlI8OPWp+AQroaSDaeTsr9c
         QmzPBqHQYahnIyxUPKKtM8P1EnhXJEeR5smsWWbJvKBaPRn2Yd+3zowbFIgc47bwfPsa
         8DT8b94QLKevyQvHkav+/nUKuiSUzdYlv7mheI2AR1VpagAnnBmzGSvDp127ZRq4oHrM
         +d6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pLzFV9bVvdr4KYBirs5X2mj4DUo8QQJaXp8K6ahEWRc=;
        b=hX59ImxVRPLBYmBHCw4rIZrKZLg2kFWgY+65b3Z6anqMi3MZcrLTumTKVrjdVDG2LO
         Q4p7o/PDiRkx4kwvxU7dxbNKnChXEakn+EVUlPjn4yO9PKm8NKSzgwUJqdON/zbT2gfB
         czOSdoHPLtwLfvTR2rJLjXLwc2y5sW2mjktU228uZQF7tL3Lfn94PDaA3v6yBij3Hy/T
         6nMpU6wcrTQ23wOv3FjmsIYxxy5ASLZcfKjQeDO8EF3u8fx3gZF5JldgXyrerCdmZ+Tk
         22p3MzQ1CBP2IzfQ/1e6rk36sh9jh2KIfR7VJY4uphr7zSln5A9eA2lcvxC3ZL65Qbst
         v0/Q==
X-Gm-Message-State: AOAM533KRdj3hmyVHfcVobkcLVc7dA1Ia5MjZPBZ1GME8yJmxEEE66k3
        h9iLHgBo21HG0nDr2qeQyfy6a3xMivFSywcSVcQ=
X-Google-Smtp-Source: ABdhPJyalwUZFSHhyZ4Lc8XVzGNjSWk8JzjA5IhRBFMi881bU4Pz4wujoBnDe/4bLHXjEUJ+Jcs3rQ==
X-Received: by 2002:a1c:7308:: with SMTP id d8mr19627179wmb.20.1625997482179;
        Sun, 11 Jul 2021 02:58:02 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m18sm9095567wmq.45.2021.07.11.02.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 02:58:01 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 1/2] net: bridge: multicast: fix PIM hello router port marking race
Date:   Sun, 11 Jul 2021 12:56:28 +0300
Message-Id: <20210711095629.2986949-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210711095629.2986949-1-razor@blackwall.org>
References: <20210711095629.2986949-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When a PIM hello packet is received on a bridge port with multicast
snooping enabled, we mark it as a router port automatically, that
includes adding that port the router port list. The multicast lock
protects that list, but it is not acquired in the PIM message case
leading to a race condition, we need to take it to fix the race.

Cc: stable@vger.kernel.org
Fixes: 91b02d3d133b ("bridge: mcast: add router port on PIM hello message")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 53c3a9d80d9c..3bbbc6d7b7c3 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3264,7 +3264,9 @@ static void br_multicast_pim(struct net_bridge *br,
 	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_ip4_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
-- 
2.31.1

