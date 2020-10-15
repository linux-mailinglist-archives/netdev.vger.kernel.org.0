Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA3C28F54C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389257AbgJOOxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 10:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388348AbgJOOxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 10:53:52 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B99C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 07:53:52 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id x20so2483913ybs.8
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 07:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=INj0b8S3VIHAUvdF0VEtdQjpqh0hqr6y7AO0GhOYTkk=;
        b=tv73eFOo+kwBvW9ZmNC5pNxsAqrUqPFUH9Lgg9L7u1coUSj9YOEwuga+XHgm3zapNp
         DTjmqM4PC0PUkRLQbJHuWMRp7Dqb/BCH/kQvhw4FL7elNgmn1KsFRXb5+q+n1umIl93h
         lDLD/71bmghE+uMBs/Vunyl5e0gJlVVaLwUctriLyl6o2rCz/7UEEakSqUP7oUkDKDnb
         c+GSFs5EpT7VucKpd3Qz/bQeeTJHtPQ7wYCUmzh2bhppitTHHAKYNMYioF61DZA+BTHa
         +nnhNh41MWtlBfOZyt3ngQXDk1UvQ1X6jLLqpf7z7ImVnwK+5kX6Q2tbkvq3KKYQggLh
         maRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=INj0b8S3VIHAUvdF0VEtdQjpqh0hqr6y7AO0GhOYTkk=;
        b=WIHWtlsNyVC9ZRG6D3desjCrUGlKQJc1aNbXJccL/czWKq0EwZnBoJd7J3BpxkElK+
         x8ZCsn098OsYlctZdOjzBePdEXjHsnyh7Un2ExiAKYDiBwVeeFLHDG0iYBGmk5wmYKLl
         c+Anz7HXYyQ5I74SeE6qBZKC4Wb1R1f2qQBsGiuNGsFL4bo4Kjn5EjgrecrETskF3Pq7
         vyDQk7ai1zh8irDMkv3WtOCyA4OBHCicCU2g1OaKcQokg+WoRmZ6RmzSc6v6+V7z4PYX
         oYxWwdq9k2n/NPE9rBse064gyYVHAgXz2cQOTtx+YyR0+C3/ZGRLDyxDu+L/2KheUn3d
         watw==
X-Gm-Message-State: AOAM530cdx0iAdlyHatfCKfyp40BLteNCEBjKvsJiZqe+8aw05OgpFYW
        IyCMyImXfUyAwK+bLsdulGH5cn6rLfPDlsEiliN4ROcu0BSJYw==
X-Google-Smtp-Source: ABdhPJzMmiG4hGP0XT+B+jl5dtqmvZElsfc6rTyTUnZGYb2ReOpi59+neJbRsd9BWs6+637fGWQvG8OiSjkwsr85IMY=
X-Received: by 2002:a25:b8b:: with SMTP id 133mr6062071ybl.257.1602773631508;
 Thu, 15 Oct 2020 07:53:51 -0700 (PDT)
MIME-Version: 1.0
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 15 Oct 2020 17:53:40 +0300
Message-ID: <CAJ3xEMiOtDe5OeC8oT2NyVu5BEmH_eLgAAH4voLqejWgsvG4xQ@mail.gmail.com>
Subject: perf measure for stalled cycles per instruction on newer Intel processors
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Brendan Gregg <bgregg@netflix.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Earlier Intel processors (e.g E5-2650) support the more of classical
two stall events (for backend and frontend [1]) and then perf shows
the nice measure of stalled cycles per instruction - e.g here where we
have IPC of 0.91 and CSPI (see [2]) of 0.68:

 9,568,273,970      cycles                    #    2.679 GHz
           (53.30%)
     5,979,155,843      stalled-cycles-frontend   #   62.49% frontend
cycles idle     (53.31%)
     4,874,774,413      stalled-cycles-backend    #   50.95% backend
cycles idle      (53.31%)
     8,732,767,750      instructions              #    0.91  insn per
cycle
                                                  #    0.68  stalled
cycles per insn  (59.97%)

Running over a system with newer processor (6254) I noted that there
are sort of zillion (..) stall events [2] and perf -e $EVENT for them
does show thier count.

However perf stat doesn't show any more the "stalled cycles per insn"
computation.

Looking in the perf sources, it seems we do that only if the
backend/frontend events exist (perf_stat__print_shadow_stats function)
- am I correct in my reading of the code?

If it's the case, what's needed here to get this or similar measure back?

If it's not the case, if you can suggest how to get perf to emit this
quantity there.

Thanks,

Or.

[1] perf list | grep stalled-cycles

stalled-cycles-backend OR idle-cycles-backend      [Hardware event]
stalled-cycles-frontend OR idle-cycles-frontend    [Hardware event]

[2] http://www.brendangregg.com/perf.html#CPUstatistics

[3] perf list | grep stall -A 1 (manipulated, there are more..)

cycle_activity.stalls_l3_miss
       [Execution stalls while L3 cache miss demand load is outstanding]
  cycle_activity.stalls_l1d_miss
       [Execution stalls while L1 cache miss demand load is outstanding]
  cycle_activity.stalls_l2_miss
       [Execution stalls while L2 cache miss demand load is outstanding]
  cycle_activity.stalls_mem_any
       [Execution stalls while memory subsystem has an outstanding load]
  cycle_activity.stalls_total
       [Total execution stalls]
  ild_stall.lcp
       [Core cycles the allocator was stalled due to recovery from earlier
  partial_rat_stalls.scoreboard
       [Cycles where the pipeline is stalled due to serializing operations]
  resource_stalls.any
       [Resource-related stall cycles]
  resource_stalls.sb
       [Cycles stalled due to no store buffers available. (not including
  partial_rat_stalls.scoreboard
       [Cycles where the pipeline is stalled due to serializing operations]
  resource_stalls.any
       [Resource-related stall cycles]
  resource_stalls.sb
       [Cycles stalled due to no store buffers available. (not including
        draining form sync)]
  uops_executed.stall_cycles
       [Counts number of cycles no uops were dispatched to be executed on this
  uops_issued.stall_cycles
       [Cycles when Resource Allocation Table (RAT) does not issue Uops to
  uops_retired.stall_cycles
       [Cycles without actually retired uops]
