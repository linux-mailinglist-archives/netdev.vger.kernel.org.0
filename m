Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1755624535D
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgHOWA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728812AbgHOVvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4564C06136B
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 20:06:06 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u128so5457528pfb.6
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 20:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5KwR5xhfPXsL2asWzQqM0wpo/ssHwspfKkLxx7jKpKY=;
        b=ZznlS5MArzxHZ8pvVUMD//i/wDFlZ3Z8h1zlweMrKnvrbjgVuHuwVphK/AemeSie+6
         ncqgM5F1H45CMne71Yb7bbxvG7jqAckd4B9//Z5orGdPpc/feoH5Zo/tZDfv28uvNOCE
         RtgoSJVkP+14hEPT/ZIQ+DvHd6iMOK6UTGhXb/b4Z9UV0t7pGbu2CeAZ33xx2IZ4RGoT
         ByJC/ZTvPR3SbN+AcNkGdR4v5ts7aD/ZBIHKoN00lGswFwtx8fbc6g4OJuTfc42J5q6S
         VZG5YQ1wQJtKIN6fsyfMwTj77OpqCE9FCpoRn9wSBf2vrjcAwxMBMifH0XTMu+f8NNrm
         fvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5KwR5xhfPXsL2asWzQqM0wpo/ssHwspfKkLxx7jKpKY=;
        b=gYnEmqmicUOmYTYkM4ftjjviDySYRpzhsUlB2Gx76smBbyUMmTWmkTbNtHWpEgGvM1
         FlHT9M0lsiWfYBsQ10GF2gmOUJFwMJBVWJc0AyVrrHNSYZHQiVMGPc/ifyCT9081OU6z
         jP9+58MCo7TKFDxghQcVS+wxKlO20fRWxX2ypPl4tEperJ4Bk5fcxyEmUlIPnwQe0xe7
         WFbb+Z1cB+lXR0ZX6GrcXisPBmmRUJ5OQphN2HIqv+eqmweKqh8QmzMGA9kpFY8jo7iE
         UBZFnEcm24mr+QkWvjMf9uX6NMSQoU+q0iuUaoP6vfjsnzTVdAogVhoLF1FY0NBGxOSS
         eKvA==
X-Gm-Message-State: AOAM5329j+kjxQm3tKYhXfDzeq1mXAAjHxO5qmbGLN2m3T2xT+LmuCWC
        vamCaZUjMohOXugdeCr4rvJxixm5dG4udA==
X-Google-Smtp-Source: ABdhPJzBu3kohYxqXAPyRwIoxaYxuDbBRlATYdvHD8geDiX4FtSeWWobcceQAy7aq/qSiCMIp4tR6A==
X-Received: by 2002:a63:e703:: with SMTP id b3mr3556490pgi.39.1597460765860;
        Fri, 14 Aug 2020 20:06:05 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:727f::46])
        by smtp.gmail.com with ESMTPSA id y7sm10157914pjm.3.2020.08.14.20.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 20:06:04 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>
Subject: [Patch net] bonding: fix a potential double-unregister
Date:   Fri, 14 Aug 2020 20:05:58 -0700
Message-Id: <20200815030558.15335-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we tear down a network namespace, we unregister all
the netdevices within it. So we may queue a slave device
and a bonding device together in the same unregister queue.

If the only slave device is non-ethernet, it would
automatically unregister the bonding device as well. Thus,
we may end up unregistering the bonding device twice.

Workaround this special case by checking reg_state.

Fixes: 9b5e383c11b0 ("net: Introduce unregister_netdevice_many()")
Reported-by: syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/net/bonding/bond_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5ad43aaf76e5..995fcb4eed92 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2205,7 +2205,8 @@ static int bond_release_and_destroy(struct net_device *bond_dev,
 	int ret;
 
 	ret = __bond_release_one(bond_dev, slave_dev, false, true);
-	if (ret == 0 && !bond_has_slaves(bond)) {
+	if (ret == 0 && !bond_has_slaves(bond) &&
+	    bond_dev->reg_state != NETREG_UNREGISTERING) {
 		bond_dev->priv_flags |= IFF_DISABLE_NETPOLL;
 		netdev_info(bond_dev, "Destroying bond\n");
 		bond_remove_proc_entry(bond);
-- 
2.28.0

