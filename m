Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A791C4990
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 00:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgEDW23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 18:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgEDW22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 18:28:28 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AAAC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 15:28:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 18so45591pfv.8
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 15:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HgqcPnpOYOR7XFGvK3K80+nDi3N9/U9Wsp+iVD3YO9Q=;
        b=O98hX5map/2pM+if7XlkGH8o9joamqVzNHZYgPeH4PehDVE5Iy/u79M6ZSwRSTlF/m
         vQwy+FEvsvj5HV0MogsGzLTXjSw/WnWg3ByBl6lfOjo7x79zW059wL4BAUZhFp/qhxbc
         PnAY8MLJ9kdlZB0KOQQZRbwftQlYLM9uuFjic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HgqcPnpOYOR7XFGvK3K80+nDi3N9/U9Wsp+iVD3YO9Q=;
        b=Cl98BipuyHLJFgtarP/lg74eCDUnTc8sX4J3u0SmdJD4hoD4+UIQwvZ6V3oXULTTM/
         lQRx+nQJxqkml1/25ltQE8+mI19MpdM2h2NCmki/woFX7KwkMi8GPcyo3akbtuKS31MG
         9wLo6gUC/FDwv9To+JE0zz6zVlTI9HZ4gF+PfltwtYWF3dF2xP2a+/hUYdrrnapHTSbx
         KFaYwBa449MkL3DnoV2mbVc5UtmohCSeKyDFMTS9qWTMukrjwGj6X3NDF+0/dTFGv/x/
         RvUWecP3Y6dYMOUwzlSOFk2rgcsVc+Kd3io+EftbS70HTZpAlJblz6LDuaD1RQIH93BL
         Pf5A==
X-Gm-Message-State: AGi0PuaCpYmvVTsLBtie3BPvhnWhaStOJvhPQ+c/kIZlueH9Ad7IdUVj
        m12l4yrLdWVxBrWRzY9uCXcbSA==
X-Google-Smtp-Source: APiQypIXUwBTuh8h7d6wG2PF/BFOMC8vbdN+Tyt/Dkf7LNMPL51R3yLKRuj/xeuYamgb+nE/XURmTQ==
X-Received: by 2002:a63:121c:: with SMTP id h28mr419389pgl.344.1588631308215;
        Mon, 04 May 2020 15:28:28 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id ie17sm21213pjb.19.2020.05.04.15.28.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 15:28:27 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        idosch@mellanox.com, jiri@mellanox.com, petrm@mellanox.com
Subject: [RFC PATCH net-next 0/5] Support for fdb ECMP nexthop groups
Date:   Mon,  4 May 2020 15:28:16 -0700
Message-Id: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
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

Roopa Prabhu (5):
  nexthop: support for fdb ecmp nexthops
  vxlan: ecmp support for mac fdb entries
  nexthop: add support for notifiers
  vxlan: support for nexthop notifiers
  selftests: net: add fdb nexthop tests

 drivers/net/vxlan.c                         | 319 ++++++++++++++++++++++------
 include/net/netns/nexthop.h                 |   1 +
 include/net/nexthop.h                       |  26 +++
 include/uapi/linux/neighbour.h              |   1 +
 include/uapi/linux/nexthop.h                |   1 +
 net/ipv4/nexthop.c                          | 127 +++++++++--
 tools/testing/selftests/net/fib_nexthops.sh |  77 ++++++-
 7 files changed, 464 insertions(+), 88 deletions(-)

-- 
2.1.4

