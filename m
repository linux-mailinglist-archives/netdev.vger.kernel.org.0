Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0713B1C45DE
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbgEDS16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730962AbgEDS15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:27:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9BDC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:27:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g17so492933ybk.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 11:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VUO5ZvdfCqUoXbWGNL6gAhXWUhU/rLulR5yl7uGpMuM=;
        b=vfH0pQPFMQ/Lf4eJLBrJK+BQAqB1vO/BEDj2eUD8p4NAMFPrFF41j0skzWH0Cf6wYT
         qaxjJtIiFITDDEJDolYYVM1xVSXJNnlvUdvKhJs341gxel+qnLFsfWB53EV3Wc6rBHPS
         Mh01gHm/1VxjOPyzuUF6g4Utr63IkLi4oKBX1CH555lRyBVAyfzuOik0M1rHo4ljC9Ve
         HiPIJfAr8jQzEcBAsFisOH8mNi2tXfhBQOKhIqa5trCsZgXOaAuTcA/O+4XxyZkRSA/w
         GWjGsVvHKd9oOHdVNYf17MNkcwaSX9i5sPoD1R2P5QBDfn5M38UZBuirJmLPFjtu/B9U
         Z6Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VUO5ZvdfCqUoXbWGNL6gAhXWUhU/rLulR5yl7uGpMuM=;
        b=oGEa2zpUkXe+YXYPrNMJiO/+b/OzpK+Uup1OEI+O9X1RHagrd2ViLldeELw5CMiKNS
         CdYrUIN+5g3dZb+uY3k0VksM7xQkSRMbRZED2WB24UvE6tFnFAfZ/XJhkRAPjsjDcVOk
         et3VY81bKYPryWuDR0OqLDOH8k0Jv2VhXcVdvNf1fTUTv/Vx5JEoZU1tp1VSSqJ+xYZ9
         skvjnAc42irFFJyls8ImEL16QbZnOoZdWo/kNoLRAA+vtJYvULIcdHv9VpqcuJZdIYai
         xjJYkOwb6BnDSM4q5W41fUMACVInpy7GR5xsZg3g6SpnFZlIRtFA684GuM3vN3bYoHII
         CdDg==
X-Gm-Message-State: AGi0Pub0fNvaJ5gm9jhKX7IQiYRE/2FxlvMLtDuSqptyATl4ODtP+gU1
        0JLARGU5W6iKmmZnQw+ZPUBw6x8nSNuALQ==
X-Google-Smtp-Source: APiQypLAIObBOo+Tr4ipTDJbRNVnxcD52PWh7+uh65+6OsiFGiH0Ab89Xc8lHgZ6dCBpcc8xfOGgdKum79EYMg==
X-Received: by 2002:a25:ef52:: with SMTP id w18mr936696ybm.191.1588616874947;
 Mon, 04 May 2020 11:27:54 -0700 (PDT)
Date:   Mon,  4 May 2020 11:27:48 -0700
Message-Id: <20200504182750.176486-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 0/2] tcp: minor adjustments for low pacing rates
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After pacing horizon addition, we have to adjust how we arm rto
timer, otherwise we might freeze very low pacing rate flows.

Eric Dumazet (2):
  tcp: refine tcp_pacing_delay() for very low pacing rates
  tcp: defer xmit timer reset in tcp_xmit_retransmit_queue()

 include/net/tcp.h     | 21 ++++++++-------------
 net/ipv4/tcp_input.c  |  4 ++--
 net/ipv4/tcp_output.c | 22 ++++++++++++----------
 3 files changed, 22 insertions(+), 25 deletions(-)

-- 
2.26.2.526.g744177e7f7-goog

