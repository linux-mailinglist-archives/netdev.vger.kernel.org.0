Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C151010587
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 08:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfEAGm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 02:42:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34669 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfEAGm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 02:42:56 -0400
Received: by mail-pl1-f194.google.com with SMTP id ck18so3550173plb.1;
        Tue, 30 Apr 2019 23:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=beknjYINW1vOED6WG9jtPKU0KCvm6eKI+KuD6xRtVow=;
        b=Li2tjDtFodzMtKZddiSawePYQNHhKcEDjzlw7HHOLEvyRhHZLqgjtfl4GZw5lbFrpc
         dRA7Kx3usDYrXgvjr3NZewRrU0y+BH5v5zYTpFF/l7wCewPOjaZ61zgwZL4IQlVKBzow
         IlS+2EHqY5671Q6RIyXcvm/3qvi/wA9GR14lM4UR/IyXHFb4B9Xr7hC+MXDv8+O7tbHZ
         1rzMLrqB+fJERcwz1uYCLP7+oO1HU4aSi9Am+bdRp0c7IDwOPaQmc4w4CQWlmfdxtYO7
         +pyQ9aMej9LTEl1/sk8P1Nzc60AZ9SDgFyYPxmU2R3q+Jrz8FeW8k1PqpE+sDWLCAcwc
         Mqgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=beknjYINW1vOED6WG9jtPKU0KCvm6eKI+KuD6xRtVow=;
        b=cF8sPkcG1f63rYNYTlpQc1R76APbEbmKubTC3CaW2rcVUgSRS/2orOciOJLL3HdIiu
         hGGx8xXTpu7RVf+mw8+UKT/2gSOu/Oo+UnwJBA4dGP4meV9Mg3ljeuef45fkB00haR9A
         vCMQn96lxZ7AtWZL/1qNzWEFGMJtAGb2yxkYCUyAbRAa+ssVBkZYjrvQqOjrZB+kB9AX
         tB35eMbSVgSCuV//MBS5+Xc6gMSecMV9Ol2EenD4nZCv7FDAgJg9cT4kWwp6hBmS9L8w
         jom/h8QkNIfsdOhUAhtoJ+SjOyKNMeDhWsPq9pudYBCaFcR89ZTarH1fiEAZL0xGLLOx
         kVAg==
X-Gm-Message-State: APjAAAWiTFMCCQgzu3mCOCYXa4X3CCmPFjTGLCrixJR1eAUv8AHsXTeq
        Anh0vuUpc4aGgvuHidqAiNg=
X-Google-Smtp-Source: APXvYqyMoEr7FhUfBVsNlCw915ZYE92+xxw7SCzLDB2SSfK/dTEMav15LkOXzFYhd0PO6Mlb3cNKHA==
X-Received: by 2002:a17:902:76c5:: with SMTP id j5mr75212990plt.337.1556692975835;
        Tue, 30 Apr 2019 23:42:55 -0700 (PDT)
Received: from bridge.localdomain ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id 25sm56800323pfo.145.2019.04.30.23.42.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 23:42:54 -0700 (PDT)
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
X-Google-Original-From: Wenbin Zeng <wenbinzeng@tencent.com>
To:     viro@zeniv.linux.org.uk, davem@davemloft.net, bfields@fieldses.org,
        jlayton@kernel.org, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, wenbinzeng@tencent.com,
        dsahern@gmail.com, nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH 0/3] auth_gss: netns refcount leaks when use-gss-proxy==1
Date:   Wed,  1 May 2019 14:42:22 +0800
Message-Id: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes an auth_gss bug that results in netns refcount leaks when use-gss-proxy is set to 1.

The problem was found in privileged docker containers with gssproxy service enabled and /proc/net/rpc/use-gss-proxy set to 1, the corresponding struct net->count ends up at 2 after container gets killed, the consequence is that the struct net cannot be freed.

It turns out that write_gssp() called gssp_rpc_create() to create a rpc client, this increases net->count by 2; rpcsec_gss_exit_net() is supposed to decrease net->count but it never gets called because its call-path is:
	net->count==0 -> cleanup_net -> ops_exit_list -> rpcsec_gss_exit_net
Before rpcsec_gss_exit_net() gets called, net->count cannot reach 0, this is a deadlock situation.

To fix the problem, we must break the deadlock, rpcsec_gss_exit_net() should move out of the put() path and find another chance to get called, I think nsfs_evict() is a good place to go, when netns inode gets evicted we call rpcsec_gss_exit_net() to free the rpc client, this requires a new callback i.e. evict to be added in struct proc_ns_operations, and add netns_evict() as one of netns_operations as well.

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

