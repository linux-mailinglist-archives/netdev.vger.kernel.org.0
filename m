Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A5424E827
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgHVO7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 10:59:46 -0400
Received: from mail.katalix.com ([3.9.82.81]:57986 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbgHVO7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 10:59:32 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id C0DD986BFF;
        Sat, 22 Aug 2020 15:59:20 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598108360; bh=wo0jKYVNAMU7jwtl2qK9yvMoiBNRbqw2AZ0GdBdbbbM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=20v2=209/9]=20docs:=2
         0networking:=20add=20tracepoint=20info=20to=20l2tp.rst|Date:=20Sat
         ,=2022=20Aug=202020=2015:59:09=20+0100|Message-Id:=20<202008221459
         09.6381-10-tparkin@katalix.com>|In-Reply-To:=20<20200822145909.638
         1-1-tparkin@katalix.com>|References:=20<20200822145909.6381-1-tpar
         kin@katalix.com>;
        b=v9wS0u1ghlPQEbKSCf6uuLyJtc6WhLY0Yd4arLGCZvmFxo766cstMUGAcxruN1WaZ
         KP7+cDEkkF5FIb12nQ2rn0vZ2SoYpIrHyz+aJaJtbd2HH/rAkKa4ALmbPV8lDCjB2x
         AhIUR27RV1b128c3kzCVw60t6qxfAik3KxcEH/EVtx7nx4gPt5B7vWCz5AQMNhiqtQ
         CHEzwKKdnSdxETixfPbV4kJUFe/mCqx7jxQhtDRNUkuprmpbY/cl/aQ72WYQW5MC9x
         SObQ5/tzNRfvFtZEqC3i1elguLOIK+xUIBQn/laykZvsqNILdwaEZWHiPBYT6JgUeQ
         PyC1iXhSQ9w0g==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next v2 9/9] docs: networking: add tracepoint info to l2tp.rst
Date:   Sat, 22 Aug 2020 15:59:09 +0100
Message-Id: <20200822145909.6381-10-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822145909.6381-1-tparkin@katalix.com>
References: <20200822145909.6381-1-tparkin@katalix.com>
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

