Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF3F1159BE
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 00:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfLFXpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 18:45:00 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:39913 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfLFXpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 18:45:00 -0500
Received: by mail-pl1-f201.google.com with SMTP id p11so3362437plo.6
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 15:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=flSySeaOTyGdNm8uRNUSmOIEW4w3YO1LjjZ/Xv4I/Ic=;
        b=jm06LW+nbytv79f1inWqwA3N4TB63lXC+HpsflIkbrzcHJIBNG/wZwm3qdgljA2Bs9
         nX2QZbcRKsT4RaUZlqE92KU2+VrpmzAXp6utjvyBHRk/Q8KqzhWw48FHc2RCdCZmeBFS
         IItCDwtQBoDjUVi1DjE0QBkNGJ2Q9r9ZWj97HXthgX2ME57I3tbKLF80j1QWmLAhAhFD
         Mhek8+0/cDlyS4/YLQt1kt45cuyv7KsFm3shr22A6gbc94QaJ3Zv+EyZVKemvrIJoxy1
         YrrCA1yw6b0SW8HN5N+OiAtmO2Hn7OYE08JjEKua3RGFUm7o//Suc/oADIVjxwaf1EWq
         2S2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=flSySeaOTyGdNm8uRNUSmOIEW4w3YO1LjjZ/Xv4I/Ic=;
        b=bcQJKO478tzo6lj9ZQTTQycWSs50Kel1ehfA7zV77c5yA+8qgm+JKKl0G5GptoEF6O
         lkOc6q2CVz6G0mTvocW4rtgolPk81DVSkJXi4112cDvzsmaBdL5udF2CvtK8BMFbRMDh
         VCHISyY4xgc75MBY6wwFIhK8Ffmm8nJNxJiWPIom6fb6ta2aGEVV2aktOUXXIWh/5OM7
         2iD2y2f/xla/cNLjAbcp6D1n+Z6AykxQxmeNQEZPPodA4R+3JrMKkFj3M7A8DmvQcBol
         9YzcYeM8BsKNuuZyPCOzz4cXtKo39O7BWciSzpIFgd336nhGij/TpJL8pRpAGs5Z19xv
         NAbA==
X-Gm-Message-State: APjAAAUGfaTf7zWjqO/W8nneF50gdixf5J2x88FV09XYIBoqBCgwMUvb
        6jzKk5v2Qarw/coEokD7weiWFqfXUy+d
X-Google-Smtp-Source: APXvYqwErECjYVXpNueYa0HIWjvJteh50MkCJRhetC7dc8IqZH/p+IT4wKYI39w5hTFScE1QUoshCZvFIfpI
X-Received: by 2002:a63:204e:: with SMTP id r14mr6562836pgm.101.1575675899839;
 Fri, 06 Dec 2019 15:44:59 -0800 (PST)
Date:   Fri,  6 Dec 2019 15:44:55 -0800
Message-Id: <20191206234455.213159-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH net] bonding: fix active-backup transition after link failure
From:   Mahesh Bandewar <maheshb@google.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the recent fix 1899bb325149 ("bonding: fix state transition
issue in link monitoring"), the active-backup mode with miimon
initially come-up fine but after a link-failure, both members
transition into backup state.

Following steps to reproduce the scenario (eth1 and eth2 are the
slaves of the bond):

    ip link set eth1 up
    ip link set eth2 down
    sleep 1
    ip link set eth2 up
    ip link set eth1 down
    cat /sys/class/net/eth1/bonding_slave/state
    cat /sys/class/net/eth2/bonding_slave/state

Fixes: 1899bb325149 ("bonding: fix state transition issue in link monitoring")
CC: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/bonding/bond_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index fcb7c2f7f001..ad9906c102b4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2272,9 +2272,6 @@ static void bond_miimon_commit(struct bonding *bond)
 			} else if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
 				/* make it immediately active */
 				bond_set_active_slave(slave);
-			} else if (slave != primary) {
-				/* prevent it from being the active one */
-				bond_set_backup_slave(slave);
 			}
 
 			slave_info(bond->dev, slave->dev, "link status definitely up, %u Mbps %s duplex\n",
-- 
2.24.0.393.g34dc348eaf-goog

