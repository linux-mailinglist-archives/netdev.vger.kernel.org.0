Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CD53E58C1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239983AbhHJLAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbhHJLAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:00:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D60BC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 04:00:22 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x14so7065034edr.12
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 04:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pl+AN+3T8L0wo4+egXAtjgAHIcgLN6DYu3BvZ5GYJfs=;
        b=ViSavQ26cd7UQHMH2Wet6fh3f1SwkvVoGnaHhGjvuSwYQ0sffku+Y/11xRJwCsqvyH
         AlAYGn+uICS7sWr2/Zvzhn+mxMCS0V3pkpaWXSjsNKtlKGzRme4sjmVKqJ14TUYpikXK
         LyXcFHtiAq7IRZkegArs5l/TR19yXYt33TLNTVk5fL9sEPuwNqInd1a4b+k+YvsjHWjH
         ZY2QNjx5KrVu2L2wqdFtKAFxM77/HYIdgvP7LdXX6oWg9V787kMbbeW3oPVBu9K54FWE
         jokMHAjXohvuze9mon5R6aV/UR4QblfykETzPLLqH0TmiYiRXqSjPt3vLRnUI3GJwVnL
         buxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pl+AN+3T8L0wo4+egXAtjgAHIcgLN6DYu3BvZ5GYJfs=;
        b=rg/HFRM132mMO1VF3tfLCz6R+o/GsPtj+ySYOo8gcDaIXFvk9lZAWpsjQXXMpipqbW
         5QXdcmDLcPl4McAmOg/S+Sq9HX4sufwB0o7GZ3Ml7zFYxHvJpcE/Pk3VqM9n8CrEnmlQ
         FRr0uGcYadToo+4ha285en1wQowiXWLQUzQfZmSgJKmFocZrXoTYQnokZ9E4YPhrYeVT
         L65wRvXq2iIAnC6W+r/ZtddLBdeaIHZUJXx7lmfFwZi/eeiD/E2lp5OR+kezfSV3/7K6
         mQZ8zxbJxUoEOc0mX5pRROZuHJN/R+naVmYFgV0yRiaFnklnMpvW2xhBk1djfjHtvluh
         YTYQ==
X-Gm-Message-State: AOAM530qmkWoguEuPROoIO5+ZNsJroQkAFsvZJTivSp5IzBef1CNy8Ne
        CPfrkf10w2cq8Fp/IpBqmzeJA64Q4eBELFPu
X-Google-Smtp-Source: ABdhPJzYffhzudO2oNgrTYCjAlKXGP/Vujv3U2IlKGoHEajfzCIOjQF6wMtyaXQz9nM31fd2sePiog==
X-Received: by 2002:a05:6402:b99:: with SMTP id cf25mr4224044edb.130.1628593220487;
        Tue, 10 Aug 2021 04:00:20 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id gl2sm62946ejb.110.2021.08.10.04.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 04:00:20 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, vladimir.oltean@nxp.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net v2] net: bridge: fix flags interpretation for extern learn fdb entries
Date:   Tue, 10 Aug 2021 14:00:10 +0300
Message-Id: <20210810110010.43859-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810072139.1597621-1-razor@blackwall.org>
References: <20210810072139.1597621-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Ignore fdb flags when adding port extern learn entries and always set
BR_FDB_LOCAL flag when adding bridge extern learn entries. This is
closest to the behaviour we had before and avoids breaking any use cases
which were allowed.

This patch fixes iproute2 calls which assume NUD_PERMANENT and were
allowed before, example:
$ bridge fdb add 00:11:22:33:44:55 dev swp1 extern_learn

Extern learn entries are allowed to roam, but do not expire, so static
or dynamic flags make no sense for them.

Also add a comment for future reference.

Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entries from user-space")
Fixes: 0541a6293298 ("net: bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: add a comment as suggested, no functional changes

 include/uapi/linux/neighbour.h |  7 +++++--
 net/bridge/br.c                |  3 +--
 net/bridge/br_fdb.c            | 11 ++++-------
 net/bridge/br_private.h        |  2 +-
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index dc8b72201f6c..00a60695fa53 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -66,8 +66,11 @@ enum {
 #define NUD_NONE	0x00
 
 /* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change
-   and make no address resolution or NUD.
-   NUD_PERMANENT also cannot be deleted by garbage collectors.
+ * and make no address resolution or NUD.
+ * NUD_PERMANENT also cannot be deleted by garbage collectors.
+ * When NTF_EXT_LEARNED is set for a bridge fdb entry the different cache entry
+ * states don't make sense and thus are ignored. Such entries don't age and
+ * can roam.
  */
 
 struct nda_cacheinfo {
diff --git a/net/bridge/br.c b/net/bridge/br.c
index bbab9984f24e..ef743f94254d 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,8 +166,7 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid,
-						fdb_info->is_local, false);
+						fdb_info->vid, false);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 835cec1e5a03..5dee30966ed3 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1044,10 +1044,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 					   "FDB entry towards bridge must be permanent");
 			return -EINVAL;
 		}
-
-		err = br_fdb_external_learn_add(br, p, addr, vid,
-						ndm->ndm_state & NUD_PERMANENT,
-						true);
+		err = br_fdb_external_learn_add(br, p, addr, vid, true);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1275,7 +1272,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 }
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid, bool is_local,
+			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify)
 {
 	struct net_bridge_fdb_entry *fdb;
@@ -1293,7 +1290,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (swdev_notify)
 			flags |= BIT(BR_FDB_ADDED_BY_USER);
 
-		if (is_local)
+		if (!p)
 			flags |= BIT(BR_FDB_LOCAL);
 
 		fdb = fdb_create(br, p, addr, vid, flags);
@@ -1322,7 +1319,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
-		if (is_local)
+		if (!p)
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
 
 		if (modified)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index aa64d8d63ca3..2b48b204205e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -711,7 +711,7 @@ int br_fdb_get(struct sk_buff *skb, struct nlattr *tb[], struct net_device *dev,
 int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid, bool is_local,
+			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-- 
2.31.1

