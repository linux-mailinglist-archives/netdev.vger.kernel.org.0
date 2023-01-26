Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5E667C53A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbjAZH6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbjAZH6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:58:43 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2B866EED
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:41 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id e19-20020a05600c439300b003db1cac0c1fso2704874wmn.5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Kw7SSasx4Ds6AkKOvqt4mIgY3YdxENH5MI6gCSX4S3c=;
        b=VLlFqv2QThf36OI0FCmQjSQhBlIYSCy0d6Q6fIrNCrgfzGBTdjhPs05YM+KSqysPfn
         gfWAe+Ve7PodfVThCi9FHonAmRNjGB7V48TB7+vwQQN3Wnwr0weBO3TgJOvzdeJdq4uc
         U28Z/9krHpaJbQ/Nsg3iP2aDD4ftKX+ZD1b9GVs9FQpY1JoSQ8RIt81fExAXPzDi6HND
         OaGw9ASW+3dHLTjJqmUusKJOKwSv05tglwH/cctIPSI5q9L8YuRj4GwFO1zRQg3EjZ9n
         kIfmXxgmCl8jiLUKzBfOyK0XNc+bqqI2pq+jwq8yFCYb45ycfeER943F1y6RVZDMtiAn
         KN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kw7SSasx4Ds6AkKOvqt4mIgY3YdxENH5MI6gCSX4S3c=;
        b=XxETak8lFc1sLdzH+JxwfhBc/CXPEMWKtnZ6LTp5kOKRcPqCj8G+BMkzQcA/9V/CF0
         QJTpG3aZdkDJ5dsZpf66uG871CsIPJaJ1hDY6fACHDaghhaDTB6FMJYb+2sy0JNR7wh/
         et0z/cr81zl3bYtwt0NE8dylnW6gmSlsp7YVALcR5glyJxeFLY7fCU3hK7n8gCSPV3+u
         XTnumdZa12eMCZ3fPpFsFuFiuVY/eY5KmR4wKwph0Va6gf6lGav4kYdqoVu/UA7+XdyX
         +hrcPIPZN6kZWpIZY/x3hxVOUBHgq8DNF/hIXsjwDAS9ipdQ/uJb/OEd6faBgSp7ys6s
         T/bw==
X-Gm-Message-State: AFqh2krDKsTJYkV3aC8H77GcL9u5z3VDnHSASPU1oXZ1v+jOQ3kRRvqo
        zqX86zpZANhrOT8ZQP6a0LSwqtV4/cdvP7o4iuEDNw==
X-Google-Smtp-Source: AMrXdXt6YrZsnk610emjE3nATAsmLsT9zepb4YFpch/rG5kMnoUdlf+dgoBPAQwpBqjls2276UZo6A==
X-Received: by 2002:a7b:c45a:0:b0:3d1:ed41:57c0 with SMTP id l26-20020a7bc45a000000b003d1ed4157c0mr42351572wmi.30.1674719919876;
        Wed, 25 Jan 2023 23:58:39 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n24-20020a7bcbd8000000b003daf7721bb3sm3715939wmi.12.2023.01.25.23.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:39 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: [patch net-next v2 00/12] devlink: Cleanup params usage
Date:   Thu, 26 Jan 2023 08:58:26 +0100
Message-Id: <20230126075838.1643665-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

This patchset takes care of small cleanup of devlink params usage.
Some of the patches (first 2/3) are cosmetic, but I would like to
point couple of interesting ones:

Patch 9 is the main one of this set and introduces devlink instance
locking for params, similar to other devlink objects. That allows params
to be registered/unregistered when devlink instance is registered.

Patches 10-12 change mlx5 code to register non-driverinit params in the
code they are related to, and thanks to patch 8 this might be when
devlink instance is registered - for example during devlink reload.

---
v1->v2:
- Just small fix in the last patch

Jiri Pirko (12):
  net/mlx5: Change devlink param register/unregister function names
  net/mlx5: Covert devlink params registration to use
    devlink_params_register/unregister()
  devlink: make devlink_param_register/unregister static
  devlink: don't work with possible NULL pointer in
    devlink_param_unregister()
  ice: remove pointless calls to devlink_param_driverinit_value_set()
  qed: remove pointless call to devlink_param_driverinit_value_set()
  devlink: make devlink_param_driverinit_value_set() return void
  devlink: put couple of WARN_ONs in
    devlink_param_driverinit_value_get()
  devlink: protect devlink param list by instance lock
  net/mlx5: Move fw reset devlink param to fw reset code
  net/mlx5: Move flow steering devlink param to flow steering code
  net/mlx5: Move eswitch port metadata devlink param to flow eswitch
    code

 drivers/net/ethernet/intel/ice/ice_devlink.c  |  20 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |  80 ++---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  18 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 283 +++++-------------
 .../net/ethernet/mellanox/mlx5/core/devlink.h |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  12 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  10 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   4 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  92 +++++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  84 +++++-
 .../ethernet/mellanox/mlx5/core/fw_reset.c    |  44 ++-
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |   2 -
 .../net/ethernet/mellanox/mlx5/core/main.c    |  22 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  18 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  16 +-
 .../ethernet/netronome/nfp/devlink_param.c    |   8 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |   7 +-
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |   6 -
 drivers/net/netdevsim/dev.c                   |  36 +--
 include/net/devlink.h                         |  20 +-
 net/devlink/leftover.c                        | 185 ++++++------
 21 files changed, 521 insertions(+), 450 deletions(-)

-- 
2.39.0

