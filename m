Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0636ABCAC8
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409834AbfIXPCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:02:16 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:37272 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390653AbfIXPB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:01:27 -0400
Received: by mail-pl1-f202.google.com with SMTP id p15so1292174plq.4
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 08:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=01AXZ38tu1NT4EO77NDZ61ZIvuNBSjHhHKN6cfv6xd0=;
        b=tZ8mSpGuwdggtd6bIONUeTvImhaoq2h5bHvDda5NExjbQqsmgnErU7FBaSRffBiR8G
         koGdU6ujs2Wp1AsCDXj8BVdrz2RyjsvTgSzIlpdPph3oEscxju2aoNmFKVxLFKs5LigK
         RVabl4Ar4p68x1l3fyGwqWqAAjA6KSH52w1nuDF+GXAF3d0zgf1QqVI3TGYVWZWPodup
         A8aUtgoYojCwPpEWU6YtPhopFUfRz7Kdz9m1oAFUQPL6cGWJX1BjkMG4WoKX4jSO8fXO
         Yt3/jmqdirSDZn9sO9ujwedzDviRQUvjG5NZMWRvAbbhYEEV7whZYWCVmeqtcCL8sm1I
         /22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=01AXZ38tu1NT4EO77NDZ61ZIvuNBSjHhHKN6cfv6xd0=;
        b=DwCfRXQaVi8VIoVrosqkPiq9UcPsCmdrIuVeBib2jcQwEUT0gR9jCBYQLNYOjAPYd6
         YUjtrRUKz6yt7b5kkm0Naf6DvQNffyLcqGyBK+neTfeWUKSDbUfjIR+7ISFD+3kez6BJ
         LOXLinb247Au58ZeYxxK592Lu9lQq9pbYH/iOoo6o2WyPCJunxkyLxat1g4Yt4gXzO5a
         MgQ1yoFI73Nru+6L9lqGpnEeyi0Pv3Mlls/T1A5Su6e9+LpB2ezOfXDHbCEk1QgeAvix
         eghbAvTJ4RZ7mJuUH+Js6le202/55vl7pu0C9e2mlmsbpsrRqXURuBfXf4fpBAlYa6XH
         PfuA==
X-Gm-Message-State: APjAAAWC5QQahYxG927X9rSbOHVRRLliXQvxcZd865m5wQRp1jXRfkJH
        RNin3tA/ejsHPHGD77IKYcnO/mVfTR1Wzw==
X-Google-Smtp-Source: APXvYqx8jB1EiSL/7LrP9dgp9vbSElFj0+xWkWix0Lo3MFEe8lOhA9ATHMkkC7WuNgse1xc3u6/7rac6KLu+CA==
X-Received: by 2002:a65:4782:: with SMTP id e2mr3292784pgs.402.1569337284707;
 Tue, 24 Sep 2019 08:01:24 -0700 (PDT)
Date:   Tue, 24 Sep 2019 08:01:13 -0700
Message-Id: <20190924150116.199028-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH net 0/3] tcp: provide correct skb->priority
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

SO_PRIORITY socket option requests TCP egress packets
to contain a user provided value.

TCP manages to send most packets with the requested values,
notably for TCP_ESTABLISHED state, but fails to do so for
few packets.

These packets are control packets sent on behalf
of SYN_RECV or TIME_WAIT states.

Note that to test this with packetdrill, it is a bit
of a hassle, since packetdrill can not verify priority
of egress packets, other than indirect observations,
using for example sch_prio on its tunnel device.

The bad skb priorities cause problems for GCP,
as this field is one of the keys used in routing.

Eric Dumazet (3):
  ipv6: add priority parameter to ip6_xmit()
  ipv6: tcp: provide sk->sk_priority to ctl packets
  tcp: honor SO_PRIORITY in TIME_WAIT state

 include/net/inet_timewait_sock.h |  1 +
 include/net/ipv6.h               |  2 +-
 net/dccp/ipv6.c                  |  5 +++--
 net/ipv4/ip_output.c             |  1 -
 net/ipv4/tcp_ipv4.c              |  4 ++++
 net/ipv4/tcp_minisocks.c         |  1 +
 net/ipv6/inet6_connection_sock.c |  2 +-
 net/ipv6/ip6_output.c            |  4 ++--
 net/ipv6/tcp_ipv6.c              | 24 +++++++++++++++---------
 net/sctp/ipv6.c                  |  2 +-
 10 files changed, 29 insertions(+), 17 deletions(-)

-- 
2.23.0.351.gc4317032e6-goog

