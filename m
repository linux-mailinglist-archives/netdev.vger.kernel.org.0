Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624EE48A896
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 08:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348600AbiAKHmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 02:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235766AbiAKHms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 02:42:48 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B99BC06173F;
        Mon, 10 Jan 2022 23:42:48 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id p5so37548027ybd.13;
        Mon, 10 Jan 2022 23:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=Wk/qGtz26hTAu2Z0ry2fUvvnKiyHU/sS4gV9WX8tBw4=;
        b=jI39erstFBgNIGGl+tQmwBiWrUIc9bgBj2bYOdDXTCO9Pd8IbRWtD9TS2r5MHOCHG+
         bPQlZGT7uj2aIkyb6hA3i11qstvrr0xHAd+mOW0cY6G9+T/e3OHnqOnGnS4ZKsqH7DPJ
         ofxAqXjCIf/xFi8OzWqkvjrvZASqHZSCrfRB8yQPQ7WPFCgdN1jNIKWyM1dC9AM9bXE4
         iiL5R0dwuy7J1t4mzrqIkGQZyqBiTURI07s+gq5Q74CgbzHSNcJPVqFHnPg1g1wULvN+
         1mb+7A8KVG/MiNByEUVrtLRl1jYB+Pdc+hp+0K4ZSuaspxApTgzOAwTppyf1/UFT22CX
         H18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Wk/qGtz26hTAu2Z0ry2fUvvnKiyHU/sS4gV9WX8tBw4=;
        b=UQYATRr7wqk8NTEs4mXDoyM81VXzV7H97g+iaJ6iOC65R2cihl4MsLtY/KBw6NkQs1
         iUgADbS98lyRN5hCbuAsgNbMKWgNf4OMY9VRJMOiEnGexlNw4VAQaI+8NNgHAHOk+hPz
         JdTKI3V3FAs+loL8DozuyIUKfuSL2a6qOg72yrBa82J+zibluVwYJJcL6hwOpjulTi+R
         jJYfX8oU3wbU4/dlNrrYNJQLJ7JRnYj/bAv7TZTTxqmNkjDX3bbAXNnbSmAyupBLOrCP
         GdEoqdfi1ZU5Hkzcaywdz3KoBapSIEO0FafvT9DtPbjnlDNyUwyxgrmSdy7bbt6wxmhk
         N7Aw==
X-Gm-Message-State: AOAM532etIgmVzUqUTfW2oru42EUnOtJ98RRQ1Ht/vY0I9Tqv+cbdQB+
        pzF4RTRjsUWRMNINS++mZiKEdFnCCeMmSs67FeA=
X-Google-Smtp-Source: ABdhPJyMRjDffGb4p4uOnDBwu0Qf279Fkk2F9HdUxM/rBqwFZ2JxNZsc3ES+DqcDwIb3BowdrEqXErSucCWsR0TnKvQ=
X-Received: by 2002:a25:4aca:: with SMTP id x193mr4438918yba.149.1641886967694;
 Mon, 10 Jan 2022 23:42:47 -0800 (PST)
MIME-Version: 1.0
From:   cruise k <cruise4k@gmail.com>
Date:   Tue, 11 Jan 2022 15:42:37 +0800
Message-ID: <CAKcFiNC1w87Of0ukV3oPHiAkKeVT7bbTqG3p1LgoUs0bGXk9CQ@mail.gmail.com>
Subject: INFO: task hung in wg_noise_handshake_consume_initiation
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Syzkaller found the following issue:

HEAD commit: 75acfdb Linux 5.16-rc8
git tree: upstream
console output: https://pastebin.com/raw/E1a5ZGSt
kernel config: https://pastebin.com/raw/XsnKfdRt

And hope the report log can help you.

INFO: task kworker/6:1:78 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc8+ #10
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/6:1     state:D stack:26416 pid:   78 ppid:     2 flags:0x00004000
Workqueue: wg-kex-wg1 wg_packet_handshake_receive_worker
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2550 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 rwsem_down_read_slowpath+0x59c/0xa90 kernel/locking/rwsem.c:1041
 __down_read_common kernel/locking/rwsem.c:1223 [inline]
 __down_read kernel/locking/rwsem.c:1232 [inline]
 down_read+0xe2/0x440 kernel/locking/rwsem.c:1472
 wg_noise_handshake_consume_initiation+0x271/0x5f0
drivers/net/wireguard/noise.c:599
 wg_receive_handshake_packet+0x589/0x9d0 drivers/net/wireguard/receive.c:151
 wg_packet_handshake_receive_worker+0x18e/0x3d0
drivers/net/wireguard/receive.c:220
 process_one_work+0x9df/0x16a0 kernel/workqueue.c:2298
 worker_thread+0x90/0xe20 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
