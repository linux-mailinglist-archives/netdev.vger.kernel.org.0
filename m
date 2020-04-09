Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D011A2DF4
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 05:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgDID0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 23:26:54 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39978 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgDID0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 23:26:53 -0400
Received: by mail-yb1-f195.google.com with SMTP id a5so4951897ybo.7;
        Wed, 08 Apr 2020 20:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=xIpdHjTqBOnzX/KRWf/+IF0SilgeswMLZm1Ka6Pjqp4=;
        b=JBz01c/jMiya2h/5olMP4ym//6eOdmfONcdfxhPexmj4IUMUJxQyqlaMWzG1E+5IQM
         0X6rO5ynLhuk3K2wJr228j4QKvU8XR0Qc+G65ZqLwOXq5RZBZ2U849odXG2uyZJSUaPd
         xpGTcj5safLWLQ/PQI2nVtzgDJGDOGHn944klId14VIgx8YNo8nBiwdIGOSVo2Fd+xmj
         wzxSMbsQyGUC+GKiHan8LybLAU0LOI9kC4QvcMiyNe7yStv1j/FZsN94zBLTV2BleRvW
         51VzY3qjBq+BnJX9R37DYzBxyCTwhZzWh5QZIUBEf13UTHoGb3vO6W6p/taXF2YFZIrm
         9phA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xIpdHjTqBOnzX/KRWf/+IF0SilgeswMLZm1Ka6Pjqp4=;
        b=sfoiFTubp2QQ2JN4uxkUzE4pzcicxEomC8KRU+W2E2quWLvPY1yCrYtuA6IoA6bwsy
         B9bVVY8C6CVmxhi2wz1H8S1IABfrx6sSmUe7+hQOv+1fgZ95r+mxig+OlFEutZBKhqmF
         MoXEThVqIxYnSDjhTNRHgr6XLeT2P1IX9s6cPEQ/TMvGHNbNPw5sEF6xBN4UTV78XmCQ
         /z6S/mXW4DoKhOS19rfNf9AZn/fwu7PF0eMGA1Oy25MK645cQ2Xvm7T8Xlvd1qSB7djm
         510XkpYnschRpZhcgZOPKJEMCMeORLEdjZSzQGiWCbMxOISh+XG1j7ctGBG7ivfEAiuC
         eLeA==
X-Gm-Message-State: AGi0PuZNHagCIq0X0AX5l3/4cvaBsNFGTx2y8eIIYaUSByl8MqbWV2Eb
        BH0MuvNPo6pPDKbWFAN0Z2lbFmN5Rovd3FjTEZCLGMRQwubj
X-Google-Smtp-Source: APiQypKuJ0Cn5j7emT2yXTOWpQmCxd+7rVq8TXo7tuN0sNTqLKkvLJp3s8Q2eeO75KI1Gngf6hpX2UmXZ+oUq7KI54o=
X-Received: by 2002:a25:d9c1:: with SMTP id q184mr17950930ybg.349.1586402812885;
 Wed, 08 Apr 2020 20:26:52 -0700 (PDT)
MIME-Version: 1.0
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 9 Apr 2020 12:26:37 +0900
Message-ID: <CAEKGpzh3drL1ywEfnJWhAqULcjaqGi+8GZSwG9XV-iYK4DnCpA@mail.gmail.com>
Subject: BPF program attached on BPF map function (read,write) is not working?
To:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, BPF program attached on BPF map function (read,write) is not called.
To be specific, the bpf kprobe program on 'htab_map_get_next_key'
doesn't called at all. To test this behavior, you can try ./tracex6
from the 'samples/bpf'. (It does not work properly at all)

By using 'git bisect', found the problem is derived from below commit.(v5.0-rc3)
commit 7c4cd051add3 ("bpf: Fix syscall's stackmap lookup potential deadlock")
The code below is an excerpt of only the problematic code from the entire code.

   diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
   index b155cd17c1bd..8577bb7f8be6 100644
   --- a/kernel/bpf/syscall.c
   +++ b/kernel/bpf/syscall.c
   @@ -713,8 +713,13 @@ static int map_lookup_elem(union bpf_attr *attr)

           if (bpf_map_is_dev_bound(map)) {
                   err = bpf_map_offload_lookup_elem(map, key, value);
                   goto done;
           }

           preempt_disable();
   +      this_cpu_inc(bpf_prog_active);
           if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
               map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
                   err = bpf_percpu_hash_copy(map, key, value);
           } else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
                   err = bpf_percpu_array_copy(map, key, value);
   @@ -744,7 +749,10 @@ static int map_lookup_elem(union bpf_attr *attr)
                   }
                   rcu_read_unlock();
           }
   +      this_cpu_dec(bpf_prog_active);
           preempt_enable();

   done:
           if (err)
                   goto free_value;

As you can see from this snippet, bpf_prog_active value (flag I guess?)
increases and decreases within the code snippet. And this action create a
problem where bpf program on map is not called.

   # kernel/trace/bpf_trace.c:74
   unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
   {
       ...
        preempt_disable();

        if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
                /*
                 * since some bpf program is already running on this cpu,
                 * don't call into another bpf program (same or different)
                 * and don't send kprobe event into ring-buffer,
                 * so return zero here
                 */
                ret = 0;
                goto out;
        }
       ...
       ret = BPF_PROG_RUN_ARRAY_CHECK(call->prog_array, ctx, BPF_PROG_RUN);

   out:
       __this_cpu_dec(bpf_prog_active);
       preempt_enable();


So from trace_call_bpf() at kernel/trace/bpf_trace.c check whether
bpf_prog_active is 1, and if it is, it skips the execution of bpf program.

Back to latest Kernel 5.6, this this_cpu_{inc|dec}() has been wrapped with
bpf_{enable|disable}_instrumentation().

   # include/linux/bpf.h
   static inline void bpf_enable_instrumentation(void)
   {
           if (IS_ENABLED(CONFIG_PREEMPT_RT))
                   this_cpu_dec(bpf_prog_active);
           else
                   __this_cpu_dec(bpf_prog_active);
           migrate_enable();
   }

And the functions which uses this wrapper are described below.

   bpf_map_update_value
   bpf_map_copy_value
   map_delete_elem
   generic_map_delete_batch

Which is basically most of the map operation.

So, I think this 'unable to attach bpf program on BPF map function (read,write)'
is a bug. Or is it desired action?

If it is a bug, bpf_{enable|disable}_instrumentation() should only
cover stackmap
as the upper commit intended. Not sure but adding another flag for
lock might work?

Or if this is an desired action, this should be covered at
documentation with a limitation
and tracex6 sample has to be removed.
