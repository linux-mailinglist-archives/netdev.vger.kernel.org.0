Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2445652F1D9
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352315AbiETRqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352316AbiETRqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:46:33 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6552A18E36;
        Fri, 20 May 2022 10:46:30 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id bs17so7481362qkb.0;
        Fri, 20 May 2022 10:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YS7mJc+0lx4oMjUF8V0bsQzPXX8feJl8CjlW/gU7/wk=;
        b=LLmh+gPdgbm/ixkTWSXXg5pzeZeDOTlVk7PSDUMlFWExW16bIgCKipVrkktm/DRSSZ
         QyIulw+vhAP2/7Qun6PGixcVPBBV4dfBKd7ghtz6irpZcTwpn0iVkb7IWOi1bWjUGE/8
         CJruqeotJJRD1OuNsGh21eM1kQPJCYEQ3EytcGnUZ6xQJH5f7zxIPaqzXJcKj5irVusa
         3dSesxIYFNYka33e3wNUruQnXuqalHsgeMqPKF4hHMOxpet1pQ9OiS/EzXe4Y5M7ys6t
         NCWSaK9EA8HemjO+KFcbmk9XQukwp0V5fFs7xPW10vYlg8ej8hlzIvcBNMcnNmV5KyjG
         mp7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YS7mJc+0lx4oMjUF8V0bsQzPXX8feJl8CjlW/gU7/wk=;
        b=c2OfhFkp65vcCvO2cLrtQxTO1XctKSWPHy8IGsEqcf5r2wLN+ZoiQ64NAgOLS5LSlI
         16CIh1FmNHwZIHH/t1/q4p/NdpZJTxQUvRyR9MVMLeK9/XpvFaezjiezEJcsAo5OA3qx
         qGSa6vUhbITRh3c8yJc3lDy9usyYPGn4RzH4wXeXRfIQm2dBuk+XLmLtuTJRO84TwoG+
         Ge6YwOvyCmMtd8hKy4h+3eKvTaRRlM5GUYYgd9Ii/uoFuKAI0EBwLUEYvYYEPjac0Ca6
         5mEtCOB9PR99g7pf1WDEaTiWdxWFZ9RbV5Orpe2wODK17Ebkkt1J8u652wjdvIPZOfiQ
         auPA==
X-Gm-Message-State: AOAM530CdPH7tlaWJUILFV88u6Itv0QuNfRrsytUjrRbLlHmYfwL/qd6
        iytiMWVGiHnmlHohWDuKsq4CemCAJ4U=
X-Google-Smtp-Source: ABdhPJwdMpa/QAeA3J9GO6sT08QIvS2XtajSo9Ouk7LgYTvGYxeFqUcRm+0lMTVIEeNg5z2PjAn2OQ==
X-Received: by 2002:a05:620a:a55:b0:6a3:5fcd:3821 with SMTP id j21-20020a05620a0a5500b006a35fcd3821mr1007349qka.539.1653068789154;
        Fri, 20 May 2022 10:46:29 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2d11:2a88:f2b2:bee0])
        by smtp.gmail.com with ESMTPSA id cn4-20020a05622a248400b002f91849bf20sm62747qtb.36.2022.05.20.10.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 10:46:28 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, jiri@resnulli.us, toke@redhat.com,
        bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v4 0/2] net_sched: introduce eBPF based Qdisc
Date:   Fri, 20 May 2022 10:46:14 -0700
Message-Id: <20220520174616.74684-1-xiyou.wangcong@gmail.com>
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

This *incomplete* patch introduces a programmable Qdisc with eBPF. 

There are a few use cases:

1. Allow customizing Qdisc's in an easier way. So that people don't
   have to write a complete Qdisc kernel module just to experiment
   some new queuing theory.

2. Solve EDT's problem. EDT calcuates the "tokens" in clsact which
   is before enqueue, it is impossible to adjust those "tokens" after
   packets get dropped in enqueue. With eBPF Qdisc, it is easy to
   be solved with a shared map between clsact and sch_bpf.

3. Potentially pave a way for ingress to queue packets, although
   current implementation is still only for egress.

4. Potentially pave a way for handling TCP protocol in TC, as
   rbtree itself is already used by TCP to handle TCP retransmission.

The goal is to make this Qdisc as programmable as possible,
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

   d) Multi-queue support should be done via map-in-map. This is TBD.

   e) Use the netdevice notifier to reset the packets inside skb map upon
   NETDEV_DOWN event.

3. Integrate with existing TC infra. For example, if the user doesn't want
   to implement her own filters (e.g. a flow dissector), she should be able
   to re-use the existing TC filters. Another helper bpf_skb_classify() is
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
v4: get rid of PIFO, use rbtree directly

v3: move priority queue from sch_bpf to skb map
    introduce skb map and its helpers
    introduce bpf_skb_classify()
    use netdevice notifier to reset skb's
    Rebase on latest bpf-next

v2: Rebase on latest net-next
    Make the code more complete (but still incomplete)

Cong Wang (2):
  bpf: introduce skb map
  net_sched: introduce eBPF based Qdisc

 include/linux/bpf_types.h      |   2 +
 include/linux/skbuff.h         |   4 +-
 include/uapi/linux/bpf.h       |  15 +
 include/uapi/linux/pkt_sched.h |  17 ++
 kernel/bpf/Makefile            |   2 +-
 kernel/bpf/skb_map.c           | 337 +++++++++++++++++++++
 net/sched/Kconfig              |  15 +
 net/sched/Makefile             |   1 +
 net/sched/sch_bpf.c            | 520 +++++++++++++++++++++++++++++++++
 9 files changed, 911 insertions(+), 2 deletions(-)
 create mode 100644 kernel/bpf/skb_map.c
 create mode 100644 net/sched/sch_bpf.c

-- 
2.34.1

