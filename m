Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DB51B958A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 05:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgD0Dla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 23:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726349AbgD0Dla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 23:41:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1CBC061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 20:41:30 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d17so8080581pgo.0
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 20:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=AACr2MGao4lBAbKNVG0Dck3oP0uyjA9wKEMNQvyO9MA=;
        b=IcRBVG8/u7Tyere711Nf2yj+LAyigtUCBlRXdiPJb8c7aZl4sRPOGJkuVgWctr6ChQ
         ajIFujRGarHQWM21nG3cy5Un01Hlz8YF7+qK88O0wkcNJdCGfzWv/WaFNbl8vJi8gg8r
         dS7CUS2d/sq3RioalGZC5C2vvfjTTOMhfmKyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AACr2MGao4lBAbKNVG0Dck3oP0uyjA9wKEMNQvyO9MA=;
        b=TJYJ2i6zGzXnDBzxQSnK03hO0q1QxvTIN7IKoJvyVACLHFm27EIXAkThbUAYhmQwF9
         5E9vPhZyRG7xi7hU+f1QgeY/IdPzQZhdutw9B4w+9QaK4rMtbsuTk2XlcWSlekNZ+HLE
         DS9N+cPo/Wl6j8nnK6qa+wKFmTSalADLzIGMN3lZj7vXcng5pryfxTSl8f5WjPrvoUCj
         +pN6RDPEJIYqyWQ/Ss6Jk91mg5IjvTFq3PQbyGsQyi63hMcaaM3X5WF/doyt9iLmtDGV
         uO6yp3cf0qYApIf/e0QXSVNEwrg66aaM5fYldz9kErIfqzf1TAKc7dMk3CqGkhXr+B9r
         egRg==
X-Gm-Message-State: AGi0PubLxrWPB8jndFXx7VEXn6bRmf/NTENH9O7poW9dvMhiXaH9c7/U
        kfJfFAdMGUa+N7Fopbr2Nxph0w==
X-Google-Smtp-Source: APiQypKKZlquc9mwCuP0IAY/fiXWO0okFreqZI/HfzVEJcj0Do5ZcfvHcXYJbvF9pqy06ZqkrC5MIw==
X-Received: by 2002:a62:7ece:: with SMTP id z197mr23136354pfc.244.1587958889432;
        Sun, 26 Apr 2020 20:41:29 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id 6sm11200858pfj.123.2020.04.26.20.41.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 20:41:28 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
Subject: [PATCH net-next v3 0/3] New sysctl to turn off nexthop API compat mode
Date:   Sun, 26 Apr 2020 20:41:22 -0700
Message-Id: <1587958885-29540-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

Currently route nexthop API maintains user space compatibility
with old route API by default. Dumps and netlink notifications
support both new and old API format. In systems which have
moved to the new API, this compatibility mode cancels some
of the performance benefits provided by the new nexthop API.
    
This patch adds new sysctl nexthop_compat_mode which is on
by default but provides the ability to turn off compatibility
mode allowing systems to run entirely with the new routing
API if they wish to. Old route API behaviour and support is
not modified by this sysctl

v3: 
	- Document new sysctl
	- move sysctl to use proc_dointvec_minmax with 0 and 1 values
	- selftest: remove pref medium in ipv6 test

v2:
       - Incorporate David Aherns pointers on covering dumps and
         nexthop deletes. Also use one ipv4 sysctl to cover
         both ipv4 and ipv6 (I see it is done that way for many
         others)
       - Added a selftest to cover dump and notfications for nexthop
	 api compat mode

Roopa Prabhu (3):
  net: ipv6: new arg skip_notify to ip6_rt_del
  net: ipv4: add sysctl for nexthop api compatibility mode
  selftests: net: add new testcases for nexthop API compat mode sysctl

 Documentation/networking/ip-sysctl.txt      |  14 ++
 include/net/ip6_route.h                     |   2 +-
 include/net/ipv6_stubs.h                    |   2 +-
 include/net/netns/ipv4.h                    |   2 +
 net/ipv4/af_inet.c                          |   1 +
 net/ipv4/fib_semantics.c                    |   3 +
 net/ipv4/nexthop.c                          |   5 +-
 net/ipv4/sysctl_net_ipv4.c                  |   9 ++
 net/ipv6/addrconf.c                         |  12 +-
 net/ipv6/addrconf_core.c                    |   3 +-
 net/ipv6/anycast.c                          |   4 +-
 net/ipv6/ndisc.c                            |   2 +-
 net/ipv6/route.c                            |  14 +-
 tools/testing/selftests/net/fib_nexthops.sh | 198 +++++++++++++++++++++++++++-
 14 files changed, 250 insertions(+), 21 deletions(-)

-- 
2.1.4

