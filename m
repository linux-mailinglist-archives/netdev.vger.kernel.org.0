Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4091877B9
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 03:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgCQCMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 22:12:55 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:49015 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQCMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 22:12:55 -0400
Received: by mail-pl1-f202.google.com with SMTP id w3so11596182plz.15
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 19:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2cUYfUOQeA8LojVinsllri32Ii03s1TL/iCiy8JjnPs=;
        b=ernmM1bCG2YNhdCEo7HlaHD1EzmtDoCxHyOKW8bxQGCxYhNxpgr+GFvOKQu0gVFats
         bwD4WvzpPu41UXjW5LIJ5LxtL1WQAVZSinjFX0K9WCQX9aYaJ5JYTet5mQBhE3Ea95Bm
         mHptBct0ER7O0cXad6UUtS4Ejs/b5BvnDb6pTx/CYTlRtcCetj/W/HZRHxDPKN2yI0z/
         N1BLAe1ahaO5k0JA/+27hAyIwJpw10pNhFuuXODieuZ661MdaawgeD/RGRpz7JApXOaM
         x9hoaMCLulfg2u/nP77TMm2WTJgt7NWaolwl8cMvZ2N7Q1d4233zYq0oiYLwPH8l0ppp
         G+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2cUYfUOQeA8LojVinsllri32Ii03s1TL/iCiy8JjnPs=;
        b=Ngg5bpCaracIDGyMKkj/nfAzlieeJuXeFYmoyv87clEhf5YbafEm6WWPW0ntyuRsIa
         H9Jr+CDDYw/NsrY+gZusJ4pajUXfnfbiv8pyBS4zCutOvnxhdrAjBAbzfUBa1QH2T07d
         BrRyTuVo0PS70db1ghg4YpKqCIN1fVPyZbkUJRVP+se+Mq5KviRZinKjOM0lOhgploGw
         I/t6WJm8XavSN+m2295OCtyq2/ybc6jgHnIrMbKtloV+Q3xBfMDCrL6EdDg0fAC0wmjA
         slIu5KwSXgbF2Wau6ev4RLXiWPdDRYlE9NXBxYLSP1LDZqdRTfNBC1bhwx9SeaDsMJB8
         tRHQ==
X-Gm-Message-State: ANhLgQ0baqLII9rDM4x1l7UeHkGf5MyVtMAKwrBK/yITxlW3xgTe/KSv
        Vo7brMRiYHqkVxblr45a8mTd2Yey59ivKA==
X-Google-Smtp-Source: ADFU+vv0TOSkXxuijwiZifB5W/p/NtXa8iy5Kdzdxw7kWj+WddAHdxCylAL3VGm/XqdOIrZxkQEDFS7QJQMjcw==
X-Received: by 2002:a17:90a:1912:: with SMTP id 18mr2642406pjg.10.1584411174073;
 Mon, 16 Mar 2020 19:12:54 -0700 (PDT)
Date:   Mon, 16 Mar 2020 19:12:48 -0700
Message-Id: <20200317021251.75190-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v2 net-next 0/3] net_sched: allow use of hrtimer slack
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
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

v2: added strict netlink checking (Jakub Kicinski)

Eric Dumazet (3):
  net_sched: add qdisc_watchdog_schedule_range_ns()
  net_sched: do not reprogram a timer about to expire
  net_sched: sch_fq: enable use of hrtimer slack

 include/net/pkt_sched.h        | 10 +++++++++-
 include/uapi/linux/pkt_sched.h |  2 ++
 net/sched/sch_api.c            | 21 ++++++++++++++-------
 net/sched/sch_fq.c             | 21 +++++++++++++++++----
 4 files changed, 42 insertions(+), 12 deletions(-)

-- 
2.25.1.481.gfbce0eb801-goog

