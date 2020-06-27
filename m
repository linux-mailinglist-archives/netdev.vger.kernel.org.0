Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C8520BE08
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 06:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgF0EFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 00:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgF0EFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 00:05:40 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51D5C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:05:39 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d10so1617327pfn.21
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=b2FbMeX0oeKVQWk240qmtNThwo74ruzp8Yu40New/Xs=;
        b=H875K5xA/7G1m/2uz0rCKYanuosnO82Ow22s3zYsCKHDy1b2Fp+ut+abrzIv9Ik/h3
         QWHNIUb1aax63HHQEVSJjnEu2zXScELLTYw+vFPk9QoiejL8G7TGDVj0w83psptWA6PC
         y3ItZK4+pTFwkTdzEAkxxvLKtt+xpnVRa1qcQoDPEqmoftu/TqIJigQq1FR4BzodpTem
         eWxqfD3/4Xq/mLY5e696ruu0NCH8bljxfP7hk9pvKmO6/F3jFkGM31ES+RPrkDu8x0pq
         aDzsw78mfwQZgKKSN8Iq0KLlK/Ax5XX1GNSOI6Ksc53cGxd8mzetRQMDqO6hZ4FxtwLP
         oUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=b2FbMeX0oeKVQWk240qmtNThwo74ruzp8Yu40New/Xs=;
        b=olTuUYnRi6rjjRgDCwszk+tSmseFx7/b6rqRseZjj6Rx57wtUyKD2A1La2Tvkxw1qf
         zRUstD8NE+MkE9JEM0WSMGf+D9A7Wh4rXfy27duKk8p3acaxLerBcvPe1ixEcu84RcJa
         0GpqBs5080azMCDILl4XBu4g3EvJNGETPHiMl0RiDP4nU6W6CqGbLyNOZqltiwC6OHmi
         xR1X+7dcA0gEfNda4G8qSfmLzA6XXD881y+q9tYyogjsa6DWIWT3pzzaQvsMjkQc7hLA
         FXPvJeCY7WhYuZNHsX9qwNo6PptCy3ntwLpiSkkt/hXdGcBwyVXcWK800a+rw7iqRnxI
         VB/A==
X-Gm-Message-State: AOAM533ROI3MpGrDqn9j/28B/+lkhncyChpscpo0HcvIpF7b4sPS7/0z
        wr8Xnu8BzVyT6vLrJZlKtwtFV/iPufCQ
X-Google-Smtp-Source: ABdhPJzstm7cW+7JwPGFmUdsGPeOPI8L/WWWgDYpswK6ivjyxuJX4A6YKKPyG7RElPQTUtP5BCp+uF1xy4dZ
X-Received: by 2002:a63:4b44:: with SMTP id k4mr1792004pgl.305.1593230738269;
 Fri, 26 Jun 2020 21:05:38 -0700 (PDT)
Date:   Fri, 26 Jun 2020 21:05:31 -0700
Message-Id: <20200627040535.858564-1-ysseung@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net-next 0/4] tcp: improve delivered counts in SCM_TSTAMP_ACK
From:   Yousuk Seung <ysseung@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yousuk Seung <ysseung@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently delivered and delivered_ce in OPT_STATS of SCM_TSTAMP_ACK do
not fully reflect the current ack being timestamped. Also they are not
in sync as the delivered count includes packets being sacked and some of
cumulatively acked but delivered_ce includes none.

This patch series updates tp->delivered and tp->delivered_ce together to
keep them in sync. It also moves generating SCM_TSTAMP_ACK to later in
tcp_clean_rtx_queue() to reflect packets being cumulatively acked up
until the current skb for sack-enabled connections.

Yousuk Seung (4):
  tcp: stamp SCM_TSTAMP_ACK later in tcp_clean_rtx_queue()
  tcp: add ece_ack flag to reno sack functions
  tcp: count sacked packets in tcp_sacktag_state
  tcp: update delivered_ce with delivered

 net/ipv4/tcp_input.c | 59 +++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 20 deletions(-)

-- 
2.27.0.212.ge8ba1cc988-goog

