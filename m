Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0E442516
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438558AbfFLMKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:10:21 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37251 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404957AbfFLMKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:10:21 -0400
Received: by mail-pl1-f196.google.com with SMTP id bh12so6566022plb.4;
        Wed, 12 Jun 2019 05:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FzWj9Xhuon5QpbEDoeMtLzky5+/Bs1gO2JVhXGS69rU=;
        b=hitdsLAIBJmCOqstVgzBYk7T/tw9Q9CjJnmRkfiU0fRcNOclTQA0fUJ32GxtmOIKCk
         yahfx1aIuASn849H8h4SCbWAQxWnjHWPixtuoM0gsAZl8JIFeeGSu5iMieRnT2GLS5uc
         vPvjrpKtytCGE2zLTjhEkUKaVgEIcCKB8f22x+Fj7msnv7TJyXbV5IGtbclNkByxKxV6
         NUAtXtTuquSezIzdHPWM67b7UPpNY1AYOhSYwlV0KwNqIQPSQ7OkdhVD1GmTs1jlNuox
         TfAIK/22wiKDoTF9YVspEhfFCJFFjFX9EEnJxRD8p6Uy8pzjTQCiP7BU4aVP46MJGW3r
         w1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FzWj9Xhuon5QpbEDoeMtLzky5+/Bs1gO2JVhXGS69rU=;
        b=Hg0IezoKvp8ne/sFqmvHHP2p3HPiY7yi7LI1d/ctbSAoQxDMJ8vNTnqAOq0UEzLHWf
         8TWPktbnjfvfwc6zSMNjgTWT8pAPKfi7JFJgzVdEvR1wPJELpR3VhqnMGMf5chnBUZan
         kpURWjFc4YrCHDrxTq61FxpNwDnjMNZbwf12/QZ4Dc2NBYDI2cpcinJYiZvpc7jB/nDx
         52YUk+xW8BMXfXvvZhhv5obPgzbb/l6VL29+2ELQu5dbQa+/ivX9kvwxfgDCw4wv1BXh
         542p2XHR3dr5XIvaVm1RpQblSWvncir3iYRYGHagz1YVENMhWBaVQe7fWFTfaWtdiiEh
         lk1Q==
X-Gm-Message-State: APjAAAWD7MyL1JBZ+khBU69gpJxX28xHGhR6hOYIpqF+u4kVWnrroQjf
        JKV6CezVB80AxHejz7nap3IXO0Lo3Ug=
X-Google-Smtp-Source: APXvYqzoj3tzZ+XGMPpbzQlbGEDBYK866FfUXZZy3+TZnqIKBMniNjaG+z4EySHYOcpy7rRUQqCR3A==
X-Received: by 2002:a17:902:b102:: with SMTP id q2mr71770682plr.149.1560341420193;
        Wed, 12 Jun 2019 05:10:20 -0700 (PDT)
Received: from bridge.tencent.com ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id s5sm5035653pji.9.2019.06.12.05.10.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:10:19 -0700 (PDT)
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
X-Google-Original-From: Wenbin Zeng <wenbinzeng@tencent.com>
To:     bfields@fieldses.org, davem@davemloft.net, viro@zeniv.linux.org.uk
Cc:     jlayton@kernel.org, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, wenbinzeng@tencent.com,
        dsahern@gmail.com, nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH v3 0/3] auth_gss: netns refcount leaks when use-gss-proxy==1
Date:   Wed, 12 Jun 2019 20:09:27 +0800
Message-Id: <1560341370-24197-1-git-send-email-wenbinzeng@tencent.com>
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
v2->v3:
 * rpcsec_gss_evict_net() directly call gss_svc_shutdown_net() regardless
   if gssp_clnt is null, this is exactly same to what rpcsec_gss_exit_net()
   previously did

Wenbin Zeng (3):
  nsfs: add evict callback into struct proc_ns_operations
  netns: add netns_evict into netns_operations
  auth_gss: fix deadlock that blocks rpcsec_gss_exit_net when
    use-gss-proxy==1

 fs/nsfs.c                      |  2 ++
 include/linux/proc_ns.h        |  1 +
 include/net/net_namespace.h    |  1 +
 net/core/net_namespace.c       | 12 ++++++++++++
 net/sunrpc/auth_gss/auth_gss.c |  4 ++--
 5 files changed, 18 insertions(+), 2 deletions(-)

-- 
1.8.3.1

