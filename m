Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B108687915
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBBJlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjBBJlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:41:04 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5963820EF
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:41:03 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-509ab88f98fso15228157b3.10
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J5ZJCOJq9eQHpmnwWlRiwnG1N2It9D7v+7XfuqxivAU=;
        b=mYRPNs77zx94m9r3xZ4t7bYz73ff4hsDUuXM51NjlhNFvnh9BkCXg+arveBiAewUb9
         yHtTdUWVqX8fFKPxBGcEEV1Yyuocc02MddB/ABRFktZggkXr0FazmC/FI61CTNqL/Atv
         ht0+IKYjcP7dKy8QJPefv7wnEXH+golGxlMzMxhXLOjTVT/fTAyo8HAo6t2uGcQPH7vO
         trDJ95B9RN76owshG9WIt7W5HZT/J3sB1kGLiA52Xu6sdonEIOZWbFX8Dc7iuv7LHHd2
         z7le1DnQQghVHwuA72eTCLsOjl9A1wNJlYNx4+rH796JANWP/fg0lvdqKncTJLc44Uqu
         L0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J5ZJCOJq9eQHpmnwWlRiwnG1N2It9D7v+7XfuqxivAU=;
        b=ysXI6ES7KbOzRYgXn11QEYFssaPS/+TL8QFdLyPG29N7JcQaReT4cVIbn31tRw50sT
         TQGjuzVBIViv0k7J4Mi0ocj0HjXKP3jQgRet9h/kC/+UlSQgYh2eWcFo45+ky1fPSZtC
         HNh3+aNMFNZCy9kNl+Tpl+QfE2ObHx18uqzQVQTLRdDewnhXBwDkZAhiIn3/+TqXkEOb
         UmbwwmCar/Hva2RZlBCN2q3RoK6RepZT9kGYtkbrQBiB9qf5UM9rRP9M5brEo3qspiyj
         up7umcAWqNsgIiwI2gp/EDGKErXlQd0aQfeWXZJJCu7q22ETnOsWdTq4shWab3kp9tmh
         K80w==
X-Gm-Message-State: AO0yUKURPZwijqnEbfhXsyvi4ZYylbY/zkEN4cvlf1ThU95CkbGGeUYk
        e50fuU92fZu+hLElRqKQCJ9mJDrdmsr7lw==
X-Google-Smtp-Source: AK7set8BDedyqocYaYymncf/gn2PpUBqQkuMPMSNEM9RqcbQhrOpOZiMBVGYc+oL4PVnOV03wLy3x3fCTUdTLg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:9915:0:b0:50f:5754:f5a0 with SMTP id
 q21-20020a819915000000b0050f5754f5a0mr630069ywg.328.1675330862917; Thu, 02
 Feb 2023 01:41:02 -0800 (PST)
Date:   Thu,  2 Feb 2023 09:40:57 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230202094100.3083177-1-edumazet@google.com>
Subject: [PATCH net-next 0/3] raw: add drop reasons and use another hash function
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
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

Two first patches add drop reasons to raw input processing.

Last patch spreads RAW sockets in the shared hash tables
to avoid long hash buckets in some cases.

Eric Dumazet (3):
  ipv6: raw: add drop reasons
  ipv4: raw: add drop reasons
  raw: use net_hash_mix() in hash function

 include/net/raw.h | 13 +++++++++++--
 net/ipv4/raw.c    | 21 ++++++++++++---------
 net/ipv6/raw.c    | 16 +++++++++-------
 3 files changed, 32 insertions(+), 18 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

