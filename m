Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2327D2CF42F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgLDSgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgLDSgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:36:01 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1593EC061A51
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 10:35:15 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r5so6808143eda.12
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 10:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VazwCTbw4qFEcnDS99kE7+UPTpKgFLvwXrTcJ/OGLV8=;
        b=UoAtycuWbYXPQuHZa93zSkhDkJSIw0b5/ox+c+olIK8DcmAbppcTQ0S5nqiX68rqak
         O0OcRXvbaYs59/0lhZyyDXuBE89LpLU/4sCiBqYoY+7kZml0b8FecNEzYnsNUW08Ihz5
         QF7SSKQPyyDDQa2ClfTAFtqizjUB+y8xrZebWbkw7H4Qp0JbSS6Bojpr/Kkqn2+Oksnw
         wT3LhcfoTMGVZj4tJFFM5mxJMYg2KBifKrCXcs7TzgB+i0DrF+DvPoqZuF/7IlEChaWv
         6gSm3TUC/frYOd6VZB2UEePpomfz08LS4mRk9rLZ8P3hSyX0ElAYgJiZ6EcXcffOOCH/
         GBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VazwCTbw4qFEcnDS99kE7+UPTpKgFLvwXrTcJ/OGLV8=;
        b=Oy4B4RAizh4u7t2mC/fjwmM0JsZQO1yLidqFPPZAnJRLVgmESlN3dD410k5cUD29IN
         0V2uKNuhsvUzSV9REpUOWGG58AHMAu6LP11Y51e36Dc6UqZiid8oc5eq6jUTQh5PZJo+
         Wk0rnNK4Iaf4frFViyJaH2wzVRr/bWSwrNIrTWFxNhqS8xAFXpHLMgXow0WaUUeuECcw
         GFOw8NTUrlgXY0suS6o0yEH0Ujaz1GVWvMFFbWNyLrAYHiLHX0KzY6Oep90g1m2brETI
         DENyHmfIG3UEuRhtv8uKYq/4YPbZCoih/yoK2z5LEbEjhmAkPqPZKJOwgk+r0Vfz26if
         NZCw==
X-Gm-Message-State: AOAM531POSmAq8eQq12ajnHWVWayu+SL929u8hXg5qs7nlHAF7URUrQx
        2wRD0hOqB/4WlZvxfhFy4+1W+3m2up1DqlWRW+kP7A==
X-Google-Smtp-Source: ABdhPJySBMs5wep5prKn4dGE0xz5+ByoMr95Z/1QhLJVmuU6vp5fZu61EN8FWgCSAJCp3cpH5tedG2S4/91FYDuyvnU=
X-Received: by 2002:aa7:d74d:: with SMTP id a13mr5352244eds.78.1607106913506;
 Fri, 04 Dec 2020 10:35:13 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 5 Dec 2020 00:05:02 +0530
Message-ID: <CA+G9fYvhvZtDYVBo4kj9OkKY_vVFSa6EbWz99iCmRPojExRieA@mail.gmail.com>
Subject: BUG: KCSAN: data-race in __rpc_do_wake_up_task_on_wq / xprt_request_transmit
To:     kasan-dev <kasan-dev@googlegroups.com>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-nfs@vger.kernel.org,
        lkft-triage@lists.linaro.org, rcu@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, chuck.lever@oracle.com,
        bfields@fieldses.org, anna.schumaker@netapp.com,
        trond.myklebust@hammerspace.com,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LKFT started testing KCSAN enabled kernel from the linux next tree.
Here we have found BUG: KCSAN: data-race in
__rpc_do_wake_up_task_on_wq / xprt_request_transmit

This report is from an x86_64 machine clang-11 linux next 20201201.
Since we are running for the first time we do not call this regression.

[   17.316725] BUG: KCSAN: data-race in __rpc_do_wake_up_task_on_wq /
xprt_request_transmit
[   17.324821]
[   17.326322] write to 0xffff90a801de6a9c of 2 bytes by task 142 on cpu 1:
[   17.333022]  __rpc_do_wake_up_task_on_wq+0x295/0x350
[   17.337987]  rpc_wake_up_queued_task+0x99/0xc0
[   17.342432]  xprt_complete_rqst+0xef/0x100
[   17.346533]  xs_read_stream+0x9c6/0xc40
[   17.350370]  xs_stream_data_receive+0x60/0x130
[   17.354819]  xs_stream_data_receive_workfn+0x5c/0x90
[   17.359784]  process_one_work+0x4a6/0x830
[   17.363795]  worker_thread+0x5f7/0xaa0
[   17.367548]  kthread+0x20b/0x220
[   17.370780]  ret_from_fork+0x22/0x30
[   17.374359]
[   17.375858] read to 0xffff90a801de6a9c of 2 bytes by task 249 on cpu 3:
[   17.382473]  xprt_request_transmit+0x389/0x7a0
[   17.386919]  xprt_transmit+0xfe/0x250
[   17.390583]  call_transmit+0x10d/0x120
[   17.394337]  __rpc_execute+0x12d/0x700
[   17.398089]  rpc_async_schedule+0x59/0x90
[   17.402100]  process_one_work+0x4a6/0x830
[   17.406114]  worker_thread+0x5f7/0xaa0
[   17.409868]  kthread+0x20b/0x220
[   17.413099]  ret_from_fork+0x22/0x30
[   17.416675]
[   17.418167] Reported by Kernel Concurrency Sanitizer on:
[   17.423475] CPU: 3 PID: 249 Comm: kworker/u8:1 Not tainted
5.10.0-rc6-next-20201201 #2
[   17.431385] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[   17.438778] Workqueue: rpciod rpc_async_schedule

metadata:
    git_repo: https://gitlab.com/aroxell/lkft-linux-next
    target_arch: x86
    toolchain: clang-11
    git_describe: next-20201201
    download_url: https://builds.tuxbuild.com/1l8eiWgGMi6W4aDobjAAlOleFVl/

Full test log link,
https://lkft.validation.linaro.org/scheduler/job/2002643#L1005

-- 
Linaro LKFT
https://lkft.linaro.org
