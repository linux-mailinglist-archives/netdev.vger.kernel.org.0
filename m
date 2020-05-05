Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762FA1C638A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgEEV60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729060AbgEEV6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:58:25 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA31C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 14:58:24 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t9so221853pjw.0
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 14:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O9BvYApTeQYQZ9FK7h3e8hVNymiiqpnTyqYUh282n+8=;
        b=rW6rmLTjJvaPdwUEJwDqDr3guyjpT1t9quN961V1+YtSR/2pcsQX8hXko7In6w0LPl
         nallWwRyg+j3oCSgoXg8YTBbS3cBjd8LOOc/ggIVbP0yG0skESDDWQRRO6JOIx+JgWe2
         U2Dp40JWOPNCXVys+eMvtPBE+IFNh+PHJf+PXq7p0AacDtuJ+4JROKFVq49ElpHiJHxM
         M3QaMjtPjQ711jUldYsXFT/GDt0eAkyjFhxx2/YN/H7HMugiKvr3mVLzeNoM5DPgVzqA
         Qo8fNKPaEEWp0VqM0uZXiyRP2vKjhAYYzriJiYUkyLydlVqTLRFfetmpxhrE7688kIr6
         4Xzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O9BvYApTeQYQZ9FK7h3e8hVNymiiqpnTyqYUh282n+8=;
        b=Xhd8kY6QL7XDDw/daVeXH5UptsyLe90Pj68T0FkD1D28sERbkj4y+so8ZAa035u2Zp
         ig0uaP0N0Zxg7hEdxSYPN7BquqQq1yo8nqvfGa5wfDyjzb8WPfdnogzEijlw0VK9qpoY
         MFBSj4ZUT3V65jF8Ice2/SMyDgujfTZYZV5nWjyiBe1HQsacSmLjXvGhnJh2YKWlFzI3
         woBgj0pEBVhm8v+mqi9lv5MYZeJv0SL3FyTG4RDaNAMskfaN26tG0hLbywwuwMF991zz
         sKdIjkiUrPKDJlzWAf3XVno30PbqEl7Rik+d4UHb+V3ZahrmNzSjX2QcONYYotHRDXVE
         tqqw==
X-Gm-Message-State: AGi0PuZURg3UtwPjeQQZH5KtgV0qUSHao5StT+9MV3AczSvBoCBvoQn1
        vxKswIcU4lL0NJQJWrxg1XB7PRTNZyQ=
X-Google-Smtp-Source: APiQypKyQAhV7yYgCGYAXA4CoGMvpRRaC+PlJzVYQxc+rz+pkbLyJT84nRjzuoo2Umg+fmTEAPWijQ==
X-Received: by 2002:a17:902:b286:: with SMTP id u6mr4991801plr.11.1588715903564;
        Tue, 05 May 2020 14:58:23 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id i13sm3028402pja.40.2020.05.05.14.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 14:58:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
Subject: [Patch net] net: fix a potential recursive NETDEV_FEAT_CHANGE
Date:   Tue,  5 May 2020 14:58:19 -0700
Message-Id: <20200505215819.1997-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
between bonding master and slave. I managed to find a reproducer
for this:

  ip li set bond0 up
  ifenslave bond0 eth0
  brctl addbr br0
  ethtool -K eth0 lro off
  brctl addif br0 bond0
  ip li set br0 up

When a NETDEV_FEAT_CHANGE event is triggered on a bonding slave,
it captures this and calls bond_compute_features() to fixup its
master's and other slaves' features. However, when syncing with
its lower devices by netdev_sync_lower_features() this event is
triggered again on slaves, so it goes back and forth recursively
until the kernel stack is exhausted.

It is unnecessary to trigger it for a second time, because when
we update the features from top down, we rely on each
dev->netdev_ops->ndo_fix_features() to do the job, each stacked
device should implement it. NETDEV_FEAT_CHANGE event is necessary
when we update from bottom up, like in existing stacked device
implementations.

Just calling __netdev_update_features() is sufficient to fix this
issue.

Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..ece50ae346c3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8907,7 +8907,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
 				   &feature, lower->name);
 			lower->wanted_features &= ~feature;
-			netdev_update_features(lower);
+			__netdev_update_features(lower);
 
 			if (unlikely(lower->features & feature))
 				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
-- 
2.26.2

