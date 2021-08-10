Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570863E5434
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 09:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhHJHWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 03:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhHJHWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 03:22:10 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09789C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 00:21:49 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y7so28758604eda.5
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 00:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=up+eew742X9QXmow643XmONFSJDHCmQiISaU60otKWY=;
        b=Hj6XIanI3u2F1shNBA3Vyc+8RWLtizk9WYkfA1YQliwp9LxB8743ERNDZ1NOhwS5NO
         c/FXufFGrZ0A9Ttt4tNCMet0B6blA8q3DDcGog5oL0gLLHpuHYrncXmkNyxHNfamrFUB
         f94yI+jcT93NbNFUP1XRjXxW6oGJypqX+f6kZ4CAJiuw5hvImbJdLu00Dd7BrlUpoxrP
         IYRA2gxyT0rrX3ybz58u2qpfDjC0MxkwNcvkAFNQoSugDDBts+jV6arlHnpXUejU/GlM
         T88EZEDQAk9F/M/dWDAuO4WkOAZZXO4qKFtttU8adSRuQit6myk/xka7e+++ODKgdxBR
         bd1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=up+eew742X9QXmow643XmONFSJDHCmQiISaU60otKWY=;
        b=Q7je3AMQ5h6dpJ3qVYWV1RbROzf/Ar4HOYqjB17hPKwFH3wJuVr+oZ7FnqmMcDvUJv
         hyap3qCCRTdVoiFszqM+aPzgyO9m3MGJmMOKF6HgcCERIceCcm445BAX5eWwd9FhdU7r
         msjrB9tNYdGlwyJjPCxu0L9rxm5LAxnguODpCJTTqzZK+AYPSWpsC1+XnyedDg3G3nsy
         6c2Q0MGFN1u3xJEH0IyCxOYzCGmBblmHgAelXzDgf7AlBrh+G4YJ/drfB70dtJAikOhV
         kLISHS58sTMhnVDWN7RNyByrKctnGnuIzaGCqAyl0GZTsoqWhfjcLYAgWiuO6L7CXa6q
         bZmg==
X-Gm-Message-State: AOAM5311IlGTi0yJBM+QeibGz2ePzHW8h3jhmoh44A0wzTxSd/7TYXo4
        9O9jiCCtRvOBFCSy7WtQSt2OFWt9+CIDY2u9
X-Google-Smtp-Source: ABdhPJzyiED0fEl+efvYe4jeXCQUt5Op8b4nYFC7UVLWft2HvFbF4JCi+uojgtNHGlrhWtFUeJ6n+Q==
X-Received: by 2002:a05:6402:1514:: with SMTP id f20mr3303243edw.336.1628580107222;
        Tue, 10 Aug 2021 00:21:47 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f26sm9141725edu.4.2021.08.10.00.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 00:21:46 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        vladimir.oltean@nxp.com, Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] net: bridge: fix flags interpretation for extern learn fdb entries
Date:   Tue, 10 Aug 2021 10:21:39 +0300
Message-Id: <20210810072139.1597621-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YRIfT6vLL16hr+7p@shredder>
References: <YRIfT6vLL16hr+7p@shredder>
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

Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entries from user-space")
Fixes: 0541a6293298 ("net: bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
As discussed I decided to keep the error for !p and !NUD_PERMANENT case.

 net/bridge/br.c         |  3 +--
 net/bridge/br_fdb.c     | 11 ++++-------
 net/bridge/br_private.h |  2 +-
 3 files changed, 6 insertions(+), 10 deletions(-)

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

