Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C9B3A7D14
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFOL1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhFOL1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:27:14 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96354C061574;
        Tue, 15 Jun 2021 04:25:10 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id m2so4450343pgk.7;
        Tue, 15 Jun 2021 04:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FgJ+fxLsBzcMN1KYsDOUn2EdtnZ5dK4AVhoseqqW7VA=;
        b=MYB0Y+3XQhG/dCmrHeAY6XHkJfjtpPm5MNSEn3dxaXAF7LX6gk+evPUNxAA3TJnitu
         8zXjYbMQx8uWxNDJ27T5bS2M2gCJy8NanhGh7uKtXKbLg1Sv3bVpob7Nf3JwdLyRLM7S
         UYLHpkIVMTsYQB+NtAGzF7vkCw2nDqngwXexRYMl1RMryuVIfuUsx6Pyyj7IdUWdr2lm
         Kh0obj1cfn/pAYO+FjsIOfy06mMIiEXfnddbyXWB69uATQpEvgeo0TW6GD4k+6jkAUCI
         CKyEaHP80hbtWqvGaO6V4mbDR92iHYyFag0j8gLSUt0XkjFoRE+lyhaINck19xt4SFIH
         iNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FgJ+fxLsBzcMN1KYsDOUn2EdtnZ5dK4AVhoseqqW7VA=;
        b=uP09DRl4z+wypeX1GnzJvoC7UL2f3eRTGllJY+PQcD6uSJEyIHWLCau7UBqKk9AjuF
         qmcVlIK/ICDT64d5f6KQXItdf28OUQurEzoRAZmUVCS4qyEhZ/3u3r2r8Sn4uaDZXRCQ
         J3oytNNZFVfwh2wUxInspXLni/C9T+nJmDOB6LHfe7WuUVAWa7ZYGjgfQPYyuL3ZRa0k
         Ba4TTf7zq1SMsCbe9PHA5YP1g3focRh0MeTSV9hiaeXC4MppmALzJpRS11uw7dGQ9Owu
         O5gRBypPM6UBhrRE+u/HTBwJvX+dQj7PSZoSdQhTMr+2/0CDw/il4hqL3g65lHgbo44h
         MF8g==
X-Gm-Message-State: AOAM530DJEB+vsUhlJgHff4HtGoGHNEpe0tfKrMwEURZuGcuj9T44vpV
        BQe0cuRahrDnSExSWZP6fPE=
X-Google-Smtp-Source: ABdhPJxOJfhSHwzKfgMpG217nOkV6lvajGidQ1CEjiR7cNklvBgHk0iTPanbOt+b3802NYFkI6C4Dg==
X-Received: by 2002:a63:e958:: with SMTP id q24mr9572811pgj.438.1623756310055;
        Tue, 15 Jun 2021 04:25:10 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.36])
        by smtp.gmail.com with ESMTPSA id i22sm15314332pfq.6.2021.06.15.04.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 04:25:09 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com
Subject: [PATCH] ieee802154: hwsim: Fix memory leak in hwsim_add_one
Date:   Tue, 15 Jun 2021 19:24:54 +0800
Message-Id: <20210615112454.2497316-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No matter from hwsim_remove or hwsim_del_radio_nl, hwsim_del fails to
remove the entry in the edges list. Take the example below, phy0, phy1
and e0 will be deleted, resulting in e1 not freed and accessed in the
future.

              hwsim_phys
                  |
    ------------------------------
    |                            |
phy0 (edges)                 phy1 (edges)
   ----> e1 (idx = 1)             ----> e0 (idx = 0)

Fix this by deleting and freeing all the entries in the edges list
between hwsim_edge_unsubscribe_me and list_del(&phy->list).

Reported-by: syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com
Fixes: 1c9f4a3fce77 ("ieee802154: hwsim: fix rcu handling")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index da9135231c07..b05159cff33a 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -824,9 +824,16 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 static void hwsim_del(struct hwsim_phy *phy)
 {
 	struct hwsim_pib *pib;
+	struct hwsim_edge *e;
 
 	hwsim_edge_unsubscribe_me(phy);
 
+	// remove the edges in the list
+	list_for_each_entry_rcu(e, &phy->edges, list) {
+		list_del_rcu(&e->list);
+		hwsim_free_edge(e);
+	}
+
 	list_del(&phy->list);
 
 	rcu_read_lock();
-- 
2.25.1

