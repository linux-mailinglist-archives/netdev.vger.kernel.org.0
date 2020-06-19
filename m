Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E71E2005AA
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732199AbgFSJpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731989AbgFSJpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 05:45:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2539C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 02:45:06 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q22so1427665pgk.2
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 02:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oneconvergence-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=6e8POfRMwE8zhfzQJLhnmOBll0OQI8avGpywZNiYw+0=;
        b=VCQfS72V9GA3zIlcKH5K6KZpcm7Okya7QXLtHdek9He+KJK0MIoz2zeAdr9CnUqV61
         zHvxC3PVxYImWw1vyuN1Enmlpps7bHaBvW+JQNwpC5GdWV514J4CpkgTT7lMKqCBaufy
         3F06AEpMuylKHV0dSTLCImwnxKQH03Gjj1djlieTsEzspaPcZedKOh8u6o3ZcGJtXZeO
         5X+XYxo3BnbKbZjLOlcOux3JVBPLr4YK9ndW/w7YuAm+RGVF8t4bJX3K55zbqV9Sp76O
         c4TDw1OnTSExIQbDH5IxVCgQPeesQDBT4WpYU/ARcNc6zcm4ExamJNab0ADk2UK2/N5K
         rkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6e8POfRMwE8zhfzQJLhnmOBll0OQI8avGpywZNiYw+0=;
        b=fUZrkgvUGw3AD11e/eh4RAa4yOngz02caZrO/qqqqkyfwh3he1Z0DylLHliwnhNR/d
         8VPaoqyHd4wLoNRm6Fcm6TCGcfuQs7H+Zw1z07Kko4gScf8nlG59Rz7d7G/vHnPf5JJA
         ZoqF0L2i8y9PmXlJ4n99k8AKrS30t+a7a4HOd41F9ST1PCpqdUa5pE84LhqM3UB2zpNS
         fVJtOZe7gfN+srzW4hj5Clm4DD0YX8uDd0B3xvK+IYujpZAzGuzjNQc60gROPs0zRZ/q
         09U292cwnJ9dLsTti9SXJ+b/YE6GufgJL5yPQFYIfDM1WHkipO8e1FjIul8CbcSMoBlO
         I5QQ==
X-Gm-Message-State: AOAM530C+2m5NI1jo/VMO6imjyw0eiTtDt1j/d6BqZTu3R6Tj1VfEPxo
        6OmRr7FPQN9arxqftpvx4Uf2IQ==
X-Google-Smtp-Source: ABdhPJxP+DsnyjtaUyDr3JEjTYuK5G01UyDgJjlAir08RaVdmUZyvI7OFjzisHQmlOBb3fzO+DoJzw==
X-Received: by 2002:a63:ff54:: with SMTP id s20mr2508097pgk.251.1592559906256;
        Fri, 19 Jun 2020 02:45:06 -0700 (PDT)
Received: from localhost.localdomain ([27.57.206.119])
        by smtp.gmail.com with ESMTPSA id m20sm5896306pfk.52.2020.06.19.02.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 02:45:05 -0700 (PDT)
From:   dsatish <satish.d@oneconvergence.com>
To:     davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        satish.d@oneconvergence.com, prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: [PATCH net-next 0/3] cls_flower: Offload unmasked key
Date:   Fri, 19 Jun 2020 15:11:53 +0530
Message-Id: <20200619094156.31184-1-satish.d@oneconvergence.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support for offloading unmasked key along
with the masked key to the hardware. This enables hardware to manage
its own tables better based on the hardware features/capabilities.

It is possible that hardware as part of its limitations/optimizations
remove certain flows. To handle such cases where the hardware lost
the flows, tc can offload to hardware if it receives a flow for
which there exists an entry in its flow table. To handle such cases
TC when it returns EEXIST error, also programs the flow in hardware,
if hardware offload is enabled.

This also covers the uses case where addr_type type should be set
only if mask for ipv4/v6 is non-zero, as while classifying packet,
address type is set based on mask dissector of IPv4 and IPV6 keys,
hence while inserting flow also addr type should be set based on
the mask availability.

Satish Dhote (3):
  cls_flower: Set addr_type when ip mask is non-zero
  cls_flower: Pass the unmasked key to the hardware
  cls_flower: Allow flow offloading though masked key exist.

 include/net/flow_offload.h |  45 ++++++++++
 net/core/flow_offload.c    | 171 +++++++++++++++++++++++++++++++++++++
 net/sched/cls_flower.c     | 132 +++++++++++++++++++++-------
 3 files changed, 316 insertions(+), 32 deletions(-)

-- 
2.17.1

