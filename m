Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DBE127B20
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfLTMfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:35:46 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35455 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbfLTMfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:35:46 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so9096216wmb.0
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7azrRTYtOBMTK2wqfFPbNvM8WgjDDbMQs/ahq7jhyGs=;
        b=qq3vZ2x8ksyOrjVh4NtnYUBt+gqCozyq1DUzXUiCxCmD9luHZRCM92zxvyy3+TtC2I
         VECEJaQBl376ncHOsfHpgkcjvCKVkrQuUNrC7qOF6HCqReAO3OyjN1DuiqO0UHJjjPcB
         QBeIwkC0FFLXOdCDsIR5Em+xdzmc6kSkNpSsijSxZndVmsGJLf51hH0awb1UG8u1cNDt
         atQSO6JXA1bMsS8Xc4VO5pUp3N3a9DtkG9/NgJ5193+m6u2WeL9flJ/pVTW4B13T/V99
         ZCOEvDjU5BS2qJZ4kb+jahwJkxjtOS1SOFnBRclZteFBlHvPM/7sk6UkdNJ6FBtoWjzS
         gJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7azrRTYtOBMTK2wqfFPbNvM8WgjDDbMQs/ahq7jhyGs=;
        b=AoIrXjGXsnguxvu9M7TOQ2wte+dNRaekAQ1t5MkgF0BGdqLEYdZvWEk0Pal/No83//
         8/H2+qtvTRy1uMvtnFqV5Z0UXSnOB3dMzMPO1aNBtj9Kr1UQdvHH370oW6OuxPNiSNj3
         cdC4RoihYxnLvQMY0ujnYPsb6+6t5StV6fNZP7ydiSNXSyuvXZEiBuGEJ2suGZaMoCsZ
         9rxz0gnEEHT1wGmVZQ+b5jgKiPGqMJcSJmqqmuQW119QYD7+pbJyKRJZP7uFZJfknlK5
         4pZftN7TJLhW/JXU9JZHaoQwNn3wj8O3YoWpXi/DISMwHQA+qbYbipOLMI4aBZJTsXoO
         3Vhg==
X-Gm-Message-State: APjAAAWfxGLuQWfS9vjunu4QDyayOv//Uz5fJhU9LUau9J28zwvOju4j
        NVGRsfNa3p/ZcuAaP1vLXa/7oRDscsU=
X-Google-Smtp-Source: APXvYqwfegY5Vw17nlsW0fu5VuMXIjnCzMV5QgLQfzmXB+sQUH1TWMBQ4O/IqGCde2V0Rvov0EAgag==
X-Received: by 2002:a1c:4e03:: with SMTP id g3mr16757158wmh.22.1576845343726;
        Fri, 20 Dec 2019 04:35:43 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id s15sm10407885wrp.4.2019.12.20.04.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 04:35:43 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next 0/4] net: allow per-net notifier to follow netdev into namespace
Date:   Fri, 20 Dec 2019 13:35:38 +0100
Message-Id: <20191220123542.26315-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently we have per-net notifier, which allows to get only
notifications relevant to particular network namespace. That is enough
for drivers that have netdevs local in a particular namespace (cannot
move elsewhere).

However if netdev can change namespace, per-net notifier cannot be used.
Introduce dev_net variant that is basically per-net notifier with an
extension that re-registers the per-net notifier upon netdev namespace
change. Basically the per-net notifier follows the netdev into
namespace.

Jiri Pirko (4):
  net: call call_netdevice_unregister_net_notifiers from unregister
  net: push code from net notifier reg/unreg into helpers
  net: introduce dev_net notifier register/unregister variants
  mlx5: Use dev_net netdevice notifier registrations

 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  14 ++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.h |   1 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +-
 include/linux/netdevice.h                     |  17 +++
 net/core/dev.c                                | 118 +++++++++++++-----
 10 files changed, 132 insertions(+), 42 deletions(-)

-- 
2.21.0

