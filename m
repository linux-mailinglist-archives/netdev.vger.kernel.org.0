Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBB026EA57
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgIRBNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIRBNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:13:35 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1371C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id c3so2091517plz.5
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Z4Fh5hhLpCWvyGPqWiAo8QcMTWj4mTqVrMlNPfbso5U=;
        b=3zarVWece3uDKfodrgw8+qxdTMo0p4YwKa3MnAkYFVdJ9vi8lVXrJOF8fFGd+/dBUH
         rrMakmu4T+Z5O1uwkAueW4BhlLLJumqrZi2XByxuBMLoRbsbIZ9fJunW4xOz8D4/MxHB
         nBcitPUrkS7b7Vsyqgioybg9S8vze+QS4OX6ZoD/tiDOWLqS9TSquKv7x7iW5sTzDWTO
         vDh2qL3IQhS/hLv+5XfgomR6ZzsF6xsLWgINPc4MgCegwvMXq82/BgF62Khojlh6dvch
         jgc4m6UDVqLKXuZ1ix3T50WVP1IdnQqN+nQG5/ZonqthRXkOi3+Am1aZ3hEP/iC2E7+Y
         P/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z4Fh5hhLpCWvyGPqWiAo8QcMTWj4mTqVrMlNPfbso5U=;
        b=FNP0EMqJ9L2Q+W6YUa3I+r71Q9+5tjbrSsCWV/2nFraX4I0KDmK/pTxc/mkpFMlgiE
         LOrEocwSzZQxifASguB8mHIfhxVygpZ8BHilpzSidqDVbSARN3LKFzodZswDM7bWhnav
         zfrfie9aZ1bTM9ZPTKrK10U1IpSohO6OBYMXDgEV+zlfQkYc0Q5SnDv6t+vcMX4JiMNv
         t/CP5fge2DTz6GBebYiRCwM2oK4Gq3dxukN3N470EmL7OVLzu6Lkos0I6Hugo/6NZpyF
         j0oCEivFemKo+F750+VSxVgp7dNrghy9+WRFotvTRZPz6KZpUgLzHCHH8ChXoEApMIkD
         tlDw==
X-Gm-Message-State: AOAM530g74+75dv1y7gz7kpSEc82Xm6UsH77uUVV+1QjiIOANfiaUQyN
        8s8Pshbmo42ruM6/qSvk5IirCOfmNQ9PnA==
X-Google-Smtp-Source: ABdhPJwOemuTut6NM8b2yJgBGttUiUYZWnZFIHYgf6Rrloa8N7o+aI9jm23Wt6bBHxV63ryZaY1huw==
X-Received: by 2002:a17:902:8d84:b029:d1:9bc8:258c with SMTP id v4-20020a1709028d84b02900d19bc8258cmr31622636plo.18.1600391613833;
        Thu, 17 Sep 2020 18:13:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id e19sm955701pfl.135.2020.09.17.18.13.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 18:13:33 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v5 net-next 0/5] ionic: add devlink dev flash support
Date:   Thu, 17 Sep 2020 18:13:22 -0700
Message-Id: <20200918011327.31577-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for using devlink's dev flash facility to update the
firmware on an ionic device, and add a new timeout parameter to the
devlink flash netlink message.

For long-running flash commands, we add a timeout element to the dev
flash notify message in order for a userland utility to display a timeout
deadline to the user.  This allows the userland utility to display a
count down to the user when a firmware update action is otherwise going
to go for ahile without any updates.  An example use is added to the
netdevsim module.

The ionic driver uses this timeout element in its new flash function.
The driver uses a simple model of pushing the firmware file to the NIC,
asking the NIC to unpack and install the file into the device, and then
selecting it for the next boot.  If any of these steps fail, the whole
transaction is failed.  A couple of the steps can take a long time,
so we use the timeout status message rather than faking it with bogus
done/total messages.

The driver doesn't currently support doing these steps individually.
In the future we want to be able to list the FW that is installed and
selectable but we don't yet have the API to fully support that.

v5: pulled the cmd field back out of the new params struct
    changed netdevsim example message to "Flash select"

v4: Added a new devlink status notify message for showing timeout
    information, and modified the ionic fw update to use it for its long
    running firmware commands.

v3: Changed long dev_cmd timeout on status check calls to a loop around
    calls with a normal timeout, which allows for more intermediate log
    messaging when in a long wait, and for letting other threads run
    dev_cmds if waiting.

v2: Changed "Activate" to "Select" in status messages.

Shannon Nelson (5):
  devlink: add timeout information to status_notify
  devlink: collect flash notify params into a struct
  netdevsim: devlink flash timeout message
  ionic: update the fw update api
  ionic: add devlink firmware update

 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |  14 ++
 .../ethernet/pensando/ionic/ionic_devlink.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_fw.c    | 206 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_if.h    |  33 ++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  27 ++-
 drivers/net/netdevsim/dev.c                   |   2 +
 include/net/devlink.h                         |  23 ++
 include/uapi/linux/devlink.h                  |   3 +
 net/core/devlink.c                            |  61 ++++--
 10 files changed, 339 insertions(+), 35 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_fw.c

-- 
2.17.1

