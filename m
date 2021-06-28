Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AAD3B592E
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 08:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhF1Gjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 02:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhF1Gjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 02:39:42 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB52C061574;
        Sun, 27 Jun 2021 23:37:17 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h4so14601294pgp.5;
        Sun, 27 Jun 2021 23:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gt9IQRDfFH+/aqTViNW3pnhtGqA+GtuD7oV18Q5kQiY=;
        b=ufebC85t0S9LraLBGKbR6RuqsLTKIbryBZGg8ro46Z6/bYVsnH1aEbupWT9FlY59+W
         21uybbm5/AmrslV10sgsQBaWwIykxPJEVGl8LOw0MYpIgmqr5ldUJULPJr956HtsW7gW
         vEtcb9TFDGM45qTagKy1dTb4zlKKNSljZpSWzLiZdqk/g6qoE20iECtAZTt67287Jjlj
         1LqcOJUhdWWvH/Yzv8dR48W6UMJR7moWso0COktHZpxx90SO3jpQe50husYhePi++O7M
         80q9VHfIg55ox8efgLdCs/ZUDWHQ11MW6CFq1qc4Q0rRv2R7FY064VOaFZA1w+kTT54+
         hDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gt9IQRDfFH+/aqTViNW3pnhtGqA+GtuD7oV18Q5kQiY=;
        b=LQvZs1MM5DSsAnsF0UZY4y7lp2zhLpb392CKwWYB93KLG2BUyIepYMF9XE7JpvgvIK
         WE5OJsrRbE1eB2KU6wKoCrVF4J7DjtyBzCVTv+oZpOya4YNo7aj5U7I42puiroenpoq4
         aLMXlQg1Jp/jbsU5NT7c2R0VZbahgzE6YaIHA+u5Wyalmzk+uQR0qc/xLGCpKR4v3x0M
         DQ6JYFiZhTKQKxtczsQqVzbMgwctpHK2/C9dn4DI8acEhtnjqPCs471U3o09gDHWG420
         PI+6Fzn9OEbPg404dKMq+w05wdt+rzNlpoCsY2QhcuHq/Ctu6hm5tI6avH5l2OwXBiCR
         wo0g==
X-Gm-Message-State: AOAM532QOls7fOdteMe1PtDRWIjrez7tgJbOoEq12ZO/jD3iTnLNQE0T
        xHc9d6bQKeTbnMaTP3DnMaw=
X-Google-Smtp-Source: ABdhPJxgsbiNRogcnhj2qXaf1prnSiZ2NCuEOS+mFrikrvD+wlm0DCCEX6ejOPaf2JCG14BnSPFIQw==
X-Received: by 2002:a62:1857:0:b029:302:fb56:df52 with SMTP id 84-20020a6218570000b0290302fb56df52mr23340195pfy.3.1624862236684;
        Sun, 27 Jun 2021 23:37:16 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y21sm2980379pfb.120.2021.06.27.23.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 23:37:16 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, lxin@redhat.com,
        hoang.h.le@dektech.com.au, Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v6 net-next 0/2] net: tipc: fix FB_MTU eat two pages and do some code cleanup
Date:   Sun, 27 Jun 2021 23:37:43 -0700
Message-Id: <20210628063745.3935-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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
ALIGN().

Changes since V5:
- remove blank line after Fixes in commit log in the first patch

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
2.25.1

