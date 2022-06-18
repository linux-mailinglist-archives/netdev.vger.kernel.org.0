Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6A655028F
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiFRDrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiFRDrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:47:10 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B10D2A26C
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:47:10 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y6so5658691pfr.13
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0S35041Q0/DhDr3ZyjCubx9di9oICdSTPO8tDpmHFfA=;
        b=TJSc0M6Crs/ZbqrySkdoF/tGnVLo6bQT4mOUewgRBPBhpS8sNBsz6n+b/zADY7a6lH
         DT5F2mFPUYDzm8eAc0s5MnXM9Y++fhgT5x7le4vykVwyH/Abkdrtf88ZHieqbWRnzTvC
         U4sA9PJPTymTDPPg3JvALEp/AA62n1GNzZjg1ChHJGVfiAhjmUVtym8pBVLsw0kuQLWh
         PmBYv78JJz7CMaewNh1QObnk+xoiVX1ftlf4+KRxOi2emetqmP49JRVXGWw3zZrlPoRo
         ftb4yv2/9WbI5m0yqy7+x/cVmZXl1dhfCCh/6yKV959BMEHaFuPsDEKHwGxiiBdd0lWV
         NNAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0S35041Q0/DhDr3ZyjCubx9di9oICdSTPO8tDpmHFfA=;
        b=lmrkO2idNqwx5fabBNAZJAJKMTNyq9bx3Iurvk7VujFjyUxlRSkMi6q9oAa5Dvn173
         SRH+J6pcBFS5DMK/PMSB3Pm9vCkJzStzIOY5qJ71AObxjNtXZP1Iv4VaShGJGn69zkq8
         JmsSq1XWAACPTuWRH8BQzE/z1372mwZ21yRDZHwhBeDkTZM/pGG+1u/Os1ggwBYaJGYo
         Bcabj1/UrV6yzx16nBeGW0fgCbalHIAUsvAww5HvedE81ZLLjoQwzI5/PaIeEBvipjFi
         ldxpV2n7PRTL7f2ivMTn8aRCuYV1bsjDSAxptVRsQZ+tXBXSf+P4z3OWaa4ssisvUu4Y
         tg4A==
X-Gm-Message-State: AJIora/Ay6o7JkMGk8KqjbER4s9eHKvhkY8U7VK392UNGvxuyWgwKWvy
        X7Ex0Bu6yvGkTWnnap5byXM=
X-Google-Smtp-Source: AGRyM1uOu+H5uosb4cGJC/jZXvXhjkATPZKLzRfl+OAOCbvPXak/ksXGykUtIplR+O99X9Qsdm0cAg==
X-Received: by 2002:a63:2bc8:0:b0:3fe:22d6:bdb2 with SMTP id r191-20020a632bc8000000b003fe22d6bdb2mr11936530pgr.474.1655524029549;
        Fri, 17 Jun 2022 20:47:09 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d5d2:fc18:6baf:e16b])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902bd4900b0016782c55790sm2275233plx.232.2022.06.17.20.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 20:47:08 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 0/2] raw: RCU conversion
Date:   Fri, 17 Jun 2022 20:47:03 -0700
Message-Id: <20220618034705.2809237-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
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

From: Eric Dumazet <edumazet@google.com>

Using rwlock in networking code is extremely risky.
writers can starve if enough readers are constantly
grabing the rwlock.

I thought rwlock were at fault and sent this patch:

https://lkml.org/lkml/2022/6/17/272

But Peter and Linus essentially told me rwlock had to be unfair.

We need to get rid of rwlock in networking stacks.

Without this conversion, following script triggers soft lockups:

for i in {1..48}
do
 ping -f -n -q 127.0.0.1 &
 sleep 0.1
done

Next step will be to convert ping sockets to RCU as well.

v2: small issue in first patch, detected by kernel bot
    Polish second patch in net/ipv4/raw_diag.c

Eric Dumazet (2):
  raw: use more conventional iterators
  raw: convert raw sockets to RCU

 include/net/raw.h   |  16 +++--
 include/net/rawv6.h |   7 +-
 net/ipv4/af_inet.c  |   2 +
 net/ipv4/raw.c      | 162 +++++++++++++++++---------------------------
 net/ipv4/raw_diag.c |  53 ++++++++-------
 net/ipv6/af_inet6.c |   3 +
 net/ipv6/raw.c      | 119 ++++++++++++--------------------
 7 files changed, 157 insertions(+), 205 deletions(-)

-- 
2.36.1.476.g0c4daa206d-goog

