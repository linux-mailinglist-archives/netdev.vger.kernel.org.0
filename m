Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2076CCE32
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjC1Xud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC1Xub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:50:31 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6712D44
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:30 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5458201ab8cso138686737b3.23
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680047430;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/XmXfnoITNnJXgMxYGIf6TnU2noVAIQby9EMzIZP/pA=;
        b=ZpyDVmAs3O0ej9c4VoQFbKAkXpYAfZ+xaS4P2k844HeCfuHbHKX7uaqeh+aAOGemz3
         zn08+gRbkyEd6GGziTcv3wx5s9Bfu74MVs5wIsVUdkua44kan6pj5X5ixewh3NtT+clS
         c+2TB8HP06X7uO1u5zcl58SdKwkwlJal4ykW3cixuuoD/2QkM/g3hiu3oJhOwE8Wwvzr
         OfCqDkKnzjK7f020VmCo0ng2IxDjytibsjaHaEUOHbGUTaQekyEGSP60IwXNQgopZsLJ
         36pM3s1FbxOT1KhXfOeKUR3XwG/5Ma+aaeVaUGq9VpToavKnwkqEvxyXOAGaUpqKPaQG
         p3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680047430;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/XmXfnoITNnJXgMxYGIf6TnU2noVAIQby9EMzIZP/pA=;
        b=p2FoB1zyvXhTQtTiFLhPkdwr3C1NkYQvsduEJ2/Gwjh8IzF+5NwoBC6kFnGgyREUlj
         4wJUwHKiPaidQSSyE9kfhpUvmCLcylNHc5oJu0ScY1OZhV/aij5CPG+6mYPFVxr52yx4
         jMHLNafOTM//QpfAmzMDfV8n7JTjjm9kF24GlAaYDuz0B8DWedaFIVkZkhRJtPrpK8om
         XHGAomtDRjncoOjazT1FLlitmRdm2p7ruclvZ74DWfFf4IG8PyuVXKkDrEYE9HdBD+m3
         85IcmcxThcmXLjxEr1nS4+yJ9DOXkJTyiLteRlDdtYDJ0rlSrZn8VaTahBqafmqT/o1A
         3sFA==
X-Gm-Message-State: AAQBX9d2PiZRUfo7zi4Noax+hkaAd0zOuR17FJgLWh9RZHU5hpxp3AtX
        1TevfxBusMD0goSy1lKtQ8Y8Wnjyfpevpg==
X-Google-Smtp-Source: AKy350YQVDSaItYpJS6qMGCS9gh4oqt0ekQPh/D2UuD2U2Icgn9oc2y1V0IQD70qux/trQNmA2JjGBEZA/edCQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:110b:b0:b71:addc:e19c with SMTP
 id o11-20020a056902110b00b00b71addce19cmr8855128ybu.8.1680047430192; Tue, 28
 Mar 2023 16:50:30 -0700 (PDT)
Date:   Tue, 28 Mar 2023 23:50:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328235021.1048163-1-edumazet@google.com>
Subject: [PATCH net-next 0/4] net: rps/rfs improvements
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Xing attempted to optimize napi_schedule_rps() by avoiding
unneeded NET_RX_SOFTIRQ raises: [1], [2]

This is quite complex to implement properly. I chose to implement
the idea, and added a similar optimization in ____napi_schedule()

Overall, in an intensive RPC workload, with 32 TX/RX queues with RFS
I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
invocations.

While this had no impact on throughput or cpu costs on this synthetic
benchmark, we know that firing NET_RX_SOFTIRQ from softirq handler
can force __do_softirq() to wakeup ksoftirqd when need_resched() is true.
This can have a latency impact on stressed hosts.

[1] https://lore.kernel.org/lkml/20230325152417.5403-1-kerneljasonxing@gmail.com/
[2] https://lore.kernel.org/netdev/20230328142112.12493-1-kerneljasonxing@gmail.com/


Eric Dumazet (4):
  net: napi_schedule_rps() cleanup
  net: add softnet_data.in_net_rx_action
  net: optimize napi_schedule_rps()
  net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ

 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 46 ++++++++++++++++++++++++++++++---------
 2 files changed, 37 insertions(+), 10 deletions(-)

-- 
2.40.0.348.gf938b09366-goog

