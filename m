Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F3F2F8FBD
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 23:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbhAPWhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 17:37:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbhAPWhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 17:37:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30B6E22CB3;
        Sat, 16 Jan 2021 22:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610836588;
        bh=1h7kZMBw07HDEg7th2P25gJkUsAQF62WqugVkdDF87c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pYRF2iQIr2f7HsdFzf0bhCr9CxAnW5rSCoczQlfC1wC5PUsdJ5qO/vqYQzxf7ZUZY
         k0dKi0MkJRmGEukQ7PwOggCnzAORGV+4r2KiQJjwQwHmpc6Ux0ZHf3nkYVWy/Ueqwf
         f+n3pzBrv2B+0jSODKvNiuf/5FkVdimKHXTDLoRuH9zxtutiS3sQCWpCN8i9C6tDOl
         lN7KLe/4y0gN8uVIlkVG5fX8tVv/kiyeI9BY2EjYoepw7wuYuny96DsVZzh0DeENid
         no/NyMafbm+zh4EYBAMMlaXGWHxBYAzoTUzDRtYflXhP/c4usmBJgDRMwZykI6YuEs
         jf0KHp6qqprMg==
Received: by pali.im (Postfix)
        id 19AF977B; Sat, 16 Jan 2021 23:36:26 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     linux-man@vger.kernel.org,
        Alejandro Colomar <alx.manpages@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH v3] netdevice.7: Update documentation for SIOCGIFADDR SIOCSIFADDR SIOCDIFADDR
Date:   Sat, 16 Jan 2021 23:36:10 +0100
Message-Id: <20210116223610.14230-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210102140254.16714-1-pali@kernel.org>
References: <20210102140254.16714-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike SIOCGIFADDR and SIOCSIFADDR which are supported by many protocol
families, SIOCDIFADDR is supported by AF_INET6 and AF_APPLETALK only.

Unlike other protocols, AF_INET6 uses struct in6_ifreq.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 man7/netdevice.7 | 64 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/man7/netdevice.7 b/man7/netdevice.7
index 15930807c..bdc2d1922 100644
--- a/man7/netdevice.7
+++ b/man7/netdevice.7
@@ -56,9 +56,27 @@ struct ifreq {
 .EE
 .in
 .PP
+.B AF_INET6
+is an exception.
+It passes an
+.I in6_ifreq
+structure:
+.PP
+.in +4n
+.EX
+struct in6_ifreq {
+    struct in6_addr     ifr6_addr;
+    u32                 ifr6_prefixlen;
+    int                 ifr6_ifindex; /* Interface index */
+};
+.EE
+.in
+.PP
 Normally, the user specifies which device to affect by setting
 .I ifr_name
-to the name of the interface.
+to the name of the interface or
+.I ifr6_ifindex
+to the index of the interface.
 All other members of the structure may
 share memory.
 .SS Ioctls
@@ -143,13 +161,33 @@ IFF_ISATAP:Interface is RFC4214 ISATAP interface.
 .PP
 Setting the extended (private) interface flags is a privileged operation.
 .TP
-.BR SIOCGIFADDR ", " SIOCSIFADDR
-Get or set the address of the device using
-.IR ifr_addr .
-Setting the interface address is a privileged operation.
-For compatibility, only
+.BR SIOCGIFADDR ", " SIOCSIFADDR ", " SIOCDIFADDR
+Get, set, or delete the address of the device using
+.IR ifr_addr ,
+or
+.I ifr6_addr
+with
+.IR ifr6_prefixlen .
+Setting or deleting the interface address is a privileged operation.
+For compatibility,
+.B SIOCGIFADDR
+returns only
 .B AF_INET
-addresses are accepted or returned.
+addresses,
+.B SIOCSIFADDR
+accepts
+.B AF_INET
+and
+.B AF_INET6
+addresses, and
+.B SIOCDIFADDR
+deletes only
+.B AF_INET6
+addresses.
+A
+.B AF_INET
+address can be deleted by setting it to zero via
+.BR SIOCSIFADDR .
 .TP
 .BR SIOCGIFDSTADDR ", " SIOCSIFDSTADDR
 Get or set the destination address of a point-to-point device using
@@ -351,10 +389,18 @@ The names of interfaces with no addresses or that don't have the
 flag set can be found via
 .IR /proc/net/dev .
 .PP
-Local IPv6 IP addresses can be found via
-.I /proc/net
+.B AF_INET6
+IPv6 addresses can be read from
+.I /proc/net/if_inet6
+file or via
+.BR rtnetlink (7).
+Adding a new or deleting an existing IPv6 address can be done via
+.BR SIOCSIFADDR " / " SIOCDIFADDR
 or via
 .BR rtnetlink (7).
+Retrieving or changing destination IPv6 addresses of a point-to-point
+interface is possible only via
+.BR rtnetlink (7).
 .SH BUGS
 glibc 2.1 is missing the
 .I ifr_newname
-- 
2.20.1

