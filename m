Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2397C3C3B69
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 11:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhGKKAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 06:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhGKKAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 06:00:51 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4E9C0613E5
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 02:58:04 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n33so9195674wms.1
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 02:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m+ppdXaepSm57DIGWDBCLlBbyDz4JtRjsnYacqgtWjM=;
        b=fnQhTuQfvikn8wsBlfQW8wa3TbTUdvL0BRKK1SsYvIwdDSwNo5zRHUXHIZiOrK1j0E
         DyOKpo7teKbeuC/1PSB5SYfWmdurOnmS2ML5Z3ywee1IsWq5zt134nq8CTF6o2Wpgagk
         vECivnNM30xVlMiDEndXTNjjyh24f6Uzcd5NrEZJRcUg4/anj/GxVspV+dI7IWBqik86
         utcc1VgQn9CSpmE3l212ly279r+QKBnk+8jfqmMAgn+bx31+Mus5OX/xNlcarV+grdl5
         Q+InIy7uEBcuh9LioRmh5VeBkXK1vglUBKECuZ3uu5JdQ8W2jW1QLLuft4wHStY4mr7Y
         b+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+ppdXaepSm57DIGWDBCLlBbyDz4JtRjsnYacqgtWjM=;
        b=JKFOBK0KbJ8RrfcExfZdYsLONYHC+0VVLCrbkRB4hM2/m+zRVcD72+Av4P54ZHctgB
         ONZC9QyjvQFI3BH4HCJKi8O5iy0mXZ5khipr6Y/TooayRAExD1y8b1oowadnzvHWqwdr
         bAjfS/K//py4WwbuIADv7if9djk/RAwP+fFac7Cw8U9M4QgljXvnaHkbxtmahzEN16eN
         RCTj3JzBBGVKNLpLeFLLTWzov2Ss9QSEhVkRfE8k9Gtuc6aYkkDPMispPKWnf1t8bQt5
         n7iCefvGQQ7DzP6/A5BrgrY5mPrzJuxWX550gnIZitkGHdLIxfincqegBukbgfLrgcuV
         e08g==
X-Gm-Message-State: AOAM531zCWwU/S/2Lhzop3OtI9OY3+CWSAPahvOuLgIigz+7zFewpak3
        Ivszlc3nTMlzbvLRIh9h3G1SKVBb1jP96oPK+bw=
X-Google-Smtp-Source: ABdhPJxMh5N/ZT1NO0GnZgOu0FK2DLpUQFpXk8FKrgs6M75XgwrtwyhH5hhkTruYNbSlG7vuXVK94A==
X-Received: by 2002:a1c:7314:: with SMTP id d20mr48433637wmb.167.1625997483257;
        Sun, 11 Jul 2021 02:58:03 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m18sm9095567wmq.45.2021.07.11.02.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 02:58:02 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        linus.luessing@c0d3.blue
Subject: [PATCH net 2/2] net: bridge: multicast: fix MRD advertisement router port marking race
Date:   Sun, 11 Jul 2021 12:56:29 +0300
Message-Id: <20210711095629.2986949-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210711095629.2986949-1-razor@blackwall.org>
References: <20210711095629.2986949-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When an MRD advertisement is received on a bridge port with multicast
snooping enabled, we mark it as a router port automatically, that
includes adding that port to the router port list. The multicast lock
protects that list, but it is not acquired in the MRD advertisement case
leading to a race condition, we need to take it to fix the race.

Cc: stable@vger.kernel.org
Cc: linus.luessing@c0d3.blue
Fixes: 4b3087c7e37f ("bridge: Snoop Multicast Router Advertisements")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3bbbc6d7b7c3..d0434dc8c03b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3277,7 +3277,9 @@ static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
 	    igmp_hdr(skb)->type != IGMP_MRDISC_ADV)
 		return -ENOMSG;
 
+	spin_lock(&br->multicast_lock);
 	br_ip4_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 
 	return 0;
 }
@@ -3345,7 +3347,9 @@ static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_ip6_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv6_rcv(struct net_bridge *br,
-- 
2.31.1

