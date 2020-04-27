Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560C51BAFD0
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgD0U4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD0U4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:56:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3013C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:56:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so149083pjb.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Vd7lbo+APjeMiVa38cT/Njf//dKlMw+4/TEoWbGCVEg=;
        b=hehimztGjNLGOPYsmYHKOszUAFb5VxHsGfHShDZG3MZXGF3PyzEXkNT3jk4JsrJrq4
         QdI+lPv+2EIRrQrPM+Wvz58YQ3u6rI/olPMwKUxvRbpCkjvtP386if8JGcuvlUytm1cm
         UosUSeh7CiARBH+y97IfjJqt9/46dHkGjbRNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vd7lbo+APjeMiVa38cT/Njf//dKlMw+4/TEoWbGCVEg=;
        b=i7Mu6VVq/TH1BrPAI2wjbsS41nV4t/nGFxtgEs8vodxwYd191kaQkrCB6zV5/qB+4A
         SOJO4Hnjhydl8ILgakBNvlDEOxbVejeIbRDtnXR6dA19pOzSevqw2ey1sa7lFz5AdGu1
         3JTpO/cJblv7F+RItc+vB9gCchzoP1IYeBvRr5AU6+omTZT4F8GSSneCqFlG9bO4+nY9
         WhXDak63S7WJxX1g21bBvmY3glzSJlZQlH8z+aNmfl6ViIi5nF76zA8PpqQgTrMdHjrN
         lNjgpMXGprqKg2LhjtozxlFPR7b+5E0bCu2/3Z7HAtKjrujy/Hy7zFzf26LX6/EBTWaQ
         +9Xg==
X-Gm-Message-State: AGi0PuawbwBTdrlvDfABpGte4KSieldz/DfbYK54fVRyTqDW1pMjxN6X
        gW232r3VOviuuGzgnN72QITp5g==
X-Google-Smtp-Source: APiQypICon/lz//oKDTKDsztgLlP8r6L7mJjipX5gdFxEb/WyHwvHtBc4yISVAeeaD21Lq+9gsl8xg==
X-Received: by 2002:a17:90a:8c85:: with SMTP id b5mr612312pjo.187.1588021013307;
        Mon, 27 Apr 2020 13:56:53 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id fh18sm443830pjb.0.2020.04.27.13.56.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 13:56:52 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
Subject: [PATCH net-next v4 0/3] New sysctl to turn off nexthop API compat mode
Date:   Mon, 27 Apr 2020 13:56:44 -0700
Message-Id: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
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

v4: 
	- Use davids note for Documenting the sysctl
	- test with latest iproute2 and adjust 'pref'

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

