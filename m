Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DCE688739
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjBBS6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjBBS6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:58:08 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46FD125AC
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:58:03 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5065604854eso29048947b3.16
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 10:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eIrkk3BkVoM/iINXe0pYuaSj/DA+Md5ZIxujG8oX2i4=;
        b=svNUe0n74D2Wi7aUJ6oR2QJ0JXQYLirEQKkvGY3CmefzXfBg6z9PbyMn7dBveLR17l
         ijDL4Z+HdC1Fpkn4rIH1zC3vr/cnIBWaYlM9wguqiVlHKme1UUxwvCHeaCNfOvg7cPGj
         wQZABKj1LqILEYWI+QkD6MozyqDAIgID7XZEUEkVvclJ6P+CXG/b8RXaQNmfIiizG0tm
         TeIzqZyrz736g/oGVF9ozFc1m7Lu0st2pn+WWEF5Oh/OGaac2f5b9bWIcYnOzvU7IExm
         QCwz/1e2Z/93uEqz4N//xmK3GrMgeyXOoANWgWR7pnrg1NW91FRR0jaAnvGQ7hfC7G6h
         I3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eIrkk3BkVoM/iINXe0pYuaSj/DA+Md5ZIxujG8oX2i4=;
        b=4bYWN6p697XHA6i6/muOMqZVj9maZ4PHb33jwXPWuXLzagWh0QIN9Lz/YNOZjjlPoO
         pPx8RgoFl5RGG7tsQLVPkTnyi8P5O5lBJiU9ERik9iOQNMPS/FJBODuHIWwcWj75g0h6
         xfJcUPq3FCzZOCcMuTjHtIm+L16tcP0kXdUWMksxtrnBDlBe0oVbeoL3RYTWY8qRsDOb
         9C8VnvlJUYuvIBf15e+1RmNd8UV7SRkwBu21Ei6/6Obr1LHa6DMA8PYRJtA9MmRGx36L
         oc4Ka5HQnlGDDEHUHH0rNCXIuI65Ezqbh+U1Vwar7BTabHURRULeQfWtYwePt8+9klTG
         xPqQ==
X-Gm-Message-State: AO0yUKUbkFktjZQcZT3pnfHEaLMt0hq1FKW+hcYxnfkS2g4UvOT0p0CJ
        g8ajSVCZTCERZRjzpLOna/eyLKtGC8frIQ==
X-Google-Smtp-Source: AK7set+hlKM0uo/BwkphF5euD+H1sBdfx7Z4h5j08Ric96hLqNMsMqSZM1UxeQQJidBinzKuFLLEcEYY3ARNlw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:4e5:b0:825:43fb:db01 with SMTP
 id w5-20020a05690204e500b0082543fbdb01mr869459ybs.407.1675364282991; Thu, 02
 Feb 2023 10:58:02 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:57:57 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202185801.4179599-1-edumazet@google.com>
Subject: [PATCH net-next 0/4] net: core: use a dedicated kmem_cache for skb
 head allocs
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>,
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

Eric Dumazet (4):
  net: add SKB_HEAD_ALIGN() helper
  net: remove osize variable in __alloc_skb()
  net: factorize code in kmalloc_reserve()
  net: add dedicated kmem_cache for typical/small skb->head

 include/linux/skbuff.h |  8 ++++
 net/core/skbuff.c      | 95 +++++++++++++++++++++++++++---------------
 2 files changed, 70 insertions(+), 33 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

