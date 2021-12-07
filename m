Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA1546AF66
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377137AbhLGAzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245599AbhLGAzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:17 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC65C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:51:48 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso671274pji.0
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pj07xbLcN+zeBuPSRg1T0cIFMUj4XryWMbiHYSMo83c=;
        b=bkswEGfo+wMp3TplOV/JmNerJ94tpGYS6MLNp8DgR0lBI8RS8dkoSTHZtWP0a1zHp7
         hj82Xyl2Ry8eXbJaWSXo6mskPiVpC+PjqBtKhHLitq63E2XfUJ3bBQtXBKEYFR3bqAlr
         z3RVqPaqi+7SKXhaK33gb2ffEaHSE5D0GK19Ea0YyMXkKta58wALlPUYsx0U2+01c6DN
         Uh0OaER1ZZJNvTAZGp9pFewr8hzOQgsR+DV5H9PY1ALsoJOkl+uGNVlippALsALa3I3D
         66ipj2CY/0i7ikLf7TNhDC03jplB4MyO0i+gEiJd0BZ179u1gYiIy0C93OQElqX3U7IQ
         LxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pj07xbLcN+zeBuPSRg1T0cIFMUj4XryWMbiHYSMo83c=;
        b=gDxTn42U51MaYuVmLDLzRVKQCQkB7LrNBRYpX+Lt0WnBYtjGeiqFV4FETOrJHzTYe5
         JckKdONXS++UQGpgeqmucHV5f0IcOS0NOiJQFznRxp6/vh2eNJ7zRDFAErJpvir0B2aI
         YQJlgC4KnXbeA/n2g45khLX0SLCN+uFxE8/MjCLhA9ohm7rHH6c68NwvUvFVC72+GhRM
         dMHCKGWeOXtDjQ+czEw36BcXnywZ+PALBiVtG/z4gVjY9M0NMD9/67RkKKrQxruB7Lb6
         2gMGBX8WEWkvSfRNedMXP3Hwboo6GJiOmq7eWYNVWEFoNOCxlANtPGJZ72IebGBCWBsu
         AkGQ==
X-Gm-Message-State: AOAM532kXNkAYKqWJw2Oty/88wPUl/cpRxX7Udkuig2bCdcMSMME/zxw
        RLvUJqrPdYvA+yDjDL5hTQs=
X-Google-Smtp-Source: ABdhPJyr8AhUFcffzfuX92jkAMRFxBuPGUy7by27AJ1NiEEUydBl/BiJjUGnH8FsqB6ZLxrd+Sdlbg==
X-Received: by 2002:a17:90b:4a0f:: with SMTP id kk15mr2485848pjb.223.1638838307689;
        Mon, 06 Dec 2021 16:51:47 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:51:47 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 00/17] net: netns refcount tracking series
Date:   Mon,  6 Dec 2021 16:51:25 -0800
Message-Id: <20211207005142.1688204-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
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

Eric Dumazet (17):
  net: add networking namespace refcount tracker
  net: add netns refcount tracker to struct sock
  net: add netns refcount tracker to struct seq_net_private
  net: sched: add netns refcount tracker to struct tcf_exts
  netfilter: nfnetlink: add netns refcount tracker to struct
    nfulnl_instance
  l2tp: add netns refcount tracker to l2tp_dfs_seq_data
  ppp: add netns refcount tracker
  netfilter: nf_nat_masquerade: add netns refcount tracker to
    masq_dev_work
  SUNRPC: add netns refcount tracker to struct svc_xprt
  SUNRPC: add netns refcount tracker to struct gss_auth
  SUNRPC: add netns refcount tracker to struct rpc_xprt
  net: initialize init_net earlier
  net: add netns refcount tracker to struct nsproxy
  vfs: add netns refcount tracker to struct fs_context
  audit: add netns refcount tracker to struct audit_net
  audit: add netns refcount tracker to struct audit_reply
  audit: add netns refcount tracker to struct audit_netlink_list

 drivers/net/ppp/ppp_generic.c     |  5 ++--
 fs/afs/mntpt.c                    |  5 ++--
 fs/fs_context.c                   |  7 +++---
 fs/nfs/fs_context.c               |  5 ++--
 fs/nfs/namespace.c                |  5 ++--
 fs/proc/proc_net.c                | 19 ++++++++++++---
 include/linux/fs_context.h        |  2 ++
 include/linux/netdevice.h         |  9 +------
 include/linux/nsproxy.h           |  2 ++
 include/linux/seq_file_net.h      |  3 ++-
 include/linux/sunrpc/svc_xprt.h   |  1 +
 include/linux/sunrpc/xprt.h       |  1 +
 include/net/net_namespace.h       | 40 +++++++++++++++++++++++++++++++
 include/net/net_trackers.h        | 18 ++++++++++++++
 include/net/pkt_cls.h             |  8 +++++--
 include/net/sock.h                |  2 ++
 init/main.c                       |  2 ++
 kernel/audit.c                    | 14 +++++++----
 kernel/audit.h                    |  2 ++
 kernel/auditfilter.c              |  3 ++-
 kernel/nsproxy.c                  |  5 ++--
 net/Kconfig.debug                 |  9 +++++++
 net/core/dev.c                    |  3 +--
 net/core/net_namespace.c          | 24 ++++++++-----------
 net/core/sock.c                   |  6 ++---
 net/l2tp/l2tp_debugfs.c           |  9 +++----
 net/netfilter/nf_nat_masquerade.c |  4 +++-
 net/netfilter/nfnetlink_log.c     |  5 ++--
 net/sunrpc/auth_gss/auth_gss.c    | 10 ++++----
 net/sunrpc/svc_xprt.c             |  4 ++--
 net/sunrpc/xprt.c                 |  4 ++--
 31 files changed, 169 insertions(+), 67 deletions(-)
 create mode 100644 include/net/net_trackers.h

-- 
2.34.1.400.ga245620fadb-goog

