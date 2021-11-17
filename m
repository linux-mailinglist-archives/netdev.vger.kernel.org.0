Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6898F454DCB
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhKQTXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbhKQTXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 14:23:35 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944D9C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:20:36 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id x7so3170335pjn.0
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=66IfR39itDZpBqObA61WBE0ZMjAtotl5RniLkeYBXv0=;
        b=cly6Lmyv1k3Yzg4DHsjFReO+bF1W0HXDMnIv/7Pr3rEcaOVb5lZ9yNPu2jqcDytFKH
         6tHmSV7EudpYaLYTVk1Rrp7sQs9bmDvw9dfOFebXJghgI4UM62V6N+34kZNuNQmFl8BB
         Q4LRQax1yQKCf0697Ezy3wXmPuJRCXfBKLMFLQx3sVwluO3jEhQG5tNmZoaBDKS7vB0q
         HoA/Fri5yEHIGqPpZYHqNq62hgdkCtJxdpgxyFrfIxUUzDzaxAJlXaLkmILputDxucBE
         PYt5LVT0T455F5sYgoFZXfb1td3f0hnaDKaW6PTYV3475uRodfUH7r98FCMdOz6ArmYB
         n0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=66IfR39itDZpBqObA61WBE0ZMjAtotl5RniLkeYBXv0=;
        b=aegZ2iifEy4OIdDAXHQwaLR5vyjBSNBFgF4jQKI/9afZLF1stLjH/x9rnbL2W7bKxD
         RGe+Pz/VfvhWEpuYdKHy2s8ou5urfcdU+KOSIb5DlSABOzuPamYZGE35IL7YrZeZMSwm
         VLT1bL5ztW+goB52IBvYwkCkau4d/uN2EESp/NLX/O0y6FSs2cmFRrHYcdI4jxmVN6Uk
         WXSTafjUubaSfwEvA8hrs0+tFw1vMk4ASxPMcyLJiWpUmU12Wk7Rmj9juAOOn7H5hi1d
         eUZQ8lla9usr53B/ACYgUntK/BQiKZ5aqBwF1lugPHXc8USzI370+085D7prQnE+xRA2
         Ofkg==
X-Gm-Message-State: AOAM532aPYLis0zE49ZcJVEwnMELZQopsMkE0tiFCTJz/oJUi7VCdf7z
        2zQ9PZPaIEXfE9r8qgvYbTg=
X-Google-Smtp-Source: ABdhPJzQQZKTZu+laI8LsnMZizpShkRjNpLgTio0cZX1qCZlF33tIPApL+O/h/+5ztnj5ZjQlD6tgw==
X-Received: by 2002:a17:90b:4f86:: with SMTP id qe6mr2559428pjb.224.1637176836166;
        Wed, 17 Nov 2021 11:20:36 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bea:143e:3360:c708])
        by smtp.gmail.com with ESMTPSA id e15sm376698pfc.134.2021.11.17.11.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 11:20:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC -next 0/2] refcount: add tracking infrastructure
Date:   Wed, 17 Nov 2021 11:20:29 -0800
Message-Id: <20211117192031.3906502-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

RFC only, I yet have to convert some dev_put()/dev_hold() to show
how this works.

I am posting this because Jakub is working on same issue.

Eric Dumazet (2):
  lib: add reference counting infrastructure
  net: add dev_hold_track() and dev_put_track() helpers

 include/linux/netdevice.h   |  23 +++++++
 include/linux/ref_tracker.h |  78 ++++++++++++++++++++++++
 lib/Kconfig                 |   4 ++
 lib/Makefile                |   2 +
 lib/ref_tracker.c           | 116 ++++++++++++++++++++++++++++++++++++
 net/Kconfig                 |   8 +++
 net/core/dev.c              |   3 +
 7 files changed, 234 insertions(+)
 create mode 100644 include/linux/ref_tracker.h
 create mode 100644 lib/ref_tracker.c

-- 
2.34.0.rc1.387.gb447b232ab-goog

