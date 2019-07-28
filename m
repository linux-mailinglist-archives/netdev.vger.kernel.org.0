Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF006780E3
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 20:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfG1SWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 14:22:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32876 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfG1SWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 14:22:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so41470367wme.0
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 11:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r321PWAMEFjT5r81kKiX/eqJ1FlWbJsSU+glz5FPlrk=;
        b=H4WINix3uy3a6QX74h26aV3AF9n+/bxK8se1JV5ZbSrbV8s3wdqLJqwG4z4YCaR6R5
         7c4X+P/+OmLUJ/iinT/IFpl2gaDR90xWToajOcwHPgljU4lLjIvQodfvCBZaswuXR6AG
         bfQKFVAS8jkPb/OTa3c29y6rSADRhDW6l1JSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r321PWAMEFjT5r81kKiX/eqJ1FlWbJsSU+glz5FPlrk=;
        b=TygqjrNjG19XhZwgF7Ez92clRw/fuh4c6tU8UX2TLhemBoDqugUU1V7ZbyVowmpjTX
         yC3ytr1FD6Y8XEOkbeV1kMpaki5pC8xwVq+I8eJwTll9zKeWT2YpyVtujh8pN7u/Jo9H
         fmbZ08CZ5MNYS4vt1eoiYcptGGVYQ+vFGQFDovyBNCXfb+5fHALlkjo1zOqTixnXDaLv
         hLvQPYMY3LyZm392SMRSoNhEAKAdZjiOtmK/WHP57em4y5GGqE22ay4qoTV+4OOYrgLn
         /u+Gg++OkzgZdskL91fl8lfRLd99VZDMu1xnxShiLIFjwHOZPcNy3UawaD5Rcwz26WRQ
         4QRw==
X-Gm-Message-State: APjAAAUYKloW/iCyZ0xsFlhSkBVXdIm/3JP8DATRKwvpQdjfQf322he1
        Jj1hX+NWhTDUgOG2I49KEeCNShFIBqc=
X-Google-Smtp-Source: APXvYqyMWaPBojtlQZ3jFCCTAayF2xx+l1yFdqq0YcPgGgx7Zr4HKtO9gucA7w7DrldfG7fj33lVaA==
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr87708714wmj.61.1564338157785;
        Sun, 28 Jul 2019 11:22:37 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm48753956wmg.42.2019.07.28.11.22.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 11:22:36 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
Subject: [PATCH net] net: bridge: delete local fdbs on device init failure
Date:   Sun, 28 Jul 2019 21:22:30 +0300
Message-Id: <20190728182230.28818-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On initialization failure we have to delete all local fdbs which were
inserted due to the default pvid. This problem has been present since the
inception of default_pvid. Note that currently there are 2 cases:
1) in br_dev_init() when br_multicast_init() fails
2) if register_netdevice() fails after calling ndo_init()

This patch takes care of both since br_vlan_flush() is called on both
occasions. Also the new fdb delete would be a no-op on normal bridge device
destruction since the local fdbs would've been already flushed by
br_dev_delete(). This is not an issue for ports since nbp_vlan_init() is
called last when adding a port thus nothing can fail after it.

Reported-by: syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
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
 
+	/* delete auto-added default pvid local fdbs before flushing vlans
+	 * otherwise these will be leaked on bridge device init failure
+	 */
+	br_fdb_delete_by_port(br, NULL, 0, 1);
+
 	vg = br_vlan_group(br);
 	__vlan_flush(vg);
 	RCU_INIT_POINTER(br->vlgrp, NULL);
-- 
2.21.0

