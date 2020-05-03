Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B101C296B
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 04:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgECCy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 22:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726737AbgECCy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 22:54:26 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6A7C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 19:54:26 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id f132so14765400qke.11
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 19:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HqSrYTToVorXm4ivu2tZwFSNj6NBHArCDqT9aGQiuNg=;
        b=IQQ+iyOjXFSisGAksYVuT8QSBUDQNF7XfIbTEC2BuESofpVTY1ILFva5u9lWV2LwFo
         vo+BH4peU01wOwNAKzKG4YWNrfqgNIrqHwqBxMH7gT7lbe3t2FjaB3qsrGS9nFjIUQN/
         i1ZTaAiYe/QHzMC9/RpKMP5m3W4bjkST2qDZ5bFA/MF59+u8HkfGxXlH2wwV6+Iv+Tn7
         hdCLnmpJWITnZwWR8PiGl7mbulQSDbM3WafC6WKrJ84Vcr+FHw5EFQOqr2Yr+33GaUoD
         xu9V13gTEIjYXK9RmyqNACjlKQq6pEW55Bp8z5IJAHBpBSjx1s78sz3rIspFp9ajmcXG
         +k1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HqSrYTToVorXm4ivu2tZwFSNj6NBHArCDqT9aGQiuNg=;
        b=lFDF1mQ8rC/Ktt+ul0Du4WyKhpbwX+WbP/KWV4nYZ2u/64FmtgxfZvsZpQnxp0n2fd
         OR98RtuKmB74ycw3Rkfz3h94V4P3t7XzFUHpimVtfJcvEBBmKINQFEY+saXjLml90UUG
         ghKHX9S9VfZddY7DFNUoWIVv8UM42BGs33RZh6Xn2781HO94uRHbz0GT+5xzczxIy3Xw
         aiZ/rv7ZnH9BsyxizVfxcyNRuITBxiDELig0tBwHEzkL6pxVp2sFQt/d48N+ykj9kdB9
         a7Ew1ESH/r5moHrKKOHeGvbc77Jvl3YQhH/ZnwEV87Z9M7AuLwJTlcr5krycns8hFfC3
         3PSQ==
X-Gm-Message-State: AGi0PubMcDnFVLP4xw7Nnit70eOED2JURWcjFM5dx/SPmGkTXWCYRD4V
        IbA+ZYvSyk+SlcRoqNmSdHmGrai6Y9hJ3A==
X-Google-Smtp-Source: APiQypKXZD11B2kGcY82WrFDjkNgLqV2WgNHW2RTa6AGkUu5Gy2YltbsNlIrzLLNMhB0hHKMmOhVoJdlZbA9bg==
X-Received: by 2002:ad4:4a08:: with SMTP id m8mr10833125qvz.216.1588474465720;
 Sat, 02 May 2020 19:54:25 -0700 (PDT)
Date:   Sat,  2 May 2020 19:54:17 -0700
Message-Id: <20200503025422.219257-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 0/5] net_sched: sch_fq: round of optimizations
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is focused on better layout of struct fq_flow to
reduce number of cache line misses in fq_enqueue() and dequeue operations.

Eric Dumazet (5):
  net_sched: sch_fq: avoid touching f->next from fq_gc()
  net_sched: sch_fq: change fq_flow size/layout
  net_sched: sch_fq: use bulk freeing in fq_gc()
  net_sched: sch_fq: do not call fq_peek() twice per packet
  net_sched: sch_fq: perform a prefetch() earlier

 net/sched/sch_fq.c | 86 ++++++++++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 37 deletions(-)

-- 
2.26.2.526.g744177e7f7-goog

