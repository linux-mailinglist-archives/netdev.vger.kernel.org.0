Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3299F67E9FA
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 16:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjA0Puv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 10:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjA0Put (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 10:50:49 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEC910E8
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:50:46 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id hw16so14776106ejc.10
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OLO7sPJsFiWLffsexBVLMaEsVIKF2pWTmyAYc5HZxNc=;
        b=YkKNWSIRGLUgsVwiEvfKohORI1WS8gndM5yprSLAymEwE99gYkmUh8HLrhNoQyWCQ6
         ye2wUD4TKSFBJIk3RiXEhJmJCwzBj0GBA1saDCH05wnN1RmS5MpuaKL+47BrMjqU4gWn
         nijh5llYN38UBaiva/P0AnHskFYeg7aKmzMSGKkofoW3XWHMV5POhOjbKl3YqIYnRv6b
         Qpheqf8QrE1J4fvt940Rg9C7RbolNyucOrsxm/LyGtKm6TwQiHqqmAaYihZQFVJt1Egn
         1FCIzqLXVJRc9cdk+iAKxXofIp6qYdPoo1zlzH+VrkZnH9vb04hFXEW4fNR3rQViGIrx
         uk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OLO7sPJsFiWLffsexBVLMaEsVIKF2pWTmyAYc5HZxNc=;
        b=lrJO1jP5u0Ay745X4FKDA3328dAcykZMcjMGuvX8hFDw1m9fG021bHJOI3tmUvStdy
         hQ/sf17c5LQVhiQNuEVm61HMWBogZQuaWYhkJYqeRaZ63HNnnT494sF+ytCwCMEPJkkD
         8lUq4AQVEDMtB6A69qqeMkV1M3TPp9U5oVdEMznSIH72RObzszmHCTvNKBG0M1qFDOBN
         C2NiGZoS1qZPrNLx2SHARDkFRFuIDheCqlsKwm4pInFX7lEPjChX+7yxo3quwSU8T4di
         7SLq4qmFwzNSRY+6xPtj8TlY/m88RO9f2UKB556oj7JcI4YN/0jztK43wZYJ+Lk8Wc1J
         I4Kg==
X-Gm-Message-State: AFqh2kqurO3xtc6IEzIWBsl5AWsdnKe2cZL+vT7nB+jtHeYJPEfpSjoQ
        mjJwnjtFCrMRRZd83SUdDWBBSFg1c0icx9khagA=
X-Google-Smtp-Source: AMrXdXsO2DHvHNLDgeISXTC7gIJSvLKRq72w7wpyJ6X5afUtQAnm0/O5BMoxBlYdBOIXXQdg0nafzg==
X-Received: by 2002:a17:907:8c89:b0:871:74c:b1f1 with SMTP id td9-20020a1709078c8900b00871074cb1f1mr49211568ejc.12.1674834645194;
        Fri, 27 Jan 2023 07:50:45 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id dk2-20020a170906f0c200b00877e1bb54b0sm2440518ejb.53.2023.01.27.07.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 07:50:44 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, jacob.e.keller@intel.com,
        gal@nvidia.com, mailhol.vincent@wanadoo.fr
Subject: [patch net-next 0/3] devlink: fix reload notifications and remove features
Date:   Fri, 27 Jan 2023 16:50:39 +0100
Message-Id: <20230127155042.1846608-1-jiri@resnulli.us>
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

First two patches adjust notifications during devlink reload.
The last patch removes no longer needed devlink features.

Jiri Pirko (3):
  devlink: move devlink reload notifications back in between _down() and
    _up() calls
  devlink: send objects notifications during devlink reload
  devlink: remove devlink features

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  1 -
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  1 -
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  1 -
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  1 -
 drivers/net/ethernet/mellanox/mlx4/main.c     |  1 -
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  9 ++--
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  1 -
 drivers/net/netdevsim/dev.c                   |  1 -
 include/net/devlink.h                         |  2 +-
 net/devlink/core.c                            | 19 --------
 net/devlink/devl_internal.h                   |  1 -
 net/devlink/leftover.c                        | 46 +++++--------------
 12 files changed, 17 insertions(+), 67 deletions(-)

-- 
2.39.0

