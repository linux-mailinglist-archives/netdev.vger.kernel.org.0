Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF472C5AA
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfE1Lst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:48:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53530 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbfE1Lst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:48:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id d17so2559620wmb.3
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=7JSd6VoTAaiDuSQ6CgfNAVENHdH7ChHJqYIRhCoU1IU=;
        b=zhMtqfa4K5x4PV+NBA/DZIIWZCCN8dySiuFdzGPTQHd1DtY3+gqq3tqDSX+n6ld/C6
         8N+JY3CX5XSKWRXzsqZLTjy5AbCIAIfte3DLY1avcAwTV0Tz69A7BeskyVPgTDpfO/RM
         87uxi6epRsPVifCiIq+phGEYb0f823Td/NJ5mfOXAo6v8K7o9Fp7KpM3yxHIzsrsQsnq
         OGLV2bfuFBYLTJUdV6QY9USyHJQzZrufmc6eMc5CUH+g/z/jU1ArHJ2wf5XpKqbFAhQy
         X5Pb2JI63T4zSJH/4AWS8rf+l1FwhWIojaDBbPm6Mj7NNg8Yby9RdOSVkCu0NHI3BTNZ
         McNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7JSd6VoTAaiDuSQ6CgfNAVENHdH7ChHJqYIRhCoU1IU=;
        b=oiyc/hqqoEuYj4lN/eRuAZ0FrNGCo9Y0uaRJcrejXrrP4BKdFqVvCAb6WB8MzhIVuR
         sDE7sK4nctJqGANLOvst5X+LMC+VHf72Dp4VJnlhfhMG3bQZVOFOK37oqy7qrvhcSNg6
         nZZ0UaDDWvNaXABfwQ3A1f30DakWG06DwkDON9LYdbAkv+KlzMhgsDe/QL/ZqOCBVDZO
         AB4LhvN/SP/CrU3LrbP3F5FuTRRoyEPehVlm8cJfGneG9QI7+mPAeAj6zHdRRXsyWuTY
         s9FGtbargM6/yHWq9oZ1UKZwdQrucRzyszvNZIjtSM+T/hYKMpnHQw6HSwNaZN5+n6Si
         DGrQ==
X-Gm-Message-State: APjAAAX41NtTpkQf/I96/pIrnwIX1tc2DT0il4JGYiot0pAVlIzRg4o+
        iXUEfmdhOXXkDUjQeZHDU8hHwbi6ULQ=
X-Google-Smtp-Source: APXvYqz7BhirSh72B0PjlaMWYNFBZi6fdQWgwhBsB3Yigd4Rc3UHN9M89Dl1G7Qbsqkj5DbjOdyC3Q==
X-Received: by 2002:a1c:4083:: with SMTP id n125mr2769489wma.54.1559044127247;
        Tue, 28 May 2019 04:48:47 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id c18sm16793337wrm.7.2019.05.28.04.48.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:48:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 0/7] expose flash update status to user
Date:   Tue, 28 May 2019 13:48:39 +0200
Message-Id: <20190528114846.1983-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

When user is flashing device using devlink, he currenly does not see any
information about what is going on, percentages, etc.
Drivers, for example mlxsw and mlx5, have notion about the progress
and what is happening. This patchset exposes this progress
information to userspace.

Example output for existing flash command:
$ devlink dev flash pci/0000:01:00.0 file firmware.bin
Preparing to flash
Flashing 100%
Flashing done

See this console recording which shows flashing FW on a Mellanox
Spectrum device:
https://asciinema.org/a/247926

---
Please see individual patches for changelog.

Jiri Pirko (7):
  mlxsw: Move firmware flash implementation to devlink
  mlx5: Move firmware flash implementation to devlink
  mlxfw: Propagate error messages through extack
  devlink: allow driver to update progress of flash update
  mlxfw: Introduce status_notify op and call it to notify about the
    status
  mlxsw: Implement flash update status notifications
  netdevsim: implement fake flash updating with notifications

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 -
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  35 ------
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +-
 .../mellanox/mlx5/core/ipoib/ethtool.c        |   9 --
 .../net/ethernet/mellanox/mlx5/core/main.c    |  20 ++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   3 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  11 +-
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   |  57 ++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  15 +++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   3 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  75 +++++++------
 drivers/net/netdevsim/dev.c                   |  44 ++++++++
 drivers/net/netdevsim/netdevsim.h             |   1 +
 include/net/devlink.h                         |   8 ++
 include/uapi/linux/devlink.h                  |   5 +
 net/core/devlink.c                            | 102 ++++++++++++++++++
 16 files changed, 305 insertions(+), 91 deletions(-)

-- 
2.17.2

