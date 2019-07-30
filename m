Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB597A6FA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 13:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbfG3LbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 07:31:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46499 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbfG3LbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 07:31:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so65341013wru.13
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 04:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tUCE/CHU/TFLeJ8RCnUMeDdjaEvSnhdkU6BkkzT8pAM=;
        b=IG6OHMW5XhjqtC/uFPxBykkCxq2KJntogSkgRduT75mGPI6Sx6/C98OaBe5/Zu7ITW
         tIkBQT2A+GYbhhzCJSmtws5xDw9CNlekeQ7LrdbK2pLC+p/InKYD8EudpNffMQaMc4Hp
         uhAs2ocTRAmTiAc4yexJCBd7AlW8uDWwv1SDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tUCE/CHU/TFLeJ8RCnUMeDdjaEvSnhdkU6BkkzT8pAM=;
        b=MNssUkBPcLxu2tBDCtW1lUHEsuS2OPy7H49CmWttxvXLhk0Sss8rX9DiBKN0RuNnO0
         ig4yQwrt9OoB9JKc75/xq94Jc5JghKdisZERVKdJu+EN2To0oqHVnvLYMiwEBCERi8Ux
         cGj0YqzwV1VCLIDN0478FfYb/S9/Owi2i1qldsUls9PSUH6kRU1XBApYYUh5qm39nNjX
         s9pW1fkn4ec5+wnMkOM/S6hNjdazNs7PJekmTFrB8ZGvWJZeSgFhHBa2dj+LvuAWE7Ot
         3KuPZJh+0h0413VzTA5SPdp+OQ8t8XA7QAS6uP5pAlUj325IUc/6/oYe9JIyDZj2pxc9
         Txuw==
X-Gm-Message-State: APjAAAXS9uDli4X4KGtPv2pg90QSiQxVqJshes51ThQt+sj5jHNjMF/9
        Gv9j034covQTv5FQYeb7O6Yfl783ya8=
X-Google-Smtp-Source: APXvYqzQ14dBPQwc3xMn/SdPqbDgdTlnJGUs4W2uaCZAdav42Zl22zxjWhoDoSkVcy/oFdqfvLlQVA==
X-Received: by 2002:a5d:4e45:: with SMTP id r5mr18745220wrt.206.1564486271341;
        Tue, 30 Jul 2019 04:31:11 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y10sm53132242wmj.2.2019.07.30.04.31.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 04:31:10 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net] net: bridge: mcast: don't delete permanent entries when fast leave is enabled
Date:   Tue, 30 Jul 2019 14:21:00 +0300
Message-Id: <20190730112100.18156-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When permanent entries were introduced by the commit below, they were
exempt from timing out and thus igmp leave wouldn't affect them unless
fast leave was enabled on the port which was added before permanent
entries existed. It shouldn't matter if fast leave is enabled or not
if the user added a permanent entry it shouldn't be deleted on igmp
leave.

Before:
$ echo 1 > /sys/class/net/eth4/brport/multicast_fast_leave
$ bridge mdb add dev br0 port eth4 grp 229.1.1.1 permanent
$ bridge mdb show
dev br0 port eth4 grp 229.1.1.1 permanent

< join and leave 229.1.1.1 on eth4 >

$ bridge mdb show
$

After:
$ echo 1 > /sys/class/net/eth4/brport/multicast_fast_leave
$ bridge mdb add dev br0 port eth4 grp 229.1.1.1 permanent
$ bridge mdb show
dev br0 port eth4 grp 229.1.1.1 permanent

< join and leave 229.1.1.1 on eth4 >

$ bridge mdb show
dev br0 port eth4 grp 229.1.1.1 permanent

Fixes: ccb1c31a7a87 ("bridge: add flags to distinguish permanent mdb entires")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
I'll re-work this code in net-next as there's a lot of duplication.

 net/bridge/br_multicast.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3d8deac2353d..f8cac3702712 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1388,6 +1388,9 @@ br_multicast_leave_group(struct net_bridge *br,
 			if (!br_port_group_equal(p, port, src))
 				continue;
 
+			if (p->flags & MDB_PG_FLAGS_PERMANENT)
+				break;
+
 			rcu_assign_pointer(*pp, p->next);
 			hlist_del_init(&p->mglist);
 			del_timer(&p->timer);
-- 
2.21.0

