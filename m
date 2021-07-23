Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872783D3780
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhGWIfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232370AbhGWIf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 04:35:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2281A60EC0;
        Fri, 23 Jul 2021 09:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627031761;
        bh=R/tUNmGg+pjjdMkzRzL/1GJuqdzUtLr2Uhdivnec1/o=;
        h=From:To:Cc:Subject:Date:From;
        b=VxOKFweETR1//8RQLzgJ0MrOo3M0d67tmtbJGVUk0n5DwPbgWeEXngZeYczNF5mME
         Z6Z87jumcJ7rcDk3gYqQjpkcRpzVGHPl4eaD1gz9ooLRFGMKbD3n6cCo40qEvwIHqK
         D+UdUnV61g84F5GpDJl9XiZ2zxVhxXKfuQ0CanEab8lYFVMyB7huNq97mft1MwOwJx
         Fn8SpMjuPPrUQZmhSnqv4X8P4EEfXg+clkd4IYJYROzctdDEe/B9j5Pzyd+tghfizS
         ADTHeVs7FVYvXm+yVU1KIKaJ+mqG4OBa44VeGW+ho1c5M64AJDXNcPdhmxcSZ+K4Wy
         6cWyKh/OGD+gQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Justin Iurman <justin.iurman@uliege.be>
Cc:     Arnd Bergmann <arnd@arndb.de>, Xin Long <lucien.xin@gmail.com>,
        Matteo Croce <mcroce@microsoft.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Taehee Yoo <ap420073@gmail.com>,
        Rocco Yue <rocco.yue@mediatek.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: ioam: fix unused function warning
Date:   Fri, 23 Jul 2021 11:15:52 +0200
Message-Id: <20210723091556.1740686-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

ioam6_if_id_max is defined globally but used only when
CONFIG_SYSCTL is enabled:

net/ipv6/addrconf.c:99:12: error: 'ioam6_if_id_max' defined but not used [-Werror=unused-variable]

Move the variable definition closer to the usage inside of the
same #ifdef.

Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/ipv6/addrconf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1802287977f1..cd3171749622 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -96,8 +96,6 @@
 #define IPV6_MAX_STRLEN \
 	sizeof("ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255")
 
-static u32 ioam6_if_id_max = U16_MAX;
-
 static inline u32 cstamp_delta(unsigned long cstamp)
 {
 	return (cstamp - INITIAL_JIFFIES) * 100UL / HZ;
@@ -6551,6 +6549,8 @@ static int addrconf_sysctl_disable_policy(struct ctl_table *ctl, int write,
 static int minus_one = -1;
 static const int two_five_five = 255;
 
+static u32 ioam6_if_id_max = U16_MAX;
+
 static const struct ctl_table addrconf_sysctl[] = {
 	{
 		.procname	= "forwarding",
-- 
2.29.2

