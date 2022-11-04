Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C94A619461
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiKDKXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiKDKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:23:33 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C306162
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:23:30 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b2so12065086eja.6
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 03:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=74piWiHi3pc8oG1qzPvBKJHSezv/5fwnEincukZkk5o=;
        b=YvkRR8nDLOHVSjf+e7p4YOSlsH5TXkxZ0M9+gJidGt/ocyNO8wBN54Z2J9BJMydtUz
         //AC06TEIjT9h/nQVB+hOYqUf3eQaR3xUE9BXUFfW7qAZXhkW33Z+k6jtCLyGuwFPMzC
         hfRK25VBiLGXK26ljo5ABGe5VzyQuzIr2+azvBce2FrHlueDsndY2phCxF5f4O1BVfdb
         WeXqLX2B5wRi8EmjOLmswMcTj8ftQ1C1ucCBRlRoS0H+UQx83suh0HhhfTPM+3o8Tqu1
         NM+r6CuohsHRnKfAU1SdFmTP+RUeFE/TRkFqIURoyGknO/qQ8vP/dXt3vZe8bAp9HNOp
         ZgBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=74piWiHi3pc8oG1qzPvBKJHSezv/5fwnEincukZkk5o=;
        b=Ib1/nJuOE695awGWr4PEz9zfwJbd626dBA2Y1E9GYK2FPRUxkty2V5ZH72k7UzHooG
         widwr9fS3Xj6Ab/xWqe3JND7dTmXOjesFVsxGDrRLrhmVUoDxC2h1NPZ/QyZk9Ies1YO
         GvFRFLoXbaZs/v1CcUTm98BsSIQTUKtW5qubEFF6JmbwIKQv2rDI9bm8ykCyucCLih7d
         hEAOJSv9eI9m2xD89PVT6VMYPIhrU+jPFPrw9p1SKySKQgu6lGFRrlu+fcAPfqzjhSLy
         ZCtn8PFOuLo+fw+vF70r8k1Cm7bxCeEHS9lFpR6Qy6koXFNtmXn5JBhkKeJcAIqDe3X5
         jIEQ==
X-Gm-Message-State: ACrzQf3UfcSc8PuDQKiBhLi2WLPSJ3lzTkK3S+BQcFlwV62kfY+ueh7I
        C5qXyq3ZrUhTiNivp1GSuuhfxfxEM1MSUdMI
X-Google-Smtp-Source: AMsMyM7VVgzW6fLg74VFweIPuV0dwkeqAA08aS9R0Na6kX3IjSfHYwtKXpcRTPOUfKwl/2T4InGlzA==
X-Received: by 2002:a17:906:9c83:b0:779:c14c:55e4 with SMTP id fj3-20020a1709069c8300b00779c14c55e4mr33266409ejc.619.1667557409080;
        Fri, 04 Nov 2022 03:23:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fg10-20020a056402548a00b0046146c730easm1706329edb.75.2022.11.04.03.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 03:23:28 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, kuba@kernel.org,
        moshe@nvidia.com, aeedm@nvidia.com
Subject: [patch iproute2-next 0/3] devlink: make ifname-port relationship behaviour better
Date:   Fri,  4 Nov 2022 11:23:24 +0100
Message-Id: <20221104102327.770260-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
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

This patchset consists of 2 items:
1) patch #1 is fixing output of "devlink mon port" by considering
   possible ifname change during run.
2) patch #3 is benefiting of newly added IFLA_DEVLINK_PORT attribute
   exposing netdev link to devlink port directly. Patch #2 is just
   dependency for patch #3

Jiri Pirko (3):
  devlink: query ifname for devlink port instead of map lookup
  devlink: add ifname_map_add/del() helpers
  devlink: get devlink port for ifname using RTNL get link command

 devlink/devlink.c | 164 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 140 insertions(+), 24 deletions(-)

-- 
2.37.3

