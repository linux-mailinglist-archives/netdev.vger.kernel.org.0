Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30DA1C7A74
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgEFTqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgEFTqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 15:46:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E3FC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 12:46:25 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t40so1404157pjb.3
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 12:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S7hJqZJ3rRXchF60uvDKCGx+Hh24pUJw7QcYRvtNVvo=;
        b=iHESDeJRmQeGWlVciSBWgErJdssvsB5jj1kjRL1h5B8WmUj9gZim7nckBGaay720MP
         1+LcZGPZzqQMZgYWoyx/pRMNGmPLGJMpA+lYc8cFSV1kxFSqaCY83nzf82I87Ihi+lMp
         5odjKoBbWLQViUWrjz7hdnRwOckVG6kb9sxQ+HZYv354Blt0UN+IHecV/7pG+rXVwunk
         MsPAfsWVDkhUtAGCmiO33VkdrCc8/ZdI6nlrQZ/DZJoNOeYYVeb+aPIzDndj+f64/oi1
         EcE5emMD2PA0r6A3NVVSZRNUm6sql2rmVHXZDjNVA0Gu4D0SBoMZ8Ih0/GUeij8NqcLm
         B92w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S7hJqZJ3rRXchF60uvDKCGx+Hh24pUJw7QcYRvtNVvo=;
        b=ZI9TGDTljCaAwkonL2Lupig46p5Ml7qapyq6UguY1GPPVnvO+Zb+LummbKU/FFRxd4
         qL0oMM7jQX1ggNyg4E973RiInCKvV8ArytHEd9Jflifc0+P1vrlnDarIHy79ZStrc8tH
         IFsvfx1WFSV7+uc2Shb2XY0Tg9UfuPsQXkvStV36tOUhjARHTWjKbL2AqLRS5mxWGOy6
         YjG2nRRB2hv9H1kkfDtL2bktk5+xIXqxsZs1QZgOOigO6a2oc7K9ryl0CwFPORo2s6+7
         0f0kIHw7pe3ttsrfo+E7ExBCVK2L+bC9A7iHrFoF0f2a0fTb3MW9DBeLAxOMOzxgwhy6
         l42A==
X-Gm-Message-State: AGi0PuaeVnmYsEgepscbqclOjLOhh1I6nXGHZv0zVHKc8K2AVBWlmAEz
        fwT3ifGu8IowlXpAOy2GxKsZ8BQRhnA=
X-Google-Smtp-Source: APiQypIvNlQI6ijjxxPYKATgqHau4DHxQ3rbbqsXovBsano4lUuhippqGXaA7DJwaVD6NpHj0HTCDQ==
X-Received: by 2002:a17:902:d70d:: with SMTP id w13mr9308700ply.283.1588794384246;
        Wed, 06 May 2020 12:46:24 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id f6sm2636652pfd.175.2020.05.06.12.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 12:46:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
Subject: [Patch net v2] net: fix a potential recursive NETDEV_FEAT_CHANGE
Date:   Wed,  6 May 2020 12:46:13 -0700
Message-Id: <20200506194613.18342-1-xiyou.wangcong@gmail.com>
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
triggered again on slaves when the LRO feature fails to change,
so it goes back and forth recursively until the kernel stack is
exhausted.

Commit 17b85d29e82c intentionally lets __netdev_update_features()
return -1 for such a failure case, so we have to just rely on
the existing check inside netdev_sync_lower_features() and skip
NETDEV_FEAT_CHANGE event only for this specific failure case.

Fixes: 17b85d29e82c ("net/core: revert "net: fix __netdev_update_features return.." and add comment")
Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..6d327b7aa813 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8907,11 +8907,13 @@ static void netdev_sync_lower_features(struct net_device *upper,
 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
 				   &feature, lower->name);
 			lower->wanted_features &= ~feature;
-			netdev_update_features(lower);
+			__netdev_update_features(lower);
 
 			if (unlikely(lower->features & feature))
 				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
 					    &feature, lower->name);
+			else
+				netdev_features_change(lower);
 		}
 	}
 }
-- 
2.26.2

