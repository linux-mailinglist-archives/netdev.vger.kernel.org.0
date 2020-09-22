Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850B5273BF9
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgIVHbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbgIVHbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:31:06 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73899C0613D4
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:31:04 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z1so15860754wrt.3
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W1k28u9m4opk3xAHXu3X6yCLygcG5WtwBqkfTVt8j0k=;
        b=s9xvwnpLYKziLVje8layNgsWzTmHghpgOKGAuVpY0nYqifWkhA2S/38GBI8rA9lvcV
         MJcn96SX/NMiA1GvU6ZD43H4if4podo4q7cw/FK+lowH1jY430SAtElKNKhmNEH6pvym
         vT3nbiNKWmc8VFUBfH3ENZRtT4qS83X4ppmxSSMnPO648B6+vNhA16CcG7uqCe/welMI
         FQBH1cw+cgRI8Mbrnq4xvkxopWt92zpj9p3f4QYIUN3MS/aCoi6hqDpvELazqBOpnz/Q
         TfgN31O/EOLpnyfgBk6FTrho031IdPXXC8avTp33EsIaNg4zOTC0uYCZFL230Q8gsw4w
         nreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W1k28u9m4opk3xAHXu3X6yCLygcG5WtwBqkfTVt8j0k=;
        b=EykClSuwLcz2EXDH51HcnTd4rZPMlkcv2QM+Gi901odZRbrMp9nXzTxSajCSvzQPBp
         zK6qWdD9fQuSNZ1+cdGR46PzBbM/KsdpypG87B6dicRS66p5wrfAXS3x6YmHBiAn9XAz
         uVz7CETKx7MHUYTFlNp4sfDrMGuv/4I4enVz+JCgxP/ISu71Q/TLdcnEB02037LskhSZ
         Q6b0CKpUi9CYAxPsQBqeNr6JvXoojdoAOhPLsfOmPszErFsusq8PQxiUUjr9ruEw2j9c
         3FzV7nrlGNhNmLV3IimeSyCWovMuDekkh3lJwAUA6Ut6XfU+p3mE5svbOmJ5MBzZlT98
         sGgw==
X-Gm-Message-State: AOAM532J2T6a+svjgAC6CyI9OpbV+9qM0tf4xIh6AuPs3ngiNJ7J4EWI
        5WHqN2KmQha2EGvfsOz6ARcqHFLcMufl02x+Rel1iQ==
X-Google-Smtp-Source: ABdhPJwQasZoL1zEzof8NC/3GMPS683hdZgAhUNkQh8NFAj6S2FHzuYBiBeXdl+mAJ088YTLbXMILA==
X-Received: by 2002:a05:6000:83:: with SMTP id m3mr3678354wrx.165.1600759862814;
        Tue, 22 Sep 2020 00:31:02 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s26sm3258287wmh.44.2020.09.22.00.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 00:31:02 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 16/16] net: bridge: mcast: when forwarding handle filter mode and blocked flag
Date:   Tue, 22 Sep 2020 10:30:27 +0300
Message-Id: <20200922073027.1196992-17-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200922073027.1196992-1-razor@blackwall.org>
References: <20200922073027.1196992-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need to avoid forwarding to ports in MCAST_INCLUDE filter mode when the
mdst entry is a *,G or when the port has the blocked flag.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_forward.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 4d12999e4576..e28ffadd1371 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -274,10 +274,19 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_port *prev = NULL;
 	struct net_bridge_port_group *p;
+	bool allow_mode_include = true;
 	struct hlist_node *rp;
 
 	rp = rcu_dereference(hlist_first_rcu(&br->router_list));
-	p = mdst ? rcu_dereference(mdst->ports) : NULL;
+	if (mdst) {
+		p = rcu_dereference(mdst->ports);
+		if (br_multicast_should_handle_mode(br, mdst->addr.proto) &&
+		    br_multicast_is_star_g(&mdst->addr))
+			allow_mode_include = false;
+	} else {
+		p = NULL;
+	}
+
 	while (p || rp) {
 		struct net_bridge_port *port, *lport, *rport;
 
@@ -292,6 +301,10 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 						   local_orig);
 				goto delivered;
 			}
+			if ((!allow_mode_include &&
+			     p->filter_mode == MCAST_INCLUDE) ||
+			    (p->flags & MDB_PG_FLAGS_BLOCKED))
+				goto delivered;
 		} else {
 			port = rport;
 		}
-- 
2.25.4

