Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDDF68C4DC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjBFRbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjBFRbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:31:11 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DFE26CEA
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:31:05 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k15-20020a5b0a0f000000b007eba3f8e3baso12039927ybq.4
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 09:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/k66tcgi5CalTcIP+AGDFioUY9CCrPY/jxGK5HBDwMA=;
        b=FJToPwyFT9TNE2m58L1rVXJsDDyWnM0rHs2p9IBS9xLKSfnwv48lR1kXLuFvnMoRps
         RU1g8euDlZQwf++mHO4Bkft8iTpQcFAh+qYv55qfZWzESXSpo7Fo1LjsZr2OJ+gS9/St
         Ry6VSmwrRXJjXg/a0hc+Dv3KIrpY4oLFU/XprpsL11wceME3NICJdllKLRgP40HLOZCO
         JsRyFCbGjHYGXEnl69/PLDMUmAoqifyYH0PqmmJbiQcY/K6cH33bqCIvUujOfSXD64ZN
         /tKQxUeyQbq0dzAOEmbYNM3g9KDORUoN0Qg4vzBQJBH5JMRe9VdzHwaoF1qFheK3ZpSd
         AaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/k66tcgi5CalTcIP+AGDFioUY9CCrPY/jxGK5HBDwMA=;
        b=KhojH9iV1Q6LDQqLEl2qOuoV5sP8Nr3SSEJtIqFjpbMbp84+TW3HgqdJrNI22gsuVO
         UI3kEqWCJxh/4vTlaIS5Lj1xjhFP3+6B2IrQPRVNg/IJIuButruo+f2Wdgh9Emaxso4k
         fuU5ND7hTiTYEqRE7OkOEblMHhPSZE1guQYHTr9rpgKFWK3ugNR1CtVJAzhJixMXCJCR
         ZBU0ZJ86IiT3tcU6TF3wzHpFQqV2P3lRwsZmjHKtga0M7ueofyRRUVEnPOKXEJ6XL1Ws
         UDw801h+sMFiuaKGFOkb7qipJ6T7dFlk9qtL39kUGHFepFd+rTWn2j25Hzf+G0AXD3+S
         66HQ==
X-Gm-Message-State: AO0yUKWDm55aTMcXCytT1bpCn5cAoaASGq0Q51y2vgPWmPtSRMrNG/Sx
        zTsesrm4lh6sxm+yijCHIk4OUCONvbXJNg==
X-Google-Smtp-Source: AK7set8Jcv8bohW03C6ChwmJk2UkZaUYQ5wwIE566BE6t54i2CyM9MlwtweFsjt7RdVhpZiqMgQ68uQ9/EHzXg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:299:b0:528:37bd:c122 with SMTP
 id bf25-20020a05690c029900b0052837bdc122mr5ywb.5.1675704664841; Mon, 06 Feb
 2023 09:31:04 -0800 (PST)
Date:   Mon,  6 Feb 2023 17:30:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206173103.2617121-1-edumazet@google.com>
Subject: [PATCH v2 net-next 0/4] net: core: use a dedicated kmem_cache for skb
 head allocs
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Soheil Hassas Yeganeh <soheil@google.com>,
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

Our profile data show that using kmalloc(non_const_size)/kfree(ptr)
has a certain cost, because kfree(ptr) has to pull a 'struct page'
in cpu caches.

Using a dedicated kmem_cache for TCP skb->head allocations makes
a difference, both in cpu cycles and memory savings.

This kmem_cache could also be used for GRO skb allocations,
this is left as a future exercise.

v2: addressed compile error with CONFIG_SLOB=y (kernel bots)
    Changed comment (Jakub)

Eric Dumazet (4):
  net: add SKB_HEAD_ALIGN() helper
  net: remove osize variable in __alloc_skb()
  net: factorize code in kmalloc_reserve()
  net: add dedicated kmem_cache for typical/small skb->head

 include/linux/skbuff.h |   8 +++
 net/core/skbuff.c      | 115 +++++++++++++++++++++++++++++------------
 2 files changed, 90 insertions(+), 33 deletions(-)

-- 
2.39.1.519.gcb327c4b5f-goog

