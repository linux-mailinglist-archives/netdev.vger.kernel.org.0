Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC66F3AD8AA
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 10:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhFSIne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 04:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhFSInc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 04:43:32 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7DDC061574;
        Sat, 19 Jun 2021 01:41:22 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso8225271pjx.1;
        Sat, 19 Jun 2021 01:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OTx6q5PnXq+yGS2yZ7d+MKeUb58X7yAoJp+atwowZSw=;
        b=c5c2+U0N0+79Mckt6pAaqn1Im1dEZCItC/bgPnCF5XmctsnUZrmCtbDSDvkvZ+mbxP
         ePKmJMnfLY5ZiKWGq5pw9opXQ7ivT9r8+qsj7+MWEFOgadXMZN5ausc+I61Q1/97kJCU
         iF7tUczgFcChc5AkbMdhpCDR9DZVuDZC806vx0VfP83Lgd5VKEj022rRxbFl8pbvOQM4
         x1MB4jNK3o9ryK6trkcP/igjOm0EPstXX/MMaDaVQhAfTGBf29CjogANY7q7VrHIELLs
         2FHkHympM5RqUHlIH7NwqCtzCwW0iAExxLsM1doKwpUB5ecNMpZr9PAEQSI28DaxOpbe
         R0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OTx6q5PnXq+yGS2yZ7d+MKeUb58X7yAoJp+atwowZSw=;
        b=N5Kw0PChN1Ngtz5n3EZxHDmIbJWtgbSJSkkSxkss6j4LSVle05pDnPN9IP1ZV3XnEc
         RXGrYS57wWaFT1FL0yAvc2MaG3LLD9poL16I3l4+vo8UGWzGGnRe7u+33Yd5VlP2T4NC
         +lq+sB3uftvtP8MI0Bjt3b5wIbvQRw7PlkLuQPDwgCAPG0Ocsp2IrZR1zoYlx4bfJ3Zc
         6D3Tr+H70HZiGXtrsP7VPIsBvyGXANcSYuxTQUoYaFgUN1XbOvy2YjayHC/+dAdfEF91
         PqwL1NG7mVZi7zNiZgfogyS7VrG961SKZwINqKnG2KW/NSU2QDhgD9KCu6GYZSQT8heK
         SOrw==
X-Gm-Message-State: AOAM533TuBMVhbGTsGiHY9nq3JtZ5IYSNer9IJSJwkKpNlmDaWk82anb
        TKnWfSdyDBrkdiRx5aA0XnI=
X-Google-Smtp-Source: ABdhPJwHZPSRKMK4Xx9Du44YE9frNlglRxbJeMbwobTX2fVSIbdUZuKj318obreCw31gIg4PSQGepQ==
X-Received: by 2002:a17:90a:4503:: with SMTP id u3mr15791921pjg.210.1624092081583;
        Sat, 19 Jun 2021 01:41:21 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id v6sm10153921pfi.46.2021.06.19.01.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 01:41:21 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, lxin@redhat.com,
        hoang.h.le@dektech.com.au, Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v5 net-next 0/2] net: tipc: fix FB_MTU eat two pages and do some code cleanup
Date:   Sat, 19 Jun 2021 16:41:04 +0800
Message-Id: <20210619084106.3657-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

In the first patch, FB_MTU is redefined to make sure data size will not
exceed PAGE_SIZE. Besides, I removed the alignment for buf_size in
tipc_buf_acquire, because skb_alloc_fclone will do the alignment job.

In the second patch, I removed align() in msg.c and replace it with
BUF_ALIGN().

Changes since V4:
- remove ONE_PAGE_SKB_SZ and replace it with one_page_mtu in the first
  patch.
- fix some code style problems for the second patch.


Menglong Dong (2):
  net: tipc: fix FB_MTU eat two pages
  net: tipc: replace align() with ALIGN in msg.c

 net/tipc/bcast.c |  2 +-
 net/tipc/msg.c   | 27 +++++++++++----------------
 net/tipc/msg.h   |  3 ++-
 3 files changed, 14 insertions(+), 18 deletions(-)

-- 
2.32.0

