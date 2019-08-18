Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F829185E
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 19:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfHRRgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 13:36:12 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35802 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRRgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 13:36:12 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so8836529qke.2
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 10:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gkQ3DSRmCtIetRerRd8qvoxhzVV/Be41oVCqq3zqMZM=;
        b=A7zgRfGIVxfGEMdqOBhe8gJaGEMClKHmtahsdK6gTgzSipXTQesLvEKCYQPB4u6DnA
         VyCkrfMja43wclr2lWrplmKmeCdhXGq62vMInf1C33Au+kmmrB3W4yKPG69SkRqWNVkU
         tDwmOzlVjEX6RboNoBIxWSpny4ZNJ1zV9vKdEoVNA4xFl3mXVzWSBWxWRME6MCCI5ah9
         GlK1RwKMwvJUCdT1YoUGBJxBM9BVcqCyTi2onHaeyx2qmsVm5Si8t8z9Q3Bvt93BvMlA
         ZUTpwPNksDYqDTjs1mNZERkv1xwgSOkJF59rQ19BaXTOAeEzcPOudkzJdeGP/pj2j9NT
         j8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gkQ3DSRmCtIetRerRd8qvoxhzVV/Be41oVCqq3zqMZM=;
        b=BmYAZewMc4Pw4S25pdCkJrItsDJxJfhsXv7HxGvLTvfbpphO4zmveJV4+DZhP9gZw0
         WDBSbm8SQ4VoJ+UZLfGV99fzaH0D9ISU7E3j73XMewg3IAN+OLd1s5HT+5piLy8ZUEJi
         V1k/ZOjBkYHnV5+KgIGtfjg0KysSyZoSnB71hmFoUaa0r85i3eQjAtj1VpHvRuUcIwc4
         9UWSPlCcFDGIinGtsb46SSDUbtND0c3F04ce0oPmd1ZdHGgF+hRqwi2OIF6EAtnptnGa
         QdmoqzvS3HZXPFDjF3+kQH1SxFDQY6Rm7TWIi5Ngl3g/Rnd2lpgHOt2Ue27kPA8VWqk0
         4qSw==
X-Gm-Message-State: APjAAAVDQUKJomO4jsKXFDZL8X56kzQ8ty7xW9D5cisnscwRnJdA6cdf
        73Tc4Wg5EHo5q4eJ80FGLd1OTGOj
X-Google-Smtp-Source: APXvYqxVenljdpXQO0sX7Y6UfwVHSp7/gu2U9sm00X7tIPzd5up8I47FcjUOxnLH3nWGgOLuQzifDg==
X-Received: by 2002:ae9:e417:: with SMTP id q23mr16632298qkc.54.1566149770889;
        Sun, 18 Aug 2019 10:36:10 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q28sm7296762qtk.34.2019.08.18.10.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 10:36:10 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/6] net: dsa: enable and disable all ports
Date:   Sun, 18 Aug 2019 13:35:42 -0400
Message-Id: <20190818173548.19631-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA stack currently calls the .port_enable and .port_disable switch
callbacks for slave ports only. However, it is useful to call them for all
port types. For example this allows some drivers to delay the optimization
of power consumption after the switch is setup. This can also help reducing
the setup code of drivers a bit.

The first DSA core patches enable and disable all ports of a switch, regardless
their type. The last mv88e6xxx patches remove redundant code from the driver
setup and the said callbacks, now that they handle SERDES power for all ports.

Vivien Didelot (6):
  net: dsa: use a single switch statement for port setup
  net: dsa: do not enable or disable non user ports
  net: dsa: enable and disable all ports
  net: dsa: mv88e6xxx: do not change STP state on port disabling
  net: dsa: mv88e6xxx: enable SERDES after setup
  net: dsa: mv88e6xxx: wrap SERDES IRQ in power function

 drivers/net/dsa/b53/b53_common.c       | 10 ++-
 drivers/net/dsa/bcm_sf2.c              |  6 ++
 drivers/net/dsa/lan9303-core.c         |  6 ++
 drivers/net/dsa/lantiq_gswip.c         |  6 ++
 drivers/net/dsa/microchip/ksz_common.c |  6 ++
 drivers/net/dsa/mt7530.c               |  6 ++
 drivers/net/dsa/mv88e6xxx/chip.c       | 64 ++++++-----------
 net/dsa/dsa2.c                         | 98 +++++++++++++-------------
 8 files changed, 112 insertions(+), 90 deletions(-)

-- 
2.22.0

