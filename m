Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2614E5A0DF1
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiHYKeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237443AbiHYKeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:34:05 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED199F742
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:04 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id h1so10049929wmd.3
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=yljgt3779N8b1oeyppKx6OX30xqA79VI1owmRdgaQUk=;
        b=7Sz0513ILOrAOhq0i0AjbjbSZibAc/Ei4u9A4MjOv4UyctiCKNyXX3Dckz0Cv79qXJ
         tmLZAt6Zuci7zmGU0VY2DQQorUEVmX667MfG7vkjjol4wA+0mVHsbkEaxLLbAhT321ph
         Nj3/pFWoqPw+WOZBhf3PkmygJfSzPKiQNeBZimnFeXK4k2ytwORdhxFo0+LYfu5hGVmE
         YTnMfON9CCyudyGGrNWx4e1eW0TA+Tirp51TXk/MQKVmgB3rDsBfCfSSKupFIwF1mMKf
         y1HxjJPTn9k6nhu5krHjBo+wGb/evc3QWPSgxazczOaRIMXYo/g22H2nhDQgcBu7fe2N
         ZYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=yljgt3779N8b1oeyppKx6OX30xqA79VI1owmRdgaQUk=;
        b=yigewphG0UJ1cKiMUES19la4WWUMKDyWny6CtQ/tRQEKkAo1SEVfMMEtbO8Jg609jP
         FRLR3d3vtmfUIIil91MKZD8o9fx6Zy7m7kE9wxPpP0SAMDpvVcVrUYxSWCRhNsNUOg/L
         ka7/XgD8txmXjGJs96TLpn7+nJJP+kTLqPY+Dj0qpZXWJMI2YGBg8luHlaSuCpjIl3pM
         s2vwOT1p6LEr9mByEoUuzKCLauvzwEmvO/zlqm+8mFxEVgPCHNZEnEbo21m9KYoVGWDV
         BziQX/p+3fhvP9Bvruws0B5I1JjYueAVvfWb8fbt/yrpHs+Zti9QX/MyaxpaYyg8XIPw
         uKfA==
X-Gm-Message-State: ACgBeo0fTXfidAfsHqEqpNvuOvVFSHYniAOwpTqa/91J+rRWD05VWqTk
        yAIvbL+WaGtbNJauRcP5E+imCHDYUKq0SEAL
X-Google-Smtp-Source: AA6agR4GJjqdnnlk3NRzLJm+zfulwyyhyiCgSMdtQY6d7BeSPdD2xnCIQ/yFlAgQum5MM5LUwZD1Hw==
X-Received: by 2002:a1c:4b01:0:b0:3a5:94e8:948e with SMTP id y1-20020a1c4b01000000b003a594e8948emr1868893wma.197.1661423642618;
        Thu, 25 Aug 2022 03:34:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ib6-20020a05600ca14600b003a62400724bsm5662429wmb.0.2022.08.25.03.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:34:01 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next 0/7] devlink: sanitize per-port region creation/destruction
Date:   Thu, 25 Aug 2022 12:33:53 +0200
Message-Id: <20220825103400.1356995-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
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

Currently the only user of per-port devlink regions is DSA. All drivers
that use regions register them before devlink registration. For DSA,
this was not possible as the internals of struct devlink_port needed for
region creation are initialized during port registration.

This introduced a mismatch in creation flow of devlink and devlink port
regions. As you can see, it causes the DSA driver to make the port
init/exit flow a bit cumbersome.

Fix this by introducing port_init/fini() which could be optionally
called by drivers like DSA, to prepare struct devlink_port to be used
for region creation purposes before devlink port register is called.

Force similar limitation as for devlink params and disallow to create
regions after devlink or devlink port are registered. That allows to
simplify the devlink region internal API to not to rely on
devlink->lock.

Tested with dsa_look with out-of-tree patch implementing devlink port
regions there kindly provided by Vladimir Oltean.

Jiri Pirko (7):
  netdevsim: don't re-create dummy region during devlink reload
  net: devlink: introduce port registered assert helper and use it
  net: devlink: introduce a flag to indicate devlink port being
    registered
  net: devlink: add port_init/fini() helpers to allow
    pre-register/post-unregister functions
  net: dsa: move port_setup/teardown to be called outside devlink port
    registered area
  net: dsa: don't do devlink port setup early
  net: devlink: convert region create/destroy() to be forbidden on
    registered devlink/port

 drivers/net/ethernet/mellanox/mlx4/crdump.c |  20 +-
 drivers/net/netdevsim/dev.c                 |  18 +-
 include/net/devlink.h                       |  12 +-
 net/core/devlink.c                          | 154 ++++++++--------
 net/dsa/dsa2.c                              | 191 ++++++++------------
 5 files changed, 178 insertions(+), 217 deletions(-)

-- 
2.37.1

