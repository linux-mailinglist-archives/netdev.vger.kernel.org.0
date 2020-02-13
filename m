Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE39515CB0E
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 20:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgBMTUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 14:20:46 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42078 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgBMTUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 14:20:45 -0500
Received: by mail-pl1-f196.google.com with SMTP id e8so2715084plt.9
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 11:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DsageZ48MrIkiBYIgPN+zB7G6LpRpVRQvl1dNc6DGMs=;
        b=ffOtHuGu5ofmwI2gagL3kuJryTvw9JbZBHHWlAQE2MALnG+SSAYWcn7yaqkkXPIaw1
         09CKtfUR0CWOoL38/8KW4HDs4HAeW78Y+KX6HM2yynStmEbLGjLkJO4dKBWIcn0D37/g
         HUGFDbLfVW122y/TspkFl29SdvEE8V3o8aIchs6uno2yMNg0PLzIpjVqECwoqF8mrMDH
         F5cXr9d9nL1hHmqDO5BmoTA5uNEf/29CelwFKaX9N+WBMbq0F71fdqChsCa0kxjLZ54t
         W6kToLJmtf1deTMhnOCziqSDTBJArkh/2yALlXA9sPPxzUfhGnCtsHNWtaXToVSVaxf9
         AsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DsageZ48MrIkiBYIgPN+zB7G6LpRpVRQvl1dNc6DGMs=;
        b=BKYamMxUiaiBAfeqDDEbNwY7mq3wKEAA9F4bRQGRWE1kMnbeYG07c2oLNCeag+mIYl
         oMpCuuytRn0A5V3UFNu3yGGQF0IqAwtXVZrXAv17eRH0ilxUlz2Bhi44OJJtxPX8xidN
         LVz+uzCaMuYuH/ULSLuIh6/iBR3OdvEhlVlC8L2tbTKHJ1hv8JNnYjgBE3TtZ8X8TM47
         IBZM8OPELvK/qhkj7N//iCHOffZtjXF4zQj9CPPWauFLKmE10CC0efnlnnOrbQ160J/w
         jNSrqIrIyCCrN/vwTNKcBiwdEGw0Wexi+pTVodU6NEzR9HTrSbS9hsorchY0d1yDv2rv
         zZOw==
X-Gm-Message-State: APjAAAXdE0DYgxK4PTYjbZvD5igtrPUHoXmECW4E/em4ZHKHwcTnrlTc
        cc06t55RkqAZCxvZu8D+PPU=
X-Google-Smtp-Source: APXvYqxZ/JziXEjI4UHjXHYmmKxIUmNVg2Ik3Q8T9fwIKCiBmRKjPm/iDfpmRGRIMSWF3RJsn75URA==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr6680134pjg.111.1581621645132;
        Thu, 13 Feb 2020 11:20:45 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id y24sm4281700pge.72.2020.02.13.11.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 11:20:43 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/2] fix bonding interface bugs
Date:   Thu, 13 Feb 2020 19:20:34 +0000
Message-Id: <20200213192035.15942-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes two bugs in bonding module

1. The first patch adds missing dynamic lockdep class key update routine.
After bond_release(), netdev_update_lockdep_key() should be called.
But both ioctl path and attribute path don't call
netdev_update_lockdep_key().

2. The second patch changes bonding stats routine
In the current code, bonding interface collects stats of slave interfaces
when dev_get_stats() is called.
But, this has several problems.
1. Possible imbalance lock/unlocking.
2. Show incorrect stats info.
So, this patch changes bonding interface stats routine.
In addition, it fixes lockdep warning.

Taehee Yoo (2):
  bonding: add missing netdev_update_lockdep_key()
  bonding: do not collect slave's stats

 drivers/net/bonding/bond_alb.c     |  14 +-
 drivers/net/bonding/bond_main.c    | 222 +++++++++++++++--------------
 drivers/net/bonding/bond_options.c |   2 +
 include/net/bond_alb.h             |   4 +-
 include/net/bonding.h              |  17 ++-
 5 files changed, 142 insertions(+), 117 deletions(-)

-- 
2.17.1

