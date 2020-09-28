Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F362E27B0EE
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgI1PaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgI1PaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 11:30:11 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECD8C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 08:30:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x23so1576529wmi.3
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 08:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6VVT8An+NVIG2uzRBeTIUimQFMuHQujGalFijHXJVJI=;
        b=XhxW9IkpduseHfGezLNC9OdGxB2wtvIOpXqB3BDtu6tTq9Mm4FSLxbmnCPAiejqzMy
         lLX5xwhrs8gWvpa5OyzpjP6uZYDLzVIOU4TL07RRpNUAELUUd8PS2twg43gLPUp3BPQD
         7m9PLhMfF9D87ue2POf2SWtB8NjmNEp/qwxs/RWEnYYFWLu2RElcCLRQS2cfluakSu+M
         mNiVE39M/ItzKQxu2zEpZY9HrgzS7khanvvW1O5vP8iSG+DT+L2yOyCZb57PmkPHvy+A
         HXGbGKaatNVxbed9XwCQjOewVAV19W+0NmkgLSZQGztFMpRv3BlvlUfp8dQ0oqCo+vBL
         U6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6VVT8An+NVIG2uzRBeTIUimQFMuHQujGalFijHXJVJI=;
        b=K3Xsn+agj/hgq3ABLz2XhYv8fDw0k3yZKlqPTd4L3QxW2XeE82npaiktNO/KyuX5HL
         WBaGtkhMs+e4ROSQ2RW8NXOCcgcWwiKWb8zy0l5MVWh6206wOcatAu7LElM/BW2I4O7S
         8op/ohfuPbGwsZ8hq/ATeV405Tl84+vEYlcmq4vFwzuFF73G8nrWOk8QV8kJMR3lOu6w
         DxPTKYLA12Ir9KQBBnU5MY28La1r+itGWbTkXCAAiwCyUx9bqQGXOT7NYgnLzzpUM8kX
         Dc20+zQ9LgHJjMDa7XckDICwRpLRRN36DZYclLG8GBlCSYFk0fuRGc/ag1VQcxZ/K6W+
         Ngrw==
X-Gm-Message-State: AOAM532M7c6Qu6tx7Ifl+sZ0QIMriET8r8kMTF+zPIOdSkQM9B0lnoWZ
        VcPpK+ec/ya5z+5yHskjXyYmsfUM4j86khNmJ3s=
X-Google-Smtp-Source: ABdhPJyZxVWjvMtpvvDZIeNbOCG85h7F4zAnClzOR6Fcdz82eVkdT6zckKyT8PxXBJLiXdFfiDNEzA==
X-Received: by 2002:a7b:cd89:: with SMTP id y9mr2152572wmj.72.1601307008336;
        Mon, 28 Sep 2020 08:30:08 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id t202sm1903247wmt.14.2020.09.28.08.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 08:30:07 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     idosch@nvidia.com, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net] net: bridge: fdb: don't flush ext_learn entries
Date:   Mon, 28 Sep 2020 18:30:02 +0300
Message-Id: <20200928153002.1697183-1-razor@blackwall.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When a user-space software manages fdb entries externally it should
set the ext_learn flag which marks the fdb entry as externally managed
and avoids expiring it (they're treated as static fdbs). Unfortunately
on events where fdb entries are flushed (STP down, netlink fdb flush
etc) these fdbs are also deleted automatically by the bridge. That in turn
causes trouble for the managing user-space software (e.g. in MLAG setups
we lose remote fdb entries on port flaps).
These entries are completely externally managed so we should avoid
automatically deleting them, the only exception are offloaded entries
(i.e. BR_FDB_ADDED_BY_EXT_LEARN + BR_FDB_OFFLOADED). They are flushed as
before.

Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entries from user-space")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_fdb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 9db504baa094..32ac8343b0ba 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -413,6 +413,8 @@ void br_fdb_delete_by_port(struct net_bridge *br,
 
 		if (!do_all)
 			if (test_bit(BR_FDB_STATIC, &f->flags) ||
+			    (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags) &&
+			     !test_bit(BR_FDB_OFFLOADED, &f->flags)) ||
 			    (vid && f->key.vlan_id != vid))
 				continue;
 
-- 
2.26.2

