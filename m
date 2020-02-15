Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9488D15FE09
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 11:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgBOKuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 05:50:00 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53279 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgBOKt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 05:49:59 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so5126962pjc.3
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 02:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yBP4Vy7DWHI/UAiR8Qm9FYp+5N6BpaIF/sueqcJlpu0=;
        b=pD2Q6KxFwM5Bcyep8ZYeeXYwl87jqgsfH1d7+FWrs0y2wYIRXWafoof84nR0bPLfJZ
         BOCQ3y2NOs4yqIuOAx1WoA9kJ87uAljqYLwV69vdBiLzg6DbhFMVpjaZcg6r8BkqSlhC
         lcUJ6qy712Om5H7jEtU1KkyqW+e6lj2U0G33CHzi7hkM4HrWpPZlBRKeuZ3AF8UNYve1
         UH/9W2fv1Ffgx3NtG+hiwgUPbqBlgLiAzchLpreOKGxQ+P5wLu4nSpeeBmTYARMPc/Yr
         QQwBG2/weLXX1d9/0tto3QT3BYIyqKABbAjVUr+zwYuhBXvTKSLb8iPi3EUANdt7pkzK
         NW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yBP4Vy7DWHI/UAiR8Qm9FYp+5N6BpaIF/sueqcJlpu0=;
        b=ii5FfZrXs9ovowD6QPOTF04vjOnPRI27ZrebMQq5U1xUsQQJck9K9bMUt6dLzQsHEW
         9HDrkoI/OTmCCByEV1Y4PZSdkDzNJLeyoGC10tPIwIJ0u4O0MINCgyTKeBvhj+JHwZ/i
         brwWQNZnaQw+SKRbj10ajVhY/KNvKYONcrf725XBbRuOoP+YZ6O0PbbgKTyTEBIZsEeQ
         w2Yng3obWVJC6QVeBK2t4OgqpnWeDlVnPi2V/jntDKc0rctZXAQqRqrw3z79ekgaxm4f
         QfidLuVMraNae2ytvlh4ieX7IdtyMw3kn0rt4suOJkinPxAV6Eitavcg0S0PucMlQ/ia
         m6jQ==
X-Gm-Message-State: APjAAAWptEfUEco+VOyH9aLh0HsJQFEcrVnjY1DWjEwNi9EwsN0geTYM
        71T81ORoQedGRvvJCqtjn7c=
X-Google-Smtp-Source: APXvYqxzLigt5WaNyyAeX6qNRgAX1meBvu28jbJSnbd531wsrpQgnqjOkvMMrUPB7difK6AMKadJdg==
X-Received: by 2002:a17:90a:8042:: with SMTP id e2mr8926425pjw.16.1581763797443;
        Sat, 15 Feb 2020 02:49:57 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 18sm2938520pfj.20.2020.02.15.02.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 02:49:56 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 0/3] bonding: fix bonding interface bugs
Date:   Sat, 15 Feb 2020 10:49:49 +0000
Message-Id: <20200215104949.21355-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes lockdep problem in bonding interface

1. The first patch is to add missing netdev_update_lockdep_key().
After bond_release(), netdev_update_lockdep_key() should be called.
But both ioctl path and attribute path don't call
netdev_update_lockdep_key().
This patch adds missing netdev_update_lockdep_key().

2. The second patch is to export netdev_next_lower_dev_rcu symbol.
netdev_next_lower_dev_rcu() is useful to implement the function,
which is to walk their all lower interfaces.
This patch is actually a preparing patch for the third patch.

3. The last patch is to fix lockdep waring in bond_get_stats().
The stats_lock uses a dynamic lockdep key.
So, after "nomaster" operation, updating the dynamic lockdep key
routine is needed. but it doesn't
So, lockdep warning occurs.

Change log:
v1 -> v2:
 - Update headline from "fix bonding interface bugs"
   to "bonding: fix bonding interface bugs"
 - Drop a patch("bonding: do not collect slave's stats")
 - Add new patches
   - ("net: export netdev_next_lower_dev_rcu()")
   - ("bonding: fix lockdep warning in bond_get_stats()")

Taehee Yoo (3):
  bonding: add missing netdev_update_lockdep_key()
  net: export netdev_next_lower_dev_rcu()
  bonding: fix lockdep warning in bond_get_stats()

 drivers/net/bonding/bond_main.c    | 55 ++++++++++++++++++++++++++++--
 drivers/net/bonding/bond_options.c |  2 ++
 include/linux/netdevice.h          |  7 ++--
 net/core/dev.c                     |  6 ++--
 4 files changed, 60 insertions(+), 10 deletions(-)

-- 
2.17.1

