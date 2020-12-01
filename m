Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A153F2CA1D9
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 12:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389045AbgLALxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:53:40 -0500
Received: from mail.katalix.com ([3.9.82.81]:36906 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388983AbgLALxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 06:53:40 -0500
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id A662A83169;
        Tue,  1 Dec 2020 11:52:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1606823578; bh=Z2/LazyF/ndDgTr+YBy9xrnh/bqsHRQdk+LBgD0DCnY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20v2=
         20net-next=202/2]=20docs:=20update=20ppp_generic.rst=20to=20docume
         nt=20new=20ioctls|Date:=20Tue,=20=201=20Dec=202020=2011:52:50=20+0
         000|Message-Id:=20<20201201115250.6381-3-tparkin@katalix.com>|In-R
         eply-To:=20<20201201115250.6381-1-tparkin@katalix.com>|References:
         =20<20201201115250.6381-1-tparkin@katalix.com>;
        b=zKm2y5kqhvkO/xDT2aWhoAO6+jI+uv3ih37q+7OI8MdsNvILMyQfJU3F8oYr8jMec
         SsbqyCul1c26chA6uZ7aGZAZcOwxqbgGJ2PCzL8EAguAIqlgF651AhCppMm1W1jXKr
         AJuqmLO+acRG7d84jU5xiXb17Ze25UdCLzjj68xPRPyh28mfYUj/cgUq3kXo4u70QX
         ljZ3UA09PcX+irSb8WiKKHpsTO05KZ32WwDdhlAZZd6akEjs6LfgEXjOTBgCcsXJpE
         3ibCagqa0SNvp7W3ID7HRnaDh/WR0dBAHrQnQhV67K/43gEcpAtEj1Kp6taK746Zbi
         hyJTlsHNY/u8A==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH v2 net-next 2/2] docs: update ppp_generic.rst to document new ioctls
Date:   Tue,  1 Dec 2020 11:52:50 +0000
Message-Id: <20201201115250.6381-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201115250.6381-1-tparkin@katalix.com>
References: <20201201115250.6381-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of the newly-added PPPIOCBRIDGECHAN and
PPPIOCUNBRIDGECHAN ioctls.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 Documentation/networking/ppp_generic.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/networking/ppp_generic.rst b/Documentation/networking/ppp_generic.rst
index e60504377900..5a10abce5964 100644
--- a/Documentation/networking/ppp_generic.rst
+++ b/Documentation/networking/ppp_generic.rst
@@ -314,6 +314,22 @@ channel are:
   it is connected to.  It will return an EINVAL error if the channel
   is not connected to an interface.
 
+* PPPIOCBRIDGECHAN bridges a channel with another. The argument should
+  point to an int containing the channel number of the channel to bridge
+  to. Once two channels are bridged, frames presented to one channel by
+  ppp_input() are passed to the bridge instance for onward transmission.
+  This allows frames to be switched from one channel into another: for
+  example, to pass PPPoE frames into a PPPoL2TP session. Since channel
+  bridging interrupts the normal ppp_input() path, a given channel may
+  not be part of a bridge at the same time as being part of a unit.
+  This ioctl will return an EALREADY error if the channel is already
+  part of a bridge or unit, or ENXIO if the requested channel does not
+  exist.
+
+* PPPIOCUNBRIDGECHAN performs the inverse of PPPIOCBRIDGECHAN, unbridging
+  a channel pair.  This ioctl will return an EINVAL error if the channel
+  does not form part of a bridge.
+
 * All other ioctl commands are passed to the channel ioctl() function.
 
 The ioctl calls that are available on an instance that is attached to
-- 
2.17.1

