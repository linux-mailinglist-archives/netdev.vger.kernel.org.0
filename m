Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571E25F58F4
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiJERSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJERSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:18:07 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A66813CC0;
        Wed,  5 Oct 2022 10:18:06 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id fb18so876500qtb.12;
        Wed, 05 Oct 2022 10:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=wXTLSqmAIjjRRTkuHZFDqIFGC9IDRgbpl+sVPHe3DS0=;
        b=WhvLbcPsIqU1h5/d5N20ViAN12Swdl+pyLjSzM+2KTUva/v/gBu4W8AsJu4FGsMYpq
         Q3EG6HwOLUyn8R6rdwS813iR7USJ33MgJ3QiH3uR3oEyLhf4UwZMtHoUMaDVIxLF7ZU4
         QL7+SeGXkfFdwW58WNnOV7gr6X1TkdPAVnsmDMCY3WBm3EPCbGWBEF+aPW/xB3LBq7J6
         nOjTZFQFqgte2+e9FSrs7WlNSnE5CB1wcdLdtojdjwLJ9qz/JZt8AB77zDhi7xoCvWPY
         nnp5CAK38QP1r7rATa7UAQO0Hq+6iy8lLJjK9On3F453r2HJbn2UAg+SRq70u2KPB9nj
         CGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=wXTLSqmAIjjRRTkuHZFDqIFGC9IDRgbpl+sVPHe3DS0=;
        b=JIWvmqwwYnaCfwLswPSpRU2JbhCsEE5lqrsy31OCp3M1DUWlvAjVID6ECATX6kLajg
         UqBHxkby0QgQJi7XAHvtLpPlmI1MYnKpwYhuCx5laFjfOjGjva6VZKrblXcij80sBE3y
         UOGMYo1LLGWLFk80WANqaNZ5U1+7Uw9AZ8HMJ6iLaBXgZiOH5qV0JjFKnuZi52C3L2IT
         2Q74P0A1gy72j2cDl34p8g7HGF+n+Z3n8P/5fuZmj5XVzN+sxtStwt8MGrBPa0yhOQdY
         wC3ejvMut4pJo0BWyyRXmRVvsyoTIfiJ/UQE5YV/rdBRZXYtvzJh/7bl+SYq0Pc6dic4
         bIzQ==
X-Gm-Message-State: ACrzQf0gXZmCoRP1/fJuZDC4cPAvQQdluaaPgjAjN9COjrsJ34ygVswK
        TSPCVfxCq7XEX+rykrH4SyKGVKP17cA=
X-Google-Smtp-Source: AMsMyM4CDdD1oCfVt7coGu+CoBvgr3tHqa635tTiksLJlI15+JFQwln6JEkUbDKXP1QQDx5pOveiYg==
X-Received: by 2002:a05:622a:412:b0:35d:5770:a5ef with SMTP id n18-20020a05622a041200b0035d5770a5efmr495651qtx.25.1664990259596;
        Wed, 05 Oct 2022 10:17:39 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2bd1:c1af:4b3b:4384])
        by smtp.gmail.com with ESMTPSA id m13-20020ac85b0d000000b003913996dce3sm1764552qtw.6.2022.10.05.10.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 10:17:38 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yangpeihao@sjtu.edu.cn, toke@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, bpf@vger.kernel.org, sdf@google.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v6 0/5] net_sched: introduce eBPF based Qdisc
Date:   Wed,  5 Oct 2022 10:17:04 -0700
Message-Id: <20221005171709.150520-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This *incomplete* patchset introduces a programmable Qdisc with eBPF.

There are a few use cases:

1. Allow customizing Qdisc's in an easier way. So that people don't
   have to write a complete Qdisc kernel module just to experiment
   some new queuing theory.

2. Solve EDT's problem. EDT calcuates the "tokens" in clsact which
   is before enqueue, it is impossible to adjust those "tokens" after
   packets get dropped in enqueue. With eBPF Qdisc, it is easy to
   be solved with a shared map between clsact and sch_bpf.

