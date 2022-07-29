Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE4C584C6A
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbiG2HKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiG2HKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:10:42 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E7E51A02
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:41 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id oy13so6996805ejb.1
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lRMTvJmvyH1jrtjbOqZDWvY6LG0xcVs8SwXl9n4Gt40=;
        b=PzhZM5/9WPQAOl3xKJi8qWlOUaFFLFU6am1YnRueZvxjWNQUVpQSxZwycFV9Jo/07u
         j/OhkqcLmJgWoRis0aHTDxhY3DpYyFHTHBBYJ7LeKY34Rgl0rAcDaZITn6yaA7oOrKLr
         gkOklDtuj83ClTn40hDQR3RegNMWeTFfk3RcIcL26Hf0+Jj9w3aFTBdKt+rjmS04kxFW
         u4/1JNNrZqsdgXxcnsPUgkO77ceKhF1UWx50uwrWc/2JdlPg5XFeWTG+S985mjNdv0iT
         wznvg5W/ulI9+MV55nyb6T5SQNc1lzlH91wWzCe3XRwYI9DZcxGHzMxOXzgvyOXQ5PVE
         wmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lRMTvJmvyH1jrtjbOqZDWvY6LG0xcVs8SwXl9n4Gt40=;
        b=pLxRhyZZht5cr04DxFzk/18U+7hom8B2rwiiXs+f/D2ivd0IbyxMwjS5O7vJsFE6QI
         12M1bFTQbc8PRVpFE4IZ4tHocbQ1cpNTfW0Xt2b7bXZ6CpZ/Kf0lRYyca+NLcqcuEExg
         L6AjUwnmXXW81DxU5WEcgyMwX9pgS/F2Aw1bX4YKWxqr9kgqHLBkfiyqrLcw1kGdduuv
         HDk2LXKAIxmiuJjkOOP9V7Cj5FEu/dOCkoZCszItIeaBdSZSRZBKtdwkXAMfCC2VwJ/y
         M0B25JP1tbGW9iNjqWmOaUAodDOQc6yE7g2350HRfMWdtGrs8f/WSXysNUpEQgbpg6D7
         3Xtw==
X-Gm-Message-State: AJIora8J6eE8edLKiExVAVzsyvBwKm7t6CIxzK1Dl0XXoIJJQdZjP5Ml
        e2SA5bTi5CPF6wVftzUjnGE7e7tNNxx+YFUk
X-Google-Smtp-Source: AGRyM1sgN7dc+keMHOITL9YXHi/ddO9mASApssqVYFZjxjXYCVk0bmogT5yT+Zpih+DUgJu71yASsQ==
X-Received: by 2002:a17:907:7b87:b0:72e:d45a:17af with SMTP id ne7-20020a1709077b8700b0072ed45a17afmr1902278ejc.73.1659078639461;
        Fri, 29 Jul 2022 00:10:39 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709060cc200b00722e4bab163sm1307592ejh.200.2022.07.29.00.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:10:39 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, moshe@nvidia.com
Subject: [patch net-next 0/4] net: devlink: allow parallel commands on multiple devlinks
Date:   Fri, 29 Jul 2022 09:10:34 +0200
Message-Id: <20220729071038.983101-1-jiri@resnulli.us>
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

Aim of this patchset is to remove devlink_mutex and eventually to enable
parallel ops on devlink netlink interface.

Jiri Pirko (4):
  net: devlink: introduce "unregistering" mark and use it during
    devlinks iteration
  net: devlink: convert reload command to take implicit devlink->lock
  net: devlink: remove devlink_mutex
  net: devlink: enable parallel ops on netlink interface

 drivers/net/ethernet/mellanox/mlx4/main.c     |   4 -
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   4 -
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   4 -
 drivers/net/netdevsim/dev.c                   |   6 -
 net/core/devlink.c                            | 110 ++++--------------
 5 files changed, 21 insertions(+), 107 deletions(-)

-- 
2.35.3

