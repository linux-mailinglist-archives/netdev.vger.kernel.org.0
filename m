Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E412247F0D6
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 21:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353491AbhLXUBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 15:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbhLXUBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 15:01:25 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09618C061401;
        Fri, 24 Dec 2021 12:01:25 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id v22-20020a9d4e96000000b005799790cf0bso12089646otk.5;
        Fri, 24 Dec 2021 12:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bzYscnPBVPQ+HLTf6uGUFq6uTGRmHq5UoMjjhmil7sE=;
        b=piLVeOuPKhtQG/UKMFWdNQPZdA4C4E/WlKPOuTETbll8Z0Ny+Q8EweWzRcHhX+xFkS
         7MvS4+gUNiWc7KIDWxKIgQhYZdxai0K8bI7ZvG6DF7R89xUJ21+6IC6iZuHvTNc7++DO
         s1JkUNusPWSkLm6RHdhxHXGgtfjUqFrzPOQH7tNTRQrAUn5FOjphRpC6lwLriIsbzx+4
         MHjCkg9jkzHROarRRl3rwu9uaUnaoEBwHVm/jEOq0TNGQ6eRdvuTGfmqS4koKDdSJyfT
         Ymygj0R2Z80qPcJa69EliNuCr2AvUooS/P8dH5ICaOWR2ogIZm8EUQGaWh0kou/ubvPX
         P/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bzYscnPBVPQ+HLTf6uGUFq6uTGRmHq5UoMjjhmil7sE=;
        b=klKH4AJ3GGOJQnuOVSFwYUTvINxklAeJ2xXqTjt4afR+0uxLHUMdWNubGsUH+oHp9b
         8XY9N/s16OSG4c4sDx4LwgKoa0YKlW6CgAMGsp77PqcPgOaQjzp6dIVD67+NX+IgNX/q
         ACcYXmIV23pEborcqQzoxJ+/u60b/vOH5Edm4J2O9bRoQLA6OhNDYQUsPXkArbxm7L4u
         XTpS7kNiw1oVSs4Q0mOQgGZlgJTyhh65hX0CMl+nsOh4M3V6TCr3SVOIGNzkmm0FKdQS
         KCnfWHcuKwP+qsIG/fPyxya1eJsIFduJG/QbMSUIUIe1CR/o/8GNxFOHbXnZqgmhC6SU
         m9xQ==
X-Gm-Message-State: AOAM532ldgm79zB7i8/9WS5fhg1PB2ylIpWEzmMu3ORfBCD9BONWQD1T
        wKs+L4zlJ+9wroudgAXuAXCUWEpCvM4=
X-Google-Smtp-Source: ABdhPJw/5t+tLovjSbVm82gStQnFoxwyOxOP9L1zC1GBlkQ4p2GeWIcG5PZnjDjLUiQqbueb/P/GRA==
X-Received: by 2002:a9d:750c:: with SMTP id r12mr5429294otk.273.1640376083367;
        Fri, 24 Dec 2021 12:01:23 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:b326:fb0b:9894:47a6])
        by smtp.gmail.com with ESMTPSA id o2sm1865506oik.11.2021.12.24.12.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Dec 2021 12:01:23 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [RFC Patch v3 0/3] net_sched: introduce eBPF based Qdisc
Date:   Fri, 24 Dec 2021 12:00:56 -0800
Message-Id: <20211224200059.161979-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This *incomplete* patch introduces a programmable Qdisc with
eBPF.  The goal is to make this Qdisc as programmable as possible,
that is, to replace as many existing Qdisc's as we can, no matter
in tree or out of tree. And we want to make programmer's and researcher's
life as easy as possible, so that they don't have to write a complete
Qdisc kernel module just to experiment some queuing theory.

The design was discussed during last LPC:
https://linuxplumbersconf.org/event/7/contributions/679/attachments/520/1188/sch_bpf.pdf

Here is a summary of design decisions I made:

1. Avoid eBPF struct_ops, as it would be really hard to program
   a Qdisc with this approach, literally all the struct Qdisc_ops
   and struct Qdisc_class_ops are needed to implement. This is almost
   as hard as programming a Qdisc kernel module.

2. Introduce skb map, which will allow other eBPF programs to store skb's
   too.

   a) As eBPF maps are not directly visible to the kernel, we have to
   dump the stats via eBPF map API's instead of netlink.

   b) The user-space is not allowed to read the entire packets, only __sk_buff
   itself is readable, because we don't have such a use case yet and it would
   require a different API to read the data, as map values have fixed length.

   c) Two eBPF helpers are introduced for skb map operations:
   bpf_skb_map_enqueue() and bpf_skb_map_dequeue(). Normal map update is
   not allowed.

   d) Multi-queue support should be done via map-in-map. This is TBD.

   e) Use the netdevice notifier to reset the packets inside skb map upon
   NETDEV_DOWN event.

3. Integrate with existing TC infra. For example, if the user doesn't want
   to implement her own filters (e.g. a flow dissector), she should be able
   to re-use the existing TC filters. Another helper bpf_skb_classify() is
   introduced for this purpose.

Although the biggest limitation is obviously that users can not traverse
the packets or flows inside the Qdisc, I think at least they could store
those global information of interest inside their own hashmap.

TBD: should we introduce an eBPF program for skb map which allows users to
sort the packets?

Any high-level feedbacks are welcome. Please kindly do not review any coding
details until RFC tag is removed.

TODO:
1. actually test it
2. write a document for this Qdisc
3. add test cases and sample code

Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
v3: move priority queue from sch_bpf to skb map
    introduce skb map and its helpers
    introduce bpf_skb_classify()
    use netdevice notifier to reset skb's
    Rebase on latest bpf-next

v2: Rebase on latest net-next
    Make the code more complete (but still incomplete)

Cong Wang (3):
  introduce priority queue
  bpf: introduce skb map
  net_sched: introduce eBPF based Qdisc

 include/linux/bpf_types.h      |   2 +
 include/linux/priority_queue.h |  90 ++++++
 include/linux/skbuff.h         |   2 +
 include/uapi/linux/bpf.h       |  15 +
 include/uapi/linux/pkt_sched.h |  17 ++
 kernel/bpf/Makefile            |   2 +-
 kernel/bpf/skb_map.c           | 244 +++++++++++++++
 net/sched/Kconfig              |  15 +
 net/sched/Makefile             |   1 +
 net/sched/sch_bpf.c            | 521 +++++++++++++++++++++++++++++++++
 10 files changed, 908 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/priority_queue.h
 create mode 100644 kernel/bpf/skb_map.c
 create mode 100644 net/sched/sch_bpf.c

-- 
2.32.0