3. Replace qevents, as now the user gains much more control over the
   skb and queues.

4. Provide a new way to reuse TC filters. Currently TC relies on filter
   chain and block to reuse the TC filters, but they are too complicated
   to understand. With eBPF helper bpf_skb_tc_classify(), we can invoke
   TC filters on _any_ Qdisc (even on a different netdev) to do the
   classification.

5. Potentially pave a way for ingress to queue packets, although
   current implementation is still only for egress.

6. Possibly pave a way for handling TCP protocol in TC, as rbtree itself
   is already used by TCP to handle TCP retransmission.

7. Potentially pave a way for implementing eBPF based CPU scheduler,
   because we already have task kptr and CFS is clearly based on rbtree
   too.

The goal here is to make this Qdisc as programmable as possible,
that is, to replace as many existing Qdisc's as we can, no matter
in tree or out of tree. This is why I give up on PIFO which has
serious limitations on the programmablity. More importantly, with
rbtree, it is easy to implement PIFO logic too.

Here is a summary of design decisions I made:

1. Avoid eBPF struct_ops, as it would be really hard to program
   a Qdisc with this approach, literally all the struct Qdisc_ops
   and struct Qdisc_class_ops are needed to implement. This is almost
   as hard as programming a Qdisc kernel module.

2. Introduce a generic rbtree map, which supports kptr, so that skb's
   can be stored inside.

   a) As eBPF maps are not directly visible to the kernel, we have to
   dump the stats via eBPF map API's instead of netlink.

   b) The user-space is not allowed to read the entire packets, only __sk_buff
   itself is readable, because we don't have such a use case yet and it would
   require a different API to read the data, as map values have fixed length.

   c) Multi-queue support is implemented via map-in-map, in a similar
   push/pop fasion based on rbtree too.

   d) Use the netdevice notifier to reset the packets inside skb map upon
   NETDEV_DOWN event. (TODO: need to recognize kptr type)

3. Integrate with existing TC infra. For example, if the user doesn't want
   to implement her own filters (e.g. a flow dissector), she should be able
   to re-use the existing TC filters. Another helper bpf_skb_tc_classify() is
   introduced for this purpose.

Any high-level feedback is welcome. Please kindly ignore any coding details
until RFC tag is removed.

TODO:
1. actually test it
2. write a document for this Qdisc
3. add test cases and sample code

Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
v6: switch to kptr based approach

v5: mv kernel/bpf/skb_map.c net/core/skb_map.c
    implement flow map as map-in-map
    rename bpf_skb_tc_classify() and move it to net/sched/cls_api.c
    clean up eBPF qdisc program context

v4: get rid of PIFO, use rbtree directly

v3: move priority queue from sch_bpf to skb map
    introduce skb map and its helpers
    introduce bpf_skb_classify()
    use netdevice notifier to reset skb's
    Rebase on latest bpf-next

v2: Rebase on latest net-next
    Make the code more complete (but still incomplete)

Cong Wang (5):
  bpf: Introduce rbtree map
  bpf: Add map in map support to rbtree
  net_sched: introduce eBPF based Qdisc
  net_sched: Add kfuncs for storing skb
  net_sched: Introduce helper bpf_skb_tc_classify()

 include/linux/bpf.h            |   4 +
 include/linux/bpf_types.h      |   4 +
 include/uapi/linux/bpf.h       |  19 ++
 include/uapi/linux/pkt_sched.h |  17 +
 kernel/bpf/Makefile            |   2 +-
 kernel/bpf/rbtree.c            | 603 +++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |   7 +
 net/core/filter.c              |  27 ++
 net/sched/Kconfig              |  15 +
 net/sched/Makefile             |   1 +
 net/sched/cls_api.c            |  69 ++++
 net/sched/sch_bpf.c            | 564 ++++++++++++++++++++++++++++++
 12 files changed, 1331 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/rbtree.c
 create mode 100644 net/sched/sch_bpf.c

-- 
2.34.1

