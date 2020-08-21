Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B5124D317
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgHUKsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:48:13 -0400
Received: from mail.katalix.com ([3.9.82.81]:45450 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbgHUKr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 06:47:57 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 2F8DD86BF2;
        Fri, 21 Aug 2020 11:47:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598006864; bh=wo0jKYVNAMU7jwtl2qK9yvMoiBNRbqw2AZ0GdBdbbbM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=209/9]=20docs:=20networking:=20a
         dd=20tracepoint=20info=20to=20l2tp.rst|Date:=20Fri,=2021=20Aug=202
         020=2011:47:28=20+0100|Message-Id:=20<20200821104728.23530-10-tpar
         kin@katalix.com>|In-Reply-To:=20<20200821104728.23530-1-tparkin@ka
         talix.com>|References:=20<20200821104728.23530-1-tparkin@katalix.c
         om>;
        b=N+eCIOaX21seUbX1ot0FtgFx1oYUcHHy9skHniJklRKZqxsCUgsejSJbr2ymHSOaQ
         6+rF2hLiLYw8glGUI+otLIQZGRCyA7xQ3tjQmA4/Bv3SbwaWGQ2vQ6vPN/KNt7PtJX
         ybvySOiDNR3vfLCobVJfTTYgVT3Svui8yILDtw/vKC7BfxmSLqmzzQgKYji9R0rFB9
         ZAjgB+F1kO/4xFggWo+/n6qKiCEk4ZPNMwcgk1Z/LzS7onX1jRyIWU81UQpBcd1Rp4
         5KmxNdcw/QWWSAVLqnpYgUwtobhU7mhN+NF91R6E+JVnm+g9c4ahJQHzuUvyVOsFZA
         mwoymr0DtU05Q==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 9/9] docs: networking: add tracepoint info to l2tp.rst
Date:   Fri, 21 Aug 2020 11:47:28 +0100
Message-Id: <20200821104728.23530-10-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821104728.23530-1-tparkin@katalix.com>
References: <20200821104728.23530-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update l2tp.rst to:

 * remove information about the obsolete debug flags and their use
 * include information about tracepoints for l2tp

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 Documentation/networking/l2tp.rst | 37 ++++++++++++-------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/Documentation/networking/l2tp.rst b/Documentation/networking/l2tp.rst
index 693ea0e3ec26..498b382d25a0 100644
--- a/Documentation/networking/l2tp.rst
+++ b/Documentation/networking/l2tp.rst
@@ -455,31 +455,16 @@ l2tp help`` for more information.
 Debugging
 ---------
 
-The L2TP subsystem offers a debug scheme where kernel trace messages
-may be optionally enabled per tunnel and per session. Care is needed
-when debugging a live system since the messages are not rate-limited
-and a busy system could be swamped. Userspace uses setsockopt on the
-PPPoX socket to set a debug mask, or ``L2TP_ATTR_DEBUG`` in netlink
-Create and Modify commands.
+The L2TP subsystem offers a range of debugging interfaces through the
+debugfs filesystem.
 
-The following debug mask bits are defined:-
-
-================  ==============================
-L2TP_MSG_DEBUG    verbose debug (if compiled in)
-L2TP_MSG_CONTROL  userspace - kernel interface
-L2TP_MSG_SEQ      sequence numbers handling
-L2TP_MSG_DATA     data packets
-================  ==============================
-
-Sessions inherit default debug flags from the parent tunnel.
-
-If enabled, files under a l2tp debugfs directory can be used to dump
-kernel state about L2TP tunnels and sessions. To access it, the
-debugfs filesystem must first be mounted::
+To access these interfaces, the debugfs filesystem must first be mounted::
 
     # mount -t debugfs debugfs /debug
 
-Files under the l2tp directory can then be accessed::
+Files under the l2tp directory can then be accessed, providing a summary
+of the current population of tunnel and session contexts existing in the
+kernel::
 
     # cat /debug/l2tp/tunnels
 
@@ -488,8 +473,14 @@ state information because the file format is subject to change. It is
 implemented to provide extra debug information to help diagnose
 problems. Applications should instead use the netlink API.
 
-/proc/net/pppol2tp is also provided for backwards compatibility with
-the original pppol2tp code. It lists information about L2TPv2
+In addition the L2TP subsystem implements tracepoints using the standard
+kernel event tracing API.  The available L2TP events can be reviewed as
+follows::
+
+    # find /debug/tracing/events/l2tp
+
+Finally, /proc/net/pppol2tp is also provided for backwards compatibility
+with the original pppol2tp code. It lists information about L2TPv2
 tunnels and sessions only. Its use is discouraged.
 
 Internal Implementation
-- 
2.17.1

