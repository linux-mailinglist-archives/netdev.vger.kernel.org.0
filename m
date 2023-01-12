Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E198666805
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbjALAnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbjALAm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:42:57 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31B132183
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:42:00 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id jr10so8029947qtb.7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SOveME4xE6o63NVeDvPdxP9Tjrcxu2ZLc2xfq+OFyLM=;
        b=VJKmUnQZ12ueveDinxAiUAhJnqJFzrcYTwmqydlw/o0DPe6J5CrfpdT+MfA29N6oNT
         65VIJiuf51ZC1uv8AFsQIVDlKVmIQLqh8g6PgOuvkEnx3DtsWkMViLYViSI87hvZTXVP
         AiL4Lm5L2zFY3sD7K3U4P89Qzd3wTJY6NHmwlOZ0w5C6/mcM1iuZ1jhyIY4C4c1/yotX
         KpBOcfj8/uWoNU3xQ8a7TkaFrgUSG5DdIqpjtNUA6OEN0a5E9BNvd68lQUQNjjcpEulR
         7TX3/Cp7PMHkUfto4t8R3LZjAIol8JTDEXjShYLZwGjEAaXNig1KU3hKGoJG6jHrrtXO
         /n3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SOveME4xE6o63NVeDvPdxP9Tjrcxu2ZLc2xfq+OFyLM=;
        b=oEUg3T+2QoU7+88wdGQ3e+V06Qnx5cWSOFwGnu8Bn7+0Ojc1fWt9svq/wSaO30tPOj
         Blxe7hv2b4zyO7MNazlc0ctjgc2lnk3jRkigi4x1sPi96OhjBAx/Yz5T/II3+L6WclBJ
         I6dV7sfML1y7pbqfM8YzVO+PmBMNo4hYRPP/wbf5zSWnWV2mnI5IG0KCwjab2lpg+KOL
         K6mp1r/RV+kq3WTom7yP0x4rfwG+zJKWrwLq8eL4egCInseLZ0ANeSKvZ1FbNqGWZfp3
         g7wMauzFVe10dxjvc8T3JBE2QXmvWmhSstE64aYnw1ehFkbCnBwYgUD4mm9UewMcl6Sv
         SSrQ==
X-Gm-Message-State: AFqh2kqWsUGIN4BjlJaGspkIfp46aR9tOXHqWHVdHxWLBlJIkainzP10
        /oDExH++RUvBK/rOgEGTQBUWaa/aaDbuoQ==
X-Google-Smtp-Source: AMrXdXs6Kk3ITV92dUs5Lp+UnkPbYZf3Ba+2GnsmeL7lBf6fXU6gGK+HCp6cdQ4baHFxx3f8EQgJpg==
X-Received: by 2002:ac8:7655:0:b0:3a5:c8c6:a889 with SMTP id i21-20020ac87655000000b003a5c8c6a889mr102094075qtr.22.1673484119097;
        Wed, 11 Jan 2023 16:41:59 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c11-20020ac853cb000000b00397b1c60780sm8268152qtq.61.2023.01.11.16.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:41:58 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCHv2 net 0/2] net: fix nsna_ping not working in team
Date:   Wed, 11 Jan 2023 19:41:55 -0500
Message-Id: <cover.1673483994.git.lucien.xin@gmail.com>
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

Completely disabling ipv6 addrconf is too harsh to team driver,
as nsna_ping link-watch still needs it. The 1st patch is to fix
it by only preventing DAD and RS sending for it, and 2nd patch
is to add a selftest for all factors that may prevent DAD and
RS sending including the team/bond slave ports.

v1->v2:
  - no need to check IFF_NO_ADDRCONF addrconf_dad_begin(), see
    Patch 1.
  - add a selftest for DAD and RS as David Ahern suggested, see
    Patch 2.

Xin Long (2):
  ipv6: prevent only DAD and RS sending for IFF_NO_ADDRCONF
  kselftest: add a selftest for ipv6 dad and rs sending

 net/ipv6/addrconf.c                        |  12 +--
 tools/testing/selftests/net/Makefile       |   1 +
 tools/testing/selftests/net/ipv6_dad_rs.sh | 111 +++++++++++++++++++++
 3 files changed, 117 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/ipv6_dad_rs.sh

-- 
2.31.1

