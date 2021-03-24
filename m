Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C506934834F
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbhCXU7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238188AbhCXU7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:59:24 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7359C06174A;
        Wed, 24 Mar 2021 13:59:23 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id 19so303495ilj.2;
        Wed, 24 Mar 2021 13:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=NESGUyPvHL7cCoVnbsS2gymQUCnVSgr6wRyH7bS6EFQ=;
        b=S+BLe/cT5ZlLK94ci/pFtEACTd3Pq/k3Y8J6rLZ2FwYP0HptAdHmNPN8/LASu3grfw
         hii1c9YKX3kuA7OBxONq2PzssbtlCIFBq4TEoADxm/Xh1jWVdYikuZRxikUx7isy1KHT
         EPv2Crsr98o1ZlPnBDKfe2GkQZy2QkcYP15hD8Glc5FqSKcFEVJ+vpAJY+L0pgTbh/ii
         TQ6wwVYfN1+W3HOGs8DffGZrWxzVVFRSRT2fuB1KivwsFcFiHzCGYVQdWBJMDqIQHdqv
         qUqqxfY1GgKeHbaiQoFiFm7zj1EBUY2GwCmQ0PaQvzGxNk7BVR4RaWfZrhyMOpPbfEUW
         KvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=NESGUyPvHL7cCoVnbsS2gymQUCnVSgr6wRyH7bS6EFQ=;
        b=eZZ4Sd1dKIcZ2bBbujLEyJ1GJs4UGg2GElfV62HWgt8uehane7vIjhDLIM5FXFPSXS
         27wS7jBwd4su1nTUL4JQM1mUM8cJVwqj1BrZO+K87cc7ZssrVNrbJnJEJsvW/z3fyHuu
         wnlOwpzaz8PpAoODeK+MKWaBL72fRAL4aaeqmSI4r2uiSD8lx6naZhVdHxJsy7N1e6h/
         Xh1CNhM1hJAAHZRtejPC+mJK6Efv3C+NliIc95fhupaDelQ/5/4v7IrwjRpscqKTd7y2
         HQWaxAKDdBeaqsEO8xuNntbA906ztIJZVd89n/R9Jh5ltOS9k+c/KIpw+Zd11Xz4XUed
         YQWg==
X-Gm-Message-State: AOAM533kHuXjQswUagr9OAbjhcJMTyURbzS6ITLeUW3Nx0Cs6hjNR6eA
        t0X8qUEN+zMGuhKwDr4mWRU=
X-Google-Smtp-Source: ABdhPJxmLxcgn41PV9qTp+HG9HlZoDocxzhEeL6RPFP7ANZwg98VbqPkMBiUQqAR/iKLCM76iGhsMw==
X-Received: by 2002:a05:6e02:13ad:: with SMTP id h13mr4227115ilo.32.1616619563227;
        Wed, 24 Mar 2021 13:59:23 -0700 (PDT)
Received: from [127.0.1.1] ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id m1sm1363105ilh.69.2021.03.24.13.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 13:59:22 -0700 (PDT)
Subject: [bpf PATCH 0/2] bpf, sockmap fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, andrii@kernel.org, daniel@iogearbox.net,
        ast@fb.com
Cc:     xiyou.wangcong@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lmb@cloudflare.com
Date:   Wed, 24 Mar 2021 13:59:10 -0700
Message-ID: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses an issue found while reviewing latest round of sock
map patches and an issue reported from CI via Andrii.

The CI discovered issue was introduced by over correcting our
previously broken memory accounting. After the fix, "bpf, sockmap:
Avoid returning unneeded EAGAIN when redirecting to self" we fixed
a dropped packet and a missing fwd_alloc calculations, but pushed
it too far back into the packet pipeline creating an issue in the
unlikely case socket tear down happens with an enqueued skb. See
patch for details.

Tested with usual suspects: test_sockmap, test_maps, test_progs
and test_progs-no_alu32.

---

John Fastabend (2):
      bpf, sockmap: fix sk->prot unhash op reset
      bpf, sockmap: fix incorrect fwd_alloc accounting


 include/linux/skmsg.h |    1 -
 net/core/skmsg.c      |   13 ++++++-------
 net/tls/tls_main.c    |    6 ++++++
 3 files changed, 12 insertions(+), 8 deletions(-)

--
Signature
