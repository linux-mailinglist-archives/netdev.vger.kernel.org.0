Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C62527CB1
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiEPEZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiEPEZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:25:02 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4752318384
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cu23-20020a17090afa9700b001d98d8e53b7so12257586pjb.0
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SeR+hj0WDkoqfJ2KzZutFu1gH3UYpfreOS1f6On3Z7k=;
        b=blGwh3txWvSWpjUjqmpId4BbEKOcLfUpAHqrUlSfTDlySXpWxacQUQolMBGWqFplbD
         bF+E1dY/IAaZgq9bed1I9K4Wi4Gg6UkzpCG1OhZ4KvBOSvYC/0PShFY6zX6r6ZxIWGKK
         GVG5yKw3+efdaVOqBGgcVxckTbT0aD0n0FkcZI9TXRNdOlZqQGdFHgp4JBDejspHv6na
         zRsFMYju0R38JglBgcyH2J7lHH0M7TQTf5PUBAgjCEf6oHfQn+NaaPYrql2Z6bYJqDU+
         gH0DQ20NpEWhsk7RdqrfTbdp3MpqUYSl3loXCy2vUgFnZ3o1PQ9cGgm1J/489u/GngtK
         epEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SeR+hj0WDkoqfJ2KzZutFu1gH3UYpfreOS1f6On3Z7k=;
        b=KeMkmIUfp53jJaKiOaU7MIL0/9ftprY5zA/bGRaGoU1rymFWixAPJUn95kYWVm1J9D
         yEChQbtmiuAGHbYxpghJ9laIW2bnI8M38nMvX9r//8xp0y118ArrVT+TZuK9WExiMj0q
         9OSe1DejcfdBFo70N6e8yOXzUwAKd71Ly8cIQmuWwjumURfiZeKyh6ivEU6zLtc5Fkw7
         2AUlbYORdvbja32eYhb32yXkbd5kaB40+xb0lkQj2QLhj25iIaRSdFIRjCbaPYpwwSdr
         ZHadKvtu98H8jFsGM5kQPwOlYW7PWvTASgWUe2IcQdhLk55mdC25ZTLzJ/x3aHeCl1jf
         qiww==
X-Gm-Message-State: AOAM530YII+lq1IrEs2Z2rZ0C7Oi7qSLZcVI9Kq9sobk4AGMjk5Vm0sy
        28Ys7oJ3jXKHNQJ1xopgABo=
X-Google-Smtp-Source: ABdhPJwgoRAsN9QEn0yzTeD38dxHuU6oEbNhXZMC+XVbi4ad0zCi798FwPjkpPoszfVfVuEpGdPhfw==
X-Received: by 2002:a17:902:db12:b0:15e:acc0:ea84 with SMTP id m18-20020a170902db1200b0015eacc0ea84mr15935151plx.127.1652675100733;
        Sun, 15 May 2022 21:25:00 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:983e:a432:c95c:71c2])
        by smtp.gmail.com with ESMTPSA id w16-20020a634910000000b003f27adead72sm308403pga.90.2022.05.15.21.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 21:24:59 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/4] net: polish skb defer freeing
Date:   Sun, 15 May 2022 21:24:52 -0700
Message-Id: <20220516042456.3014395-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
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

While testing this recently added feature on a variety
of platforms/configurations, I found the following issues:

1) A race leading to concurrent calls to smp_call_function_single_async()

2) Missed opportunity to use napi_consume_skb()

3) Need to limit the max length of the per-cpu lists.

4) Process the per-cpu list more frequently, for the
   (unusual) case where net_rx_action() has mutiple
   napi_poll() to process per round.

Eric Dumazet (4):
  net: fix possible race in skb_attempt_defer_free()
  net: use napi_consume_skb() in skb_defer_free_flush()
  net: add skb_defer_max sysctl
  net: call skb_defer_free_flush() before each napi_poll()

 Documentation/admin-guide/sysctl/net.rst |  8 ++++++++
 include/linux/netdevice.h                |  1 +
 net/core/dev.c                           | 15 ++++++++++-----
 net/core/dev.h                           |  2 +-
 net/core/skbuff.c                        | 18 ++++++++++--------
 net/core/sysctl_net_core.c               |  8 ++++++++
 6 files changed, 38 insertions(+), 14 deletions(-)

-- 
2.36.0.550.gb090851708-goog

