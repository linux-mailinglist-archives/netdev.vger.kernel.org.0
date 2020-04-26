Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9D61B8A64
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 02:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgDZAsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 20:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725962AbgDZAsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 20:48:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECB4C061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 17:48:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x2so3184932pfx.7
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 17:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=DQbyUPVald1Zp2+TqRakbFQcZ4W4ojdBD2tncGS9Sh8=;
        b=GB4TC0eh7kfX946QTFUCI1ifNxG6h5PGKUvS0foTAAUhQE+er3eHTgO5Fi9MzQeoQ1
         lnDvoCifizfgyBHnJooa7/7kdmHETpmXUC1IpuniWEEL433MFDA/J+tA9SZZ/HV69LYM
         qlneqUxpIC6g5uZWy8QErjIyYcHoBqF0c+Z88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DQbyUPVald1Zp2+TqRakbFQcZ4W4ojdBD2tncGS9Sh8=;
        b=hKsIwf/4QlbzamaIUMWO1riuVpNGTnmVtBLNCwNgtRXqEY6A4xrgg3HCCsIhfRyEDC
         mPuTTMemhv8jvRKN9iCjU44N8pcrEW86BFqIu0uXzzeGmuIzkTCnQQcVGeqtPs9kT37o
         5zzBFmR8O2D+29w9rdjfuP3w9BnY2XCPTPhRHTkYrrZ3q64AwDez6Ctk0b8pbaqCdpz1
         B12PmTPh3u704BnirZ2JItRIpiS67L9cWOaLGMzvjzzS2SucRfs5hg5djkUrAHxAdu4L
         3EeTc45u5/l2aUodxRr4ZFgiAmE2UFuTbvxYkDMX3mKINKUvGVbNgZD5MC0R1/Fsmb0A
         l9aA==
X-Gm-Message-State: AGi0PuYCbl4H9J9Y5qwnP9UuDFejh+mUg11efg2R2h6fuwMsH/9357h7
        trcv/SirQZr6mAH1pV+Wk91sew==
X-Google-Smtp-Source: APiQypKUNVrfJqTK8bWQMiNYOU+eUM4OSqohDApGJjtA/1hMyZZecbVblPagYt31dlSRAZSo1/TxlA==
X-Received: by 2002:a63:b557:: with SMTP id u23mr16255437pgo.160.1587862134004;
        Sat, 25 Apr 2020 17:48:54 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id c59sm8242514pje.10.2020.04.25.17.48.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Apr 2020 17:48:53 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        bpoirier@cumulusnetworks.com
Subject: [PATCH net-next v2 0/3] New sysctl to turn off nexthop API compat mode
Date:   Sat, 25 Apr 2020 17:48:45 -0700
Message-Id: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
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

v2:
       - Incorporate David Aherns pointers on covering dumps and
         nexthop deletes. Also use one ipv4 sysctl to cover
         both ipv4 and ipv6 (I see it is done that way for many
         others)
       - Added a selftest to cover dump and notfications for nexthop
	 api compat mode

Roopa Prabhu (3):
  net: ipv6: new arg skip_notify to ip6_rt_del
  ipv4: add sysctl for new nexthop api compatibility mode
  selftests: net: add new testcases for nexthop API compat mode

 include/net/ip6_route.h                     |   2 +-
 include/net/ipv6_stubs.h                    |   2 +-
 include/net/netns/ipv4.h                    |   2 +
 net/ipv4/af_inet.c                          |   1 +
 net/ipv4/fib_semantics.c                    |   3 +
 net/ipv4/nexthop.c                          |   5 +-
 net/ipv4/sysctl_net_ipv4.c                  |   7 ++
 net/ipv6/addrconf.c                         |  12 +--
 net/ipv6/addrconf_core.c                    |   3 +-
 net/ipv6/anycast.c                          |   4 +-
 net/ipv6/ndisc.c                            |   2 +-
 net/ipv6/route.c                            |  16 ++-
 tools/testing/selftests/net/fib_nexthops.sh | 154 +++++++++++++++++++++++++++-
 13 files changed, 192 insertions(+), 21 deletions(-)

-- 
2.1.4

