Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27146EA765
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjDUJoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjDUJoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:44:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97CCB465
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b92309d84c1so5017552276.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682070241; x=1684662241;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1U89pSXNGpnYYdSVvv0W+iIBJv7ZMFwlAxMGF73Ioxs=;
        b=RkauWPcgbQy9jSIf4f31dyh2qTZUAhFHhNMR+rPRmtM9f6wokwR6APdgM0WvUTtglY
         EA04yb783kDyeVAuC97PfX7admbykFEwbr5qq/1mRgoySK12kZWLO3Fex3k18K92mmJF
         g3g76DDJaTdzovhmXcEhZgnDSwqX0JXU3DgI3xodCr6gJkviFLGeYPgu910E8bVYqeVY
         RqOSmHu9sMkB+jW4zqJT7KUEI+y3dMGqhtNvBl+Uc/B4IgLluiVKdpZ7oneAzrtI9+Gb
         f7f++S08p4Zpn0BHho5dNJuUUhk4yHwqYB9cwfDAcemBdTQPa9yq1dB/1Kw2hVjw60wJ
         JveA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682070241; x=1684662241;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1U89pSXNGpnYYdSVvv0W+iIBJv7ZMFwlAxMGF73Ioxs=;
        b=QBXfl6dxikTM9IdxNL5e4UqEqZih2zA+ddv/e/3ZSmrI/YBf82ttoq6se1BBS0e05S
         TbrNfw8WCBhrQeE5ruE+7oiJUoUdWJNCTqjsyfkh6xdLczPXZwnI2MrUujUUF51GCwpi
         gYQmdvmBLGxKIxjotv1LX4vJ7NsDVHT2eCDMSNhzELySEe7Vwg0atravcMqg2Hkb12mj
         TDuhpG84DivmzTjP4Vz0//8y1GlFgr4S8ZSJO37iMw//+npiBUsImChtamzgGyI28y74
         afJN5N04jByZ2CYnITdqvskwTmjpuqm6kv3fGHkAGwet85fAq1JuBPZfNFswMojfLnAG
         MW0A==
X-Gm-Message-State: AAQBX9dSjHVpPSl4GW9R+ICUh8OF/RKipwnrAXhJ8KwmbgbY0Bn3HnWz
        ZvkFIaAYzlqT6hD+TOXa7n1fRuTfA8SLyg==
X-Google-Smtp-Source: AKy350b9tDY2RrySoBxUqHqXc6onZXlcE3BM/NqdH71a5a5Ea7d3KNBZ3BNqkKk7KUh1INcwBQSRlQbu9iZC1A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:444:b0:54f:dc41:8edf with SMTP
 id bj4-20020a05690c044400b0054fdc418edfmr1373372ywb.2.1682070241211; Fri, 21
 Apr 2023 02:44:01 -0700 (PDT)
Date:   Fri, 21 Apr 2023 09:43:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421094357.1693410-1-edumazet@google.com>
Subject: [PATCH net-next 0/5] net: give napi_threaded_poll() some love
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is interest to revert commit 4cd13c21b207
("softirq: Let ksoftirqd do its job") and use instead the
napi_threaded_poll() mode.

https://lore.kernel.org/netdev/140f61e2e1fcb8cf53619709046e312e343b53ca.camel@redhat.com/T/#m8a8f5b09844adba157ad0d22fc1233d97013de50

Before doing so, make sure napi_threaded_poll() benefits
from recent core stack improvements, to further reduce
softirq triggers.

Eric Dumazet (5):
  net: add debugging checks in skb_attempt_defer_free()
  net: do not provide hard irq safety for sd->defer_lock
  net: move skb_defer_free_flush() up
  net: make napi_threaded_poll() aware of sd->defer_list
  net: optimize napi_threaded_poll() vs RPS/RFS

 include/linux/netdevice.h |  3 +++
 net/core/dev.c            | 57 +++++++++++++++++++++++----------------
 net/core/skbuff.c         |  8 +++---
 3 files changed, 42 insertions(+), 26 deletions(-)

-- 
2.40.0.634.g4ca3ef3211-goog

