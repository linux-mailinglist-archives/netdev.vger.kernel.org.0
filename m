Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A19B278F4C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbgIYREi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729477AbgIYREi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:04:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F71C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 140so3283720ybf.2
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=Ebilc4DY3Vyd6ZRYopWeA/UmKzd5DTCHvPamWycxxTc=;
        b=v2+3vv9LEtVIhQTNfhoBJy0Vf97GtW1LGsa8xsVwrTke+nHpnIm3eUF3I6E75gKGs0
         hXRWY4dAduhQV45psn8qiVFQDuHhaQJjvN1FN4Y0K8OzY9Gcg3BcFG0xIGPe4cXOiwBY
         g7kE5K48aO3tDJQC9Q+l1N9MRSUFG7j0EaOb06L2zGoGn8e1D+8dVHPYyQc4XrCZIZt3
         80eufFalHsM752XXJGCAXYLoT0PVO5HSI5gaAqb6G2JqxJtRaPepUaoCNvtioTLb0cg6
         KEMAM7jj4m9iMjDzxi2adnvFP2QLNAMoOOKKGU/0diE8KiLUU5LrcedwbN7cKMrA2kPC
         bBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=Ebilc4DY3Vyd6ZRYopWeA/UmKzd5DTCHvPamWycxxTc=;
        b=jCIwRWwSgIzOtjhuj0b8VH9kwA8W0WoirnaYNeU9iLx3xGeNwb4ufyzDH4mMZ3bC90
         IEYfS22LMkh1xsbQAD73WoSqeKzhWBNyrZlFGnMUCAXD9pNr9qE8ZkpeciTe81ssV1Bf
         +AAllcjt3XhQj76UNRZpI5GNYeDvQs1EBXAvj/q1+vLGVxpMeHYp5kCLJ6R3wk8y5Elr
         W58Z+4kOynTmGiRSntpyuGSLt4UNMaaGnGEvrbiosmHRMYpRiygVEU6lCZ8yUbGlkQNP
         HI74gtfRbrkN0TYV7T0H0wIy2XcwMF8lqPgEJI4r193De8BOosLBEHjKRV4V8bNXLCB5
         d/IA==
X-Gm-Message-State: AOAM5327GoDicoO0YRVYNkhvuqlIFFUkcRMJeHBJ4neqi2CPVBMtpX1j
        g5xsxrr6ZcCdX0D5o3ujJ9iWVoa1mRM=
X-Google-Smtp-Source: ABdhPJwiZaOYZ9BDjP7Lgr/RawuPPSaJukryLan0UQBnbRPfrJcmznFkMOJ9Y2LvFEf66m9ps3pQ+bXpuNs=
Sender: "ycheng via sendgmr" <ycheng@ycheng.svl.corp.google.com>
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:fc76])
 (user=ycheng job=sendgmr) by 2002:a25:e4c5:: with SMTP id b188mr217129ybh.79.1601053477030;
 Fri, 25 Sep 2020 10:04:37 -0700 (PDT)
Date:   Fri, 25 Sep 2020 10:04:27 -0700
Message-Id: <20200925170431.1099943-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next 0/4] simplify TCP loss marking code
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCP loss marking is implemented by a set of intertwined
subroutines. TCP has several loss detection algorithms
(RACK, RFC6675/FACK, NewReno, etc) each calls a subset of
these routines to mark a packet lost. This has led to
various bugs (and fixes and fixes of fixes).

This patch set is to consolidate the loss marking code so
all detection algorithms call the same routine tcp_mark_skb_lost().

Yuchung Cheng (4):
  tcp: consistently check retransmit hint
  tcp: move tcp_mark_skb_lost
  tcp: simplify tcp_mark_skb_lost
  tcp: consolidate tcp_mark_skb_lost and tcp_skb_mark_lost

 net/ipv4/tcp_input.c    | 60 +++++++++++++++--------------------------
 net/ipv4/tcp_recovery.c | 16 +----------
 2 files changed, 23 insertions(+), 53 deletions(-)

-- 
2.28.0.681.g6f77f65b4e-goog

