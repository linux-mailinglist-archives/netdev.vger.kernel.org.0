Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F97161D60
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgBQWgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:36:50 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:37262 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgBQWgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:36:50 -0500
Received: by mail-qv1-f65.google.com with SMTP id m5so8298562qvv.4
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PejQKB3TNMDuFjWyr7grtYQLcEwc7UTLFUaTUi8fuIw=;
        b=RP5JOOlTF5AyC7mb5PsqeSestWMXIWI8Vnnh150adup6NCpGo74vuCLmiRUczaW5b1
         RjaQVcGg252x4RXCtgDafb6WayguJhBs9g0Rl6oLGZkOjlEMV5IuZzCuFP00K2YTiG6A
         Tc/WYrO+lrpT6X3OisWkFwyC6oJO0UGytwqr7pHOcPUz90qS/hnSQAZLHTUOnFCLoBkX
         7g6McfaGH1Cn7cT2gO4cOJL4vUVsqjLHAwrJk/K4f8/yPbQazobnp/3QTzBUqGWn4yTW
         8lvOzl+J7J4nsxYhS1CGPP8Pjcl1ZdI70qeoUOaa/AHf6/XAeSVy91ofA/n9CHVJHeRT
         gRnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PejQKB3TNMDuFjWyr7grtYQLcEwc7UTLFUaTUi8fuIw=;
        b=IxnzSyt7IT3FM8cW6L9+3/GjSdxIfaeOVGhs9siawmRJlBYID5WCyeS2tylcDfOFR2
         0yKLqfxX2TCjEiv390/ZvsUaLoRigepGk08QbcQmVxv5BAnnzMn9q8AQINIhVnbqdv5M
         m4as4SdZj8gomg1frWa/VtTzVP+7yJYDdnrhRpuSvBkJk63mzjClb9sYTC+DwcIag+0T
         RRKnNxQAYYG3KRjKzpIk+iIVYxkWT7zx6FU9FUnDq1pxRAgpo1rHxTFL+gNDGcLu96D+
         +q8GKRm/bT3YcvH1NnyCF7QS3GX2QN7zZrAZYKkoTBxJMhsIzU44gCzPDz+5z6YLhmDV
         oEtg==
X-Gm-Message-State: APjAAAWmGniels5G45Zz+O62eWv728NWnXkYLg/6rWNR3tgn77MFx6q+
        g3EY4PC//1DAS9OHSoSP1/8=
X-Google-Smtp-Source: APXvYqyQwBVh71gkkfD9WwB22JEk/i+Sc/ZUCWabxi8o73VtdH8Och/HM1Mm2lKrl9Pt3eLDaBDMcA==
X-Received: by 2002:a0c:e8cd:: with SMTP id m13mr14625661qvo.102.1581979009125;
        Mon, 17 Feb 2020 14:36:49 -0800 (PST)
Received: from localhost.localdomain ([216.154.21.195])
        by smtp.gmail.com with ESMTPSA id a2sm964031qka.75.2020.02.17.14.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:36:48 -0800 (PST)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PACTH net-next 0/5] net: ipv6: add rpl source routing
Date:   Mon, 17 Feb 2020 17:35:36 -0500
Message-Id: <20200217223541.18862-1-alex.aring@gmail.com>
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

Alexander Aring (5):
  include: uapi: linux: add rpl sr header definition
  addrconf: add functionality to check on rpl requirements
  net: ipv6: add support for rpl sr exthdr
  net: add net available in build_state
  net: ipv6: add rpl sr tunnel

 include/linux/ipv6.h              |   1 +
 include/net/addrconf.h            |   3 +
 include/net/ip_fib.h              |   5 +-
 include/net/lwtunnel.h            |   4 +-
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
 net/ipv6/rpl_iptunnel.c           | 375 ++++++++++++++++++++++++++++++
 net/ipv6/seg6_iptunnel.c          |   2 +-
 net/ipv6/seg6_local.c             |   5 +-
 net/mpls/mpls_iptunnel.c          |   2 +-
 27 files changed, 934 insertions(+), 30 deletions(-)
 create mode 100644 include/net/rpl.h
 create mode 100644 include/uapi/linux/rpl.h
 create mode 100644 include/uapi/linux/rpl_iptunnel.h
 create mode 100644 net/ipv6/rpl.c
 create mode 100644 net/ipv6/rpl_iptunnel.c

-- 
2.20.1

