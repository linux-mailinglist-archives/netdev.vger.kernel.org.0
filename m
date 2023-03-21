Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01256C3748
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjCUQps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjCUQpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:45:44 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815EC532AB
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:45:25 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5425c04765dso158489157b3.0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679417121;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R+3tkT3g95x6KEZvXkjA9sV7jDvH3g32JYOy0aQfZIA=;
        b=Wj1lCbw3MThy6wSfGvQVYL43MdwS4xeRLOH860YspKlMLidY4FjUl9IiCe9eZ6Tjbu
         h18Tm/ySSvuVtIuZ61JzzF7uYvlpVOMRNhvTq8ko5vr51yDCzOaHaXwSTFJcnitw6lB+
         kpkVjbC6y90pb397w21eHPlXoPJM8HVCGIZLgLmAZwe1W0TSB0E37ucF4QVsAzo0FTrM
         970vhjVbtOvtPUTIrq4j0If7h9iZa8CkAa8p76Jx8tLk76z5NQU0UkKKjLP6utGbfaIW
         ppA4aJNWPDechPWar/6pbVFEIoyMOV86tkZx54S0dqbjtXAvSTq7Bx35RSguRhGY2fUc
         73YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679417121;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R+3tkT3g95x6KEZvXkjA9sV7jDvH3g32JYOy0aQfZIA=;
        b=jFFCstSkm4oxzo0lfeoojZAo9KeOrIydqWvqTd2aG6B1utNZcibnuZ+zpyzAxSbObU
         4hrgEdf95Jm3JO4GA+MhsAzjspD2gRtfpK6Myd93DsK2B6LjcavDFxDuVP1CN3hAxs27
         29wF+NwW0ZJQlXSf6QCx9EQxSm5V276sojEayWTFO19k0ZCq+pcdqBt//yktnKmeM9jX
         XaqduGIthNvWqoTStemc772FyEEiF2z5kI4WfKWwT+1KGTWxzPJ/jELMh6/jLxOPLbik
         nRO8avHdPbdj8P65zmqt4KfT+oy+n5+dRO5ecAr4R0M90I2TtODqPv04AJQRXJXTIpUJ
         Q4Fg==
X-Gm-Message-State: AAQBX9fn0QTEM0PXdBOIT0iuAlSBt/YhEmDleAIOQYU0Vi5CxTN0AJRP
        TaKeSqpliWVnO2lm9QRkIl8+Qvit5A7VCw==
X-Google-Smtp-Source: AKy350ZQDmJEnxvjfiIziUnsXKOU0UlEOJtln0VRAHkZswcgWFr4BRA6I3Jh/TZmJm2wWfT94egbNyAqB3Codw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1083:b0:a4a:a708:2411 with SMTP
 id v3-20020a056902108300b00a4aa7082411mr2016159ybu.10.1679417121332; Tue, 21
 Mar 2023 09:45:21 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:45:16 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321164519.1286357-1-edumazet@google.com>
Subject: [PATCH net-next 0/3] net: remove some skb_mac_header assumptions
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Historically, we tried o maintain skb_mac_header available in most of
networking paths.

When reaching ndo_start_xmit() handlers, skb_mac_header() should always
be skb->data.

With recent additions of skb_mac_header_was_set() and 
DEBUG_NET_WARN_ON_ONCE() in skb_mac_header(), we can attempt
to remove our reliance on skb_mac_header in TX paths.

When this effort completes we will remove skb_reset_mac_header()
from __dev_queue_xmit() and replace it by
skb_unset_mac_header() on DEBUG_NET builds.

Eric Dumazet (3):
  net: do not use skb_mac_header() in qdisc_pkt_len_init()
  sch_cake: do not use skb_mac_header() in cake_overhead()
  net/sched: remove two skb_mac_header() uses

 net/core/dev.c         | 8 ++++----
 net/sched/act_mirred.c | 2 +-
 net/sched/act_mpls.c   | 2 +-
 net/sched/sch_cake.c   | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.40.0.rc2.332.ga46443480c-goog

