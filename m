Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2082F201AF9
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732885AbgFSTMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgFSTMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:12:39 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56840C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:12:38 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id o24so6031647qkm.22
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5sp9eeFUa8v8cu3Q9iKUjTQx7wecqVwwHJetKNMVbDY=;
        b=GKguu4Yw6IgNhUDYoiP+tYtbvhmQRfU2COiBlGdYYp3uCmS74oWltSLqlY8I65VqQv
         YD2Bf3rIsV8yjawNm5lPtEC481PfmO1rrHduPpTO0tgr7D0mgT+n+aIunvkSJ0U/kvbh
         j9I6DKQpL8nmu7fbUP1RFTT1ymAvLMsoAdEoqxvi7xa9IpY3YiywXsUPouB+gnOM0cRj
         wDkl7N5Xt55aNRNVlluAFV6TAfS2dKPBcuGsGMo9qi+wB80/u2SU0/d9LDo4vtqb4YbI
         SFxqetGNxfa5knlb9A5RzZf5vFWB0sZ/0M3SrJclfoNwspSAP2BwijrEjr2/sa5B5mhO
         SbRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5sp9eeFUa8v8cu3Q9iKUjTQx7wecqVwwHJetKNMVbDY=;
        b=QF7YrscsgNWeHmY3RBxpYkzbkiFQz0RDsnbNFGPB7lAxwVK/kJV8x3jSZOIlxr+JWd
         TIoN604CR9b9rRklbFz3oQh9qFdSun2Slk39/8RqHR04CWqUtRCLGtVP4iSclveQnN4d
         zwGHtU3GDDMpspZxFoq5o8oIyVJAebPUnbXlbjSYtu4OH1+PtB9nEdC665JkJhPvltPd
         7Yj/4RyzWBScmHA0dBlXbipYRwN6tefCGo0uzuD+DQyjJx/IpzhbXidusA9OhluTa9Hs
         BvNzi4ZtVGD2klFZ5UX7uiNs0yGHyS5twTtQFu0+b7TXucQyBwPykj9w81dIrkBNlwbT
         qoCQ==
X-Gm-Message-State: AOAM532XbmGky3Q4JYzQW3wwJ6zqgYJR19XV3C2G1Sryr1gUWPEsUdoQ
        xk/Epu9i5cj7EmsT7YMivZ0Y6skhXwzkvg==
X-Google-Smtp-Source: ABdhPJwl1oUJ0Cp0oyasZXAKkzTf1DEnOOepYjNq3O8AIZm8X/aPC7uJT//7JDHnxtEJM0hGd44iFi/xPg4aXw==
X-Received: by 2002:ad4:4368:: with SMTP id u8mr10160921qvt.227.1592593957500;
 Fri, 19 Jun 2020 12:12:37 -0700 (PDT)
Date:   Fri, 19 Jun 2020 12:12:33 -0700
Message-Id: <20200619191235.199506-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 0/2] tcp: remove two indirect calls from xmit path
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__tcp_transmit_skb() does two indirect calls per packet, lets get rid
of them.

Eric Dumazet (2):
  tcp: remove indirect calls for icsk->icsk_af_ops->queue_xmit
  tcp: remove indirect calls for icsk->icsk_af_ops->send_check

 include/net/ip.h           |  6 +-----
 include/net/ip6_checksum.h |  9 ---------
 include/net/tcp.h          |  4 ++++
 net/ipv4/ip_output.c       |  6 ++++++
 net/ipv4/tcp_output.c      | 12 ++++++++++--
 net/ipv6/tcp_ipv6.c        |  7 +++++++
 6 files changed, 28 insertions(+), 16 deletions(-)

-- 
2.27.0.111.gc72c7da667-goog

