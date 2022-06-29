Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E0C55FB16
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiF2Ixx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiF2Ixv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:53:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3877B3983E
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:53:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a15so14438088pfv.13
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Uj6zbSREGN1nMpBprSeQN/3wmRyMG124zBtpw8EGUY=;
        b=HP2xVzm6iHmSIyFRnEwNNj1TuTcI29bUr3dToCg+36QA62zxkfqMe2dRZ3P7e7iV53
         zj6teoHUcW5J/1LDfErAqHXOHNzR4sCLjnZHBQ7EunphCAY2dUVhCceID+1pUhPLowAN
         NeyBO+LsSZR1tRyXDxRmzW6fGJdPQv8n0uyUXhgK2S8Z2gXisShYCyOGbHoMb8z37TD9
         b4lwhmMChBZnkrzwy0GWD8kBXGnNhE0BxfYwAOco9t5a5BZ6yw4kbLQF8USi9vCmI8jU
         lr13RNLWkV7ytB80qgCT8cZOrDRA89hhq5RBjUJVj2aNb//3doVXgqeERKQKfrOkBgBF
         c0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Uj6zbSREGN1nMpBprSeQN/3wmRyMG124zBtpw8EGUY=;
        b=WolsrfPkVgsCt13sNSBtpzIFdkRiuPjnVALmr9hd4DicV1GHaeBMsME1H+bkCy8jce
         2In+yU11TLbLKYikSsj9eg/j79ZtOZyCOKcc0UzhjXXSBwhtT7GG4DjR9d21Ryye33gB
         RgCYrk/oW7gA3wKhNX1QGYT7W9WvFFFs+kYieBZpJSDx2Tz79oCxdHDbuSe2L1PBkssm
         aOBux/VGWBI7cp5tiE0hUykumsnbwql+MSes3BrQwf1LI+St76MExd5jLQKl4lNP0Xip
         VdpXKD3cyJIFzLosXOz+5wlG/zUoYDqHZbWpy0CddfVXf0LboNTeTF1MJQVVgto3IDH7
         un2Q==
X-Gm-Message-State: AJIora8tj0ewQ/uN7hW7dzTcWJ8QSyXfNUVdrXAyVFpLXgS75ukUt7/i
        YfHSElRTagmHtzQzDWgdSAE=
X-Google-Smtp-Source: AGRyM1u39BpHHkwV8TiwTWISkgl4KiW2WDQLDfUTe/QZC72yvXdjlwWnAPNuN1me3E7U6MN0sJoeag==
X-Received: by 2002:a05:6a00:808:b0:525:3c3f:7393 with SMTP id m8-20020a056a00080800b005253c3f7393mr9281390pfk.57.1656492830744;
        Wed, 29 Jun 2022 01:53:50 -0700 (PDT)
Received: from nvm-geerzzfj.. ([103.142.140.73])
        by smtp.gmail.com with ESMTPSA id y19-20020a17090aca9300b001e0c5da6a51sm1425724pjt.50.2022.06.29.01.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 01:53:50 -0700 (PDT)
From:   Yuwei Wang <wangyuweihx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, daniel@iogearbox.net
Cc:     roopa@nvidia.com, dsahern@kernel.org, qindi@staff.weibo.com,
        netdev@vger.kernel.org, Yuwei Wang <wangyuweihx@gmail.com>
Subject: [PATCH net-next v4 0/2] net, neigh: introduce interval_probe_time for periodic probe
Date:   Wed, 29 Jun 2022 08:48:30 +0000
Message-Id: <20220629084832.2842973-1-wangyuweihx@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a new option `interval_probe_time_ms` in net, neigh
for periodic probe, and add a limitation to prevent it set to 0

Yuwei Wang (2):
  sysctl: add proc_dointvec_ms_jiffies_minmax
  net, neigh: introduce interval_probe_time_ms for periodic probe

 Documentation/networking/ip-sysctl.rst |  6 ++++
 include/linux/sysctl.h                 |  2 ++
 include/net/neighbour.h                |  1 +
 include/uapi/linux/neighbour.h         |  1 +
 include/uapi/linux/sysctl.h            | 37 ++++++++++++-----------
 kernel/sysctl.c                        | 41 ++++++++++++++++++++++++++
 net/core/neighbour.c                   | 32 ++++++++++++++++++--
 net/decnet/dn_neigh.c                  |  1 +
 net/ipv4/arp.c                         |  1 +
 net/ipv6/ndisc.c                       |  1 +
 10 files changed, 103 insertions(+), 20 deletions(-)


base-commit: da6e113ff010815fdd21ee1e9af2e8d179a2680f
-- 
2.34.1

