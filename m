Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEFD3A8EB5
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 04:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhFPCLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 22:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhFPCLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 22:11:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B99EC061574;
        Tue, 15 Jun 2021 19:09:16 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 69so322790plc.5;
        Tue, 15 Jun 2021 19:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pQbf5OSdud0PkB03WD3uL1vE42Is0a71hcG2aWYgcFo=;
        b=FTNpYXlhVnmGVbZSUM/HqXnlV+DJo4fPITWgQP42vcMSNz5qFx6XWZzNEEBe8Gu5dF
         VRs6CPSEPb1M0YXmVSuuwCj43XwrMh2eLkXs9sCOYhDPigW6IhFTNqUkZU+kOH4R4vxU
         VbJEVzbZZjpiiyaRVd6hBJuYHOIVc4ITjmXHfr58MtzYEgqYBAeRKA5OF8l5B9YbBcKp
         WiFNOKLAP6afEEqKX7N1sZm0Y5i4SECIzTOk53G7lCu9OflZyh4ePsS26408djJOKck8
         0vu/T058uRAjfFnzjCuNhJ1FbN3KRD+6+DC8SwfUsh4Z0PeB0gW6dnE1pu7lBJ2TG41c
         VKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pQbf5OSdud0PkB03WD3uL1vE42Is0a71hcG2aWYgcFo=;
        b=MacKZQDXNpicZGgUXQLQs6x+BUJ0/peICOsQDnpgLzzlQVXFtZuS6JtKOPQFMviRn0
         zrbFr4TT+CnYCDORT5lWoBGGHR1cnAvvCPKEW9KhlyLAz4ut3cxSm9oGKJq0wA6uODnY
         XJFTocQtmHDXrMHdV8wGsGvjtPSYXzCVh/KQbosTbd0AFYcO0jYpsnSg2YRnpoMcduCv
         2DPMhozrPfj0fvJ88l1Z4D8X0AfmXjE91OfaPzMHTXEIVxWNegS8q3Ttlbl7eXJbZC/h
         RD2CXSEE5Ns2ca77E4nXSW8IBAA8Pe99R5PJeo+ZkR8nTcj7Hbg7XLC4e9LxiyytYbH/
         RNnQ==
X-Gm-Message-State: AOAM532XcF9IcN12ExSOj0x08u9ZuDX5JBjOtf54FAjlXBSWmSsfQIVR
        Wmvh6nzaWnsP5FlsmGMyFXA=
X-Google-Smtp-Source: ABdhPJxv/N+I/DgzPdN3ZAHJ315+Z798lsoRnxRO0EUSt1qFUR+N0gWt0IprBYvFby2cY6JTDIjRhA==
X-Received: by 2002:a17:90a:ee84:: with SMTP id i4mr2459756pjz.34.1623809355561;
        Tue, 15 Jun 2021 19:09:15 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.27])
        by smtp.gmail.com with ESMTPSA id j3sm374452pfe.98.2021.06.15.19.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 19:09:14 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com
Subject: [PATCH v2] ieee802154: hwsim: Fix memory leak in hwsim_add_one
Date:   Wed, 16 Jun 2021 10:09:01 +0800
Message-Id: <20210616020901.2759466-1-mudongliangabcd@gmail.com>
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
v1->v2: add rcu_read_lock for the deletion operation according to Pavel Skripkin

 drivers/net/ieee802154/mac802154_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index da9135231c07..cf659361a3fb 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -824,12 +824,17 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 static void hwsim_del(struct hwsim_phy *phy)
 {
 	struct hwsim_pib *pib;
+	struct hwsim_edge *e;
 
 	hwsim_edge_unsubscribe_me(phy);
 
 	list_del(&phy->list);
 
 	rcu_read_lock();
+	list_for_each_entry_rcu(e, &phy->edges, list) {
+		list_del_rcu(&e->list);
+		hwsim_free_edge(e);
+	}
 	pib = rcu_dereference(phy->pib);
 	rcu_read_unlock();
 
-- 
2.25.1

