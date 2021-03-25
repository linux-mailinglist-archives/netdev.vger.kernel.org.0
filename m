Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92A134992B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhCYSIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhCYSIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:08:22 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433F1C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id q5so2862308pfh.10
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hfm7pI8K0MqDI1FiwuqN2IUGjZSU/PIi6H52bEDIPVo=;
        b=AsefGD3WRKq2nau+m15ilGsCoBJIegKUpzZDUE7Mwd7rwOOgVoUVd8vc2P/QtniXkK
         6zEDo/+gV6MllPH5LXfDm5b6S3efRwyb/N6gBAObiO/ivvE9ipTW398xvzUAQZLkFeic
         7dITO/OoXyL5xQFaWDFp+BXO6Khd6axIARO/8hk50l3bjurSt8mHnWaLEC6siq62F9iL
         PaqMe28AMwIqhy7Gc29hxkwxGbv4npuS5fz38f7a80HTKx0YXHhZsuGBmRdQj7lG9XpM
         Eg8y0UVR3e9+oNELTfUVFSqiV/WpBAi4ZrKFumONLKbY+RC+RXKB4ELbqKy6ELVZsv3/
         h3yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hfm7pI8K0MqDI1FiwuqN2IUGjZSU/PIi6H52bEDIPVo=;
        b=m3nT4KCGcS46tefGm3Yyqwwc1HIJdtWSVtMRD7fQK6JgX4KDz5wUiLiZysygkE8fH9
         DMF3BlM004oBm0ivW7VGto8j//68+JfcZ4HDJyWWIUVDId1udrP6Xg9N6ruV7COg0xnE
         z8zIwTmt4eqmv2IO/9xSeDPtgFJSmche99dgXiF4rw2igClnb+864xc9+OlHaKEMhHGk
         l8Z0Dv/ZZiO5aTRu0649qcTD8X3U/MW2DD4XNEeC37RdPT5mEEFxP+xibt5pQhpYp8rp
         3Uem5XdKHXe453n8I/8si3HxNMQOR80B2LuqnuEOxbsNw6jnr/djUOms/t0NMQsqsd5W
         xoqQ==
X-Gm-Message-State: AOAM531WvIgLMdhZ85P6VV9FaoL7Ktq7GeliHmJ+Nhn8s7BkCVUkonfC
        ELUHQ+W9uGCG3mrBkLAyRrA=
X-Google-Smtp-Source: ABdhPJzlDV58Uy67g1RE7fK68YHmEnx4eExyR23fUztgN7O3maQFF/1wqy9nGFb38OZM4/f6c7/JVw==
X-Received: by 2002:a63:2d45:: with SMTP id t66mr8358781pgt.449.1616695701812;
        Thu, 25 Mar 2021 11:08:21 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2c0c:35d8:b060:81b3])
        by smtp.gmail.com with ESMTPSA id j20sm5968359pjn.27.2021.03.25.11.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:08:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/5] net: use less storage for most sysctl
Date:   Thu, 25 Mar 2021 11:08:12 -0700
Message-Id: <20210325180817.840042-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This patch series adds a new sysctl type, to allow using u8 instead of
"int" or "long int" types.

Then we convert mosts sysctls found in struct netns_ipv4
to shrink it by three cache lines.

Eric Dumazet (5):
  sysctl: add proc_dou8vec_minmax()
  ipv4: shrink netns_ipv4 with sysctl conversions
  ipv4: convert ip_forward_update_priority sysctl to u8
  inet: convert tcp_early_demux and udp_early_demux to u8
  tcp: convert elligible sysctls to u8

 fs/proc/proc_sysctl.c      |   6 ++
 include/linux/sysctl.h     |   2 +
 include/net/netns/ipv4.h   | 106 +++++++++----------
 kernel/sysctl.c            |  65 ++++++++++++
 net/ipv4/sysctl_net_ipv4.c | 212 ++++++++++++++++++-------------------
 5 files changed, 232 insertions(+), 159 deletions(-)

-- 
2.31.0.291.g576ba9dcdaf-goog

