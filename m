Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D06F11D82F
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 21:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbfLLUzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 15:55:41 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:55684 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730860AbfLLUzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 15:55:40 -0500
Received: by mail-pj1-f74.google.com with SMTP id e7so103600pjt.22
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 12:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lcu+XBlazISW9Ha+P8a6hKyT894dJ4fC/BtrAAGAtZQ=;
        b=pJTG96umM9VU1pl/7wVCyvjkAyX8W29aWjT8GUh3xQ6yx6wDS/0Z7GHvhDGMKiWX53
         7pFU0H7e4Kqn46F9uKIi7+AYrFkUwKGdY7yBwntKJ9v0Gd/vIv1O5oTtOvPeIQaEnVov
         lkIcOO2FIJsWsv6eoC/jjRchjlfcZFvon2Vfb6fiBEdAF5bTpwyZMvpX1yL+wLj06LTm
         WxE4o5GLDJMljg5F0phRWN+ZeQFUCnHbM+o1MzUNt3u4B6eAIZWg1C+A75xtNDmU7L9l
         RT6Qb1ahOZdw52bXNLcPtv8eD7GEoireFcDhyfyI2E1KiP6JVskMt7ghcTBf8blzQelE
         yjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lcu+XBlazISW9Ha+P8a6hKyT894dJ4fC/BtrAAGAtZQ=;
        b=tFglpPxjyJrDLFwm4ag0sgV3YbolTJxjCcB40SxzWIC5QPeOJ7RCXtagghDyqtVtKK
         I93bq6nqxFgJQ1XibCL6xjbeo96KMTy4zMJtnkwlJTzl9gfyjaXNOUVMMiNdL88An8Zm
         n/HYaPmJXbG938MMfFSoCgDHfm3LG6iQNcXPTBIAgwlpZ47XdaVDKeeyCJqhEDIhQxrA
         WzhbI9yb0Of7Qyo/C5RaklBrgizF0NAjvxlF43f5LZpNy6gL3uN9cDwVWRr+kQRy2o5z
         S+DSysIJD8nuZIxcD2pC1c4cfGKYud3h7DgXcKQFlRN+WRVR22USqzgS0JSYn+j4blb0
         uQ9Q==
X-Gm-Message-State: APjAAAWuCTHjI8OqRdpGPJLeXcb/J7lKvFh+o0mv6im+xE7Zri7k42t/
        s8/hRkMuIP1ir0wja8cTWMwGj4CKRe58Yg==
X-Google-Smtp-Source: APXvYqwlGrFtMlT9ITB37Bi3MxY1JuSNkJGoH78oMjBFJQucPkqXrKj4KMYRhzbu783MXFoPbjpCn+RwXgVCdA==
X-Received: by 2002:a63:31cf:: with SMTP id x198mr12560933pgx.272.1576184140174;
 Thu, 12 Dec 2019 12:55:40 -0800 (PST)
Date:   Thu, 12 Dec 2019 12:55:28 -0800
Message-Id: <20191212205531.213908-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net 0/3] tcp: take care of empty skbs in write queue
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We understood recently that TCP sockets could have an empty
skb at the tail of the write queue, leading to various problems.

This patch series :

1) Make sure we do not send an empty packet since this
   was unintended and causing crashes in old kernels.

2) Change tcp_write_queue_empty() to not be fooled by
   the presence of an empty skb.

3) Fix a bug that could trigger suboptimal epoll()
   application behavior under memory pressure.

Eric Dumazet (3):
  tcp: do not send empty skb from tcp_write_xmit()
  tcp: refine tcp_write_queue_empty() implementation
  tcp: refine rule to allow EPOLLOUT generation under mem pressure

 include/net/tcp.h     | 11 ++++++++++-
 net/ipv4/tcp.c        |  6 ++----
 net/ipv4/tcp_output.c | 13 +++++++++++--
 3 files changed, 23 insertions(+), 7 deletions(-)

-- 
2.24.1.735.g03f4e72817-goog

