Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815F4691C20
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjBJKBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjBJKBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:01:36 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D2C77167
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:34 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id lu11so14392512ejb.3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zamAIWO7q9aybwGy7pOHg6zLv5H4HQo8Tdx6aR4stmE=;
        b=ynjsukjMZ6CsE3+LUNMfUIsp/n/oY4XhoAyx1DCpGT7pGbO/XlsSDfKbm/B0sMQJDC
         xBFjCRmN54jSaapw+DsIgmSXtYqzpR/2WYKblZylDeV7IyW7ygoBXIxA0lYpwuZccsaB
         QQXCkrLePhgnkpy/9pubvCwjnKpmGkB3FrgYBDcGGICJ+DRRDGf2d1cq4VKPcMHcXi6y
         JPgdLG4AaKc2DtNW9E+YSpxGbQZMrJjTknBWKKIouU6BHPBGn72mm5LVnbbzeKeMP5p+
         wA7y3SsEtmJRE6/iq8tC2FiqMJV8ZSmHOYVCSgZJgoW68m6s0pPu3Cwsi5yaPC2t88P9
         S5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zamAIWO7q9aybwGy7pOHg6zLv5H4HQo8Tdx6aR4stmE=;
        b=teY8UtnRg4twpB/McpoMRe/TNYQG8VqZYrVGR20o8asrYnpH0KeGXeggPx8kLVhFTl
         /ETlPX1+/heBxIDNCbSYMs4IsevakAWpSwhAW1PzHoi2Hgviipxd9LEwbhsr9z7BepjI
         5VZO92Q78oSYxUxrZL6WmhlvXyV+jdgjWEsjI9kdSgYoNzNeDZfz/CfgcREbKfvdgGSH
         LZnXNZ8CflPyPk+qW1VpdY3BhOOBPfqpfFCRS18bV+c7QGCQXDMSVleQvQ+/pyZw4Rml
         BKk8ddIy9V7Rp1ctv+XH5SF79i4dZMQUYiWlU8urbXi4homM81J2YiHfFJJJMGwF7FKs
         /Acg==
X-Gm-Message-State: AO0yUKUWlzIwvLBvdaEkzL5SQ9eCQnWWMbVa9vw5HIUkAuZYObvLj3ES
        kz0t00ckCW2T638fFeR0PpWVFME2DBItDeqPwyE=
X-Google-Smtp-Source: AK7set/LwQ50uPSinYrjF37FU2GNaWbybhXwtphRJBythRk3un7DcPNUC+PtZbTebn7/nBRSWjYnoA==
X-Received: by 2002:a17:906:dc94:b0:878:4d11:f868 with SMTP id cs20-20020a170906dc9400b008784d11f868mr20310642ejc.2.1676023293020;
        Fri, 10 Feb 2023 02:01:33 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h15-20020a170906828f00b0087bd2924e74sm2134398ejx.205.2023.02.10.02.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 02:01:32 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com, simon.horman@corigine.com, idosch@nvidia.com
Subject: [patch net-next v2 0/7] devlink: params cleanups and devl_param_driverinit_value_get() fix
Date:   Fri, 10 Feb 2023 11:01:24 +0100
Message-Id: <20230210100131.3088240-1-jiri@resnulli.us>
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

The primary motivation of this patchset is the patch #6, which fixes an
issue introduced by 075935f0ae0f ("devlink: protect devlink param list
by instance lock") and reported by Kim Phillips <kim.phillips@amd.com>
(https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/)
and my colleagues doing mlx5 driver regression testing.

The basis idea is that devl_param_driverinit_value_get() could be
possible to the called without holding devlink intance lock in
most of the cases (all existing ones in the current codebase),
which would fix some mlx5 flows where the lock is not held.

To achieve that, make sure that the param value does not change between
reloads with patch #2.

Also, convert the param list to xarray which removes the worry about
list_head consistency when doing lockless lookup.

The rest of the patches are doing some small related cleanup of things
that poke me in the eye during the work.

---
v1->v2:
- a small bug was fixed in patch #2, the rest of the code stays the same
  so I left review/ack tags attached to them

Jiri Pirko (7):
  devlink: don't use strcpy() to copy param value
  devlink: make sure driver does not read updated driverinit param
    before reload
  devlink: fix the name of value arg of
    devl_param_driverinit_value_get()
  devlink: use xa_for_each_start() helper in
    devlink_nl_cmd_port_get_dump_one()
  devlink: convert param list to xarray
  devlink: allow to call devl_param_driverinit_value_get() without
    holding instance lock
  devlink: add forgotten devlink instance lock assertion to
    devl_param_driverinit_value_set()

 include/net/devlink.h       |   6 +-
 net/devlink/core.c          |   4 +-
 net/devlink/dev.c           |   3 +
 net/devlink/devl_internal.h |   5 +-
 net/devlink/leftover.c      | 139 ++++++++++++++++++++----------------
 5 files changed, 91 insertions(+), 66 deletions(-)

-- 
2.39.0

