Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2CB57FB52
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbiGYI3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbiGYI3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:30 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30F413F5B
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:28 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id os14so19238750ejb.4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NQrr1JlTdLSIB/8RIRDhs4XWfg4t0HMVyQNDxp7JX9Y=;
        b=rRgClsMcClPfTHXQAmACgkCRy6UdBcxaaknotPJClz2ngaW0Apc4ouehhfDBwI9A8P
         I8suh/QbPixUdOuj1J6pRWeTPCUN+R3F1u6Vsb4SXzxkWqv7/Kc6slcFY6V+ithPilkG
         dkTpo0+BX/iETjxddhadJ+8jTlmEAvrnUmn1jLZcBId0El2t+Lsqeeqp9YaIK/PhFvf5
         tSv77CSRiiGQ0o7/OMj1bvT2vcRIYTpsjWa8kIiIXkuS5qDrnaQo+lKMBXhIS4X0Qm8w
         GTVB0BfkdAFKcgK3SkH3rioJq8+aAx0tWcP/uqCskFXiCuxlA5sT/OQFPMBytQcxL1uO
         NCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NQrr1JlTdLSIB/8RIRDhs4XWfg4t0HMVyQNDxp7JX9Y=;
        b=ZOujX/3mfNJAbcMnH/Qja8NVD/Ot/eWfHlITC+8vFaCqQnh5DRxyE0IWMd2HkseGFX
         R3GMRg9S2eFILSAkxfNKsqIYld2XV5vU/g4x1Ym9PF2ulCaxzXfbzfpbx208CkzGUM2w
         F3ieMRBHnsCuBgRVZ1oCcZiApuZBBjXj3CNBCjXHEw57X95zmZI5DPObDzzNqDZyo9LC
         srHcjOtUUeS+4WjdUsWvy7PP20n8eW+GowC4DH9PHaGQLL5cFVIitj3h8tQx8Ot27Gbm
         TOVEdcqMOY42fUH3qPFWTHpIp+tIzw16ySr8/MnFzif1L9aZVUhnwRdh6xy7WF3WZUHJ
         ONOw==
X-Gm-Message-State: AJIora8pysaapVohvuNtzZmHgpGDY3b2x3x93E+N42v67a/1+38oDnDm
        A7oP7/bQf65J4LN/IKTRNGJzf+EloEcVmR0BzQc=
X-Google-Smtp-Source: AGRyM1udsUukxxDBGv1Pe39REsgArfq2092h/vnRhvd9t4sgO52fg5Zx+XLtCZLjGcohpbT8guamFA==
X-Received: by 2002:a17:906:7b82:b0:6f3:ee8d:b959 with SMTP id s2-20020a1709067b8200b006f3ee8db959mr9122043ejo.458.1658737767295;
        Mon, 25 Jul 2022 01:29:27 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ek19-20020a056402371300b0043c0fbdcd8esm748474edb.70.2022.07.25.01.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:26 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 00/12] Implement dev info and dev flash for line cards
Date:   Mon, 25 Jul 2022 10:29:13 +0200
Message-Id: <20220725082925.366455-1-jiri@resnulli.us>
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
1) "devlink dev info" is exposed for line card (patches 6-9)
2) "devlink dev flash" is implemented for line card gearbox
   flashing (patch 10)

For every line card, "a nested" auxiliary device is created which
allows to bind the features mentioned above (patch 4).

The relationship between line card and its auxiliary dev devlink
is carried over extra line card netlink attribute (patches 3 and 5).

The first patch removes devlink_mutex from devlink_register/unregister()
which eliminates possible deadlock during devlink reload command. The
second patchset follows up with putting net pointer check into new
helper.

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
  net: devlink: move net check into
    devlinks_xa_for_each_registered_get()
  net: devlink: introduce nested devlink entity for line card
  mlxsw: core_linecards: Introduce per line card auxiliary device
  mlxsw: core_linecards: Expose HW revision and INI version
  mlxsw: reg: Extend MDDQ by device_info
  mlxsw: core_linecards: Probe active line cards for devices and expose
    FW version
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
 net/core/devlink.c                            | 288 ++++++-------
 .../drivers/net/mlxsw/devlink_linecard.sh     |  54 +++
 12 files changed, 1043 insertions(+), 171 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c

-- 
2.35.3

