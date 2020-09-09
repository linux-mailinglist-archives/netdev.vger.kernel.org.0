Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6879A262A3D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIII1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgIII1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:27:44 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D650EC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:27:43 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id g1so1264182qtc.22
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=yRE3fIcUYviNrW1rvrVhLf2lyWpk2aadxVQcBuiEOD8=;
        b=MaR8GzbZ3LPxgQDYfuUiyvpx7rSr+8ngXZiZ95Ucd4i087Qe+LkicMGpg+RT/r89xJ
         IoddHLZywkZkAq2rwp7SkxdrHZAPz8DluixBpvUdwlyF/w4iRS9oeKUnUx26OMAdVqBK
         gzlpmUo9CkDbpHZcGiQSZ8Xc0pb2wY2ZJwrGEr4ASjfpzZcn2iWr6Zye7vEklnNegIEj
         F3Q6qD2qmpZsXwHjyldHYknwRMzC5HZRjiofOtapvKiMibFeVVAaRL/bbf749MlHY/9p
         8Msk5uYrB2CV1RfI5xpEin4vPyL8lgHgymCGvNdm0/2rhUqee8pDwLQEoyR/5hV5MjgL
         /u3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=yRE3fIcUYviNrW1rvrVhLf2lyWpk2aadxVQcBuiEOD8=;
        b=QMJl44UX/PbnLgvZRhJ8M0JgJ0ktL/ILRWRMdhD78mmrXtALnbztNcABcLZfvMyiap
         htpzLolKKo32UeFCdcnTXLK6GerHkxYSDspeTMiOdJFEW+EBrUW1JxuyzHxx6COs1/sJ
         UwWLCZstQ4fhqwZe/XO9tAS8k7L4FaP2JtWzh+3lht+L/ggzD4eJ7+oKfYFH5pESloiL
         i+TUc6pC0ziYs/5b2r74EuuP4nizerHfnV8fXJVAkd6nlIZCvkqXZ7zxG4wRnOpla8o1
         wRKQygyz4OOeJHrHXQVViIcw2aTMVDDnpJjkNddYkxyQesfOH+cjM/rj5ZhuIX+rAvnt
         Myew==
X-Gm-Message-State: AOAM5330giWEDi7ygillSEfRhDxbHMzWAMwAgM1Basow9qRdeZyBrAjn
        b+Y0BpUMTUpG6PeWehYXH3jPQXqjnk4reg==
X-Google-Smtp-Source: ABdhPJyC2278IQRVutMs3IhSDh2fUF2ZeEuJpxj6mvMNaIER7b4XLaf8Hwm9KisRji0WZgn5KK6AOixRVw9GZA==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a0c:a9d6:: with SMTP id
 c22mr3081297qvb.102.1599640063001; Wed, 09 Sep 2020 01:27:43 -0700 (PDT)
Date:   Wed,  9 Sep 2020 01:27:38 -0700
Message-Id: <20200909082740.204752-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net 0/2] net: skb_put_padto() fixes
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sysbot reported a bug in qrtr leading to use-after-free.

First patch fixes the issue.

Second patch addes __must_check attribute to avoid similar
issues in the future.

Eric Dumazet (2):
  net: qrtr: check skb_put_padto() return value
  net: add __must_check to skb_put_padto()

 include/linux/skbuff.h |  7 ++++---
 net/qrtr/qrtr.c        | 21 +++++++++++----------
 2 files changed, 15 insertions(+), 13 deletions(-)

-- 
2.28.0.526.ge36021eeef-goog

