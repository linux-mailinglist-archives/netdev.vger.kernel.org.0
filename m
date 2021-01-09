Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BD42F040F
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbhAIWTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbhAIWTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 17:19:22 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98870C061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 14:18:42 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e7so14274381ile.7
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 14:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w2VIkQnMAZODbJW9hj2GE2ROmlZThb3D6eYLKoSqBBg=;
        b=u2ab68iQoimV7ho7lmr8fHX+GmpFUP2GtXQXyn1D3PDshQtb7yIklfUnfCHnI5lBjg
         kKw95EYL9bwkISziOi5tbUlJOwd4gj6i1cK463mRgr85ribmJYIUHHBgZdARYeYdJsjX
         aj5t3klsX2OQfN6/HVZa7bRCJMDibYq69pICpspfsH6jzFalQ3tmGou+rLro5aIG9XOZ
         m7n9LMGo+/dpqAnwoLlhH/5tcPyY7b5YJCvI3AaYpCWQrQwDqui0N07koZuh09N5ANBS
         WEycTj8bigPGgEnz14tCO7UhOh870XQ/eZYAXB8+ddmKb1lPuUnE8igQ0xf7XBk4hss2
         r6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w2VIkQnMAZODbJW9hj2GE2ROmlZThb3D6eYLKoSqBBg=;
        b=IDV9e9AxD5CGGnSPhmgC4Ut2Lzu1lXX1fCDJ2QDwlhq4iRY0RksgmO9d9csqe1ILR0
         8qWE0UgyObHYpOQOXVtbnoHavAvLcVg86Eag/n4HoFwiVamx/BBpIr1iQuuGAA2FHScj
         cBAUcrVwFnz2PziumaWn5+bWUEY7KaC4u0e95LLdS/k0tGpDAux9ry0SZtJppfhktldR
         TReA7qnQwfY/HaMyIy599QpDYLct1PDlfC0VFyPzbuKBuXiXR4hQ/05UlWBcuX7UbJL/
         lbgt4BxRw0SbkXa+lhQ+SpG29RVPdGiT8vO0bsvW9YHrafLAJMIT3tNyvE6Ta/40F5WW
         GJMQ==
X-Gm-Message-State: AOAM53361hfSNJcrcXIeq3cgcHZNxf9zdo5TveRL1UPDUOFXn6QURm9W
        q4CFv8OgsFnyyK7+8MbwuvPAQMMwe7c=
X-Google-Smtp-Source: ABdhPJy/T9PLTTp51TWSRgmCV0S37GJAI+6RJrQcQ5Y/ZPhphF6pEy560ndUoU0odidB9IKvEmAwmg==
X-Received: by 2002:a05:6e02:14cc:: with SMTP id o12mr9668867ilk.133.1610230721668;
        Sat, 09 Jan 2021 14:18:41 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id i27sm11415849ill.45.2021.01.09.14.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 14:18:40 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net v2 0/3] skb frag: kmap_atomic fixes
Date:   Sat,  9 Jan 2021 17:18:31 -0500
Message-Id: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

skb frags may be backed by highmem and/or compound pages. Various
code calls kmap_atomic to safely access highmem pages. But this
needs additional care for compound pages. Fix a few issues:

patch 1 expect kmap mappings with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
patch 2 fixes kmap_atomic + compound page support in skb_seq_read
patch 3 fixes kmap_atomic + compound page support in esp

changes
  v1->v2
   - in patch 2, increase frag_off size from u16 to u32

Willem de Bruijn (3):
  net: support kmap_local forced debugging in skb_frag_foreach
  net: compound page support in skb_seq_read
  esp: avoid unneeded kmap_atomic call

 include/linux/skbuff.h |  3 ++-
 net/core/skbuff.c      | 28 +++++++++++++++++++++++-----
 net/ipv4/esp4.c        |  7 +------
 net/ipv6/esp6.c        |  7 +------
 4 files changed, 27 insertions(+), 18 deletions(-)

-- 
2.30.0.284.gd98b1dd5eaa7-goog

