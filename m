Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D724F53BA65
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbiFBOBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiFBOBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:01:21 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EE8271781
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 07:01:20 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d22so4590400plr.9
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 07:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=NEkqd70uljO3jCHyeQu1WPotLMJG5tc7aZ7gxzL77Zo=;
        b=aqo5BjeVUAthkQWwt226yrFr5M0LO0Tugr8/clCytCvF0JuayF2vpFQhTrKeiAeLKE
         OztGCPPLw49jIO1EME02NLlzPRy31raFhQQhfM7nxr9Pidxe6HoTdwP/xN4TNsXEzL4Z
         c5I1qastLK2GWaxDOh53gXosFx0s2upMROMnbaewdWeZshwM5YCM2MOaKUC/AuToU586
         5rn5bP3Ikps8k4wJlagWdNuZI9r/XXYcnsu8rVwcrpd/rZlRFxGz1D1QunWo3KtcEueE
         yVTnHnx3cuIM7HT1CAJfOAflgfV9eJObF+OMexfvmzf4UWM67Nll3Wen1sgfjQ+BWal7
         c2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NEkqd70uljO3jCHyeQu1WPotLMJG5tc7aZ7gxzL77Zo=;
        b=JZjdQLD4g2bpZDvmHfnzOmsxdatz440xDC/W5UwY407ZwyWv4LonDVqD5tbNVCVIMY
         A76OTTUHpEeVxtw0kpbywxa+UfjFvjce3oDIKs8WXD7fqUWzrbEtFokBVq61u5leZnqm
         qWi5F+5f+y0Z17J1TYHaewDOGNdB9XwROOGF1wT5+Qy71IoE4/fCVyfhPQJD9Y8oy3Ie
         gF32joGMtVWCiFjjqNxo/2tD7atNmsweJlbWLJNeMxrriE/FIeRH2agnWjjIskjOht9C
         JalIqv4R1Z/k1SGnP1OYlUUhHNuZNA9ejfzF/KHrb/e6W3/E8UXUcmuaNGQ74Fl6M82F
         8JVw==
X-Gm-Message-State: AOAM533gLhNR5WJjs856OY/QLpnDeX6XagdqE3QwpEjP8/ZFq04958nz
        XzYl02+kOyvqH31UvVf2J/g=
X-Google-Smtp-Source: ABdhPJyjdcp2LRaSN9XybL2FpvUnhNMy6Z/nQ+t0YrusCZQw96nAPi8LElBaqiVkO3PM8NMjRYgAIQ==
X-Received: by 2002:a17:903:110e:b0:15e:f450:bee8 with SMTP id n14-20020a170903110e00b0015ef450bee8mr5014374plh.136.1654178479644;
        Thu, 02 Jun 2022 07:01:19 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k13-20020aa7998d000000b0050dc76281ecsm108463pfh.198.2022.06.02.07.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 07:01:18 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/3] amt: fix several bugs in amt_rcv()
Date:   Thu,  2 Jun 2022 14:01:05 +0000
Message-Id: <20220602140108.18329-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes bugs in amt_rcv().

First patch fixes pskb_may_pull() issue.
Some functions missed to call pskb_may_pull() and uses wrong
parameter of pskb_may_pull().

Second patch fixes possible null-ptr-deref in amt_rcv().
If there is no amt private data in sock, skb will be freed.
And it increases stats.
But in order to increase stats, amt private data is needed.
So, uninitialised pointer will be used at that point.

Third patch fixes wrong definition of type_str[] in amt.c

Taehee Yoo (3):
  amt: fix wrong usage of pskb_may_pull()
  amt: fix possible null-ptr-deref in amt_rcv()
  amt: fix wrong type string definition

 drivers/net/amt.c | 59 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 19 deletions(-)

-- 
2.17.1

