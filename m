Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475875717F7
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiGLLFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiGLLFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:05:16 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F4CAF75F
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:14 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id b11so13616019eju.10
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QQ6HK8GRUGLpKZK5MkH41GA7jVGZGxJDtFcfcVFiQHg=;
        b=LYX74Z0asBzo0yI6tdPRJgvIor4oPvV7hYLoFiAXia4plOW9n/ZaDYvKfc1Is5auvC
         TbzYA+wD3aPB3mbrp6mMGXpKAYm4FZ8VVJ85043CHOc0WnHWETojhzprG1b5ucK66v1Z
         SEt4dw5TnvRvzrTZ6rt7PrMxGjq+VhA75RqVbcokqxMFEjK16mZGegblo3i/m09IPJe7
         D1YETcU5LqtMgMy3WPTTeV6O/hLi44xs/XJ0vR7DvaFMMYOoPpOxbYuG621KlflOTZlQ
         vP6DGViRuMEJ8w8cqgwOer81cPLvewIfGOyvhPFoc4SHp/uw3GOzA/xR2Dko38CBQT5k
         kzCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QQ6HK8GRUGLpKZK5MkH41GA7jVGZGxJDtFcfcVFiQHg=;
        b=z9+Ombzy/GQV9IkyTH8H2z8s0YkxGpuVJ9w6r0zjglmJA+Nj2eHIfolsJR5u0/xZex
         7wH+864JI96/xVPpSxZROC4ea7uGE8wp1lEp1b5/34OWy9tEVZImiHatSwP0QLYDYDlc
         V9IRGWga6bJf4E2aZxIPL9GIj0SKWQSRq4iz/5d2G0lcW3nkL4+wxFJWdiXvTvAN81gb
         lrKGEe/SvpZw5AfUZ4DDPTZ+seuNqiTZguBoN/o1ojTdaxeGpFB5VkNXUahlO/wjEM41
         CBCzhosc2PkJeiv82lKqQY2E5Bx+GEG/zqX2B/WlRgPNcMvJVp/o7WVI53zh2r07Bo3m
         0sSA==
X-Gm-Message-State: AJIora/5JsP+ojLpmIGA4wrkqAppAzupOdw0u77o84MLj2+723swa8j+
        ozhXl1+lj584ApYcJbXbH1YnGP0TAblLoootPcM=
X-Google-Smtp-Source: AGRyM1sANSuxYrDQ08k3j3DnNhmaC63p9ktU/lGs8+Bzu3UvqiXwXYuDF/BxgqLMF3CQiX6LgG9xCw==
X-Received: by 2002:a17:907:7f8e:b0:726:41df:cbc6 with SMTP id qk14-20020a1709077f8e00b0072641dfcbc6mr23666897ejc.230.1657623912830;
        Tue, 12 Jul 2022 04:05:12 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id e41-20020a056402332900b0042de3d661d2sm5906580eda.1.2022.07.12.04.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:05:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFC 00/12] net: devlink: prepare mlxsw and netdevsim for locked reload
Date:   Tue, 12 Jul 2022 13:05:01 +0200
Message-Id: <20220712110511.2834647-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

I would like to ask you to take this RFC for a test spin, will send v1
after you give me a go.

Jiri Pirko (8):
  net: devlink: add unlocked variants of devlink_resource*() functions
  net: devlink: add unlocked variants of devlink_sb*() functions
  net: devlink: add unlocked variants of devlink_dpipe*() functions
  net: devlink: add unlocked variants of devlink_trap_policers*()
    functions
  mlxsw: convert driver to use unlocked devlink API during init/fini
  net: devlink: add unlocked variants of devlink_region_create/destroy()
    functions
  netdevsim: convert driver to use unlocked devlink API during init/fini
  net: devlink: remove unused locked functions

Moshe Shemesh (2):
  net: devlink: avoid false DEADLOCK warning reported by lockdep
  net: devlink: add unlocked variants of devling_trap*() functions

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
 net/core/devlink.c                            | 636 ++++++++++++------
 16 files changed, 814 insertions(+), 605 deletions(-)

-- 
2.35.3

