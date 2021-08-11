Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE0E3E880F
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 04:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhHKClX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 22:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhHKClV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 22:41:21 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B91C061765
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 19:40:59 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id u16-20020a05622a14d0b029028ca201eab9so534396qtx.21
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 19:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MNqJlxKZGKw/Uq+3KBHoBoWEkO9SAFSOWsCaFTYm2jE=;
        b=Kox1GoozgQrT16Yjiit0WBrITwZtXpsrXaHcMzwrNUACeTmtP1l1jLYzCembq00H/B
         Ojf4Lboz+bRW7sbeIOvZUEEFFA6SC9Y+WAChy9IgZcH5Ay/1ysPsjScYUFlAM0AGiufK
         bqCjYKkn00CpQScmtOwUqt3+nuUsgR08mLYHN3lHZ24c12YgqYP9Apkito/m7ngE03Cd
         j6uN9/NYfNHdHtJ4tbaE+edJeM1UP3D7o5twrsJJKmXzl6Gk7wnal1FAn9Jjp+gBMC6I
         uBTlDx6E+4w8CtiPgrNKPC5tcwRW5Xm8CPethzUZCs2qmY78B7hxNkUyI9mvF3BZfP5K
         2Hog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MNqJlxKZGKw/Uq+3KBHoBoWEkO9SAFSOWsCaFTYm2jE=;
        b=rke+njMhJini925+ELBGsFUt/tOIvErh8/P5zid2lZaDQfKOktxYmcaDI9J6wITfnf
         3Was/av8Od5Rzv+Me7Att7HQUKHi1V6gPI/ZqSQtSxmdWNCBRJxqcLacoi7nNuAIruno
         CIJ9KJeiUS2SlTvNXy8DYvPqHDFBMiKsJR8uuPUR/BCGY2zfNLI9PwzAdXD7Ajo/4dmc
         GJX9c40VcErpisnltM5AhMgdzImTHnRSRq/IiQp1L6djFocZpNqvQUFEQ5x4XtfIi1vO
         VQVWhfMQObHRQHVAGdkJ7U3cO7Atc5zRLK9gAw7B9gIB1Y6kVozX7ACjguMHAJVwPgS3
         SDjg==
X-Gm-Message-State: AOAM533s6fV/fn/9591ZF/0WsH8FNOXci6VEpOOIvuPZO7N35eXkax8x
        4hl0lff68Ey6Fd0vI4XfFYTJqDLmBhFIFXw=
X-Google-Smtp-Source: ABdhPJz48Wai2TKAILVXT/Lk5c13YvgNlrgtUc371yZqUKVao7Hr4tu1rIk+ens3Ii38cJoyo0GyfTiCC8NXZSU=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:8480:c952:3c36:f506])
 (user=ncardwell job=sendgmr) by 2002:ad4:5de1:: with SMTP id
 jn1mr21051745qvb.62.1628649658291; Tue, 10 Aug 2021 19:40:58 -0700 (PDT)
Date:   Tue, 10 Aug 2021 22:40:56 -0400
Message-Id: <20210811024056.235161-1-ncardwell@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH net] tcp_bbr: fix u32 wrap bug in round logic if bbr_init()
 called after 2B packets
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if BBR congestion control is initialized after more than 2B
packets have been delivered, depending on the phase of the
tp->delivered counter the tracking of BBR round trips can get stuck.

The bug arises because if tp->delivered is between 2^31 and 2^32 at
the time the BBR congestion control module is initialized, then the
initialization of bbr->next_rtt_delivered to 0 will cause the logic to
believe that the end of the round trip is still billions of packets in
the future. More specifically, the following check will fail
repeatedly:

  !before(rs->prior_delivered, bbr->next_rtt_delivered)

and thus the connection will take up to 2B packets delivered before
that check will pass and the connection will set:

  bbr->round_start = 1;

This could cause many mechanisms in BBR to fail to trigger, for
example bbr_check_full_bw_reached() would likely never exit STARTUP.

This bug is 5 years old and has not been observed, and as a practical
matter this would likely rarely trigger, since it would require
transferring at least 2B packets, or likely more than 3 terabytes of
data, before switching congestion control algorithms to BBR.

This patch is a stable candidate for kernels as far back as v4.9,
when tcp_bbr.c was added.

Fixes: 0f8782ea1497 ("tcp_bbr: add BBR congestion control")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Kevin Yang <yyd@google.com>
---
 net/ipv4/tcp_bbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 6ea3dc2e4219..6274462b86b4 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -1041,7 +1041,7 @@ static void bbr_init(struct sock *sk)
 	bbr->prior_cwnd = 0;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	bbr->rtt_cnt = 0;
-	bbr->next_rtt_delivered = 0;
+	bbr->next_rtt_delivered = tp->delivered;
 	bbr->prev_ca_state = TCP_CA_Open;
 	bbr->packet_conservation = 0;
 
-- 
2.32.0.605.g8dce9f2422-goog

