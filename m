Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B781AFBE5
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDSQTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgDSQTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 12:19:53 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50005C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 09:19:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id np9so3454107pjb.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 09:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YG+p9bpPBHqyI4mCiMrVfo4BojUmW4QV1jvJ5YQRhnY=;
        b=hHE1PNZgAIGvBQTOD3CUD4s+7VggJSeq6TnzxrF3uubC7quWhfgn7tRKDYFs+xlAbc
         +KV+tqw1PUHAsh3qRxT4zw1Y+8hjoONwZcGjRqvtZZoW4t1v94x40FvDL1nlhxqRXqAL
         Qf/bXUUtZ2viScyRqbtwtkz56JfAiDIugkeD1/z1zfdbn2SiSE+e6lcpc1D9kZu34hc4
         g+rA+fY8YIDld6yxHeMuNeiqye20nk88NVxb83OUaGxzGlJ4Du7fltMj1KSJgyqgnJUU
         YY1rxThk5EH5azh1q9ox8+CfG5TiveZ9dXo6hFTa2gxKRARs7+h7Vd9Dth/YL4FxQIQf
         YNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YG+p9bpPBHqyI4mCiMrVfo4BojUmW4QV1jvJ5YQRhnY=;
        b=L6HDzAmJP8pNdtEVapGJ2trwxL+zzEYx4G1PuzCnP90LSUYJVixkOGBsOMXPMmYAxF
         xdzNMDwVKA7l+5jmH/YPXKSih7yHZwSpEm8gPw73nwky8N5XNe635s3bZmLSNEeWBmw6
         fcwWthi6s8I/oUzkLgFMBIu5ZPhqL7z/DbS5cUiGdiy/qA8ripoR9dxCoVxiAR23TGSk
         3uh1ack3WuOiwBPEbWDEXqRtAg3l+gEmZ9KOWKDGt22lp1sx6Y3LW9tEq+zQI9hs41yC
         WV2Og2LzXc5TasgS+sX3/2DHrWo8CTGsVGLYfAG9k3QrceUBEZktj9eVdjdCnq6dBSB6
         6tSQ==
X-Gm-Message-State: AGi0PubAGhH07i/7u1tcjfUCPRgNXDevSStVXCWVFuiw2wfiJVqRsCiP
        pU/vPAG1RgcKNKiU48OPcgC4hiJA5OE+Tg==
X-Google-Smtp-Source: APiQypJLbgPo7MTzc0x6sikVq4UdzWK5aXvn0WloExU02qcoI1xEihcY9913DVQzdtaNkrCFZ8d3cQ==
X-Received: by 2002:a17:902:7598:: with SMTP id j24mr13781426pll.166.1587313192684;
        Sun, 19 Apr 2020 09:19:52 -0700 (PDT)
Received: from P65xSA.lan ([2402:f000:1:1501::7141:e898])
        by smtp.gmail.com with ESMTPSA id a13sm25173557pfc.26.2020.04.19.09.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 09:19:52 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [RFC PATCH net-next] net: bridge: fix client roaming from DSA user port
Date:   Mon, 20 Apr 2020 00:19:46 +0800
Message-Id: <20200419161946.19984-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a client roams from a DSA user port to a soft-bridged port (such as WiFi
interface), the left-over MAC entry in the switch HW is not deleted, causing
inconsistency between Linux fdb and the switch MAC table. As a result, the
client cannot talk to other hosts which are on that DSA user port until the
MAC entry expires.

Solve this by notifying switchdev fdb to delete the leftover entry when an
entry is updated. Remove the added_by_user check in DSA

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
I tried this on mt7530 and mv88e6xxx, but only mt7530 works.
In previous discussion[1], Andrew Lunn said "try playing with auto learning
for the CPU port" but it didn't work on mv88e6xxx either

I think commit 7e26bf45e4cb ("net: bridge: allow SW learn to take over HW fdb
entries") already tried to fix this issue..

[1] https://lore.kernel.org/netdev/20200405150915.GD161768@lunn.ch/

 net/bridge/br_fdb.c | 3 +++
 net/dsa/slave.c     | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 4877a0db16c6..46003e78f2ac 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -579,6 +579,9 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			/* fastpath: update of existing entry */
 			if (unlikely(source != fdb->dst &&
 				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
+				/* Remove the entry in HW */
+				br_switchdev_fdb_notify(fdb, RTM_DELNEIGH);
+
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e94eb1aac602..6133a1be1a74 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1932,8 +1932,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = &switchdev_work->fdb_info;
-		if (!fdb_info->added_by_user)
-			break;
 
 		err = dsa_port_fdb_del(dp, fdb_info->addr, fdb_info->vid);
 		if (err) {
-- 
2.26.0

