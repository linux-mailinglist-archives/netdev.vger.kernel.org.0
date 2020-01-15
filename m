Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B073213CE92
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgAOVC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:02:59 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42506 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729664AbgAOVC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:02:59 -0500
Received: by mail-pg1-f193.google.com with SMTP id s64so8759992pgb.9
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 13:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YJD0yw3nQi+UEJRFtkbQORjFF24uctd6MeM7YkMC4X4=;
        b=I9bVS+joII/JvwcqpYB9bmz3LA5419qR37zuZDcqd+S07L4oYe+GnVExD/EeTNbToG
         mMWBS2BD+Mr4A3EKe9Pv5rzd4usxEk84t1D6hruByOQ9xHD128E9KnMo0AOr6kTDJlzO
         3gLGbNfDOMbDUF3VyK/Lb27Qj11zyqpcREliPSLquucIZMEIRWh1n9vYgEuRDjM55f3O
         buBD8s91cJbg/Rb1Qu5oblI5g1vpw1iJ5JT/alZ+v9AUdestH2Z+QX5sf8BwcxCx8Klh
         ByOYXZKOatQsacMIWUZ3DsJRCRdExXoQTjGgp2e/w2g5uOHWSvaPA7wS528s9UNSWbKE
         5LpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YJD0yw3nQi+UEJRFtkbQORjFF24uctd6MeM7YkMC4X4=;
        b=ENSn5aQm5am5busuZn2cvghNPgolbim1CGLH9JId37XFrjfYR+hsRCdtkldlF7/7p8
         b/8umntFct1LqufkZa8xPKD2gh07azeXm2DMMoyr5GZLzlRVBRr76j9wEDiD9q1Tk9Aw
         P7bdQHwineWTRZvQ19wbSyP0y1A2HxSXWSYXffg/9S/eVsHJkCC8BQWvA+BUJdSGGUq4
         fZ+/uOVjgWEfblQ3GK8bfqG5w1Npl67yg7U8N8Q168F4c0i/xPQTjPumcwSD88m/jiQZ
         SWw9FVo7hW592Sb4oCrO4Gf+lRivWz6wlSna+ZrNLxlCDgjjF1M7QhjPbNYNheIpiJm3
         qSXg==
X-Gm-Message-State: APjAAAWf+s9e//g0GAU4Z8moIjriLs3rPl3Jz1SA3dFhJOWlTAGLeW6o
        jWCY2XULvqCDXX8op09RN/RNydSE9/A=
X-Google-Smtp-Source: APXvYqzpTqd+TG3nB18UL3Mufxtt00d6sB1NiO0hZkUv2Vz6UEfICTWizBJdzs02heI/5HJPS9GYjQ==
X-Received: by 2002:a63:3f4f:: with SMTP id m76mr34406978pga.353.1579122178627;
        Wed, 15 Jan 2020 13:02:58 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id 12sm23231582pfn.177.2020.01.15.13.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 13:02:58 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>
Subject: [Patch net] net: avoid updating qdisc_xmit_lock_key in netdev_update_lockdep_key()
Date:   Wed, 15 Jan 2020 13:02:38 -0800
Message-Id: <20200115210238.4107-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported some bogus lockdep warnings, for example bad unlock
balance in sch_direct_xmit(). They are due to a race condition between
slow path and fast path, that is qdisc_xmit_lock_key gets re-registered
in netdev_update_lockdep_key() on slow path, while we could still
acquire the queue->_xmit_lock on fast path in this small window:

CPU A						CPU B
						__netif_tx_lock();
lockdep_unregister_key(qdisc_xmit_lock_key);
						__netif_tx_unlock();
lockdep_register_key(qdisc_xmit_lock_key);

In fact, unlike the addr_list_lock which has to be reordered when
the master/slave device relationship changes, queue->_xmit_lock is
only acquired on fast path and only when NETIF_F_LLTX is not set,
so there is likely no nested locking for it.

Therefore, we can just get rid of re-registration of
qdisc_xmit_lock_key.

Reported-by: syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com
Fixes: ab92d68fc22f ("net: core: add generic lockdep keys")
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/core/dev.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0ad39c87b7fd..7e885d069707 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9177,22 +9177,10 @@ static void netdev_unregister_lockdep_key(struct net_device *dev)
 
 void netdev_update_lockdep_key(struct net_device *dev)
 {
-	struct netdev_queue *queue;
-	int i;
-
-	lockdep_unregister_key(&dev->qdisc_xmit_lock_key);
 	lockdep_unregister_key(&dev->addr_list_lock_key);
-
-	lockdep_register_key(&dev->qdisc_xmit_lock_key);
 	lockdep_register_key(&dev->addr_list_lock_key);
 
 	lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		queue = netdev_get_tx_queue(dev, i);
-
-		lockdep_set_class(&queue->_xmit_lock,
-				  &dev->qdisc_xmit_lock_key);
-	}
 }
 EXPORT_SYMBOL(netdev_update_lockdep_key);
 
-- 
2.21.1

