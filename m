Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F041F660D5D
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjAGJtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjAGJtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:49:17 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646F77CDD4
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:49:13 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id p123so1811044pfb.8
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 01:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R0egiXutMh/Uw0kmyho2x1XeN+KjRvJ3om8P8Oy50d8=;
        b=Zh2lIQk8pQ92kr9if3IYXG7DbbwHCDzR07DPzNhb4id3hmz+pbsdqCwlS5s0iDAwcv
         FQLSnS+9e3M/UQFr5lrm4kiahG+8EIVBlf2yrK4LxdP5GpLWKsAcHe+iL/DWuQoPKF/f
         LWJ7EmlkMPNLZO83BOzj4LhRVgr3HFDi59DunRj6u2CDMLXBqZk9wHkJmdjiSkrS16au
         iSEiG1h7kzpgz64pkPiOsDTCLoDRO5i6bX/noRLDLRESRjZ65JU7q6OWHu688/kcIeAd
         R8AMvqudEwCQ5YO4UVBhCVFOSKOPlmEdnce37k+P1OWcrNDHUqAucGfSZlcMwrM9dZ+7
         YU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R0egiXutMh/Uw0kmyho2x1XeN+KjRvJ3om8P8Oy50d8=;
        b=VryO7+u3Qfr+w87ck9QafF+7Vmo1VRZ7MfeyAjQtR8GZR3sFCnQ34N14lT2S46AUTQ
         31Ow0n9LsOrQtTKJCJZxcFdCKhtN0RLVqMNokzBp452FUDNZ5lIHd4jfpVJywZnpnezo
         nyZfMI5mIqXnXlm89krXR8HpMSlI8dmD+whtT1OBVegbBI5GVXVu8+sQ5gIECz1qzqkW
         tXnOJF9MvDW3mEDnfvE0JUxNz6ctfufi+HbZN9kjq0wq0TH39M/fFYpkeNtQZRS3cGgr
         3Y9rF7B5E2Dl+Lm4qvZfGjGz/nS7dBFmHnMaZWrg7Ipec+BgUdajwENaZdDTU5WiMyuI
         l3Gg==
X-Gm-Message-State: AFqh2kqF5RN6ykD+uphgCVZ5eg7xcdOAK/Uu0ii/JwB0/SXecnQu7Uas
        g62SSv4t6AVxNM+eEP7O2JWGGKiJ+YcPMOoEbWE1Nw==
X-Google-Smtp-Source: AMrXdXt3+T2uM67/LbbbZUIJNiSidX+sr5/cyTBvHkWVnaJxtstd37Sdz6CpT8EThNc2XG7SfAIt6g==
X-Received: by 2002:a62:f20f:0:b0:566:900d:5ae8 with SMTP id m15-20020a62f20f000000b00566900d5ae8mr50615542pfh.24.1673084952882;
        Sat, 07 Jan 2023 01:49:12 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id w65-20020a623044000000b0056c349f5c70sm2466479pfw.79.2023.01.07.01.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:49:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, maximmi@nvidia.com, gal@nvidia.com
Subject: [patch net-next 0/8] devlink: features, linecard and reporters locking cleanup
Date:   Sat,  7 Jan 2023 10:49:01 +0100
Message-Id: <20230107094909.530239-1-jiri@resnulli.us>
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

This patchset does not change functionality.

In the first patch, no longer needed devlink features are removed.
Patches 2-5 remove linecards and reporters locks and reference counting,
converting them to be protected by devlink instance lock as the rest of
the objects.
Patches 6 and 7 convert linecards and reporters dumpit callbacks to
recently introduced devlink_nl_instance_iter_dump() infra.
The last patch adds assertion to devl_is_registered() as dependency on
other locks is removed.

Jiri Pirko (8):
  devlink: remove devlink features
  devlink: remove linecards lock
  devlink: remove linecard reference counting
  devlink: remove reporters_lock
  devlink: remove reporter reference counting
  devlink: convert linecards dump to devlink_nl_instance_iter_dump()
  devlink: convert reporters dump to devlink_nl_instance_iter_dump()
  devlink: add instance lock assertion in devl_is_registered()

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   1 -
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |   1 -
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |   1 -
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   1 -
 drivers/net/ethernet/mellanox/mlx4/main.c     |   1 -
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   9 +-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  12 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |   6 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   9 +-
 .../ethernet/mellanox/mlxsw/core_linecards.c  |   8 +-
 drivers/net/netdevsim/dev.c                   |   1 -
 drivers/net/netdevsim/health.c                |  20 +-
 include/net/devlink.h                         |  26 +-
 net/devlink/core.c                            |  23 -
 net/devlink/devl_internal.h                   |  20 +-
 net/devlink/leftover.c                        | 431 +++++++-----------
 net/devlink/netlink.c                         |  12 +-
 18 files changed, 218 insertions(+), 370 deletions(-)

-- 
2.39.0

