Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056473EF653
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 01:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhHQXwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 19:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbhHQXwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 19:52:18 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9682BC0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 16:51:44 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h186-20020a37b7c30000b02903b914d9e335so442319qkf.17
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 16:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MEiCR9Cah5aHQ1J6uzdzF/HLObdzrDnYsPZJ2mdDD/k=;
        b=hFsDfI0n/o2qCkm9UydXHf8uoIZXd7u3Hp0MVTQ3zaFyOU4IBANP9ybLqzawFDzzaR
         or5MDAjXNancOPd50WJC6RMv2bpiKLmcKZ3yiRZ6bM8KVeiS3sE7bxwCr8SmsSsvMjuw
         KuZ0Zb+T0rlLquKeblcRFtpTpVk0Xd4bAFvK9ECFygZ+4PYyzk5n2trFNSTa5inZJnxr
         dQKFpd+23ST+wHYuFfNcEUpzaIfBu6w4JjHVtE5hCObhxvP5ZPcxSMA9RTNwJ3+uPXWF
         Vo+3ppGQAOHJhkaun+ZPiEl2hwiVVtl8crVTgpfFtnfGak40S7a6y/RzgqKvmEY6JaDy
         EhBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MEiCR9Cah5aHQ1J6uzdzF/HLObdzrDnYsPZJ2mdDD/k=;
        b=aT68jz1fMWC6hy6hQMhwFIIGV97iAQidE4MKY3jEHbI+JrQaTF2vgPFOEs4ec6M42X
         wuMMV+OrBTC4/ZHQfuG1MPSwP52nUxVzLcvq2ggpZ2GhKp62Zd6jwe0lFbM961H/4+qb
         gb4NYDSKmDsRB6TvRcVDTirtqLekAH0tM4DGu7LlTHwZi9rxn450ZgtzrwmdahMCv6nx
         gDK8zk90YiFUJvJTuAer07lSETPEfllzXymnrmEj1EW1mkNarEZPc3DGpLIG4EaHmdeO
         3iaIxIMqSYaUD/cES5U7+i1/s5FdGv+igLBIoBKUB+g9GI2Hznc96OyRheAHC3ztNvuj
         BXRg==
X-Gm-Message-State: AOAM531Oi/51Aa67rEPPHz0TpJhoW531f4sd5ZGK7kymcU0x8l4vS40n
        IvM84RBszBN/VdQwtNjWbs+772SgeXA0O7Wo+XjrEJx6P884SrKo3TiBYeSq/bGDvw+fiaUg2ja
        1qDDbMPj+7DL4vTdT6fNAtdCJD1HASs0vCl5COhbIbI6IYZwYm8cRPMu1WYlpKZHv7fsOfb4f6C
        wtncALOU4=
X-Google-Smtp-Source: ABdhPJyO8QpxhaGIfBEBRl3wXdHqbUNaJiFobtpqIVC3JyqdDbiLjfJ3jP0ivFr2NqMj0l7qTS90yRhCfi+p19PkFOcP2w==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:ad4:4043:: with SMTP id
 r3mr5991218qvp.1.1629244303671; Tue, 17 Aug 2021 16:51:43 -0700 (PDT)
Date:   Tue, 17 Aug 2021 23:51:35 +0000
Message-Id: <20210817235141.1136355-1-richardsonnick@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v3 0/3] pktgen: Add IMIX mode
From:   Nicholas Richardson <richardsonnick@google.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, promanov@google.com, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Di Zhu <zhudi21@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>,
        Leesoo Ahn <dev@ooseel.net>, Ye Bin <yebin10@huawei.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Richardson <richardsonnick@google.com>

Adds internet mix (IMIX) mode to pktgen. Internet mix is
included in many user-space network perf testing tools. It allows
for the user to specify a distribution of discrete packet sizes to be
generated. This type of test is common among vendors when perf testing 
their devices.
[RFC link: https://datatracker.ietf.org/doc/html/rfc2544#section-9.1]

This allows users to get a
more complete picture of how their device will perform in the
real-world.

This feature adds a command that allows users to specify an imix
distribution in the following format:
  imix_weights size_1,weight_1 size_2,weight_2 ... size_n,weight_n

The distribution of packets with size_i will be 
(weight_i / total_weights) where
total_weights = weight_1 + weight_2 + ... + weight_n

For example:
  imix_weights 40,7 576,4 1500,1

The pkt_size "40" will account for 7 / (7 + 4 + 1) = ~58% of the total
packets sent.

This patch was tested with the following:
1. imix_weights = 40,7 576,4 1500,1
2. imix_weights = 0,7 576,4 1500,1
  - Packet size of 0 is resized to the minimum, 42
3. imix_weights = 40,7 576,4 1500,1 count = 0
  - Zero count.
  - Runs until user stops pktgen.
Invalid Configurations
1. clone_skb = 200 imix_weights = 40,7 576,4 1500,1
    - Returns error code -524 (-ENOTSUPP) when setting imix_weights
2. len(imix_weights) > MAX_IMIX_ENTRIES
    - Returns -7 (-E2BIG)

This patch is split into three parts, each provide different aspects of
required functionality:
  1. Parse internet mix input.
  2. Add IMIX Distribution representation.
  3. Process and output IMIX results.

Changes in v2:
* Remove __ prefix outside of uAPI.
* Use seq_puts instead of seq_printf where necessary.
* Reorder variable declaration.
* Return -EINVAL instead of -ENOTSUPP when using IMIX with clone_skb > 0.

Changes in v3:
* Move fill_imix_bins() out of #ifdef CONFIG_XFRM block.

Nick Richardson (3):
  pktgen: Parse internet mix (imix) input
  pktgen: Add imix distribution bins
  pktgen: Add output for imix results

 net/core/pktgen.c | 163 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 1 deletion(-)

-- 
2.32.0.605.g8dce9f2422-goog

