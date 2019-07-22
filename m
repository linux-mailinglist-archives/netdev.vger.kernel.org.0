Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EED6FEBD
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 13:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbfGVLbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 07:31:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21629 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfGVLbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 07:31:15 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 733C58535C;
        Mon, 22 Jul 2019 11:31:15 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (dhcp-192-200.str.redhat.com [10.33.192.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D73EF9CD3;
        Mon, 22 Jul 2019 11:31:13 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     libc-alpha@sourceware.org, Sergei Trofimovich <slyfox@gentoo.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>, mtk.manpages@gmail.com,
        linux-man@vger.kernel.org
Subject: [PATCH glibc] Linux: Include <linux/sockios.h> in <bits/socket.h> under __USE_MISC
Date:   Mon, 22 Jul 2019 13:31:12 +0200
Message-ID: <87ftmys3un.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 22 Jul 2019 11:31:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Historically, <asm/socket.h> (which is included from <bits/socket.h>)
provided ioctl operations for sockets.  User code accessed them
through <sys/socket.h>.  The kernel UAPI headers have removed these
definitions in favor of <linux/sockios.h>.  This commit makes them
available via <sys/socket.h> again.

[[[
This is related to this thread:

From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: linux-headers-5.2 and proper use of SIOCGSTAMP
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
 mtk.manpages@gmail.com, linux-man@vger.kernel.org
Date: Sat, 20 Jul 2019 17:48:44 +0100 (1 day, 18 hours, 40 minutes ago)
Message-ID: <20190720174844.4b989d34@sf>

I have tried to verify this against our 3.10 kernel headers and the 5.2
headers, and I do not see any failures in glibc itself (the latter with
build-many-glibcs.py).  Impact on application code is unclear at this
point, of course.

This patch depends on the earlier Linux 5.2 compatibility patch which
introduced <bits/socket-constants.h>.
]]]

2019-07-22  Florian Weimer  <fweimer@redhat.com>

	* sysdeps/unix/sysv/linux/bits/socket.h [__USE_MISC]: Include
	<linux/sockios.h>.

diff --git a/sysdeps/unix/sysv/linux/bits/socket.h b/sysdeps/unix/sysv/linux/bits/socket.h
index 082f8b9031..ff5b705f41 100644
--- a/sysdeps/unix/sysv/linux/bits/socket.h
+++ b/sysdeps/unix/sysv/linux/bits/socket.h
@@ -352,6 +352,7 @@ struct ucred
 #ifdef __USE_MISC
 # include <bits/types/time_t.h>
 # include <asm/socket.h>
+# include <linux/sockios.h>
 #else
 # define SO_DEBUG 1
 # include <bits/socket-constants.h>
