Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B43A28905B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390231AbgJIR5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgJIR5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:57:32 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03D9C0613D2;
        Fri,  9 Oct 2020 10:57:32 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j13so6009894ilc.4;
        Fri, 09 Oct 2020 10:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=fhckr9t15zkqok8A7BECkV8H2Y2YB45c4WYRODFhpmk=;
        b=F703kJxOqLjzfO1Jf7ckFfr0x/MjmrT3BMozeZQWG0DDVvbhjnEbjLHWLoOwehS+bP
         y1NjuRk/0EGKKe43maZAxCAt0IIRMHhW2/v9yN/XYwN792rKh2FejDLKR061DMOLpA4g
         X7qSZkN0DxdYwCyOCDQt7ZHCKd0JeumjeDS4BVXJARMX55QrM+NQlYtyjvLn2jFhh6mJ
         Zcq688rRBVqdaGyR6Glhigu/j7+jJPo1YqxG1t0LX5Sftmi6JzC+7uUpvc6rCBesxECd
         jw1rd7pLFxyTkkfHtPu7jedQutRUXWA3T36TqK3VsYTSyX3qPQaRkcxmY4lYvwcAO6ai
         0gEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=fhckr9t15zkqok8A7BECkV8H2Y2YB45c4WYRODFhpmk=;
        b=B/uvwvyu0IZVdygoCaXGI75/ESAT/yKDjxKps5Yat35+GwA54x+yg15scex8ORolrJ
         6z0XpFB5RNsC/6LfsFdaVeWO/anB0ahVMbtIwmCkMciop9cTvX8famM+tJZHk1VjXN/6
         1t78KxN3do5m1xQuTNdsLaQqWw+rRot5JrkbeZkZe6WMHnrwgmdOmtlRmxYQ3QjVKJj2
         aEPV05eEMCzMK9gldoQz3jo+ODIetCKxY8ApY/nsM6OnAfs51zTfWAN5AW+rTR3JP+mO
         B9ZfH8k8qsSffKSNO83sadyyM0zvc9INiqr3x27ZUEedPKc1TQQwiuLCNc2lSqQnZ7fn
         Fgcw==
X-Gm-Message-State: AOAM532Z2dmkoizgXsC1BqYdh97QOoTGBYTWtCGbtioVMAmvjQMNR38S
        xPtrTkRjUD/FjXE/c0R4JOQ=
X-Google-Smtp-Source: ABdhPJx3WdN0cWV7zKKpnwje3wfU1kRe7bNHFAGuxidHwqkZmkqsHCaiXyOrstn4H27cqwgquMCaDg==
X-Received: by 2002:a92:dd0f:: with SMTP id n15mr11532165ilm.227.1602266251909;
        Fri, 09 Oct 2020 10:57:31 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c28sm4686001ilf.3.2020.10.09.10.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:57:31 -0700 (PDT)
Subject: [bpf-next PATCH v2 0/6] sockmap/sk_skb program memory acct fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 10:57:19 -0700
Message-ID: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users of sockmap and skmsg trying to build proxys and other tools
have pointed out to me the error handling can be problematic. If
the proxy is under-provisioned and/or the BPF admin does not have
the ability to update/modify memory provisions on the sockets
its possible data may be dropped. For some things we have retries
so everything works out OK, but for most things this is likely
not great. And things go bad.

The original design dropped memory accounting on the receive
socket as earlyy as possible. We did this early in sk_skb
handling and then charged it to the redirect socket immediately
after running the BPF program.

But, this design caused a fundamental problem. Namely, what should we do
if we redirect to a socket that has already reached its socket memory
limits. For proxy use cases the network admin can tune memory limits.
But, in general we punted on this problem and told folks to simply make
your memory limits high enough to handle your workload. This is not a
really good answer. When deploying into environments where we expect this
to be transparent its no longer the case because we need to tune params.
In fact its really only viable in cases where we have fine grained
control over the application. For example a proxy redirecting from an
ingress socket to an egress socket. The result is I get bug
reports because its surprising for one, but more importantly also breaks
some use cases. So lets fix it.

This series cleans up the different cases so that in many common
modes, such as passing packet up to receive socket, we can simply
use the underlying assumption that the TCP stack already has done
memory accounting.

Next instead of trying to do memory accounting against the socket
we plan to redirect into we keep memory accounting on the receive
socket until the skb can be put on the redirect socket. This means
if we do an egress redirect to a socket and sock_writable() returns
EAGAIN we can requeue the skb on the workqueue and try again. The
same scenario plays out for ingress. If the skb can not be put on
the receive queue of the redirect socket than we simply requeue and
retry. In both cases memory is still accounted for against the
receiving socket.

This also handles head of line blocking. With the above scheme the
skb is on a queue associated with the socket it will be sent/recv'd
on, but the memory accounting is against the received socket. This
means the receive socket can advance to the next skb and avoid head
of line blocking. At least until its receive memory on the socket
runs out. This will put some maximum size on the amount of data any
socket can enqueue giving us bounds on the skb lists so they can't grow
indefinately.

Overall I think this is a win. Tested with test_sockmap from selftsts
and running netperf in a small k8s cluster.

These are fixes, but I tagged it for bpf-next considering we are
at -rc8.

v1->v2: Fix uninitialized/unused variables (kernel test robot)

---

John Fastabend (6):
      bpf, sockmap: skb verdict SK_PASS to self already checked rmem limits
      bpf, sockmap: On receive programs try to fast track SK_PASS ingress
      bpf, sockmap: remove skb_set_owner_w wmem will be taken later from sendpage
      bpf, sockmap: remove dropped data on errors in redirect case
      bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
      bpf, sockmap: Add memory accounting so skbs on ingress lists are visible


 net/core/skmsg.c |   83 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 38 deletions(-)

--
Signature
