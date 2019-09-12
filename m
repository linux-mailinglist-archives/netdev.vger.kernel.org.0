Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FB4B0AA1
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 10:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfILItu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 04:49:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43697 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfILItu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 04:49:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id q17so22795208wrx.10
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 01:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPqHMrarnj/eqlovwm4Ti2RJQ9+Z2LObwoWgr5fDQsE=;
        b=h89vlR+f5rkMwDGsFE/3Y5NQOaf0Phw9X7yAOtlMbvpvPPQg5f6XKiBIV5FtEWK4Kq
         2OZAISqwLm1leImVYjrOAYtW4Nwn3PRvqs8sCQzxFgeulfsLNZ5diO2CND05JjmmdlkK
         NvdcigujbQE2kQ+b+tbAUie2JvMpKPg+tX5sluko5dV4s9i5XoAUjbjJIPglU6S8dLcq
         zCuQbLcYVSUp/JuZOZn29x3crZZgD/TVWqXL14l7wi8ATlJnoqE7p3wcffkiIZknZKIX
         RYijiJe47EZ7XZ30hLtrL19YrkGnNgF1rbaMEpd1zUer2YW+GLXsYtqkJ4K5TfBKAbR9
         gyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPqHMrarnj/eqlovwm4Ti2RJQ9+Z2LObwoWgr5fDQsE=;
        b=pKRlU1wzfFWyG25QiuA8rrEzUhR7PpnvEcmXL3qCdR0jJPq7yKY+6QAbDw7MG6NWwc
         C/aXOXMbTqRBydaPCQ7yBUkNlGz8zhKOPMTYKqdVUo4xDXkEcom9u9z8WdZ+2ywK81Kz
         qk69co4Hbu+pm/NlNGGkA7MGEGw88r1LMwfP+jXpz4vIMPoi5BiB2feT0zGY9L4FBCUp
         7TO2Ny6GPJGuWrmuor+6hSRGSas7Ipvxc3WjtYFLDYywL2nI7KEVnLXO8ZPe7Kt0QKgm
         lpyQK2RgaSbrCwT0vEDOTiU851hkAUI3swirZBRAbDBGNhYuYe0Ca0IJXwbeheJVxxWB
         fK7w==
X-Gm-Message-State: APjAAAW0/T6NGiTURbXpe/QI1IvJZgj8tJkEMA2CBT1rKamU28TCE1JU
        vJCYUcJw1OMBm34SiXd62prsOyPi+Js=
X-Google-Smtp-Source: APXvYqwLS81pYsSHQLLcW5ZTRiSSKr1cmv9eDmzQmYWyRVFmswFPIRCVoeNdkSTs2j8oiAdMVfSZdw==
X-Received: by 2002:a5d:6691:: with SMTP id l17mr32138197wru.262.1568278187347;
        Thu, 12 Sep 2019 01:49:47 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s12sm34028654wra.82.2019.09.12.01.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 01:49:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v3 0/3] net: devlink: move reload fail indication to devlink core and expose to user
Date:   Thu, 12 Sep 2019 10:49:43 +0200
Message-Id: <20190912084946.7468-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

First two patches are dependencies of the last one. That moves devlink
reload failure indication to the devlink code, so the drivers do not
have to track it themselves. Currently it is only mlxsw, but I will send
a follow-up patchset that introduces this in netdevsim too.

Jiri Pirko (3):
  mlx4: Split restart_one into two functions
  net: devlink: split reload op into two
  net: devlink: move reload fail indication to devlink core and expose
    to user

 drivers/net/ethernet/mellanox/mlx4/catas.c |  2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c  | 44 ++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h  |  3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c | 30 +++++++++------
 drivers/net/netdevsim/dev.c                | 13 +++++--
 include/net/devlink.h                      |  8 +++-
 include/uapi/linux/devlink.h               |  2 +
 net/core/devlink.c                         | 35 +++++++++++++++--
 8 files changed, 106 insertions(+), 31 deletions(-)

-- 
2.21.0

