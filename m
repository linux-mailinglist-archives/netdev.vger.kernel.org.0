Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969DC46FC01
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhLJHsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhLJHsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:48:08 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC530C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 23:44:33 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id m24so7343864pgn.7
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 23:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Nhjx5DF8RroTcl7RL0hHzjk66HYBncFii1gZpVJAkI=;
        b=lhWIljT+yQl/OZVYrQAXP+SwCHpQ9h2/VbziF5HvPoyWbIdbcW2Ce1jyuMZiN5TsuI
         df+RwTYl1B81U1ZWT0STSlzjlaarzf7sCq8A3WV8L+ca8HdUjyG4K9GvECrlZujDi0ox
         yoX8CCwxaU14mf9GEERuvDL26BgU77WBkemiLpWm1dRXJ6qgM1fLJexgsJJUVjCsXf9A
         h/aRyFFrVTBFDglE7nfBXwjf07s/atg5zQWj6I51AhWIznfpr66gJiSglAHKuF7iW8kd
         Rd0VmtTS02SypjuwE0TymXegZvqi949/laN6hFHJiZWG4wncXEYF50VMiwOsxAlJgrik
         NcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Nhjx5DF8RroTcl7RL0hHzjk66HYBncFii1gZpVJAkI=;
        b=YZc8NgVQig/JGDk48uTEPQcYoJZdGq4SqDWI0BcoaKk1QcXKX9Gi3SqwhYKWCqPdxd
         P5a1U+tSBk9Z+EFIe5y+jsN1jLULtR2oPEruosHZc1UCs8zaf7/n8fz2WJbVyS2BJtq9
         1ghySQ9WQKJ1j42J0Q1qep3tBpYqkCVyh5y3TPTqXBKn+U5PmkyCpMPf5OJiDZaWTfwe
         Jvx4U8uT7Zin76EN8qn642kLRyZsKCFfMdSlJVzXtQdnzr8crWYGab7cz7UhIV5XTK+D
         AngI4eyidPpeZMoZnSIoVp3hLvW8WnvMDo0CJ4bIVMwOiE/i6OycUqBPhazUeedX8HaL
         XzDw==
X-Gm-Message-State: AOAM533drg3iyrsMs6GAncyD1v7ZNimgaEJNgQ6nurb/PjXTbToU43EQ
        4RQKxO+gACYtwEKOtH/2JZ95RB8Di9DMPg==
X-Google-Smtp-Source: ABdhPJwgV7+stPi927KcQfjteD10/qSfT3P/rlw27F5992UvR1n5UDubRFO1/mXjVOfZf+K1ZuvJRw==
X-Received: by 2002:a63:68d:: with SMTP id 135mr38447753pgg.547.1639122273282;
        Thu, 09 Dec 2021 23:44:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4f5:a6b4:3889:ebe5])
        by smtp.gmail.com with ESMTPSA id y12sm2001346pfe.140.2021.12.09.23.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 23:44:32 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH V2 net-next 0/6] net: netns refcount tracking, base series
Date:   Thu,  9 Dec 2021 23:44:20 -0800
Message-Id: <20211210074426.279563-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We have 100+ syzbot reports about netns being dismantled too soon,
still unresolved as of today.

We think a missing get_net() or an extra put_net() is the root cause.

In order to find the bug(s), and be able to spot future ones,
this patch adds CONFIG_NET_NS_REFCNT_TRACKER and new helpers
to precisely pair all put_net() with corresponding get_net().

To use these helpers, each data structure owning a refcount
should also use a "netns_tracker" to pair the get() and put().

Small sections of codes where the get()/put() are in sight
do not need to have a tracker, because they are short lived,
but in theory it is also possible to declare an on-stack tracker.

v2: Include core networking patches only.

Eric Dumazet (6):
  net: add networking namespace refcount tracker
  net: add netns refcount tracker to struct sock
  net: add netns refcount tracker to struct seq_net_private
  net: sched: add netns refcount tracker to struct tcf_exts
  l2tp: add netns refcount tracker to l2tp_dfs_seq_data
  ppp: add netns refcount tracker

 drivers/net/ppp/ppp_generic.c |  5 +++--
 fs/proc/proc_net.c            | 19 ++++++++++++++++---
 include/linux/netdevice.h     |  9 +--------
 include/linux/seq_file_net.h  |  3 ++-
 include/net/net_namespace.h   | 34 ++++++++++++++++++++++++++++++++++
 include/net/net_trackers.h    | 18 ++++++++++++++++++
 include/net/pkt_cls.h         |  8 ++++++--
 include/net/sock.h            |  2 ++
 net/Kconfig.debug             |  9 +++++++++
 net/core/net_namespace.c      |  3 +++
 net/core/sock.c               |  6 +++---
 net/l2tp/l2tp_debugfs.c       |  9 +++++----
 12 files changed, 102 insertions(+), 23 deletions(-)
 create mode 100644 include/net/net_trackers.h

-- 
2.34.1.173.g76aa8bc2d0-goog

