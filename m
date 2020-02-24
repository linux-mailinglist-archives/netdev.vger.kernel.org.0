Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9654E169F53
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgBXHgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:02 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43288 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXHgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:02 -0500
Received: by mail-wr1-f52.google.com with SMTP id r11so9068534wrq.10
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7SFParyE2pUEqCppZexl4SaZpVZqE2G7fiK9Rx4wVMc=;
        b=nxvhzt8Jc8HcaUS+j6ljRomynckVZ1+tEXszgT3HJvGsQB3guAFyRReoxdboo9LyPK
         erv/W8Xx1iVWVhzhjj1vNWsxRh1XRMGnyevYZ1GKjIsPvT9rfhtqPuad/ru1mp2dSvOm
         hibutb131AeOjCgzW8y8nWTP3m3DMVb8LV7fG6dvilSqF6T5O1K9GQaWpvdFWNvjzdQE
         yc5d3/ot5Xdt4tGnvGh03dHjXEJ9jFBEXTAKOGvjf3+V363jJ73QKTt9JAnEf3vlJJyv
         39kTlGWjZG+4/a5KPe3ZbgrNYpmoUod62k+9JJ7qYyQTRuT0nZiZgyEMii/sV6RGgO/n
         +xiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7SFParyE2pUEqCppZexl4SaZpVZqE2G7fiK9Rx4wVMc=;
        b=pvOaXYZ8UXdCnSkaM95nSdTznKkgTMb2qzfW9MmTkMw0CjtZ65IdS3n9TZgkSq2tdm
         DYYE4MqRf3F4Juo4E7CaHzyZZ2TNjqLthfsyB4aN26ryHCUNhWxDLkzWCIFhhZ3wKhwn
         iysznwz7Yj1gxS3PfNl0HjMUS2I8I3fKnyns6an14J8R5eFTyb2m9LtO0cPId+xOZSzA
         vYFgmLbtjMGLHynca1Kza/rr2ByzaChLqxkPQGS3Ybpn9BlcCaOYM54x4+RqC5T7mp9Y
         6xdejfU+2qq4+4tWIuEW5pRcE5uxDdE9NtTnXzQgCwBcjK/U5vJIDTYPYMn8+a2meQ3k
         mUig==
X-Gm-Message-State: APjAAAV/3rwMh7m7Nji9nFT5PnO5vPd3hLyqjUqX7lyAz4JQMNOOpaoI
        f/Hj3+XWu9y6EEgQhNqc9A97CIU16N8=
X-Google-Smtp-Source: APXvYqx+g3ViIjYYu2K7gy7WMj5l2vlEeXRqubzPexSiv9IGQXNsIYUsBBbFmKAfUC9DIdamBKdHtA==
X-Received: by 2002:adf:f103:: with SMTP id r3mr65104872wro.295.1582529759917;
        Sun, 23 Feb 2020 23:35:59 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id u8sm17254596wmm.15.2020.02.23.23.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:35:59 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 00/16] mlxsw: Introduce ACL traps
Date:   Mon, 24 Feb 2020 08:35:42 +0100
Message-Id: <20200224073558.26500-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset allows to track packets that are dropped in HW by ACL.

Unlike the existing mlxsw traps, ACL traps are "source traps".
That means the action is not controlled by HPKT register but directly
in ACL TRAP action. When devlink user changes action from drop to trap
and vice versa, it would be needed to go over all instances of ACL TRAP
action and do change. That does not scale. Instead, resolve this
by introducing "dummy" group with "thin" policer. The purpose of
this policer is to drop as many packets as possible. The ones
that pass through are going to be dropped in devlink code - patch #6
takes care of that.

First four patches are preparation for introduction of ACL traps in mlxsw
so it possible to easily change from drop to trap for source traps
as well - by changing group to "dummy" and back.

Jiri Pirko (16):
  mlxsw: spectrum_trap: Set unreg_action to be SET_FW_DEFAULT
  mlxsw: core: Allow to register disabled traps using MLXSW_RXL_DIS
  mlxsw: spectrum_trap: Use listener->en/dis_action instead of
    hard-coded values
  mlxsw: spectrum_trap: Prepare mlxsw_core_trap_action_set() to handle
    not only action
  devlink: add ACL generic packet traps
  mlxsw: spectrum_acl: Track ingress and egress block bindings
  mlxsw: spectrum_flower: Disable mixed bound blocks to contain action
    drop
  mlxsw: spectrum_acl: Pass the ingress indication down to flex action
  mlxsw: acl_flex_actions: Trap all ACL dropped packets to DISCARD_*_ACL
    traps
  mlxsw: core: Allow to enable/disable rx_listener for trap
  mlxsw: core: Extend MLXSW_RXL_DIS to register disabled trap group
  mlxsw: spectrum_trap: Introduce dummy group with thin policer
  mlxsw: spectrum_trap: Add ACL devlink-trap support
  selftests: introduce test for mlxsw tc flower restrictions
  selftests: pass pref and handle to devlink_trap_drop_* helpers
  selftests: devlink_trap_acl_drops: Add ACL traps test

 .../networking/devlink/devlink-trap.rst       |   9 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  77 ++++++---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  83 ++++++----
 .../mellanox/mlxsw/core_acl_flex_actions.c    |   8 +-
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   9 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  37 ++++-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  21 ++-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  59 +++++--
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   2 +
 include/net/devlink.h                         |   9 ++
 net/core/devlink.c                            |   3 +
 .../net/mlxsw/devlink_trap_acl_drops.sh       | 151 ++++++++++++++++++
 .../net/mlxsw/devlink_trap_l2_drops.sh        |  28 ++--
 .../net/mlxsw/devlink_trap_l3_drops.sh        |  44 ++---
 .../net/mlxsw/devlink_trap_tunnel_vxlan.sh    |   4 +-
 .../net/mlxsw/tc_flower_restrictions.sh       | 100 ++++++++++++
 .../selftests/net/forwarding/devlink_lib.sh   |   7 +-
 19 files changed, 539 insertions(+), 116 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_acl_drops.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh

-- 
2.21.1

