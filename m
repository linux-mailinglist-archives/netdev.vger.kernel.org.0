Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB05F1D8D7E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 04:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgESCOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 22:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgESCOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 22:14:39 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB4FC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:39 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u22so4982299plq.12
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=v9bnFFTNpYZyXyvKsAdqDwRYDL3FCgyPmm8QOSJBYP4=;
        b=UbSkbZcYUAH7dWnEpWQxDsbIERsonCmk5n811wrlD9jAPf0gEAxcBPMvOBcY3gYndE
         pEr54WQV073Svm0KarNJRh/hNgs/ypQAvwhDAXMahmTEmWOwdtdfvI6WTvvyUpm5Su+6
         6Ol3H3kkW0K8h6h9rZ/NXliQRi4zZJOZBc3U4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v9bnFFTNpYZyXyvKsAdqDwRYDL3FCgyPmm8QOSJBYP4=;
        b=h/j9Z0wTbJHUDvDIp57pP6kEHNamg8MIn+zVM7BoVxGWeRA5SZLK2V6/JPo0nqiSft
         9Jgj/09jR1XFqiZeu0N0z1+kDpHwpwGEqcUMnuk91vkECP9QTTUaRaw+dleZtaFlCija
         HMiSkRxGji56iYODv6nNROk0vAd8Svm4R/q23nzomKm8IVLyn0fYmLnU2bKZdRcaPKop
         /7nGPdE3fr0wLN8/mVa02nnuIMzpkOzI+xxCjo/6G6G6/5TytWzxhJkGqSFWr4zwOWMN
         e43d8TjdvlNOuueEyojbCUdWkqk7Mk2C7+kIIcNXwtQW9I60ksm+Duo6RgE7kYcTmJJK
         Sabg==
X-Gm-Message-State: AOAM531/HZz+GLydg1dVtWz+Cjd0e84dVAGqaf6zD227qUVviK3U0PS8
        bYtRyayLsHgKFrknCysfoEqKZwLXl9pz0g==
X-Google-Smtp-Source: ABdhPJwOhWHsThDFUNJaNhBTLGWxe+p3C4MwQT4t3xq99aC3CDwmUr2TzjnnJsCisjVrx/OMo6RWZg==
X-Received: by 2002:a17:902:6ac2:: with SMTP id i2mr17592654plt.18.1589854478849;
        Mon, 18 May 2020 19:14:38 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id 5sm664753pjf.19.2020.05.18.19.14.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 19:14:37 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next 0/6] Support for fdb ECMP nexthop groups
Date:   Mon, 18 May 2020 19:14:28 -0700
Message-Id: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This series introduces ecmp nexthops and nexthop groups
for mac fdb entries. In subsequent patches this is used
by the vxlan driver fdb entries. The use case is
E-VPN multihoming [1,2,3] which requires bridged vxlan traffic
to be load balanced to remote switches (vteps) belonging to
the same multi-homed ethernet segment (This is analogous to
a multi-homed LAG but over vxlan).

Changes include new nexthop flag NHA_FDB for nexthops
referenced by fdb entries. These nexthops only have ip.
The patches make sure that routes dont reference such nexthops.

example:
$ip nexthop add id 12 via 172.16.1.2 fdb
$ip nexthop add id 13 via 172.16.1.3 fdb
$ip nexthop add id 102 group 12/13 fdb

$bridge fdb add 02:02:00:00:00:13 dev vxlan1000 nhid 101 self

[1] E-VPN https://tools.ietf.org/html/rfc7432
[2] E-VPN VxLAN: https://tools.ietf.org/html/rfc8365
[3] LPC talk with mention of nexthop groups for L2 ecmp
http://vger.kernel.org/lpc_net2018_talks/scaling_bridge_fdb_database_slidesV3.pdf


Nikolay Aleksandrov (1):
  nexthop: dereference nh only once in nexthop_select_path

Roopa Prabhu (5):
  nexthop: support for fdb ecmp nexthops
  vxlan: ecmp support for mac fdb entries
  nexthop: add support for notifiers
  vxlan: support for nexthop notifiers
  selftests: net: add fdb nexthop tests

 drivers/net/vxlan.c                         | 318 ++++++++++++++++++++++------
 include/net/ip6_fib.h                       |   1 +
 include/net/netns/nexthop.h                 |   1 +
 include/net/nexthop.h                       |  44 ++++
 include/net/vxlan.h                         |  24 +++
 include/uapi/linux/neighbour.h              |   1 +
 include/uapi/linux/nexthop.h                |   3 +
 net/core/neighbour.c                        |   2 +
 net/ipv4/nexthop.c                          | 170 ++++++++++++---
 net/ipv6/route.c                            |   5 +
 tools/testing/selftests/net/fib_nexthops.sh | 140 +++++++++++-
 11 files changed, 617 insertions(+), 92 deletions(-)

-- 
2.1.4

