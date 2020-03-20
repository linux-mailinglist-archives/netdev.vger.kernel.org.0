Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B414918C565
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgCTCjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:39:20 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39199 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCTCjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:39:20 -0400
Received: by mail-qt1-f196.google.com with SMTP id f20so3805511qtq.6
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEkXapvEJ+bJFis1hmu0ftP/FWnxnwq4odyzzKW3M1Q=;
        b=P1F9cBY5Qop0dl68Vm1xV8gtUHfq0NMQmnvE3Hc5k392C6zRI3a9zmvlKJDapebK3j
         atzy50mY9uemuCRQQftW0r+TYIn/0SbbFRSwgzgB2xHFwZQF9Yf2vHByCvrESzh/39IQ
         MZyn7GkgVvHv3aKYYBxn1tgWWwIbeiebaachd7ltPiRB+ZQ4QY7L76pcwKwPFNkhRowI
         fw6xCZg21UhZkqOjBq9Gnb5GETz3LhSgTd13LdXdqjH/xkemNsnWHX3AYyEBPaIioItJ
         v75kzM1G54sCJ3X5zbfq2IOKLGSZrsNOHD2CSa+rY+CoqWD7vTAnORP0MeRO9u5+auZE
         qQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEkXapvEJ+bJFis1hmu0ftP/FWnxnwq4odyzzKW3M1Q=;
        b=ZujzFlmWjclIGZOAAlOeHIoh69uhcwxAF9QIlbUY3XKAD538/bBJ7vGaPurqIzrt/J
         m4Po+y1pWeANlfrlKgtrK59xofxoshtFp5oVRwEZIQsp2ra7oqySD9GAMuEtqc/dxurH
         lSJSg/PxrQjsErCfSv6v7m4w2XxHEDn/s8fojSNSWn9moKCoGge8MhY+bVqh3OkMFHVh
         XzcMTzPSzhImFHP1XfMnwnTZ5KO28+JVuOUXaF4XgQ6N3/l1/uZiPUEHsQW4aX/IAxLq
         Qu+F7Sl43+sreNL3q5akH8Fz+MHbc6niZ4Z8AzzdInve1TLKBt59zSuqffLNY7sATBXv
         zNaA==
X-Gm-Message-State: ANhLgQ2smXUyboDxqP+8cVWMh8p+KO0oyQh/Y8TZ57cNCSsWDh/OywkY
        qo8/GKrkfnrtSKZhaODGrnE=
X-Google-Smtp-Source: ADFU+vvIOVutWV9uj7yrZ2SZ6yMuBr77Asv4KKq2GTdXQYCz4xgA5C+Kx4nr7uQl+cxmWgQlHcWrOg==
X-Received: by 2002:ac8:5493:: with SMTP id h19mr6134365qtq.151.1584671959014;
        Thu, 19 Mar 2020 19:39:19 -0700 (PDT)
Received: from localhost.localdomain (69-196-128-153.dsl.teksavvy.com. [69.196.128.153])
        by smtp.gmail.com with ESMTPSA id d9sm2979465qth.34.2020.03.19.19.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 19:39:18 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCHv2 net-next 0/5] net: ipv6: add rpl source routing
Date:   Thu, 19 Mar 2020 22:38:56 -0400
Message-Id: <20200320023901.31129-1-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

This patch series will add handling for RPL source routing handling
and insertion (implement as lwtunnel)! I did an example prototype
implementation in rpld for using this implementation in non-storing mode:

https://github.com/linux-wpan/rpld/tree/nonstoring_mode

I will also present a talk at netdev about it:

https://netdevconf.info/0x14/session.html?talk-extend-segment-routing-for-RPL

In receive handling I add handling for IPIP encapsulation as RFC6554
describes it as possible. For reasons I didn't implemented it yet for
generating such packets because I am not really sure how/when this
should happen. So far I understand there exists a draft yet which
describes the cases (inclusive a Hop-by-Hop option which we also not
support yet).

https://tools.ietf.org/html/draft-ietf-roll-useofrplinfo-35

This is just the beginning to start implementation everything for yet,
step by step. It works for my use cases yet to have it running on a
6LOWPAN _only_ network.

I have some patches for iproute2 as well.

A sidenote: I check on local addresses if they are part of segment
routes, this is just to avoid stupid settings. A use can add addresses
afterwards what I cannot control anymore but then it's users fault to
make such thing. The receive handling checks for this as well which is
required by RFC6554, so the next hops or when it comes back should drop
it anyway.

To make this possible I added functionality to pass the net structure to
the build_state of lwtunnel (I hope I caught all lwtunnels).

Another sidenote: I set the headroom value to 0 as I figured out it will
break on interfaces with IPv6 min mtu if set to non zero for tunnels on
L3.

- Alex

changes since v2:
 - add additional segdata length in lwtunnel build_state
 - fix build_state patch by not catching one inline noop function
   if LWTUNNEL is disabled

Alexander Aring (5):
  include: uapi: linux: add rpl sr header definition
  addrconf: add functionality to check on rpl requirements
  net: ipv6: add support for rpl sr exthdr
  net: add net available in build_state
  net: ipv6: add rpl sr tunnel

 include/linux/ipv6.h              |   1 +
 include/net/addrconf.h            |   3 +
 include/net/ip_fib.h              |   5 +-
 include/net/lwtunnel.h            |   6 +-
 include/net/rpl.h                 |  46 ++++
 include/uapi/linux/ipv6.h         |   2 +
 include/uapi/linux/lwtunnel.h     |   1 +
 include/uapi/linux/rpl.h          |  48 ++++
 include/uapi/linux/rpl_iptunnel.h |  21 ++
 net/core/lwt_bpf.c                |   2 +-
 net/core/lwtunnel.c               |   6 +-
 net/ipv4/fib_lookup.h             |   2 +-
 net/ipv4/fib_semantics.c          |  22 +-
 net/ipv4/fib_trie.c               |   2 +-
 net/ipv4/ip_tunnel_core.c         |   4 +-
 net/ipv6/Kconfig                  |  10 +
 net/ipv6/Makefile                 |   3 +-
 net/ipv6/addrconf.c               |  63 +++++
 net/ipv6/af_inet6.c               |   7 +
 net/ipv6/exthdrs.c                | 201 +++++++++++++++-
 net/ipv6/ila/ila_lwt.c            |   2 +-
 net/ipv6/route.c                  |   2 +-
 net/ipv6/rpl.c                    | 123 ++++++++++
 net/ipv6/rpl_iptunnel.c           | 380 ++++++++++++++++++++++++++++++
 net/ipv6/seg6_iptunnel.c          |   2 +-
 net/ipv6/seg6_local.c             |   5 +-
 net/mpls/mpls_iptunnel.c          |   2 +-
 27 files changed, 940 insertions(+), 31 deletions(-)
 create mode 100644 include/net/rpl.h
 create mode 100644 include/uapi/linux/rpl.h
 create mode 100644 include/uapi/linux/rpl_iptunnel.h
 create mode 100644 net/ipv6/rpl.c
 create mode 100644 net/ipv6/rpl_iptunnel.c

-- 
2.20.1

