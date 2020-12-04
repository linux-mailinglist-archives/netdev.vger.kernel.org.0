Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1532CF206
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgLDQht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:37:49 -0500
Received: from mail.katalix.com ([3.9.82.81]:43632 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730759AbgLDQhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 11:37:48 -0500
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 5F255832DC;
        Fri,  4 Dec 2020 16:37:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1607099827; bh=Z2/LazyF/ndDgTr+YBy9xrnh/bqsHRQdk+LBgD0DCnY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20v3=
         20net-next=202/2]=20docs:=20update=20ppp_generic.rst=20to=20docume
         nt=20new=20ioctls|Date:=20Fri,=20=204=20Dec=202020=2016:36:56=20+0
         000|Message-Id:=20<20201204163656.1623-3-tparkin@katalix.com>|In-R
         eply-To:=20<20201204163656.1623-1-tparkin@katalix.com>|References:
         =20<20201204163656.1623-1-tparkin@katalix.com>;
        b=NwW79FqZa2mSShhFNFW0Q0UQLr81D6Bjy+bsWCitWAzplx5nxTjab4G3ZpytfCJqI
         l+yOWvYZ5UhLCi+SDgpdnmiiCbXXe2PpvnoMEglx2ga+9U1ZX46YRcWyUUQ1O3p3+7
         nIagjpLsb75W+KBKRcjPGyIp5A2i6wsCQ3B8jZIyuRBxgieUEvMvYhPk7+dYfuFkH/
         Y9au0r2txdO9TJo47Qd3s9YAbBnLABwL40Q6/mL0VbTHf7S2Wm9JC9X8i7POO3YHzw
         dGd4GCr1urhdmfQRu0nqke2zV1mYfmP9tbmAWdacWXecOyWjmakUnxYam9KJFdT7j0
         SckUwwVxv/HJQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH v3 net-next 2/2] docs: update ppp_generic.rst to document new ioctls
Date:   Fri,  4 Dec 2020 16:36:56 +0000
Message-Id: <20201204163656.1623-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201204163656.1623-1-tparkin@katalix.com>
References: <20201204163656.1623-1-tparkin@katalix.com>
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

