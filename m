Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E058621232
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiKHNWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbiKHNWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:22:13 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF9A4D5FA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:22:12 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id cl5so20939118wrb.9
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 05:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/x7zktZ6Cb18T3ME1UkDRkpoaeZB0sSQIiFMNPwGMVo=;
        b=sOKxCq52ySpaPDESVrCve03+16R0DhL1oX5UmXoDrURP+vSY8JnqoZtbwoAy3essX8
         mOizHuIyNN3pqDCa5toZWcz3mhAjbEQGKeSD4+X9euuXsB2VtvWJ2lHPIyM++/2TdH2N
         XZFECkZrZkXu2/cG0xm84giGu8X1aloggGRYbhI8jlsM7lVTsM5P9MTX+oJaaRMU6NQm
         kMgZkqGcZ/laZfQ/7q059vJGhvGL/3/wHSrZ69aIM+mPT0OqhmZq0hbLVnhq7buZ8CGN
         kITnyOGdjsiy1ZHR2jkzbDyTA3dTv432+UyWJlcCZca/YoKkjWFtEoDFicRkQkYa4CJo
         woRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/x7zktZ6Cb18T3ME1UkDRkpoaeZB0sSQIiFMNPwGMVo=;
        b=cyITeAwY16ug3PVUnJ9P+g3ia4ImoX+Y7K8Xt7iQeMRLUJE0ZzK3ggbTmPjRfR1niy
         XviOnJw814caMA7uZKv62jxwmVvlUNSemuHP4e/zN94IV2j6ZiGmUzwSiI/fLNrrJrDc
         RhcTxxJRO4ch310UXIS/VwZTRH+W4vODvmnOY3wn0bM0+M7HLjG6mCZHyOjgD6Fyuxhy
         qY780t6LF/CrfYjXQzSXdrgOWjpLvDzEygRqz087iR1U1PQwplMRa605eYU8uTP0aGKF
         FI/qhhSBUmTd1M//rfvq0H5LV6AsPhFcCPigcgHdS/B+4B0jkSvgueMyvPBW7nMdM+aO
         BLkA==
X-Gm-Message-State: ACrzQf0LJ8dsRemZiVvbvGtCB9al+zfyS08oGdYeKJ7K+oeATv026teq
        SA7IPx5shOvwWRXFv/ORNDcAlpoprzqdgM6k
X-Google-Smtp-Source: AMsMyM7zq+g1BsNLGrKYqfelg4HQEvOLakSrkpz+JoliCqrA2YFWFhr9ptpFmlYVLcICRcRPVG3WyQ==
X-Received: by 2002:a5d:4fc8:0:b0:236:9c57:248 with SMTP id h8-20020a5d4fc8000000b002369c570248mr35360732wrw.193.1667913730553;
        Tue, 08 Nov 2022 05:22:10 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l12-20020a05600c2ccc00b003b47ff307e1sm11994403wmc.31.2022.11.08.05.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 05:22:09 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: [patch net-next v2 0/3] net: devlink: move netdev notifier block to dest namespace during reload
Date:   Tue,  8 Nov 2022 14:22:05 +0100
Message-Id: <20221108132208.938676-1-jiri@resnulli.us>
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

Patch #1 is just a dependency of patch #2, which is the actual fix.
Patch #3 adds a small check that would uncover the original bug
instantly.

Jiri Pirko (3):
  net: introduce a helper to move notifier block to different namespace
  net: devlink: move netdev notifier block to dest namespace during
    reload
  net: devlink: add WARN_ON to check return value of
    unregister_netdevice_notifier_net() call

 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 22 ++++++++++++++++++----
 net/core/devlink.c        |  9 ++++++---
 3 files changed, 26 insertions(+), 7 deletions(-)

-- 
2.37.3

