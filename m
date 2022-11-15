Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAF0629E11
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238533AbiKOPvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238359AbiKOPvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:51:04 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB5F2E9DA
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:50:59 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id s20so9731431qkg.5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xaat2VyLldoqJoQSYuOa4mB+mnE/6Fm7QgRB0AqRuJw=;
        b=CjgJF0z59pegNShpUwuJWbbVAJr4Bo0+i8J74NQy7oQPQ8RDnUzlXxKCh2RNZ4vUZ5
         OtKOWPw/Gh+LMg3Lk4GsW3FYXWOPJ8MLB99q4omUnYorbKQ+/JFaMChwwOAIvfJsFwbz
         /W9/+AcpvfK9fWUWXRxldp8dLtfuM1wLINEW6PJH1ro7Ak3+FRRwd9zAQOUgPXFfywkR
         wCbtBLwCKZikWZvr54J154IE4bonyQLnukUxsE4ZN2easSZnRzPfttQbaTOJFRXcSwdd
         DdYRzlENYJwmh1qXnnmlu4SNkj4fdrxCRww9yB5CL/NMbXP4JK4FNL4BGRtJjXCE7XsD
         Dg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xaat2VyLldoqJoQSYuOa4mB+mnE/6Fm7QgRB0AqRuJw=;
        b=KmKB8Os4Y4q26FNkiiwvFklG5xl/9JlVjX/i6Zmrgxn4CSCzGx9IfcN2PgU3EryOye
         Xj3FzcasHcrVt9JvQNXm76kA7tw9iE1oOUznsBqcFbiwLhtmq5KRv9DWixXlVfIUQYAk
         qpk4s52E1X5X5kpRid4TJyxJe4ZNLEjw47z1fevKyACQB2ioxgmpglyYEm0ZHdvkyF5f
         /VralSJWHDf8OhIXSDx+XE4mfmpoS028AlMuw4s64SPrMMPxoWGB9IShIqbBUm6RfzEU
         LCOPChbZN8bmNFmfXnFsjTGg5fqpGRN5AiSoEW/uVQQBteiIjR/dyyofX4M4ynlXsozn
         AF6w==
X-Gm-Message-State: ANoB5pk4BAcV2YPgDkDDb1pzd9BpUoyXAeCuOlS1zEFg0dcQw14V46pV
        1auwJ8fDJEBQE0XcGC9qUQDHfYGbn/eT8w==
X-Google-Smtp-Source: AA0mqf5jVc5nvJ3XxNFrgupk8z+6K3zFn81xp4Ch1K4XofuU6hBB/c4mzKfHAGVbQhZaa8s3rhwsaQ==
X-Received: by 2002:a05:620a:371d:b0:6fa:d35:8466 with SMTP id de29-20020a05620a371d00b006fa0d358466mr16069053qkb.486.1668527458831;
        Tue, 15 Nov 2022 07:50:58 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f9-20020a05620a280900b006eeb3165554sm8244351qkp.19.2022.11.15.07.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 07:50:58 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net-next 0/5] net: eliminate the duplicate code in the ct nat functions of ovs and tc
Date:   Tue, 15 Nov 2022 10:50:52 -0500
Message-Id: <cover.1668527318.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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

The changes in the patchset:

  "net: add helper support in tc act_ct for ovs offloading"

had moved some common ct code used by both OVS and TC into netfilter.

There are still some big functions pretty similar defined and used in
each of OVS and TC. It is not good to maintain such similar code in 2
places. This patchset is to extract the functions for NAT processing
from OVS and TC to netfilter.

To make this change clear and safe, this patchset gets the common code
out of OVS and TC step by step: The patch 1-4 make some minor changes
in OVS and TC to make the NAT code of them completely the same, then
the patch 5 moves the common code to the netfilter and exports one
function called by each of OVS and TC.

Xin Long (5):
  openvswitch: delete the unncessary skb_pull_rcsum call in
    ovs_ct_nat_execute
  openvswitch: return NF_ACCEPT when OVS_CT_NAT is net set in info nat
  net: sched: return NF_ACCEPT when fails to add nat ext in
    tcf_ct_act_nat
  net: sched: update the nat flag for icmp error packets in
    ct_nat_execute
  net: move the nat function to nf_nat_core for ovs and tc

 include/net/netfilter/nf_nat.h |   4 +
 net/netfilter/nf_nat_core.c    | 131 +++++++++++++++++++++++++++++
 net/openvswitch/conntrack.c    | 146 +++------------------------------
 net/sched/act_ct.c             | 136 +++---------------------------
 4 files changed, 159 insertions(+), 258 deletions(-)

-- 
2.31.1

