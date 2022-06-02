Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA2B53B26B
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 06:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiFBELB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 00:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiFBEK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 00:10:58 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26B6202D22;
        Wed,  1 Jun 2022 21:10:55 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id y15so2671454qtx.4;
        Wed, 01 Jun 2022 21:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iyZ6bJR+lsrbo3POZbTSoU/ZS8d0/V/7sOK3LmVFXsc=;
        b=WjaYY4ohWFcEZdaGjzQl61rz8G9jYL8KVOolAJAWVZtWe575XyayUyffwP42Au8EwB
         MHHoPC804QODIPO46EKaWtCXFDyw5uBMj5PoAXLGYwDzZHDC8TH4UCLfERcQM630oxF9
         5dZC5sbLraSMTh0tQs29GWbfmXXsdRaGhfuECLuecwhvzpRrmV5n3y2iV0Pu7paFFixb
         AFFpknWasf9cSmVuNvSvg+PYOqYhORLR6v/PhRoCCYnQOfqLMbg9W9ugd3/imXDdNYcS
         og8UlTuH+zTusAPYpAWLk8J21+dybay2vSFo6wv9w9RwyQqW1KC2oKNQzIGqWEdf0eti
         pybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iyZ6bJR+lsrbo3POZbTSoU/ZS8d0/V/7sOK3LmVFXsc=;
        b=Vua8Gtjvxf+qtCGgAnwZFLhhzzTvICy0LUHsvwhgUgwzfOO9OxmNJFivWmaA8D+7X3
         bVG/vdzvGXm1q5GTKmmqbd2uUh68Ul0ypeMupSeWkhPVlkvbCgMLrwIyWb1GPfWpe5Y6
         /t88RaoTw3R610UdVaKUT/UZvsbSWGS1diIWDEPY6mzq/t4OyExfabQrxz2Z5G8Tf4p4
         mpRSvm/qzxMjVefbNIcd66pEXNO220lUmhcVRfOu9MSUG2WzKbRDgQ9i+qsMNqZZ8+XZ
         edlvWlQNpc1DJp3YwcU4eDE9IOv7feZMZ5BW16hVC+YruKtp7zwmFlHJTJeVAVz9s0bb
         glbg==
X-Gm-Message-State: AOAM533mrKGUUvgQ9Q+od8rwzT02bGMLXytDzjg6u6PpOqa8LSjSzRdt
        uiA3rA6myhj69l/I3hvHv69IGxoUgNo=
X-Google-Smtp-Source: ABdhPJwqpdK9dRSnUKU2A+n02Mcf97M0Z0J3RSLPhAHLlb8CDraFFdRNy8YqBPb48bUeiqh/qP0ysA==
X-Received: by 2002:ac8:7e8b:0:b0:302:2402:c5f5 with SMTP id w11-20020ac87e8b000000b003022402c5f5mr2347742qtj.200.1654143054292;
        Wed, 01 Jun 2022 21:10:54 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:d7c6:fc22:5340:d891])
        by smtp.gmail.com with ESMTPSA id i187-20020a3786c4000000b0069fc13ce1fesm2396654qkd.47.2022.06.01.21.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 21:10:53 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [RFC Patch v5 0/5] net_sched: introduce eBPF based Qdisc
Date:   Wed,  1 Jun 2022 21:10:23 -0700
Message-Id: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

The goal here is to make this Qdisc as programmable as possible,
that is, to replace as many existing Qdisc's as we can, no matter
in tree or out of tree. This is why I give up on PIFO which has
serious limitations on the programmablity.

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
   bpf_skb_map_push() and bpf_skb_map_pop(). Normal map update is
   not allowed.

   d) Multi-queue support is implemented via map-in-map, in a similar
   push/pop fasion.

   e) Use the netdevice notifier to reset the packets inside skb map upon
   NETDEV_DOWN event.

3. Integrate with existing TC infra. For example, if the user doesn't want
   to implement her own filters (e.g. a flow dissector), she should be able
   to re-use the existing TC filters. Another helper bpf_skb_tc_classify() is
   introduced for this purpose.

Any high-level feedback is welcome. Please kindly do not review any coding
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
  net: introduce skb_rbtree_walk_safe()
  bpf: move map in map declarations to bpf.h
  bpf: introduce skb map and flow map
  net_sched: introduce eBPF based Qdisc
  net_sched: introduce helper bpf_skb_tc_classify()

 include/linux/bpf.h            |   6 +
 include/linux/bpf_types.h      |   4 +
 include/linux/skbuff.h         |   9 +-
 include/uapi/linux/bpf.h       |  23 ++
 include/uapi/linux/pkt_sched.h |  17 ++
 kernel/bpf/arraymap.c          |   2 -
 kernel/bpf/hashtab.c           |   1 -
 kernel/bpf/map_in_map.c        |   2 -
 kernel/bpf/map_in_map.h        |  19 --
 kernel/bpf/verifier.c          |  10 +
 net/core/Makefile              |   1 +
 net/core/filter.c              |  39 +++
 net/core/skb_map.c             | 520 +++++++++++++++++++++++++++++++++
 net/sched/Kconfig              |  15 +
 net/sched/Makefile             |   1 +
 net/sched/cls_api.c            |  69 +++++
 net/sched/sch_bpf.c            | 485 ++++++++++++++++++++++++++++++
 17 files changed, 1198 insertions(+), 25 deletions(-)
 delete mode 100644 kernel/bpf/map_in_map.h
 create mode 100644 net/core/skb_map.c
 create mode 100644 net/sched/sch_bpf.c

-- 
2.34.1

