Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2485EBC94
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbiI0IBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbiI0IAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:00:12 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D21B0B1A
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:56:47 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o5so6001509wms.1
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=2Duvoys/UXx9mTSKSqzPzkmfBaU5tDN9Iw3nEsRbxdc=;
        b=6da8DmpWl7aYiAk3weQzGreKxpos8JrWr7yrRBTMFNXa31jB5KCaKkUX0rvDsvLs8d
         4WVP0oF0VDlwpb3Eybc6v8hSfNmTRfad0OJM4lhDu5UX0yeNFKbiL9fJ8UT9dnn9ppKt
         hdAX1uTT5kCG20C0TGEvUk2ZBCOI7JMxa7BjHVPW1qjZ1NejuXQ6WHXokWQizZsJitaZ
         8F1KCs9uLBfBd3KkPBBYSJCi+0gi+r49nORnkrFflFlctjkyVKHoFNNWkPspQOjpsGiW
         vGPHeThb6rvFQptYhqRAUQPyc6eDYPTzGpHJC5I2PwiXNC0WgIYft0LUQHEtNn+223ub
         DOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=2Duvoys/UXx9mTSKSqzPzkmfBaU5tDN9Iw3nEsRbxdc=;
        b=pw6J8b7VbynD+2DAv+yVNBPXzHXj693RbUWomxcBpxC2MQa9LIvAaU91i8i5lcR5Eo
         rXD6Ak1YajK5kCbpGubJDyCZI5r8p8ufOs46d73ICbeqdRPynCV9eZp8XZVnyAHWSDee
         U8e+A4cnKt9XhpsUMnAe7eveALGi5NYnrCzPh23oEpps775EqFvt9X+4sy8uiF0jikzL
         xJhmeizcQ5pGgyDhj0/cBe4AyBxLYoDqs7WW/4kWvvoSbv+u8rEh/3cOvCdwp40ZKY0z
         CoewPSjJBOLYf5rhEuRbJHL4FCuK8+dREASm6E5U/6ZSRUiPqXtT3l6oT5S+FrmXtSZE
         2paw==
X-Gm-Message-State: ACrzQf003Ac1ROnnktsAFpFNBZ9ZyrE1mOdKx8FM1stuUcK4d2+E2eH5
        g9chezEf6xFhkE5zwVrogY++DyBvO5XZYpN7
X-Google-Smtp-Source: AMsMyM45L51RlSorRBHxfvoLDd3LecOSi3UTpfb+afGnYcC7mQT8waguC1LMJD5h4LAhdJpOM0x45w==
X-Received: by 2002:a05:600c:1d28:b0:3b4:91f9:aeb8 with SMTP id l40-20020a05600c1d2800b003b491f9aeb8mr1603250wms.136.1664265407274;
        Tue, 27 Sep 2022 00:56:47 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b13-20020a5d40cd000000b00226f39d1a3esm1049281wrq.73.2022.09.27.00.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:56:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v2 0/7] devlink: sanitize per-port region creation/destruction
Date:   Tue, 27 Sep 2022 09:56:38 +0200
Message-Id: <20220927075645.2874644-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
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

Tested by Vladimir on his setup.

---
v1->v2:
- Netdevsim patch removed and also the patch forcing region creation
  before register was removed.
- Two Vladimir's patches were added.

Jiri Pirko (5):
  net: devlink: introduce port registered assert helper and use it
  net: devlink: introduce a flag to indicate devlink port being
    registered
  net: devlink: add port_init/fini() helpers to allow
    pre-register/post-unregister functions
  net: dsa: move port_setup/teardown to be called outside devlink port
    registered area
  net: dsa: don't do devlink port setup early

Vladimir Oltean (2):
  net: dsa: don't leave dangling pointers in dp->pl when failing
  net: dsa: remove bool devlink_port_setup

 include/net/devlink.h |   7 +-
 include/net/dsa.h     |   2 -
 net/core/devlink.c    |  80 ++++++++++++++----
 net/dsa/dsa2.c        | 184 ++++++++++++++++++------------------------
 net/dsa/dsa_priv.h    |   1 +
 net/dsa/port.c        |  22 +++--
 net/dsa/slave.c       |   6 +-
 7 files changed, 166 insertions(+), 136 deletions(-)

-- 
2.37.1

