Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA2CE97E8
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 09:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfJ3IPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 04:15:21 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40219 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJ3IPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 04:15:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id 15so960911pgt.7
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 01:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vYtZtkYWDvDzQYnS3hqTyuwFeB/obLgObO09ABiBAGs=;
        b=SLaQDwL7QIvKkNUICNySeM+o0gJkN9Tqtm/44IgQGYd/xfViWeGBGxMHf48KppeZ5u
         rmpMYZs6K7wPEhp+nobGOSUdxakfP/yQ/1/NWNMYJr60fMTeWRtLVQDbeA2Tiq9e86Ji
         1y/e0QqDw6JX5ikrtsWVtUHDx1ybnr5tK4PD2jPJVPjPGcYrTbQiyKm6RPWtyENVhHAJ
         N+smL/ojVPQM2KTVpzgvn3o0+qRscZ4XTM0PgOP4gvESahaRB7ch1VVVqqb6chfBfSdf
         LPEfO2SJil5j1GUAXTuGpRuhsyoSOBG4Db8jvYnUYYXyHLagtGJxJlgyp/bqz+01nwos
         HWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vYtZtkYWDvDzQYnS3hqTyuwFeB/obLgObO09ABiBAGs=;
        b=qGWRrzezFwrtSiVGn9N/vFtGSFye84c3f+gk3EYehvWeeFaSEACrXfTdftx78fKeYm
         QclgqtxStJDQuPLwGySkkwsZKIzTwjXw7BswOOapsIjLdtr7vcl+n/BAgNA+/QT+HnLC
         9EdoIvX4bbgFlW8PbnOkNkHwCrDbMstU0PeSUF+0aoaQXzveTETaKQ6efeslbazQk+y1
         /q+tyMox7PvRnJjrs45HGnOEa1GNo5V7wzA9GB9EcjljNFQ67Ar/XjnvkxzbkEEihMy4
         abNojIUIh1BFA4Yls9XliGWdagmEHW7S0fLxm0VZ8dJZ1+NLDAcEBfimkrZcIrnlWZkN
         Xp0w==
X-Gm-Message-State: APjAAAUZqs7DSdYeiNYzEKLrOWwLwygb72PprftWXpGH1ZjlYNgYjU39
        UQEjGsSywcavdusKeS6W1LA=
X-Google-Smtp-Source: APXvYqzbIhdls5mdU1iGJMpfwxHjCpnj/uaZIL9FZ11Wh6a5nqGI72a/CQMJOGngL/TlpU4yFnXtFA==
X-Received: by 2002:aa7:971d:: with SMTP id a29mr27451500pfg.205.1572423320122;
        Wed, 30 Oct 2019 01:15:20 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id z7sm1738532pfr.165.2019.10.30.01.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 01:15:19 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] vxlan: fix unexpected failure of vxlan_changelink()
Date:   Wed, 30 Oct 2019 08:15:12 +0000
Message-Id: <20191030081512.25743-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 0ce1822c2a08 ("vxlan: add adjacent link to limit depth
level"), vxlan_changelink() could fail because of
netdev_adjacent_change_prepare().
netdev_adjacent_change_prepare() returns -EEXIST when old lower device
and new lower device are same.
(old lower device is "dst->remote_dev" and new lower device is "lowerdev")
So, before calling it, lowerdev should be NULL if these devices are same.

Test command1:
    ip link add dummy0 type dummy
    ip link add vxlan0 type vxlan dev dummy0 dstport 4789 vni 1
    ip link set vxlan0 type vxlan ttl 5
    RTNETLINK answers: File exists

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/vxlan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index fcf028220bca..a01b8ddaa44a 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3965,6 +3965,9 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (err)
 		return err;
 
+	if (dst->remote_dev == lowerdev)
+		lowerdev = NULL;
+
 	err = netdev_adjacent_change_prepare(dst->remote_dev, lowerdev, dev,
 					     extack);
 	if (err)
@@ -4006,10 +4009,10 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 		mod_timer(&vxlan->age_timer, jiffies);
 
 	netdev_adjacent_change_commit(dst->remote_dev, lowerdev, dev);
-	if (lowerdev && lowerdev != dst->remote_dev)
+	if (lowerdev && lowerdev != dst->remote_dev) {
 		dst->remote_dev = lowerdev;
-
-	netdev_update_lockdep_key(lowerdev);
+		netdev_update_lockdep_key(lowerdev);
+	}
 	vxlan_config_apply(dev, &conf, lowerdev, vxlan->net, true);
 	return 0;
 }
-- 
2.17.1

