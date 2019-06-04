Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FB834919
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfFDNkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:40:47 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43203 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfFDNkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:40:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id r18so6874235wrm.10
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=KPEi1VZnC+wQGcsyvJN0joeJerQl2xi+JECEaj2XKYw=;
        b=PwL/2F2cgPTAUkKjdA53T9XPSyxSW/+8DWRar9fOyFKirLXs5+KEKd7VoukKBJvPtg
         THWkm7D++D1bB+tbD/anqrGfQF+VFreXzM96KNhVP4IPtbyDDLQAJYSNgmAFzxl4MOQt
         BD2PEeUL3wgpzqncy5cIpihYDpvlbACc4V767n6rOlcVizCXchmkfCqGPHagXDY/ti+j
         CgcDTOlRe0BwNq7jv+QSjG1/C8vaM1fg+VDQxm3YzwjDYYmwZtziKhQFgg3XPqbdYw3d
         akxFebJjt/Kz6Eg5/tskBZOAaALdq+vN0GYVLFWiQJwCfMLDQ1vhqMy8sYlQxR1bei+R
         LXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KPEi1VZnC+wQGcsyvJN0joeJerQl2xi+JECEaj2XKYw=;
        b=PUDw6UPA3pf4goGpMxaDC94CWMdLk7lj0Os5MQm0TIyengV6Jd13cEW2i93tn2ndVt
         x7jM9LiXdCrqX+aMxVmuYdZ4qjDTZ/pJc6oOaclGL7spKWoF1h8kfQVu/XDSIHBAX12m
         +A7556J3JZktE6t5mAVXbb3xHUKEGQiWuTOaeLAX8RWvjQU6sVGFaoN9FFLlafE0cCFG
         vhAIFD+UbOD2VFP6vb6Rh1ahtQaGY9Lx/lRJB974atrXRT0DZurxjZxTA3NK1DMJ06jg
         vKpPaXYCHCxwtLQpyMdb3p9GiLlopriTr89EhcgF4i3mbg6NF9sXMWmLXzPww0hK0zXU
         ME+Q==
X-Gm-Message-State: APjAAAWcc5sJ4xXSuM1lOZHA6DdVwbqU6NFnpe6basUeWkZ4hsc4O5MP
        Ki9tkQHgCYgq20w/GeKDw6ogzcm4oNTuT4xQ
X-Google-Smtp-Source: APXvYqzNnje69eeQOoWSZE8k2nrZ+n1kF2tEPeEm8wD11ASGODMisyFjvHSNa8fJCSZvRkhHTppi9Q==
X-Received: by 2002:a5d:4992:: with SMTP id r18mr6753028wrq.107.1559655645555;
        Tue, 04 Jun 2019 06:40:45 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id b17sm8691643wmj.26.2019.06.04.06.40.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:40:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 0/8] expose flash update status to user
Date:   Tue,  4 Jun 2019 15:40:36 +0200
Message-Id: <20190604134044.2613-1-jiri@resnulli.us>
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
v2->v3 only adds tags and the last selftest patch

Jiri Pirko (8):
  mlxsw: Move firmware flash implementation to devlink
  mlx5: Move firmware flash implementation to devlink
  mlxfw: Propagate error messages through extack
  devlink: allow driver to update progress of flash update
  mlxfw: Introduce status_notify op and call it to notify about the
    status
  mlxsw: Implement flash update status notifications
  netdevsim: implement fake flash updating with notifications
  selftests: add basic netdevsim devlink flash testing

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
 .../drivers/net/netdevsim/devlink.sh          |  53 +++++++++
 17 files changed, 358 insertions(+), 91 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/devlink.sh

-- 
2.17.2

