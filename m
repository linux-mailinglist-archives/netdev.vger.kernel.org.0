Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9F71875FE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 00:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732893AbgCPXCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 19:02:30 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:50008 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732854AbgCPXC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 19:02:29 -0400
Received: by mail-pl1-f201.google.com with SMTP id a2so4189419pls.16
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 16:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SUb6EV5rhXrnRAvvqOodBLBiB/DUyXugCNcGk/0Trfg=;
        b=WNg6+88fDFQFygGKhUa+NIObfplMNvlfV+je/qZbhn3SLlJShYDP5A+x0pzJbWIrQq
         jkDVaUkZEQ+kfJbAcJEryl1cfshsmiZAibzhDEMDFM7MWH1SRuendgSYFHWKMFHfVUxN
         rMuPPvEibOyyA89DCdYXAmpw4QBpAD1g3tAYN3e9g0OuPwUuRxlP4DKkzVgDY9nIHaeY
         woz2o/+vvrK5PRPWDRIYwWyx3K1r4oUZs7RgeZOyBmpRLLhHMmirToZrGnDMxh/fIec8
         1T8PCSXWa/XeTjJsUtUftl0hLHTLA5N6i+M6x6VwBTWjMA2Pof8sR/FndRwtAt67GLGh
         Etyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SUb6EV5rhXrnRAvvqOodBLBiB/DUyXugCNcGk/0Trfg=;
        b=sLEZOYl/MchhxZe30R+RWZOoX8sHDXEKtg0vMmfm8s2sEVbgrbnFBsJ58KQkIW7HVe
         NYOxeD2dimJNgIdab1QByIFq/1DbpoMZflyXwArT1v/b86sMyx6f5fy+TZeehOh6tntx
         2NGFzHYVPWe4KLmWMSp2RTNxz8wh6ZK4WQO6xuDEdGSZHViJ4NamLIExQWnOsZ6ugKF1
         ejb/79tXfr0EQljvlmBTpjiLA444KcVgECpNmMulKCCottMMbKodT7fH8BqHiIql+JZQ
         a0dnVeUkByVIrnmQmn2n/QbdM8yxGezQNMDMl0x7s1d9/zO6yEviTs43CqICWW/Oedq+
         y1FQ==
X-Gm-Message-State: ANhLgQ1ugtafkdQFwcg4vyK7FzhwyXSB/9FsJmwD502rXbRLNonWC+2i
        D0FLv6maxhgEFpQ+pt/mE82PS01TDVXkaw==
X-Google-Smtp-Source: ADFU+vttg3kQ0n398NNeWzrHvCRsboRgG3TRHaR3nm5bIGyX5+sssDvIj+VcFIWHz9saYNpHrI1yw3JTCznSxg==
X-Received: by 2002:a17:90a:bf81:: with SMTP id d1mr1952527pjs.21.1584399746962;
 Mon, 16 Mar 2020 16:02:26 -0700 (PDT)
Date:   Mon, 16 Mar 2020 16:02:20 -0700
Message-Id: <20200316230223.242532-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net-next 0/3] net_sched: allow use of hrtimer slack
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packet schedulers have used hrtimers with exact expiry times.

Some of them can afford having a slack, in order to reduce
the number of timer interrupts and feed bigger batches
to increase efficiency.

FQ for example does not care if throttled packets are
sent with an additional (small) delay.

Original observation of having maybe too many interrupts
was made by Willem de Bruijn.

Eric Dumazet (3):
  net_sched: add qdisc_watchdog_schedule_range_ns()
  net_sched: do not reprogram a timer about to expire
  net_sched: sch_fq: enable use of hrtimer slack

 include/net/pkt_sched.h        | 10 +++++++++-
 include/uapi/linux/pkt_sched.h |  2 ++
 net/sched/sch_api.c            | 21 ++++++++++++++-------
 net/sched/sch_fq.c             | 19 +++++++++++++++----
 4 files changed, 40 insertions(+), 12 deletions(-)

-- 
2.25.1.481.gfbce0eb801-goog

