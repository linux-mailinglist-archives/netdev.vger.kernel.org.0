Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEFD2FD461
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390906AbhATPmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390064AbhATOzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:55:22 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCECC06179B
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:13 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ox12so9599555ejb.2
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xs9gPZTNfwtouWL9L4Nwr/WiYcl05VUqiVfBi+fW7JY=;
        b=G2//UHT/o2c5Z0+ywqgYEJtbnhHs25pOiB5Hi603BHS9wXvsRRDCgkJiKUxbQ0KJDO
         e1Yndcf9jirckWBmIvpPn0gHoyqQB22I4w1kw1kZuePA9nf2fbkR+Ktb0FVFdfLnhunp
         nZmMBKaFi7SwtLDb3fPiIISvtcC1deEyhBZvO9LDTqJhPmQRyugqN6QNg1KRHRhZWegI
         lM3JM3qOesjLASCsNv8loWGV81f8X3jD7lS1lKDPmfvx97Y8lEpIMJ4a/oYOVHqm5SPT
         PqLYo01xDXT1OIuY0lwjOpGVWTYcvho3K2apPsSHaEnG+/fBQNZt9q+qUcmw0XOE2vgv
         Ba5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xs9gPZTNfwtouWL9L4Nwr/WiYcl05VUqiVfBi+fW7JY=;
        b=MNGOmWkdE/SO7Oc3Wbl4KrSaKNEsPG8XC0yO9Luk2hEyl0pr44KD8w9h1WHbxhoEiF
         Px6o9bqR1n3yBWNhFMsS/vzs1EUanV3F/I0nbmKO0jTXIWBrjVMQoiS3lcT/qWi1QrW/
         8pdb6zeKy5PQ8zITzdwQ5LifIjgiQr43whYiLJT8e2Azor+65hJqqF9rc7k+x9bYPVLx
         7xLCjutPIOm2qAcDNBhYgXLO8Q3b5+OHkPWZ+xo37NsGJVJxLHaAYsMp3+qkOMqMNaPw
         pMtlvjUd2fa8Rbq1JYDDcd6p5xI5l1f0+OVfmwuMrdOEXCiXzXhhincAj/2x5CpLSt3F
         kyqw==
X-Gm-Message-State: AOAM533RvVcYvQzc88DQm9IzIjien7WDQaWIEyKZpLnNAameQws3H9xF
        iU1SlN7KsElri/z6fTWB1EoZkdrQzgIMm39piw0=
X-Google-Smtp-Source: ABdhPJxYWtI/+xhWcQjLakBo7f1LtDsY3rbEJ8g1rI5gFBMRGuitDHC2HKAAblIe6Z0ZrC9CexNYUw==
X-Received: by 2002:a17:907:7292:: with SMTP id dt18mr6658252ejc.317.1611154391937;
        Wed, 20 Jan 2021 06:53:11 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:11 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 08/14] net: bridge: multicast: add EHT host delete function
Date:   Wed, 20 Jan 2021 16:51:57 +0200
Message-Id: <20210120145203.1109140-9-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Now that we can delete set entries, we can use that to remove EHT hosts.
Since the group's host set entries exist only when there are related
source set entries we just have to flush all source set entries
joined by the host set entry and it will be automatically removed.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast_eht.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index f4bbf2dc9fc8..409fced7eae2 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -434,3 +434,20 @@ static bool br_multicast_del_eht_set_entry(struct net_bridge_port_group *pg,
 out:
 	return set_deleted;
 }
+
+static void br_multicast_del_eht_host(struct net_bridge_port_group *pg,
+				      union net_bridge_eht_addr *h_addr)
+{
+	struct net_bridge_group_eht_set_entry *set_h;
+	struct net_bridge_group_eht_host *eht_host;
+	struct hlist_node *tmp;
+
+	eht_host = br_multicast_eht_host_lookup(pg, h_addr);
+	if (!eht_host)
+		return;
+
+	hlist_for_each_entry_safe(set_h, tmp, &eht_host->set_entries, host_list)
+		br_multicast_del_eht_set_entry(set_h->eht_set->pg,
+					       &set_h->eht_set->src_addr,
+					       &set_h->h_addr);
+}
-- 
2.29.2

