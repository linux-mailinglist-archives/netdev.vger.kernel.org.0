Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E232557B949
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241202AbiGTPMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiGTPMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:12:43 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCFF57E05
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r1-20020a05600c35c100b003a326685e7cso2065478wmq.1
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mK8Pztrx/mBVghehrarLAqOKi7GhuNWefvGB9Kai6Ho=;
        b=bUuCLpr2pnNkbR5SFIWJ/KAZ/v5rGtYJJ3X+5okVX2HQvOKpAUcgjvrFNNYnbjlgZ4
         KRTdCx9H33H0q2yCQF3caWlunR/c6bvBy3RC84G854WI8hh1uWEhD041ZuzjCN9+JpmB
         Lh75VkBm+NdUfAxSmXR5tsjDqk2xux3aDJg5tFmrbx0p3bJhOHK6fNtF9+VACnzfiyr1
         nnOetPKKjfyjQam3Pdbnx8i5Kb26gC4Kaz7xz6JOX9puhdsKVrB/TyxejQ0OSXdeKQbJ
         hpjtFT5gMibq9WYJ27HaQTI5KkFFb5OmdDSIr/PXx6Zni2F8sg1Y2oraLdh26OvnrjQL
         GyEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mK8Pztrx/mBVghehrarLAqOKi7GhuNWefvGB9Kai6Ho=;
        b=4u+URyGTLHThWuzQ9tB/VWfmuscmAM+GROGtioevNaxLrMlrryUGP+31FeKZtCzerO
         ji5nvgueiJ6UZIEDCy++Wy67GTX4B168KBjXmT65FSlOiZH6JC2/2RuuV7auVt+xt5dZ
         p4nbnqe0jJtwrnN9uA505CiqwVO/vAl2ua+42PUkxEhi46JICMUZBTVaqr/9uIkQTHGu
         h2FgS+gE2pc0/Vjuik6P0lXC8kRK09Tay/iWFEu3kwSaPHaKVT055ChffMlGL+W8pUaY
         HsJi//TxQOS3uDuvZ4B3f1JQtDqd/Bz7V2TDrW4mjWfjHvtYn/WMhnbObcVVBu5odGMT
         otmQ==
X-Gm-Message-State: AJIora8o105lhBrV0TaAOPwpBu9f/WcKI4+bFV2kmFRLNHEaZZ46uLQV
        d5f0GmQjzeYw1ImSZyq2N7UiqEASC5XyLnXZVs8=
X-Google-Smtp-Source: AGRyM1vB+4T2YQsW9iq/ujhi811YbMf97HaWIBsw0tKoYL3yyla6csCUuzuWbTwiiSV/QVj/bZsIlA==
X-Received: by 2002:a1c:7517:0:b0:3a0:2d36:4dcc with SMTP id o23-20020a1c7517000000b003a02d364dccmr4255030wmc.21.1658329957769;
        Wed, 20 Jul 2022 08:12:37 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d52c8000000b0021d65e9d449sm17290856wrv.73.2022.07.20.08.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:35 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 00/11] mlxsw: Implement dev info and dev flash for line cards
Date:   Wed, 20 Jul 2022 17:12:23 +0200
Message-Id: <20220720151234.3873008-1-jiri@resnulli.us>
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
1) "devlink dev info" is exposed for line card (patches 5-8)
2) "devlink dev flash" is implemented for line card gearbox
   flashing (patch 9)

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

Jiri Pirko (11):
  net: devlink: make sure that devlink_try_get() works with valid
    pointer during xarray iteration
  net: devlink: introduce nested devlink entity for line card
  mlxsw: core_linecards: Introduce per line card auxiliary device
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
 .../mellanox/mlxsw/core_linecard_dev.c        | 184 ++++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 405 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 173 +++++++-
 include/net/devlink.h                         |   2 +
 include/uapi/linux/devlink.h                  |   2 +
 net/core/devlink.c                            | 156 ++++++-
 .../drivers/net/mlxsw/devlink_linecard.sh     |  54 +++
 12 files changed, 1050 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c

-- 
2.35.3

