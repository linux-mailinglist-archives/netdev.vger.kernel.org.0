Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1663978871
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 11:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfG2Jal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 05:30:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35487 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfG2Jal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 05:30:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so52770418wmg.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 02:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwkbToRnvkPkaAeAvQMV1LEHyGv3X3yvIxFI1T/d490=;
        b=gkQJGCLEBtZ12CHhRHiZL6+DgUKHZMIlh1b0TuXIeqbIuKHSdQ8o3Q8a4xh/WQ9kIG
         2slVscevycmtN2jsWuLGi8hh1P6+ON6h4h3b0LhbCrJIz0UM0FVaClNqAh9GfA0A4qFv
         1N7qFKp/wj6t1QiZV8qbD22VqrmjDLSIzdY8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwkbToRnvkPkaAeAvQMV1LEHyGv3X3yvIxFI1T/d490=;
        b=uh4M9gVLHuIP68l+kD0inarXX5hSu+1rTfejXYsi+mJJMDhuMU1AlYZmhzLcb5YiwW
         r5XAXVpKLVJ5vqZIHX/W/X9gzdsV0/mccNZSCkzPFhJSXMTo95jfX/j/VpFrwUELq1tK
         bKfwqWaCb3uLHu++I3kzEihn0Q0DC22+7OLkDkVZI+uJUE6HurBf++q8n6gXqQ8c6eyo
         HkGj/IEpmfRhDFBdt+qZY9CRLi77qMGbbhmA/fY4RwWsWBc/ONYpK/nXZioCIZDrRbzt
         Go8qznFsINrvrVw2IiZcGwxIIA1QNGkA9Efta3YcKQHFoyMWGqjOtbfkUgr/VuGI2IJ+
         GueQ==
X-Gm-Message-State: APjAAAUom6vhZbAG1ZKtVKJ6rqrkO3DVOHACSy+nBq+phfHX39/qeQUw
        HQhC5eS9l87re+AWVZ7e3eHsuJde55c=
X-Google-Smtp-Source: APXvYqyhlnZ9knli0ifQGUXH0RUZ7bDZQTFKmuy4zzV4OJFV4Poe1b6zBdqpq7iSI3B2IaeP1r45zQ==
X-Received: by 2002:a7b:cae9:: with SMTP id t9mr98201451wml.126.1564392638792;
        Mon, 29 Jul 2019 02:30:38 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id g19sm68922504wmg.10.2019.07.29.02.30.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 02:30:37 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
Subject: [PATCH net v2] net: bridge: delete local fdb on device init failure
Date:   Mon, 29 Jul 2019 12:28:41 +0300
Message-Id: <20190729092841.4260-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190728182230.28818-1-nikolay@cumulusnetworks.com>
References: <20190728182230.28818-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On initialization failure we have to delete the local fdb which was
inserted due to the default pvid creation. This problem has been present
since the inception of default_pvid. Note that currently there are 2 cases:
1) in br_dev_init() when br_multicast_init() fails
2) if register_netdevice() fails after calling ndo_init()

This patch takes care of both since br_vlan_flush() is called on both
occasions. Also the new fdb delete would be a no-op on normal bridge
device destruction since the local fdb would've been already flushed by
br_dev_delete(). This is not an issue for ports since nbp_vlan_init() is
called last when adding a port thus nothing can fail after it.

Reported-by: syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
v2: reworded the commit message and comment so they're not plural, we're
    talking about a single bridge local fdb added on the init vlan creation
    of the default pvid

Tested with the provided reproducer and can no longer trigger the leak.
Also tested the br_multicast_init() failure manually by making it always
return an error.

 net/bridge/br_vlan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 021cc9f66804..3e6a702e4c21 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -715,6 +715,11 @@ void br_vlan_flush(struct net_bridge *br)
 
 	ASSERT_RTNL();
 
+	/* delete auto-added default pvid local fdb before flushing vlans
+	 * otherwise it will be leaked on bridge device init failure
+	 */
+	br_fdb_delete_by_port(br, NULL, 0, 1);
+
 	vg = br_vlan_group(br);
 	__vlan_flush(vg);
 	RCU_INIT_POINTER(br->vlgrp, NULL);
-- 
2.21.0

