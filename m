Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D759B63F590
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLAQqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiLAQqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:18 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3843B0DC3
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:46:11 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r26so3107230edc.10
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ksBlzqIsxDhk0c0PK8ya7Um/zCX+Q2v2Hd13+24F4pM=;
        b=pOHOKbMQwef7hnRcJn/k5R0nGg0AQBvlAxABylWiggwC0MBCGOwhSmYymGZUC63pDS
         bgqwq5bsFMLDnmHKaeRocKgtai8Y0s9mCx/fg+meeAoXbgbtyKpUjbGrDVOZBLTUQFHH
         nD6Jaja8wyCe9Hd6qfx/UqyFrkA5R+poEvdRztHbFzQrzJcnwcdgr0N4mxB1XSRycSeC
         IvmyZ7F2u5PHSCaiPnsvZ2dRaIyXp2bS8jBaqPdyKtzUh+FCjCrb7XrhKYx75VesxuQS
         Sjex+eSvaTpJFrwKcc73Bman0irx3WZZJ6NzR1WKYCf/g6AzLyL3NJFKKwP2+RLl5zWg
         tWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksBlzqIsxDhk0c0PK8ya7Um/zCX+Q2v2Hd13+24F4pM=;
        b=0QuuuVXnWX4X40pMlQcqjICMkLjyJM40k1iAgiiDycTOas2oZGFIXJCF1aRvYK1nb4
         4EzwDzvKUsBwWEHO/XAISIkCN6mjUrHN43Cblfqma3LnV2n/sJcOKMzoc+tchOHVTOi4
         GvOTfZr09NVtuFZG7dRIrwKD2RCiHnjsXnDxbkcETDZtaeC68AtBEQyKBXEClm8+4Wzv
         X/hqajdv5YL7DorYTz4JzlHY5vw51AM7ucmdP15WJsog2KONbLl6ASEgoqOoKyYC6rL5
         MbeFI78DTOBFbyLNKhbHAWWz7s0L4kTl2w8EqOBfJlPl0DrE7SrrVEcYhL01LdeABlIo
         dcNg==
X-Gm-Message-State: ANoB5plSfe9ubIstT80Hiat0co9SDC3N8oJBentuWj0Rox6c0Z1Fb/Km
        cIfPc+N+89Kxa52wxj5f+CtvejzSxSiY/FLG
X-Google-Smtp-Source: AA0mqf5y3BdTLHzHUpM3UlJ3Rl6aH5blqelFX+XNXo+BRUxC3fkFZPiPXOnuubfCdcDDzsyfvevM8w==
X-Received: by 2002:aa7:c841:0:b0:45d:2a5:2db8 with SMTP id g1-20020aa7c841000000b0045d02a52db8mr45816240edt.105.1669913170282;
        Thu, 01 Dec 2022 08:46:10 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v17-20020a170906293100b0078e0973d1f5sm1967259ejd.0.2022.12.01.08.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:46:09 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yangyingliang@huawei.com, leon@kernel.org
Subject: [patch net-next RFC 0/7] devlink: make sure devlink port registers/unregisters only for registered instance
Date:   Thu,  1 Dec 2022 17:46:01 +0100
Message-Id: <20221201164608.209537-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
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

Currently, the devlink_register() is called as the last thing during
driver init phase. For devlink objects, this is fine as the
notifications of objects creations are withheld to be send only after
devlink instance is registered. Until devlink is registered it is not
visible to userspace.

But if a  netdev is registered before, user gets a notification with
a link to devlink, which is not visible to the user yet.
This is the event order user sees:
 * new netdev event over RT netlink
 * new devlink event over devlink netlink
 * new devlink_port event over devlink netlink

Also, this is not consistent with devlink port split or devlink reload
flows, where user gets notifications in following order:
 * new devlink event over devlink netlink
and then during port split or reload operation:
 * new devlink_port event over devlink netlink
 * new netdev event over RT netlink

In this case, devlink port and related netdev are registered on already
registered devlink instance.

Purpose of this patchset is to fix the drivers init flow so devlink port
gets registered only after devlink instance is registered.

Jiri Pirko (7):
  devlink: Reorder devlink_port_register/unregister() calls to be done
    when devlink is registered
  netdevsim: Reorder devl_port_register/unregister() calls to be done
    when devlink is registered
  mlxsw: Reorder devl_port_register/unregister() calls to be done when
    devlink is registered
  nfp: Reorder devl_port_register/unregister() calls to be done when
    devlink is registered
  mlx4: Reorder devl_port_register/unregister() calls to be done when
    devlink is registered
  mlx5: Reorder devl_port_register/unregister() calls to be done when
    devlink is registered
  devlink: assert if devl_port_register/unregister() is called on
    unregistered devlink instance

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 29 +++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  7 ++-
 .../ethernet/fungible/funeth/funeth_main.c    | 17 ++++--
 drivers/net/ethernet/intel/ice/ice_main.c     | 21 ++++---
 .../ethernet/marvell/prestera/prestera_main.c |  6 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     | 60 ++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 10 +++-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 17 +++---
 .../mellanox/mlx5/core/sf/dev/driver.c        |  9 +++
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 24 ++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 38 +++++++++---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 10 ++--
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 22 +++++--
 .../ethernet/pensando/ionic/ionic_devlink.c   |  6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  7 ++-
 drivers/net/netdevsim/dev.c                   | 31 ++++++++--
 net/core/devlink.c                            |  2 +
 18 files changed, 218 insertions(+), 100 deletions(-)

-- 
2.37.3

