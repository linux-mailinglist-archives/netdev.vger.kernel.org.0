Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B96579367
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiGSGsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiGSGsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:48:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0672D2611E
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:50 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y4so18287527edc.4
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1za1b6SWs9Oov5g0a26h83fWo2W0hYwg3XyNPP5UF6k=;
        b=SkJioEuwFb8QUAvJN4QvQ4ogFoTPOPn/wzujPbZY7JTMdT7mH0sJ0ftWfXPWNniF3E
         J3espNA7Ssi35hXgjnhiyszw+gh+peaQiA5inreHyH1bI+Ow8RdEXukrXHWvaTZjysu6
         dSXPqYYemWoGSHFQN8zOzOEIOx7wMHdLaClDItBQJS+s7/y81/X/znUY22nxIzkoMXRc
         kX2AMqcDiQQTnInClDIKVYt7ecCrYzewVpt6uEO0YGVuSNUJfOdqCes71epi4Yk6wJ74
         qLn99UMpBZXjIFoOq06/usdSgz3XmXdwkwVkf34yXKkG/ViRWKvfBonvb3Goce4QVH3I
         k72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1za1b6SWs9Oov5g0a26h83fWo2W0hYwg3XyNPP5UF6k=;
        b=u6ElI/8c/jRneymd8su4tPRl9VuyKcbuNvT5IuU/kFn28nId84ajKxiVzau5rNtOMO
         kE188Rcp00ldqVLGRTQBTthr2vt2YQn6ntkX3gr+teJzC9Y1GOXNHobUykRqyVNT4nJg
         uRICFyYEehP6Uutm+TyJHsRGmSU0HvIWBoClbVd4v1YwHvB9VZMRl6RWhpLg/xkl8VlT
         51hO2nSmfKl6Ez/uIV2rylvVV7VQSMixSZIzPrXlTox5zV6R5PmVVCH3enLHKAR/26Gr
         qzZZFxxjIL+GgB+Jqk0pr4BxiFYIHRzjQ9/rvYpUfx5pc/l9aHN8GP0rwcVC9siH2v7Y
         zqug==
X-Gm-Message-State: AJIora+U2xLEfUUmC9S6C3LwzE2g5kDKtUpTk58yUDdbMo8rS+9jCuLn
        PUYI/31Erdbpe0JKdthB57cwjnJsT0kpgMW4PfU=
X-Google-Smtp-Source: AGRyM1ualJJV5cGnt/5kjr1High8JVx3dMMmAtfnMDIWVJ8+UNmi19xwjRKdTDdMEbCxk1jLMm8pvA==
X-Received: by 2002:a50:fd08:0:b0:43a:7890:9c54 with SMTP id i8-20020a50fd08000000b0043a78909c54mr41984781eds.52.1658213328534;
        Mon, 18 Jul 2022 23:48:48 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id dy20-20020a05640231f400b0043ba1798785sm7436edb.57.2022.07.18.23.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:48:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 00/12] mlxsw: Implement dev info and dev flash for line cards
Date:   Tue, 19 Jul 2022 08:48:35 +0200
Message-Id: <20220719064847.3688226-1-jiri@resnulli.us>
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

This patchset implements two features:
1) "devlink dev info" is exposed for line card (patches 5-9)
2) "devlink dev flash" is implemented for line card gearbox
   flashing (patch 10)

For every line card, "a nested" auxiliary device is created which
allows to bind the features mentioned above (patch 3).

The relationship between line card and its auxiliary dev devlink
is carried over extra line card netlink attribute (patches 2 and 4).

The first patch removes devlink_mutex from devlink_register/unregister()
which eliminates possible deadlock during devlink reload command.

Examples:

$ devlink lc show pci/0000:01:00.0 lc 1
pci/0000:01:00.0:
  lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
    supported_types:
       16x100G

$ devlink dev show auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0

$ devlink dev info auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0:
  versions:
      fixed:
        hw.revision 0
        fw.psid MT_0000000749
      running:
        ini.version 4
        fw 19.2010.1312

$ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2

Jiri Pirko (12):
  net: devlink: make sure that devlink_try_get() works with valid
    pointer during xarray iteration
  net: devlink: introduce nested devlink entity for line card
  mlxsw: core_linecards: Introduce per line card auxiliary device
  mlxsw: core_linecard_dev: Set nested devlink relationship for a line
    card
  mlxsw: core_linecards: Expose HW revision and INI version
  mlxsw: reg: Extend MDDQ by device_info
  mlxsw: core_linecards: Probe provisioned line cards for devices and
    expose FW version
  mlxsw: reg: Add Management DownStream Device Tunneling Register
  mlxsw: core_linecards: Expose device PSID over device info
  mlxsw: core_linecards: Implement line card device flashing
  selftests: mlxsw: Check line card info on provisioned line card
  selftests: mlxsw: Check line card info on activated line card

 Documentation/networking/devlink/mlxsw.rst    |  24 ++
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  44 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  35 ++
 .../mellanox/mlxsw/core_linecard_dev.c        | 183 ++++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 404 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 173 +++++++-
 include/net/devlink.h                         |   2 +
 include/uapi/linux/devlink.h                  |   2 +
 net/core/devlink.c                            | 155 ++++++-
 .../drivers/net/mlxsw/devlink_linecard.sh     |  54 +++
 12 files changed, 1047 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c

-- 
2.35.3

