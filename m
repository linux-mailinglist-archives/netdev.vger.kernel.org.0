Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688DAFBC8
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfD3Oop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfD3Oop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 10:44:45 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BA432147A;
        Tue, 30 Apr 2019 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556635484;
        bh=jQl6KZ1mkt2sFen+G+4PwxY4Gea4OC9Ny6/E3aBMeOs=;
        h=From:To:Cc:Subject:Date:From;
        b=T3Qg+S+Jfwc91y28o9Gen624qUDTKTyFgP15EYwDtwOvQCjCkn32PD7YoktkT9Jn1
         LriI+VKyBDSwblQadABpH79fbr+wZtUXXXR8iCch1GVOEma82G06y985zuZINCjJN3
         lN8KhxcGzm4TsEKl+0J1NKyJO44YB3EZ7YpSqGpc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 0/3] ipv4: Move location of pcpu route cache and exceptions
Date:   Tue, 30 Apr 2019 07:45:47 -0700
Message-Id: <20190430144550.15033-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This series moves IPv4 pcpu cached routes from fib_nh to fib_nh_common
to make the caches available for IPv6 nexthops (fib6_nh) with IPv4
routes. This allows a fib6_nh struct to be used with both IPv4 and
and IPv6 routes.

v4
- fixed memleak if encap_type is not set as noticed by Ido

v3
- dropped ipv6 patches for now. Will resubmit those once the existing
  refcnt problem is fixed

v2
- reverted patch 2 to use ifdef CONFIG_IP_ROUTE_CLASSID instead
  of IS_ENABLED(CONFIG_IP_ROUTE_CLASSID) to fix compile issues
  reported by kbuild test robot

David Ahern (3):
  ipv4: Move cached routes to fib_nh_common
  ipv4: Pass fib_nh_common to rt_cache_route
  ipv4: Move exception bucket to nh_common

 include/net/ip_fib.h     |  8 ++++--
 net/ipv4/fib_semantics.c | 48 ++++++++++++++++---------------
 net/ipv4/route.c         | 75 ++++++++++++++++++++++--------------------------
 3 files changed, 64 insertions(+), 67 deletions(-)

-- 
2.11.0

