Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2030A337F1F
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhCKUgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhCKUfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:35:48 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412D4C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:35:48 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so2195320pjb.0
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bnoqCNJaWiwi+Y0V4hNJkf28BV4nNKLfK4WQyVtf2XM=;
        b=F8idy7udIyDEpz+UZTDLFewR3EO1zyE96eyjeeWd4KvN30/1pKHOVQJqkxtYhzXZwJ
         1gOUVsm8ykLLVX0yUDQ0DduyJdj3rD9OQv9cYqxi4OeEVpvna7/YrWr6jlCEYM2zUv/w
         V590FazFlz6Icayz26GER5A0UiPXaqm9vEE7eahSmn3l3LljD0wXKHhJgUmjKQxDmT29
         Iegp9qsYz2q2S/kTP6nr+r1/7svAIRrcsZg2CaVmHp5Ux+MRbcddZ+GZu5eVdDeS0+qQ
         BW6IQmQTB7SlqVToVnmJgNHYBtJXcXvyFgmH26tZh+rh4t4WDPhC/rBPusC6s/scVYA4
         9lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bnoqCNJaWiwi+Y0V4hNJkf28BV4nNKLfK4WQyVtf2XM=;
        b=rwiJFHFiwcC9eRcUExzALcINhS2Fv7Glg7i5yp1tbNa0z6OQrr2fHALJXjm8JNY4OY
         tJxodvChZ5WK1bT8g5Qt4ZHEQxVR/5bg5SPDYU9psaswfNShYbI5jYPvfwAuKoJWVvdN
         mPhnroHdaWOtgFUAZtNYK3686kjICQHieSJbjWW675MfaLTl32fs4v2PVMAUbtiU/w9v
         RPNv0HDgprLUXdWwC9WOEnvcDUP/5H+ZvmKv0lPdv7yMPTZkC19FLHP7IS50OVnkFsIL
         d/2XEBrQf9nCSKMhUQV/NCrthIHwF8LwNmx3/Y5vnmG7DmEUIdK6b8EqmBZg+HDTmDlA
         igyg==
X-Gm-Message-State: AOAM530Q+5HtGBngSRdDOhnrrOWwLvHP0IaFzjq5nA5jOzo2BqWuFMv4
        xXRFmL9zZMiRe09VEfj+FkM=
X-Google-Smtp-Source: ABdhPJw+Q+Hc/JXZcqLaZof3SkLDEGH4ajwGh1aThPUVF2TjYZu5ovskbecvaEfRoBegrJLNHRA/mQ==
X-Received: by 2002:a17:902:c1d5:b029:e6:52e0:6bdd with SMTP id c21-20020a170902c1d5b02900e652e06bddmr10140429plc.49.1615494947766;
        Thu, 11 Mar 2021 12:35:47 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5186:d796:2218:6442])
        by smtp.gmail.com with ESMTPSA id 25sm3232745pfh.199.2021.03.11.12.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 12:35:46 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neil Spring <ntspring@fb.com>
Subject: [PATCH net-next 0/3] tcp: better deal with delayed TX completions
Date:   Thu, 11 Mar 2021 12:35:03 -0800
Message-Id: <20210311203506.3450792-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Jakub and Neil reported an increase of RTO timers whenever
TX completions are delayed a bit more (by increasing
NIC TX coalescing parameters)

While problems have been there forever, second patch might
introduce some regressions so I prefer not backport
them to stable releases before things settle.

Many thanks to FB team for their help and tests.

Few packetdrill tests need to be changed to reflect
the improvements brought by this series.

Eric Dumazet (3):
  tcp: plug skb_still_in_host_queue() to TSQ
  tcp: consider using standard rtx logic in tcp_rcv_fastopen_synack()
  tcp: remove obsolete check in __tcp_retransmit_skb()

 include/linux/skbuff.h |  2 +-
 net/ipv4/tcp_input.c   | 10 ++++------
 net/ipv4/tcp_output.c  | 20 ++++++++------------
 3 files changed, 13 insertions(+), 19 deletions(-)

-- 
2.31.0.rc2.261.g7f71774620-goog

