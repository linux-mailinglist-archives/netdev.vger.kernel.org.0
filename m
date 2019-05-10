Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A951986F
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 08:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfEJGg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 02:36:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44296 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfEJGgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 02:36:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id z16so2495969pgv.11;
        Thu, 09 May 2019 23:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vT8J+5xe8+a83KFHodncMBgwSSqGKELQF/J0hFsWGtA=;
        b=qw5fJbIGPWcA28KqHaWQHU/4N2mlSVKQW5V8JZ3jxW1bmtyoGCRFuE54VT++XfaTJk
         ECxfJP3LMFFdmQKpmVSMTUFPSj7EQEhyrpUmvoWn/JXvQhhTXtoIPmM7IVQnrvIX4sGC
         luQbTA0HnLqWm4CZGiDjuLFIht94D1/x4evanFtBzUyXK3HUy10849a4P5DDwa+tUzMm
         DoYdzXrW0LGwGe+Jqc5v7SWv9BHbuNCuFUEYQwMhetftF7i5eySCSCclPrmkA4t0cNpI
         kbUsdwY722an5VqZDnc9t9W0IB87r2MsZAstjN8j1nZ1EE/0htDpUiHwk4gyh8iio2s3
         U9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vT8J+5xe8+a83KFHodncMBgwSSqGKELQF/J0hFsWGtA=;
        b=JfQNZkXFzQutdtHDMWk2DIE0YH9/Yf5EC7v/NpxJ9aZLr9y8SCUyeNSkcBiPfkhEBJ
         PZHInS0c/3y87g81XcK0mvOYliNBrVro/9yYlivT/DJQo6CCB6IzTOS8wZL5+s8bky8Z
         qkw+WL/NmiVGXnB0VCKrP5kunyN62CAqLw0LnvN7C3tJXHnYyp73XfMToX44DRdoLtcy
         N5P6HoeX4m8jpg57OhFC/w+owCiUMAmeoBWMiLxdz0FTtb90thFOdXIEW0YjOEpsjM9M
         nsXJeLfusjv6Zs0PvacVLwdphMIBON/RumLMFj/hujnFCgTBS77PIhm2G8cupymF0z6+
         jqiA==
X-Gm-Message-State: APjAAAVFU77qHIgHL+fyu5KS+6kmlbDQJaj7B1iW/c1z6H0KG+IkaRYJ
        UroImobV1RWP3nTsh7O/DRo=
X-Google-Smtp-Source: APXvYqwSCNBXHSW4DyU7xEdjpK+/gp7Kt1cZx3ZbTpDXuFDJYS90bWQTn34/E72UI3GXTtUvVjOxaQ==
X-Received: by 2002:aa7:9109:: with SMTP id 9mr11557887pfh.244.1557470214902;
        Thu, 09 May 2019 23:36:54 -0700 (PDT)
Received: from bridge.localdomain ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id v6sm4469263pgi.88.2019.05.09.23.36.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 23:36:54 -0700 (PDT)
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
X-Google-Original-From: Wenbin Zeng <wenbinzeng@tencent.com>
To:     bfields@fieldses.org, viro@zeniv.linux.org.uk, davem@davemloft.net
Cc:     jlayton@kernel.org, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, wenbinzeng@tencent.com,
        dsahern@gmail.com, nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v2 0/3] auth_gss: netns refcount leaks when use-gss-proxy==1
Date:   Fri, 10 May 2019 14:36:00 +0800
Message-Id: <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes an auth_gss bug that results in netns refcount
leaks when use-gss-proxy is set to 1.

The problem was found in privileged docker containers with gssproxy service
enabled and /proc/net/rpc/use-gss-proxy set to 1, the corresponding
struct net->count ends up at 2 after container gets killed, the consequence
is that the struct net cannot be freed.

It turns out that write_gssp() called gssp_rpc_create() to create a rpc
client, this increases net->count by 2; rpcsec_gss_exit_net() is supposed
to decrease net->count but it never gets called because its call-path is:
        net->count==0 -> cleanup_net -> ops_exit_list -> rpcsec_gss_exit_net
Before rpcsec_gss_exit_net() gets called, net->count cannot reach 0, this
is a deadlock situation.

To fix the problem, we must break the deadlock, rpcsec_gss_exit_net()
should move out of the put() path and find another chance to get called,
I think nsfs_evict() is a good place to go, when netns inode gets evicted
we call rpcsec_gss_exit_net() to free the rpc client, this requires a new
callback i.e. evict to be added in struct proc_ns_operations, and add
netns_evict() as one of netns_operations as well.

v1->v2:
 * in nsfs_evict(), move ->evict() in front of ->put()

Wenbin Zeng (3):
  nsfs: add evict callback into struct proc_ns_operations
  netns: add netns_evict into netns_operations
  auth_gss: fix deadlock that blocks rpcsec_gss_exit_net when
    use-gss-proxy==1

 fs/nsfs.c                      |  2 ++
 include/linux/proc_ns.h        |  1 +
 include/net/net_namespace.h    |  1 +
 net/core/net_namespace.c       | 12 ++++++++++++
 net/sunrpc/auth_gss/auth_gss.c |  9 ++++++---
 5 files changed, 22 insertions(+), 3 deletions(-)

-- 
1.8.3.1

