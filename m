Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F7B576D5F
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiGPLCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGPLCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:02:46 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F89220E4
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:44 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r18so9193099edb.9
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tO00wn2f4z/lNaFJZyqHMuGeDXv6H/xiw7t+CLY4pdU=;
        b=sp83GbA2al8rmDPAWs40+NgavsUUMsSr1f/M87XrI2HlNRPxBX7OZnlOW6K7pqRZ76
         TNJ9LScGGg+YXQAcl8ONAtEizvnd53HLXx+WW5oQfZIMGvGqBOjsMmw/IZmAM2SJ+g+a
         g796EPdQds4GfPWrejOCccddBcOolcdC4UB8brFn+osK9YZOKQa5KqmyAeAFJhn1IOxH
         PiK/XGdYJDbBHtih9GIY3ONer/vHy+Faew9W2TLtm4MK2gFWdqpFG5Djqq+07rGGm6Qp
         pEAuEDXUooxfEyz8DjfMl0gKvFAFJGWBbDg99cUKKb26Tc4FU+PzkDfRC27J5q54EQjf
         BoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tO00wn2f4z/lNaFJZyqHMuGeDXv6H/xiw7t+CLY4pdU=;
        b=Tnzjjlxa9SBIVVPMAJyLQmpoUUvqD/JxfNyEBzEHbEc/+7VSWo/gsJ0ONjG+GS7xXR
         QgIxRBQpYQZNzqRnU8h/1wNItRRvM7M08h5kJcyY1Nd0RsXhAyqNlFVBhYKhB8v3lU+Y
         mDix4h+U6ZU24hUyVUB5soYkUyjdc3nKfX/HJg9DdYEHnH3X5yN4b6M0+lqUShrXBP/z
         ercmZutOGRgzHe+8M2TYpMZV9rIIyQc8nXho+vPQpHnuFlxyN0U582Qfchm2I9A0t8Xj
         +LyBKBw9+88JK1NUnYNhD3BdsVzh0dCYdLy9fCcNQMCpDCaOxRkWjWTff6jlGwc8jhn4
         YWAg==
X-Gm-Message-State: AJIora/XYZvj2jn+mX0tdxu/VWAeHzLdl7vstLrn+YRsd6BJu2OM5CRD
        7JM3Gkb/iwTqTEoveGXlITjBv51zc/MhWQnG
X-Google-Smtp-Source: AGRyM1vvZXX+ulWfPyI/jiKgZ+59rdXz6ZHrp/Mpm+X9OiKwFXxtAaM5AC5coQJAT3uj9wFQ9Fw5Pw==
X-Received: by 2002:a05:6402:643:b0:43a:77a6:acd with SMTP id u3-20020a056402064300b0043a77a60acdmr25102129edx.173.1657969362836;
        Sat, 16 Jul 2022 04:02:42 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b18-20020a170906d11200b0072b4e4cd346sm3050585ejz.188.2022.07.16.04.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 04:02:42 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next 0/9] devlink: prepare mlxsw and netdevsim for locked reload
Date:   Sat, 16 Jul 2022 13:02:32 +0200
Message-Id: <20220716110241.3390528-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
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

This is preparation patchset to be able to eventually make a switch and
make reload cmd to take devlink->lock as the other commands do.

This patchset is preparing 2 major users of devlink API - mlxsw and
netdevsim. The sets of functions are similar, therefore taking care of
both here.

Jiri Pirko (8):
  net: devlink: add unlocked variants of devling_trap*() functions
  net: devlink: add unlocked variants of devlink_resource*() functions
  net: devlink: add unlocked variants of devlink_sb*() functions
  net: devlink: add unlocked variants of devlink_dpipe*() functions
  mlxsw: convert driver to use unlocked devlink API during init/fini
  net: devlink: add unlocked variants of devlink_region_create/destroy()
    functions
  netdevsim: convert driver to use unlocked devlink API during init/fini
  net: devlink: remove unused locked functions

Moshe Shemesh (1):
  net: devlink: avoid false DEADLOCK warning reported by lockdep

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  53 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 103 ++-
 .../ethernet/mellanox/mlxsw/spectrum1_kvdl.c  |  82 +--
 .../mellanox/mlxsw/spectrum_buffers.c         |  14 +-
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    |  62 +-
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  88 +--
 .../mellanox/mlxsw/spectrum_policer.c         |  32 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  22 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   |   6 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  27 +-
 drivers/net/netdevsim/bus.c                   |  19 -
 drivers/net/netdevsim/dev.c                   | 134 ++--
 drivers/net/netdevsim/fib.c                   |  62 +-
 drivers/net/netdevsim/netdevsim.h             |   3 -
 include/net/devlink.h                         |  76 ++-
 net/core/devlink.c                            | 637 ++++++++++++------
 16 files changed, 816 insertions(+), 604 deletions(-)

-- 
2.35.3

