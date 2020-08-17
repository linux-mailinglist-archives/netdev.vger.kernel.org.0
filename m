Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0682460CA
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgHQIq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgHQIq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:46:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F95FC061388;
        Mon, 17 Aug 2020 01:46:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f193so7881426pfa.12;
        Mon, 17 Aug 2020 01:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nb32zZpaq5DzYInbkLOMoGw5CQr0RQ3ACjmDsPtmqPo=;
        b=kWD2M2eRZOtNKawmTSq/yR75QnpAQBoo9exQE9wtVhu6SSt87u6RRdzQxwglUNqioj
         7WYux5yzIUJyhFvD5OINhiFFLd724EmEC2YNnx3Sc1cXlrKxDnGgcqdD3VVVRUylIwnt
         kAYLhayOSk7rO5Q7p6gypk/paOlMsKMGySrpR/sn4q1aJktG20z5+Ls0eohB5473ifSz
         zckKko/KXt0ABJ/jjHnrHAUN09HaXj5S2kjk5L+SJtUtbLn1dmS3L74fombWkdECCLPn
         pfG9VHUyUc+prdm2/eGq1xnFUuOsUkmHaauTfzqVYno9/OC85K1M0Sujq7sBg2MTtrHz
         fMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nb32zZpaq5DzYInbkLOMoGw5CQr0RQ3ACjmDsPtmqPo=;
        b=YEopDIBQZ5qG0LfAZ3s4UOLDOUAWr9yPGREmUsvxzXpFuDZfO4kTL7/xMQZ+CbTvA7
         8VQq9Lk2duGpiii5+N+hy+ynKn987BvGn7kmXJb6UMqq8Es388Ub/u8wJBtOoCfimXU3
         mE1Our9DF0U5ruzyuUjOnKCccUW5qPj5r+z5/dQGnI76uNilIMyb3MNux6+QdTBom9Fp
         G8O4Mn/tJ6YCN06ar/gWWXbVIy93OV7Wat49Lq6Sct+x57KR+fbn3ZcTBaff7F+1tI3u
         mihn/8CTvQnJ+e6VPoxs49bj189xH6bT0tlWf7I9hPsf6/ABbtenRw9/9Sox01ML7Lyw
         sK4w==
X-Gm-Message-State: AOAM533jzq4tY5iX3kirqnfnl50e3rrbdzuYkY69Y7j4wPfAiar7I4W5
        YHUByL2UFCxP4Rc0jqL3+h0=
X-Google-Smtp-Source: ABdhPJyypHx7MJA5JHgOzBfYE6gKoueYyuVnnKWVkRcqK6wFFKpCEGwC321zfv2ZqVmfnfvsZtfVag==
X-Received: by 2002:a63:b21a:: with SMTP id x26mr2662719pge.424.1597653986591;
        Mon, 17 Aug 2020 01:46:26 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:46:25 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 0/8] drivers: net: convert tasklets to use new tasklet_setup()
Date:   Mon, 17 Aug 2020 14:16:02 +0530
Message-Id: <20200817084614.24263-1-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts 
all the net/* drivers to use the new tasklet_setup() API

Allen Pais (8):
  net: dccp: convert tasklets to use new tasklet_setup() API
  net: ipv4: convert tasklets to use new tasklet_setup() API
  net: mac80211: convert tasklets to use new tasklet_setup() API
  net: mac802154: convert tasklets to use new tasklet_setup() API
  net: rds: convert tasklets to use new tasklet_setup() API
  net: sched: convert tasklets to use new tasklet_setup() API
  net: smc: convert tasklets to use new tasklet_setup() API
  net: xfrm: convert tasklets to use new tasklet_setup() API

 net/dccp/timer.c           | 10 +++++-----
 net/ipv4/tcp_output.c      |  8 +++-----
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/main.c        | 14 +++++---------
 net/mac80211/tx.c          |  5 +++--
 net/mac80211/util.c        |  5 +++--
 net/mac802154/main.c       |  8 +++-----
 net/rds/ib_cm.c            | 14 ++++++--------
 net/sched/sch_atm.c        |  9 +++++----
 net/smc/smc_cdc.c          |  6 +++---
 net/smc/smc_wr.c           | 14 ++++++--------
 net/xfrm/xfrm_input.c      |  7 +++----
 12 files changed, 47 insertions(+), 57 deletions(-)

-- 
2.17.1

