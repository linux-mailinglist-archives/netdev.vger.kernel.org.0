Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781CC24C441
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730530AbgHTRL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730497AbgHTRLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:11:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6FBC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:11:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k11so3031419ybp.1
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=O8CXOCLTqngUZS4W/lakq6RernfPrBHkn2aLsZzKxQE=;
        b=idKLLEe9Pgx+yx3x2ZSIEUGLBCYq9ZEIywrQSThfohzxd1GIafZ/Po+FEnpMr3EThH
         TWRfD91keKS/LzktSGZOSwQhJxYKDJgZGAT2LBXsjqMro5k5uT/KXHqYXZMsi+9idEp6
         KNlTcqzlzkRzvzV1hlJuhUnBcMcYyF8HDPkPmqvutcZnlS0DdeIQ+JzrgBUOHU9BT4Xd
         iJsdaQ64gwzuWfvmhMz+j2Poai8ZUoA30m9ikGuPWzGfb44jXSbuBm41mcUNQF1V4mm+
         hZF2ZVucEHKSciedjIgVWnxBZzZKZKWM7t+B2GIieS7gt+h2QF+D1VM1EP3fuibCVoxY
         R4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=O8CXOCLTqngUZS4W/lakq6RernfPrBHkn2aLsZzKxQE=;
        b=eLBsyfAg66deQoCxMpS+SiiRO+bBLYXdzhTXufmZ4uamMsBXRZPl+fOFrOzrr6loqv
         tC6CoEYImdr9tOGR9q0sbsqAJ3z+Si2sbuw/bYuzZP04PNwJ9cAvld2+xgUiD0qtiBWD
         P0fMJSwdQQ6MwIgAubAxaq41E2bFsQ2QRJWbbom2tNCYlLFyjMnKVPxzkWKxA80d9dQ/
         NHJwwD0pr9xFea5OekNbe2y9wTIDw5INeS42crhFkfkydgLU+qGNlrhcpeOoNGRMtxkX
         G73G+yHMyWF582b89jbBRyZsdBsPHPB0gu/Opvq8zJbCsIYWeV+jJ+q3r7kI7E+hLRa/
         dMug==
X-Gm-Message-State: AOAM530PztQtZwp1uAvHcKVnMMuyHzdiv6IQYmPGV/dBuuytPb9GcfPf
        kYbjQ7mWKWcf/f/w1/w9icv/uA2OLJdrpQ==
X-Google-Smtp-Source: ABdhPJw6tI0WjwLxz5RV34gGVOwidrarPg5wIfgv/eTogxbLgZqTCLJ1FqGqcp2zqc05euQUqPqWCZBnOEjBaw==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a25:ae5e:: with SMTP id
 g30mr4217004ybe.24.1597943482140; Thu, 20 Aug 2020 10:11:22 -0700 (PDT)
Date:   Thu, 20 Aug 2020 10:11:15 -0700
Message-Id: <20200820171118.1822853-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH net-next 0/3] tcp_mmap: optmizations
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series updates tcp_mmap reference tool to use best pratices.

First patch is using madvise(MADV_DONTNEED) to decrease pressure
on the socket lock.

Last patches try to use huge pages when available.

Eric Dumazet (3):
  selftests: net: tcp_mmap: use madvise(MADV_DONTNEED)
  selftests: net: tcp_mmap: Use huge pages in send path
  selftests: net: tcp_mmap: Use huge pages in receive path

 tools/testing/selftests/net/tcp_mmap.c | 42 +++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 7 deletions(-)

-- 
2.28.0.297.g1956fa8f8d-goog

